# Native Termux ARM64 build

This workflow builds Ashen Order directly in Termux on Android ARM64 without
proot. It validates the servers before installation into a live realm or
integration into Pocket Realm.

The restored baseline is `npcbots_3.3.5` at
`598dc2abb51e64322a4f2e3c3b31d142836e1109`. Compatibility changes are on
`codex/termux-native-build`; the baseline is preserved.

## 1. Keep the working Thor environment

Validate using Thor's existing packages first. The script checks for missing
tools/libraries and never installs or upgrades packages. Upgrading would
change the environment being compared with the working server.

For a **new Termux installation**, install the dependencies:

```bash
pkg install git cmake make clang llvm mariadb boost boost-headers libc++ openssl zlib readline ncurses pkg-config
```

Only the optional `thor-reference` profile also needs `boost-static`.
`tmux` is optional for retaining a build session. Termux repositories roll
forward: installing packages today does not reproduce historical versions.
The script records installed versions for every attempt.

Page-size and Android-property probes are optional diagnostics. The script
tries `getconf` on PATH and then Android's `/system/bin/getconf`, and records
`unavailable` if it cannot obtain a page size. No extra package is required
for that probe.

If an older checkout stopped with `getconf: command not found`, update the
checkout to this branch's latest commit and run with `--fresh`. The failed
attempt stopped before CMake, so there are no compiled objects to recover.
Keep its logs; a changed source commit deliberately cannot use `--resume`.

## 2. Clone the implementation branch

Use a new directory, separate from `~/Ashen`. No replacement of `src/` or
`modules/`, submodule initialization, source overlays or sed patches are needed.

```bash
cd "$HOME"
git clone --single-branch --branch codex/termux-native-build https://github.com/Russianranger/ashen-order-android.git ashen-termux-validation
cd "$HOME/ashen-termux-validation"
git rev-parse HEAD
git ls-files --stage | awk '$1 == "160000" {n++} END {print "Gitlinks:", n+0}'
```

Record the commit printed by `git rev-parse HEAD`. To repeat validation later,
check out that exact commit before building. Gitlinks should be `0`.
The script requires a committed checkout and rejects a local
`conf/config.cmake` override. Commit custom source changes on your own branch
before validating them.

## 3. Configure, test and compile

```bash
bash android-build/build-termux.sh --fresh --jobs 2
```

Explicit `bash` avoids the interactive-shell comment problem seen in the
earlier screenshot. The script prints a new `$HOME/ashen-build.XXXXXX`
validation directory immediately. Save that path.

The script configures once, builds and runs focused compatibility tests, then
builds `authserver` and `worldserver` sequentially. It runs each server's
`--version` without opening a database, and records its SHA-256 and ELF headers,
interpreter, RPATH/RUNPATH and required libraries. This does not start a realm.

If an older checkout reports `Hostname/service fallback failed`, update it:

```bash
cd "$HOME/ashen-termux-validation"
git fetch origin codex/termux-native-build
git checkout --detach origin/codex/termux-native-build
bash android-build/build-termux.sh --fresh --jobs 2
```

The resolver now uses explicit zero flags for a requested address family;
Android rejects the previous `AI_ALL` flag. The hostname/service test remains
mandatory and now reports the resolver error category, code and message.
Keep the failed attempt's logs. Use a fresh build because changing the source
commit invalidates the script's resume identity; do not skip CTest.

Use `--configure-only` to stop after CMake. Use `--target authserver` for the
auth milestone or `--target worldserver` for world compilation. The generated
project includes both servers and all static modules/scripts.

If compilation stops, retain the complete attempt logs. Retry with fewer jobs
using the **printed path**, for example:

```bash
bash android-build/build-termux.sh --resume "$HOME/ashen-build.ABC123" --jobs 1
```

Resume keeps compiled objects and creates a new log directory. It rejects
source revision, dependency, compiler or profile changes; use `--fresh` after
such changes. It does not delete build directories. A world-only resume is:

```bash
bash android-build/build-termux.sh --resume "$HOME/ashen-build.ABC123" --target worldserver --jobs 2
```

## 4. Optional staged installation

After both servers pass, install into the validation directory's own `stage/`:

```bash
bash android-build/build-termux.sh --resume "$HOME/ashen-build.ABC123" --jobs 2 --stage
```

This revalidates and stages executables and CMake-provided configuration
templates. It tests the staged binaries' `--version` too. It does not import
`DB_FULL/`, copy working configurations, start MariaDB, copy client data or
overwrite `~/Ashen`. Templates still need explicit runtime setup.

## Build settings

`logs.<attempt>/configure-command.sh` contains the **exact, shell-quoted CMake
command** used for the build. `CMakeCache.txt`, `source-index.txt`,
`build-identity.txt`, compiler logs, tests and ELF reports accompany it.

| Setting | Canonical default |
| --- | --- |
| Platform/compiler | Native aarch64 Android; `$PREFIX/bin/clang` and `clang++` |
| Generator/optimization | Unix Makefiles; Release `-O3 -DNDEBUG` |
| Language | C++20, as required by the restored core |
| Applications | Both servers; selectable compile target |
| Scripts/modules | Static, Custom explicitly static, existing registrations preserved |
| PCH | Core and script precompiled headers enabled |
| Tests/tools | Focused tests enabled; upstream coverage tests and extraction tools disabled |
| Allocator | `NOJEM=ON`: Android's platform allocator |
| Boost | Actual headers/libraries under `$PREFIX`; modern System is header-only |
| MariaDB | Actual `libmariadb.so`, including Termux's architecture subdirectory |
| Runtime search path | `$PREFIX/lib` and discovered connector directory |
| Linker | `-lunwind`; duplicate definitions are errors |
| Installation | Isolated validation directory's `stage/` |

The script does not add the misspelled `_ANDROID__` define, spoof Boost.System
as Filesystem, change global library symlinks, or append a fake MySQL version
to `my.cnf`. Clang supplies Android platform macros. MariaDB uses its own
connector API and numeric server-version handling.

For comparison with the historical link settings only:

```bash
bash android-build/build-termux.sh --fresh --profile thor-reference --jobs 2
```

That profile selects static Boost.Filesystem and the historical
`--allow-multiple-definition` flag. Other Boost components remain shared.
Repeat `--profile thor-reference` when resuming. The flag can hide duplicate
symbols; use the default strict profile for acceptance. Neither profile
promises the hashes of the historical binaries.

## What the preserved reference proves

`reference/` is unchanged evidence from the known-working Thor installation:
Android 13/aarch64, Clang 21.1.8 targeting Android API 24, MariaDB 12.2.2,
Boost 1.90 and libc++/NDK r29 in the inventory. The cache was generated by
CMake 4.2.0 and records older Boost/OpenSSL detection; the later inventory
lists CMake 4.3.2 and OpenSSL 3.6.2. The cached C++17 setting is overridden
by the source's C++20 requirement. Filesystem resolves to `.a` despite an
older `.so` entry. These historical artifacts cover more than one environment
state; they are not a package lockfile or one exact build invocation.

The `*-file.txt` files identify ARM64 Android PIE executables and
`/system/bin/linker64`. The `*-ldd.txt` files say `ldd` was not installed; they
do **not** establish the dependency closure. Binary hashes are preserved,
but there is no source-to-binary provenance or archived package set.
The canonical workflow records commit, package, configuration and ELF evidence
for new builds. Reproducing old hashes would require original packages,
inputs, paths and build metadata too.

## Database and runtime boundary

`DB_FULL/` is the intended five-schema offline seed, including the local
administrator, bots, predefined characters and system accounts. It is
preserved as application state. No seed accounts or rows are removed.

The patched core accepts MySQL 8.0+ or MariaDB 11.4.5+ and checks the client
library separately. The MariaDB floor accommodates the seed's MySQL 8
collation names; it is not proof of a successful full import. Remove an old
`version=8.0.36` spoof manually **when preparing a separate test database**;
do not alter the live server as part of compile validation.

The updater invokes the matching SQL CLI, feeds SQL unchanged through stdin,
and preserves CLI handling of comments, quoting, `DELIMITER` and session
state. Errors propagate and failed files are not marked as applied. A failed
file can still have partially applied statements; this is not an atomic
restore system. Credentials use a unique private temporary option file.
Remote MariaDB CLI imports with explicit TLS require a trusted certificate;
local socket operation does not need remote TLS configuration.

See [VALIDATION.md](VALIDATION.md) for measured results and
[POCKET_REALM_HANDOFF.md](POCKET_REALM_HANDOFF.md) for the next milestones.
Termux build success is not APK runtime, database or gameplay acceptance.
