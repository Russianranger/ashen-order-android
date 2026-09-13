# Pocket Realm integration handoff

This branch prepares Ashen's native source and Termux validation. It does not
modify Pocket Realm's application or controller implementation.

The Pocket Realm review used `Russianranger/pocket-realm` main at
`f397b7a13c844685898b348f5f602dfb6327ce5e`. It already has ARM64 MariaDB
daemon/client packaging and database lifecycle, migration and snapshot code.
Integrate with that infrastructure. Recheck its source before implementation.

## Database milestone

1. Create an Ashen realm profile containing `acore_auth`, `acore_characters`,
   `acore_world`, `ac_eluna` and `store`. The existing vanilla schemas
   (`classicrealmd`, `classiccharacters`, `classiclogs`, `classicmangos`)
   do not describe this seed.
2. In disposable app-private storage, initialize the packaged MariaDB daemon
   and import all intended `DB_FULL/` files with its matching SQL client.
   Record dependency order, database selection, table/routine counts, grants,
   collation support and SQL error results. Preserve seeded accounts and
   characters. Keep partial imports out of the active realm.
3. Use the existing snapshot/migration lifecycle for activation, interruption
   recovery and rollback. SQL CLI error propagation here is not a substitute
   for app-level import completion and rollback state.
4. Set explicit app-private data/config/temp/socket paths. Use loopback TCP
   where necessary. Verify import, connection and reconnect behavior against
   the actual packaged server version.

## Auth milestone

- Package `authserver`, MariaDB Connector/C and every ELF dependency for the
  APK runtime. The reviewed app uses `libpocket_mariadbd.so` and
  `libpocket_mariadb_client.so`; point `MySQLExecutable` at the executable path
  used by its supervisor. Client and connector must both be MariaDB-family
  for the MariaDB CLI flags in this branch.
- Termux libraries may contain `/data/data/com.termux/...` dependencies.
  Copying a Termux binary into a differently named APK is insufficient.
  Rebuild for the app's prefix/NDK and verify interpreter, ABI, SONAME
  dependency closure, library search paths, libc++ consistency and Android
  page-size compatibility for the devices/API levels the APK supports.
- Add Ashen auth configuration, seeded auth schema, local realm address and
  matching Wrath realm/client build. Prove login/reconnect with the Ashen
  client and retain Pocket Realm's service lifecycle/logging.

## World milestone

- Stage `worldserver`, module configs, Lua scripts, SQL updates and the five
  schema mappings together as a versioned realm payload.
- Supply matching Ashen/Wrath 3.3.5a data (`dbc`, `maps`, `vmaps`, `mmaps`,
  `camera` where required). These assets and the custom client are external
  inputs. `TOOLS_BUILD=none` does not build extractors; a separate extraction
  or asset-import path remains necessary.
- Set `DataDir`, `LogsDir`, `TempDir`, `SourceDirectory`, Lua/config and
  executable paths explicitly. Do not rely on Thor's `~/Ashen`, inherited
  working directory or global Termux configuration.
- Test startup, character entry, custom systems, NPCBots, Eluna and repeated
  start/stop. Measure memory, thermal behavior and background lifecycle on
  Thor. C++ compilation cannot establish gameplay correctness.

## Client, controller and custom-source support

The server uses Wrath 3.3.5a protocol (client build 12340); Ashen's custom
client/data must match. Pocket Realm's vanilla client selection, validation,
realmlist configuration and Wine/Box64 launch profile need an Ashen option.
Keep controller/input routing intact and test it with that client. Server
code changes alone do not demonstrate controller support.

Building a selected source tree inside Pocket Realm additionally requires
an app-owned compiler/CMake/Make toolchain and headers, dependency acquisition
or bundling, writable build/cache storage, cancellation, progress and resource
limits. `build-termux.sh` is a native build interface, not an embedded
toolchain. Version source commit, dependency manifest, seed, configuration and
client-data identity together when allowing code injection.

## Source audit boundary

The restored baseline has zero Gitlinks, 23 ordinary module source trees and
92 Custom C++ translation units. All 87 active Custom registrations
have definitions. Five supplied entries were dormant in the working loader
and remain dormant: `AddSC_SafeAreas`, `AddSC_WeeklyQuestManager`,
`AddSC_boss_the_hidden_watcher`, `AddSC_npc_mount_warning`, and
`AddSC_spell_lock_shadow_cleave`. Enable features only as an intentional change.

Android/Boost/MariaDB compatibility patches here are versioned source. Old
manual replacement files and sed recipes are not additional build inputs.
The fresh world compile also exposed Eluna calling a missing `HasRootAura()`
method. Its Lua `IsRooted` binding now uses the core's existing `isInRoots()`
root-aura check, preserving the movement-root flag check.
Eluna's bundled HTTP library also recognizes Clang's built-in `__ANDROID__`
macro, retaining its Android interface-lookup behavior without a global
`-DANDROID` compiler workaround.
The restored `boss_murmur.cpp` also had a stray period before its opening
comment. Removing that one character fixes a compiler syntax error without
changing encounter behavior.
Staged startup exposed the database connector being declared as a static
import even when `MYSQL_LIBRARY` points to a shared library. The imported
target now permits either library type, so CMake retains the shared
connector's runtime directory during installation.
Any further Thor-only fix found during validation must be reconciled into
source before app integration is complete.
