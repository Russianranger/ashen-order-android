/* SPDX-License-Identifier: AGPL-3.0-or-later */
#include "IoContext.h"
#include "DeadlineTimer.h"
#include "Resolver.h"
#include "DatabaseCompatibility.h"
#include "SqlClientConfig.h"
#include "PreparedStatement.h"
#include "ByteBuffer.h"
#include "StartProcess.h"
#include <fstream>
#include <iostream>
#include <iterator>
#include <limits>
#include <stdexcept>
#ifndef _WIN32
#include <sys/stat.h>
#endif

namespace
{
    void Require(bool condition, char const* message)
    {
        if (!condition)
            throw std::runtime_error(message);
    }

    void CheckVersions()
    {
        using namespace Acore::DatabaseCompatibility;
        for (auto version : {"8.0.0", "8.0.36", "8.4.1-commercial", "9.0.0",
            "11.4.5-MariaDB", "12.2.2-MariaDB", "5.5.5-12.2.2-MariaDB"})
            Require(IsServerSupported(version), "Supported server rejected");
        for (auto version : {"", "8", "8.0", "8.0.", "8..0", "8.0.0.1", "8.0.0junk",
            "-8.0.0", "999999999999.0.0", "5.7.44", "11.4.4-MariaDB",
            "10.11.8-MariaDB", "5.5.5-8.0.36"})
            Require(!IsServerSupported(version), "Malformed/unsupported server accepted");
    }

    void CheckCredentialsAndProcess(char const* executable)
    {
        auto directory = std::filesystem::temp_directory_path();
        std::filesystem::path saved;
        {
            Acore::SqlClientConfig first(directory, "quote\"slash\\line\nreturn\rtab\t#; ");
            Acore::SqlClientConfig second(directory, "different");
            saved = first.Path();
            Require(first.Path() != second.Path(), "Concurrent option files collided");
            std::ifstream file(first.Path(), std::ios::binary);
            std::string contents{std::istreambuf_iterator<char>(file), {}};
            Require(contents == "[client]\npassword=\"quote\\\"slash\\\\line\\nreturn\\rtab\\t#; \"\n",
                "Password escaping changed");
#ifndef _WIN32
            struct stat attributes{};
            Require(stat(first.Path().c_str(), &attributes) == 0 && (attributes.st_mode & 0777) == 0600,
                "SQL password file is not private");
#endif
            // The child consumes stdin, then fills stderr beyond pipe capacity
            // before writing stdout: sequential pipe draining would deadlock.
            Require(Acore::StartProcess(executable, {"--test-child", "ok"},
                "tests", second.Path().string(), true) == 0, "Process stdin/pipe handling failed");
            Require(Acore::StartProcess(executable, {"--test-child", "fail"},
                "tests", second.Path().string(), true) == 7, "Child error was lost");
        }
        Require(!std::filesystem::exists(saved), "SQL password file survived scope exit");
        Require(Acore::StartProcess(executable, {"--test-child", "ok"},
            "tests", saved.string(), true) != 0, "Missing SQL input reported success");
    }

    void CheckTimersAndAddresses()
    {
        Acore::Asio::IoContext context;
        Acore::Asio::Resolver resolver(context);
        auto loopback = resolver.Resolve(boost::asio::ip::tcp::v4(), "127.0.0.1", "");
        auto netmask = resolver.Resolve(boost::asio::ip::tcp::v4(), "255.255.0.0", "");
        auto ipv6 = resolver.Resolve(boost::asio::ip::tcp::v6(), "::1", "");
        Require(loopback && loopback->address().is_loopback(), "Offline loopback failed");
        Require(netmask && netmask->address().to_string() == "255.255.0.0", "Subnet mask changed");
        Require(ipv6 && ipv6->address().is_loopback(), "IPv6 literal failed");
        auto checkEndpoint = [&](boost::asio::ip::tcp const& protocol, char const* host,
            char const* service, unsigned short port)
        {
            // Start with an error to ensure successful resolution clears it.
            boost::system::error_code error = boost::asio::error::invalid_argument;
            auto endpoint = resolver.Resolve(protocol, host, service, error);
            if (error || !endpoint)
                throw std::runtime_error(std::string("Resolution failed for ") + host + ":" + service
                    + " (" + error.category().name() + ":" + std::to_string(error.value())
                    + ": " + error.message() + ")");
            Require(endpoint->address().is_loopback(), "Resolved address is not loopback");
            Require(endpoint->address().is_v4() == (protocol == boost::asio::ip::tcp::v4()),
                "Resolver changed the requested address family");
            Require(endpoint->port() == port, "Resolved service port changed");
        };
        checkEndpoint(boost::asio::ip::tcp::v4(), "127.0.0.1", "", 0);
        checkEndpoint(boost::asio::ip::tcp::v4(), "localhost", "80", 80);
        checkEndpoint(boost::asio::ip::tcp::v4(), "localhost", "", 0);
        checkEndpoint(boost::asio::ip::tcp::v4(), "localhost", "http", 80);
        checkEndpoint(boost::asio::ip::tcp::v4(), "127.0.0.1", "3724", 3724);
        checkEndpoint(boost::asio::ip::tcp::v6(), "::1", "8085", 8085);

        boost::system::error_code error;
        auto mismatch = resolver.Resolve(boost::asio::ip::tcp::v4(), "::1", "", error);
        Require(!mismatch && error, "Address family mismatch was accepted or lost its error");
        auto badService = resolver.Resolve(boost::asio::ip::tcp::v4(), "127.0.0.1",
            "ashen-test-service-that-does-not-exist", error);
        Require(!badService && error, "Unknown service was accepted or lost its error");

        Acore::Asio::DeadlineTimer timer(context);
        Require(!Acore::Asio::get_io_context(timer).stopped(), "Timer lost its io_context");
        timer.expires_from_now(boost::posix_time::milliseconds(0));
        bool fired = false;
        timer.async_wait([&](boost::system::error_code const& error) { fired = !error; });
        context.run();
        Require(fired, "Relative timer did not fire");
    }

    void CheckIntegerSerialization()
    {
        enum class WideEnum : unsigned long long { Value = 0xfedcba9876543210ULL };
        PreparedStatementBase statement(0, 5);
        statement.SetData(0, std::numeric_limits<long long>::min());
        statement.SetData(1, std::numeric_limits<unsigned long long>::max());
        statement.SetData(2, WideEnum::Value);
        statement.SetData(3, std::chrono::duration<long long>(4294967297LL), false);
        statement.SetData(4, std::chrono::seconds(42));
        auto const& values = statement.GetParameters();
        Require(values.size() == 5, "Parameter capacity changed");
        Require(std::get<int64>(values[0].data) == std::numeric_limits<int64>::min(), "Signed SQL value changed");
        Require(std::get<uint64>(values[1].data) == std::numeric_limits<uint64>::max(), "Unsigned SQL value changed");
        Require(std::get<uint64>(values[2].data) == 0xfedcba9876543210ULL, "Enum SQL value changed");
        Require(std::get<int64>(values[3].data) == 4294967297LL, "Duration truncated");
        Require(std::get<uint32>(values[4].data) == 42, "32-bit duration binding changed");

        ByteBuffer buffer;
        buffer << 0x0102030405060708ULL << std::numeric_limits<long long>::min();
        Require(buffer.size() == 16, "64-bit packet width changed");
        for (uint8 i = 0; i < 8; ++i)
            Require(buffer.read<uint8>(i) == 8 - i, "Packet endian representation changed");
        Require(buffer.read<int64>(8) == std::numeric_limits<int64>::min(), "Signed packet value changed");
    }
}

int main(int argc, char** argv)
{
    if (argc == 3 && std::string_view(argv[1]) == "--test-child")
    {
        std::string input{std::istreambuf_iterator<char>(std::cin), {}};
        if (input != "[client]\npassword=\"different\"\n")
            return 8;
        std::cerr << std::string(256 * 1024, 'x') << std::flush;
        std::cout << "done\n" << std::flush;
        return std::string_view(argv[2]) == "fail" ? 7 : 0;
    }
    try
    {
        CheckVersions();
        CheckCredentialsAndProcess(std::filesystem::absolute(argv[0]).string().c_str());
        CheckTimersAndAddresses();
        CheckIntegerSerialization();
        std::cout << "Android/database compatibility checks passed\n";
        return 0;
    }
    catch (std::exception const& error)
    {
        std::cerr << error.what() << '\n';
        return 1;
    }
}
