/*
 * This file is part of the AzerothCore Project. See AUTHORS file for Copyright information
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

#ifndef ACORE_SQL_CLIENT_CONFIG_H
#define ACORE_SQL_CLIENT_CONFIG_H

#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <stdexcept>
#include <string>
#include <string_view>

#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#include <sys/stat.h>
#else
#include <unistd.h>
#endif

namespace Acore
{
    // The defaults file keeps the password out of process arguments and logs.
    // Exclusive creation avoids collisions between auth/world imports.
    class SqlClientConfig
    {
    public:
        SqlClientConfig(std::filesystem::path const& directory, std::string_view password)
        {
            std::string name = (directory / "acore-mysql-XXXXXX").string();
#ifdef _WIN32
            if (_mktemp_s(name.data(), name.size() + 1) != 0)
                throw std::runtime_error("Cannot name SQL client defaults file");
            int descriptor = _open(name.c_str(), _O_CREAT | _O_EXCL | _O_WRONLY | _O_BINARY,
                _S_IREAD | _S_IWRITE);
#else
            int descriptor = mkstemp(name.data()); // Creates mode 0600.
#endif
            if (descriptor < 0)
                throw std::runtime_error("Cannot create SQL client defaults file");
            _path = name;
#ifdef _WIN32
            std::FILE* file = _fdopen(descriptor, "wb");
#else
            std::FILE* file = fdopen(descriptor, "w");
#endif
            if (!file)
            {
#ifdef _WIN32
                _close(descriptor);
#else
                close(descriptor);
#endif
                Remove();
                throw std::runtime_error("Cannot open SQL client defaults file");
            }

            std::string contents = "[client]\npassword=\"";
            for (char c : password)
            {
                switch (c)
                {
                    case '\\': contents += "\\\\"; break;
                    case '"': contents += "\\\""; break;
                    case '\n': contents += "\\n"; break;
                    case '\r': contents += "\\r"; break;
                    case '\t': contents += "\\t"; break;
                    default: contents += c; break;
                }
            }
            contents += "\"\n";
            bool const written = std::fwrite(contents.data(), 1, contents.size(), file) == contents.size();
            int const closed = std::fclose(file);
            if (!written || closed != 0)
            {
                Remove();
                throw std::runtime_error("Cannot write SQL client defaults file");
            }
        }

        ~SqlClientConfig() { Remove(); }
        SqlClientConfig(SqlClientConfig const&) = delete;
        SqlClientConfig& operator=(SqlClientConfig const&) = delete;
        std::filesystem::path const& Path() const { return _path; }

    private:
        void Remove() noexcept
        {
            std::error_code error;
            std::filesystem::remove(_path, error);
        }
        std::filesystem::path _path;
    };
}

#endif
