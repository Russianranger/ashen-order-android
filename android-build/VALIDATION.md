# Validation record

Validation baseline: `598dc2abb51e64322a4f2e3c3b31d142836e1109`, with the
compatibility changes in this branch. Date: 2026-09-12.

## Structural checks

- Zero Gitlinks in the complete Git index, including `src/` and `modules/`.
- 23 ordinary module trees represented in CMake's compilation database.
- All 92 Custom `.cpp` files represented in `compile_commands.json`.
- All 87 active Custom registration functions have definitions. The five
  dormant loader entries remain dormant.
- `DB_FULL/`, `data/`, `lua_scripts/`, the Custom source tree and all files in
  `android-build/reference/` are preserved from the baseline.
- No unresolved source submodules or Git LFS pointer files were found in the
  materialized source/dependency/module trees.

## Host build

This is a Linux x86-64 compile/link check, **not** a native Android build or
an APK test. GCC 13.3.0, CMake 4.2.0, Boost 1.90.0, MariaDB Connector/C 3.4.8,
OpenSSL 3.0.13, and Readline 8.2 were used. Boost and the connector were built
from their upstream releases into an isolated validation prefix.

Configuration includes both servers, all static scripts/modules, core/script
PCH, `NOJEM=ON`, `TOOLS_BUILD=none`, upstream coverage tests off and
`ASHEN_BUILD_COMPAT_TESTS=ON`. Host Release optimization was explicitly set to
`-O0 -DNDEBUG` to check the complete source within the validation environment.
The Thor script uses normal Release `-O3 -DNDEBUG`. Host linking does not use
`--allow-multiple-definition`.

| Check | Result |
| --- | --- |
| Fresh CMake configure/generation | Passed |
| `authserver` compile/link | Passed |
| `authserver --version` without database/config | Passed |
| `ashen_compatibility` CTest | 1/1 passed |
| Full `worldserver` compile/link, without multiple-definition suppression | Passed |
| `worldserver --version` without database/config | Passed |
| Isolated staged install; both staged binaries start with `--version` | Passed (including without `LD_LIBRARY_PATH`) |
| Native Termux Clang/ARM64 build | Requires running the documented command on Thor |
| Full seed import / live server / gameplay | Not run |
| Pocket Realm APK build / runtime / controller test | Not run |

The focused test executable uses the real common, database and shared
libraries. It checks numeric MySQL/MariaDB version parsing and rejection,
64-bit prepared-statement/packet values, enum and duration binding, relative
timers, literal loopback/subnet/IPv6 resolution with hostname fallback,
private/escaped temporary SQL client options and cleanup, and subprocess
stdin, exit errors, missing input and simultaneous output/error draining.
It does not connect to a database or modify the intended offline seed.

The Termux script passed `bash -n` and ShellCheck 0.11.0, its help rendered,
and invalid jobs/profile/target combinations were rejected. Its native-only
orchestration and Android-specific Bionic branches still require Thor.

## Native Thor follow-up: resolver flags (2026-09-13)

The Thor screenshot at `ba747c6887e1890d499eda329086bb41d2df0b9b` shows
successful compilation/linkage of the common, database and shared libraries
and the compatibility executable. CTest then stopped at
`Hostname/service fallback failed`. The screenshot does not establish a
complete native authserver or worldserver build.

The failing lookup was IPv4 `localhost` with service `80`. The wrapper passed
Boost.Asio `all_matching` (`AI_ALL`). Android 13's
[allowed resolver flags](https://android.googlesource.com/platform/bionic/+/refs/heads/android13-release/libc/include/netdb.h)
exclude `AI_ALL`, and its
[getaddrinfo implementation](https://android.googlesource.com/platform/bionic/+/refs/heads/android13-release/libc/dns/net/getaddrinfo.c)
rejects flags outside that set with `EAI_BADFLAGS` before resolving a name.
The screenshot alone did not expose that error code; the source inspection
and controlled reproduction identify this incompatibility.

Resolution now explicitly passes zero flags for the caller's selected family.
This also avoids Asio's default `AI_ADDRCONFIG` filtering in offline use.
Numeric address handling remains intact, and hostnames and named services
still go through the real system resolver. An error-code overload preserves
the existing three-argument API while letting tests report the actual error.

Focused Linux x86-64 checks used GCC 13.3 and Boost 1.90 headers. The timer and
address test function was compiled directly from the compatibility test source
against the real repository Resolver, IoContext and DeadlineTimer headers.

| Check | Result |
| --- | --- |
| Previous resolver/tests with normal glibc | Passed |
| Previous resolver/tests with Android's allowed-flag check | Failed at `Hostname/service fallback failed`, reproducing Thor's assertion |
| Updated resolver/tests with normal glibc | Passed |
| Updated resolver/tests with Android's allowed-flag check | Passed |

The Linux-only compatibility-test linker wrapper validates the Android flag
set, then delegates valid requests to the real `getaddrinfo`. It does not
fabricate endpoints or affect either server. It makes the regression visible
on Linux as well as on Android. Assertions cover literal IPv4/subnet/IPv6,
localhost with empty/numeric/named services, auth/world numeric ports,
address-family preservation, unknown-service errors and relative timers.

This follow-up did not repeat the full host world build or run on Thor.
The updated native CTest and both complete server builds remain required.
The workflow still stops on a failed test. Update the source and use `--fresh`;
the earlier build directory remains available for its logs.

## Interpretation

This validation distinguishes source completeness from Android execution.
The previous `__cpu_mask` and metric stream-position errors are patched,
as are modern Boost and MariaDB compatibility failures. The full build also
found an Eluna API mismatch (`HasRootAura()` versus `isInRoots()`) and a stray
leading period in `boss_murmur.cpp`; both were corrected. Eluna's HTTP header
also recognizes the built-in Android macro. Staged startup found that the
database connector was wrongly declared as a static import; its target now
allows shared libraries so installed binaries retain the connector runtime
path. Build discovery
alone was insufficient to establish this; fresh compilation tests the actual
translation units and linkage.

The documented native validation must complete before packaging these servers
into Pocket Realm. Database import, schema migration, app-prefix linkage,
client-data compatibility and game/controller behavior are separate gates in
[POCKET_REALM_HANDOFF.md](POCKET_REALM_HANDOFF.md).
