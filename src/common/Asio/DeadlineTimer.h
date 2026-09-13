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

#ifndef DeadlineTimer_h__
#define DeadlineTimer_h__

#include <boost/version.hpp>
#include <boost/asio/steady_timer.hpp>
#include <boost/asio/io_context.hpp>
#include <boost/date_time/posix_time/posix_time_duration.hpp>
#include <chrono>

#if BOOST_VERSION >= 107000
#define DeadlineTimerBase boost::asio::basic_waitable_timer<std::chrono::steady_clock, boost::asio::wait_traits<std::chrono::steady_clock>, boost::asio::io_context::executor_type>
#else
#define DeadlineTimerBase boost::asio::steady_timer
#endif

namespace Acore::Asio
{
    class DeadlineTimer : public DeadlineTimerBase
    {
    public:
        // Preserve the core's relative-time interface and forward declarations.
        // Boost 1.90 hides basic_deadline_timer with BOOST_ASIO_NO_DEPRECATED.
        template<class ExecutionContext>
        explicit DeadlineTimer(ExecutionContext& context)
#if BOOST_VERSION >= 107000
            : DeadlineTimerBase(context.get_executor()) { }
#else
            : DeadlineTimerBase(static_cast<boost::asio::io_context&>(context)) { }
#endif

        std::size_t expires_from_now(boost::posix_time::time_duration const& duration)
        {
            return expires_after(std::chrono::microseconds(duration.total_microseconds()));
        }
    };
}

#undef DeadlineTimerBase

#endif // DeadlineTimer_h__
