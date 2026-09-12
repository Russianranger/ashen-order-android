# Validation record

Base: `bfd740eb85d0599bd5f9b8149b37cf76dbe58b28` (`npcbots_3.3.5`).
Work branch: `codex/android-termux-pocket-realm`.

## Repository checks

- Zero Gitlinks in the tracked tree.
- CMake discovers all 23 ordinary module source trees.
- `DB_FULL/` remains the same five-schema, 518-file intentional seed.
- No historical `android-build/reference/` files are changed.

## Host validation environment

Validation uses Linux x86_64/GCC 13.3.0, CMake 4.4.3, Boost 1.90.0, MariaDB
Connector/C 3.4.8, OpenSSL 3.0.13, zlib and readline 8.2. Boost's filesystem,
program_options, iostreams and regex libraries and Connector/C were built into
an isolated dependency prefix. No separate Boost System library or duplicate-symbol
suppression is used.

This is a native Linux host build, not the reference Android Clang/libc++ build.
The Bionic-specific branches require Thor validation.

## Results and blocking evidence

- The initial full host configure succeeded and discovered all 23 modules.
- The authserver, shared/database/common libraries compiled and linked with
  Boost 1.90 and MariaDB Connector/C 3.4.8. Focused checks passed against those
  real libraries.
- Final `APPS_BUILD=auth-only` configure/build with the CMake-integrated test
  target passed. CTest reports `1/1` passing (`ashen_compatibility`), and
  `authserver --version` exits successfully without server configuration or a
  database. The validation executable reports the base revision with a dirty
  suffix because the source changes were tested before commit.
- The attempted world build failed at
  `src/server/scripts/EasternKingdoms/BlackrockMountain/BlackrockDepths/blackrock_depths.h:22`:
  `../scripts/Custom/Timewalking/10Man.h` was not found. This header is not tracked
  in either the clean branch or `thor-pre-merge-backup`.
- The Custom loader's 87 active registrations have no function definitions in
  the tracked C++ source. This is missing gameplay source, not a link flag issue.
- GCC also rejected `StatType StatType` in StatBooster. Qualifying the member's
  type as `StatBoostMgr::StatType` preserves the field/API while fixing lookup;
  both `StatBoost.cpp` and `StatBoostMgr.cpp` compile with that change.
- CMake now diagnoses the missing Custom tree before starting a world build.
  A separate configure confirmed this early failure. `APPS_BUILD=auth-only`
  remains available for database/auth validation.

There is no successful worldserver build or native Thor/APK validation from this
branch yet. Restoring the complete Custom tree is necessary; later compilation
may expose further issues. Existing binaries cannot supply the missing source.

## Focused compatibility checks

`ASHEN_BUILD_COMPAT_TESTS=ON` adds the `ashen_compat_tests` target, linked against
the real shared/database/common code. It does not need the full game test suite
or download GoogleTest. `BUILD_TESTING` can remain off.

```bash
cmake --build <build-directory> --target ashen_compat_tests --parallel 2
ctest --test-dir <build-directory> -R '^ashen_compatibility$' --output-on-failure
```

The checks cover supported/malformed database versions and MariaDB's legacy
protocol prefix; password quoting, temporary-file permissions/uniqueness/cleanup;
stdin delivery, nonzero child status and missing-input rejection; simultaneous
large stderr/stdout delivery; numeric and hostname address resolution; relative
timer completion; and 64-bit SQL/packet values, enums, duration width and endian
representation.

The source build also checks Boost 1.90 Process v1, MariaDB TLS/prepared-statement
API selection, and compiled module/core interfaces. Actual database connections,
seed imports, Android binaries and APK startup are separate runtime gates.
