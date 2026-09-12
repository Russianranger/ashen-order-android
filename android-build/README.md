# Ashen Order Android / Termux Build Reference

This repository was reconstructed from a known-working Ashen Order server
running natively under Termux on Android ARM64.

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
- authserver/worldserver dynamic library linkage
- hashes of the known-working binaries
- the live Termux server startup script

Absolute paths in the preserved CMake cache refer to the original working
Thor installation and are historical reference values, not portable paths.

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
