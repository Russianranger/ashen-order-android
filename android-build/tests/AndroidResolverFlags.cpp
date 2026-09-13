/* SPDX-License-Identifier: AGPL-3.0-or-later */
#include <netdb.h>

extern "C" int __real_getaddrinfo(char const* host, char const* service,
    addrinfo const* hints, addrinfo** result);

extern "C" int __wrap_getaddrinfo(char const* host, char const* service,
    addrinfo const* hints, addrinfo** result)
{
    // Match Android 13 Bionic's AI_MASK/getaddrinfo validation, using the
    // host's flag values. AI_ALL and AI_V4MAPPED are deliberately excluded.
    // This only affects the compatibility test executable, never the servers.
    // https://android.googlesource.com/platform/bionic/+/refs/heads/android13-release/libc/include/netdb.h
    constexpr int allowed = AI_PASSIVE | AI_CANONNAME | AI_NUMERICHOST | AI_NUMERICSERV | AI_ADDRCONFIG;
    if (hints && (hints->ai_flags & ~allowed))
    {
        *result = nullptr;
        return EAI_BADFLAGS;
    }
    return __real_getaddrinfo(host, service, hints, result);
}
