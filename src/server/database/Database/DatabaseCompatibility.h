/*
 * This file is part of the AzerothCore Project. See AUTHORS file for Copyright information
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

#ifndef ACORE_DATABASE_COMPATIBILITY_H
#define ACORE_DATABASE_COMPATIBILITY_H

#include <array>
#include <charconv>
#include <optional>
#include <string_view>

namespace Acore::DatabaseCompatibility
{
    using Version = std::array<unsigned int, 3>;

    inline std::optional<Version> ParseVersion(std::string_view text)
    {
        Version version{};
        for (std::size_t i = 0; i < version.size(); ++i)
        {
            if (text.empty())
                return std::nullopt;
            auto [end, error] = std::from_chars(text.data(), text.data() + text.size(), version[i]);
            if (error != std::errc{})
                return std::nullopt;
            text.remove_prefix(static_cast<std::size_t>(end - text.data()));
            if (i + 1 < version.size())
            {
                if (text.empty() || text.front() != '.')
                    return std::nullopt;
                text.remove_prefix(1);
            }
        }
        // Vendor/build suffixes are allowed; malformed fourth components are not.
        if (!text.empty() && text.front() != '-')
            return std::nullopt;
        return version;
    }

    inline bool IsServerSupported(std::string_view text)
    {
        bool const mariaDB = text.find("MariaDB") != std::string_view::npos;
        // MariaDB can advertise this historical MySQL protocol compatibility prefix.
        if (mariaDB && text.starts_with("5.5.5-"))
            text.remove_prefix(6);
        auto const version = ParseVersion(text);
        // Ashen's seed uses MySQL 8 collations supported from MariaDB 11.4.5.
        return version && *version >= (mariaDB ? Version{11, 4, 5} : Version{8, 0, 0});
    }
}

#endif
