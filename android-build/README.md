# Ashen Order Android / Termux Build

This repository was reconstructed from a known-working Ashen Order server
running natively under Termux on Android ARM64.

The Android compatibility work starts from clean commit
`bfd740eb85d0599bd5f9b8149b37cf76dbe58b28` on `npcbots_3.3.5` and lives on
`codex/android-termux-pocket-realm`. See [Pocket Realm handoff](POCKET_REALM_HANDOFF.md)
for runtime integration requirements and [validation record](VALIDATION.md) for
what has actually been tested.

## Current world-server blocker

The fresh build exposed missing Ashen gameplay source outside the flattened
modules. `src/server/scripts/Custom/` contains only `README.md` and
`custom_script_loader.cpp`; `Timewalking/10Man.h` is absent. All 87 active custom
registrations in that loader lack definitions in the tracked C++ source.
The clean and `thor-pre-merge-backup` branches both lack the Timewalking header.
The old Git ignore rule excluded this Custom tree; that rule is removed here.

Restore the **complete Custom directory** from the known-working Thor source,
including the header and its implementations. Do not add an empty header or
disable registrations: that would remove Ashen gameplay. CMake now stops early
with this diagnosis when a world build is requested. Auth/database validation
can proceed independently.

The preserved CMake cache places the working source at `~/Ashen`. On the Thor,
check that this is still the working source and package its Custom tree:

```bash
test -f "$HOME/Ashen/src/server/scripts/Custom/Timewalking/10Man.h" && tar -czf "$HOME/ashen-custom-source.tar.gz" -C "$HOME/Ashen" src/server/scripts/Custom
```

Supply that archive for reconciliation into this branch. If the test fails, use
the actual working source directory rather than the validation clone. Include
the entire Custom directory, not only the first missing header.

## Fresh Thor validation

Run this from native Termux. A new clone avoids the old manual replacements and
stale CMake caches. These commands compile and test; they do not install servers,
start MariaDB, import SQL, or modify the working `~/Ashen` installation.

```bash
git clone --single-branch --branch codex/android-termux-pocket-realm https://github.com/Russianranger/ashen-order-android.git ashen-order-android-termux
cd ashen-order-android-termux
ASHEN_APPS=auth-only bash android-build/validate-termux.sh
```

If the destination already exists, choose a new directory name. Run the script
with `bash` even if your interactive shell is zsh or fish; pasted `#` comments
caused the earlier validation attempt to stop before CMake ran.

The script checks the Android ARM64 compiler, headers, shared libraries and zero
Gitlinks. It creates a fresh `~/ashen-validation.XXXXXX/` directory, builds and
runs focused compatibility tests, then builds the requested servers. Finally it captures binary
hashes, ELF headers/program headers/dynamic dependencies, and `--version` loader
checks. Two build jobs are the default; `ASHEN_JOBS=1 bash android-build/validate-termux.sh`
uses less memory. On failure, send the log containing the **first error**, together
with `configure.log` and `environment.txt`, from the printed validation directory.

After the missing Custom source is restored and committed, run
`bash android-build/validate-termux.sh` without `ASHEN_APPS=auth-only` to validate
all modules, static scripts, authserver and worldserver. The default requests
both servers and currently fails at the explicit missing-source configure check.

The package set includes the original dependencies plus shared Boost, LLVM tools,
OpenSSL, zlib and readline. On a new Termux installation, install missing packages:

```bash
pkg install git cmake make clang llvm mariadb boost boost-headers libc++ openssl zlib readline pkg-config
```

Keep the working Thor package set for the first comparison; installing from the
current package repository may select newer versions than the historical files.
`boost-static`, `tmux` and Ninja are not required by this shared-Boost Makefile
validation. The script does not upgrade packages.

Key configure choices are C++20, `APPS_BUILD=all`, `TOOLS_BUILD=none`,
`SCRIPTS=static`, `MODULES=static`, `NOJEM=ON`, and native `$PREFIX/bin/clang++`.
The full command is in [validate-termux.sh](validate-termux.sh). Clang supplies
`__ANDROID__`; the old `_ANDROID__` spelling is unnecessary. Current Boost no
longer needs a separate System library, and Filesystem must not be substituted
for it. The historical `--allow-multiple-definition` workaround is deliberately
absent so remaining duplicate definitions fail validation. The Termux unwind
link flag is retained.

The CMake install prefix points only to the validation directory's `stage/`.
Installation is a later explicit step using `cmake --install <validation>/build`;
that stage is not yet a self-contained APK payload. The script leaves all generated
logs and binaries in the validation directory for inspection.

## Known-working environment

The reference installation runs directly in Termux on Android/aarch64.
It does not require a proot Linux distribution.

The `reference/` directory records the environment used by the working build,
including:

- Android and Termux information
- installed package versions
- Clang/CMake/Ninja versions
- MariaDB and OpenSSL versions
- the CMake cache from the known-working build
- attempted authserver/worldserver dynamic library linkage captures
- hashes of the known-working binaries
- the live Termux server startup script

Absolute paths in the preserved CMake cache refer to the original working
Thor installation and are historical reference values, not portable paths.
Both preserved `*-ldd.txt` files report that `ldd` was unavailable; they do not
establish the dependency closure. The new validation script uses `llvm-readelf`
and actual loader checks instead. The cache and package inventory are different
snapshots (for example, cached Boost 1.89 versus installed Boost 1.90), so the
reference alone cannot reproduce an identical binary.

## Compatibility changes

- Use public CPU affinity operations on Bionic, an explicit stream offset for
  metric lengths, the correct Bionic `strerror_r` variant, and `<version>` for
  G3D's standard-library detection.
- Support current Boost discovery, Process v1 and monotonic Asio timers while
  keeping the existing core interfaces. Numeric realm addresses work without DNS;
  hostname resolution and configured subnet masks remain available.
- Normalize distinct LP64 64-bit integer types for packets and prepared statements.
  Existing packet widths and statement bounds checks are retained.
- Recognize MariaDB Connector/C separately from MySQL headers and API versions;
  use its TLS/bind APIs and maintain Unix-socket connections across reconnects.
- Compare database versions numerically. The Ashen seed requires MariaDB 11.4.5+
  for its MySQL 8 collation names, or MySQL 8.0+. This is a compatibility floor,
  not proof that every seed statement works on every later release.
- Import SQL through a matching native `mariadb`/`mysql` client via stdin. The
  client handles full SQL syntax, comments, delimiters and session state. Unique
  owner-only temporary option files hold escaped passwords; failed imports propagate
  an error, and simultaneous output streams cannot deadlock the parent.
- Make `--version` return before configuration, database or service startup.

No new build requires the old MariaDB `version=8.0.36` spoof or a forced library
symlink. Existing external installations are not edited by these changes.

For SQL updates, `MySQLExecutable` must point to the same client family as the
linked connector. `TempDir` must be an existing writable directory. Imports use
`--defaults-file` first and ignore ambient client option files; configure the
connection in the server's database settings. SQL files retain their transaction
semantics: a failing import can leave earlier statements applied, especially DDL.
Take a snapshot before migrations; do not treat SQL import as an atomic operation.
Explicit MariaDB CLI TLS requests require a trusted certificate to prevent
plaintext fallback. This is stricter than the connector's encryption-only
`ssl` setting; remote self-signed TLS needs a separate configuration design.

## Modules

The module trees under `modules/` are complete ordinary source directories
copied from the known-working Thor installation.

Historical Gitlink/submodule-style module entries were deliberately flattened
so a fresh clone contains all source required by the modules.

## Database

`DB_FULL/` contains the intended Ashen Order solo/offline database seed.

The included bot/system accounts, predefined characters, and local
administrative account are intentional application state required by the
Ashen Order experience.

Ashen Order is intended primarily for solo/offline use. The included
account/database state should not be treated as appropriate for an unchanged
public Internet-facing server deployment.

## Runtime game data

Client-derived assets are intentionally not stored in this repository,
including:

- maps
- vmaps
- mmaps
- DBC data
- other extracted client runtime assets

These must be supplied or generated separately by the eventual Android
application/runtime setup process.
