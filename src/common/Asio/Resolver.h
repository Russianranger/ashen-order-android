/*
 * This file is part of the AzerothCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License as published by the
 * Free Software Foundation; either version 3 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef Resolver_h__
#define Resolver_h__

#include "IoContext.h"
#include "Optional.h"
#include <boost/asio/ip/tcp.hpp>
#include <string>

namespace Acore::Asio
{
    /**
     Hack to make it possible to forward declare resolver (one of its template arguments is a typedef to something super long and using nested classes)
    */
    class Resolver
    {
    public:
        explicit Resolver(IoContext& ioContext) : _impl(ioContext) { }

        Optional<boost::asio::ip::tcp::endpoint> Resolve(boost::asio::ip::tcp const& protocol, std::string const& host, std::string const& service)
        {
            boost::system::error_code ec;
            return Resolve(protocol, host, service, ec);
        }

        Optional<boost::asio::ip::tcp::endpoint> Resolve(boost::asio::ip::tcp const& protocol, std::string const& host,
            std::string const& service, boost::system::error_code& ec)
        {
            ec.clear();
            // Local addresses/subnet masks need no DNS or active Android network.
            // Keep the resolver fallback for hostnames and named services.
            if (service.empty())
            {
                auto address = boost::asio::ip::make_address(host, ec);
                if (!ec && address.is_v4() == (protocol == boost::asio::ip::tcp::v4()))
                    return boost::asio::ip::tcp::endpoint(address, 0);
                ec.clear();
            }
            // The caller already selects an address family. Android rejects
            // AI_ALL (all_matching); IPv4-mapped IPv6 results are not needed.
            // Explicit zero flags also avoid the default AI_ADDRCONFIG, which
            // can filter loopback results when the device has no active network.
#if BOOST_VERSION >= 106600
            boost::asio::ip::resolver_base::flags flagsResolver{};
            boost::asio::ip::tcp::resolver::results_type results = _impl.resolve(protocol, host, service, flagsResolver, ec);
            if (results.begin() == results.end() || ec)
                return {};

            return results.begin()->endpoint();
#else
            boost::asio::ip::resolver_query_base::flags flagsQuery{};
            boost::asio::ip::tcp::resolver::query query(std::move(protocol), std::move(host), std::move(service), flagsQuery);
            boost::asio::ip::tcp::resolver::iterator itr = _impl.resolve(query, ec);
            boost::asio::ip::tcp::resolver::iterator end;
            if (itr == end || ec)
                return {};

            return itr->endpoint();
#endif
        }

    private:
        boost::asio::ip::tcp::resolver _impl;
    };
}

#endif // Resolver_h__
