# Pocket Realm integration handoff

## Scope of this branch

This is the native server compatibility stage. It preserves the Ashen Order
NPCBots/modules, all 518 `DB_FULL/` seed files, Lua scripts and existing gameplay.
The clean `npcbots_3.3.5` branch is the baseline. Pocket Realm's APK, vanilla client
support and controller implementation are separate work and are not changed here.

The source contains ordinary, build-discoverable module trees and has zero
Gitlinks. System dependencies remain external: compiler/build tools, Boost,
MariaDB Connector/C plus daemon/client, OpenSSL, zlib, readline and the platform
C/C++ runtime. Historical working binaries and package patches are not vendored.
The Thor validation must confirm that no additional manual source/library edits
are required beyond this branch. A successful Linux host build is not an Android
ARM64 or APK acceptance test.

**Confirmed blocker:** the core `src/server/scripts/Custom/` gameplay tree is
missing, despite the flattened modules being present. Only its README and loader
are tracked. `Timewalking/10Man.h` is included by core and progression scripts,
and the loader has 87 active registrations without C++ definitions. Restore
the entire Custom tree from the working Thor before a full build. This branch
removes the ignore rule that would hide those files and adds an early configure
error; it does not invent replacement gameplay.

## Existing app foundation

Pocket Realm was reviewed at main commit
`f397b7a13c844685898b348f5f602dfb6327ce5e`. It already has Android native MariaDB
process management and a SQL client, database import/migration/snapshot machinery,
CMaNGOS server supervision, and a Wine/Box64 client path with controller input.
Its vanilla build 5875 client/server assumptions must be made selectable for the
Ashen Order Wrath 3.3.5a build 12340 profile.

Reuse those lifecycle and controller facilities through an explicit Ashen profile.
Switching the server executable alone is insufficient: database layout, configs,
realm metadata, client assets and first-run sequencing also differ.

## Runtime contract

| Item | Required app behavior |
| --- | --- |
| Executables | Package ARM64/Bionic `authserver`, `worldserver`, a matching MariaDB daemon/client and the transitive shared libraries. Launch each as a supervised native process. |
| Paths | Supply absolute config paths with `-c`; set writable `LogsDir` and `TempDir`, `DataDir` for extracted Wrath/Ashen assets, `SourceDirectory` for the packaged SQL update tree, and `MySQLExecutable` for the packaged SQL client. |
| Termux boundary | Rebuild/package for the APK's runtime layout. References to `/data/data/com.termux/files/usr` are private to Termux and cannot be the APK's dependency strategy. Check ELF interpreter, ABI/API target, SONAMEs, library search paths and loader compatibility in the actual app. |
| Database | Seed `acore_auth`, `acore_characters`, `acore_world`, `ac_eluna` and `store`. Preserve intentional bot/system accounts, characters and local administrator state. |
| Connection | Use app-private Unix sockets where appropriate, or configured loopback TCP. Example socket shape: `localhost;/absolute/path/mysql.sock;user;password;acore_auth`. All consumers must agree on socket/port, schema names and credentials. |
| SQL import | Use the matching CLI with stdin, check exit status and record completion only after success. Apply a deterministic manifest; do not split SQL on semicolons. |
| Configs | Start from the known-working Ashen configs, reconcile with generated `.conf.dist` files and the module configs, then substitute paths and connection settings. Default core configs alone do not recreate the known-working world. |
| Lua | Include `lua_scripts/`, set `Eluna.ScriptPath`, and preserve any relative paths used by Ashen Lua code by setting a deliberate working directory. |
| Game assets | Supply the matching custom Wrath client and its extracted maps, vmaps, mmaps, DBC and camera data. These assets are external to this source repo. |
| Controller | Keep Pocket Realm's controller mapping and input pipeline, then validate it against the custom Wrath client, UI/addons, window focus and launcher profile. |

## Milestones and remaining gates

1. **Native source validation:** restore and commit the missing Custom source,
   then run `bash android-build/validate-termux.sh` on
   the Thor from this branch. Retain source SHA, clean/dirty status, package versions,
   complete compile/link logs and successful loader checks for both servers.
2. **Database milestone:** package the daemon and CLI in the app; import all five
   seed schemas into a disposable instance with the intentional application state.
   Validate actual collation/SQL compatibility, cross-schema references, row counts,
   restart persistence and failure recovery. Define a seed manifest and an explicit
   migration baseline before enabling the core updater. Generic upstream bootstrap
   is not a replacement for `DB_FULL/`. Readiness must mean successful SQL access,
   not only a running process. Provide a snapshot/restore path before upgrading.
3. **Auth milestone:** load the preserved accounts, verify schema versions and realm
   address/port/build metadata, bind local endpoints, connect using the custom Wrath
   client and check restart/reconnect behavior. Validate in the APK process layout.
4. **World milestone:** load the full module/Lua config set and matching client data,
   validate NPCBots and intended characters, enter the world, save/reload state,
   then exercise suspend/resume, thermal/memory pressure and orderly shutdown.
5. **Custom source injection:** design a versioned source/patch and dependency
   manifest, isolated workspace, cancellation/progress/logging, staging and rollback.
   A Termux build script is not an in-app compiler toolchain. Pin that toolchain and
   build dependency set before exposing a source-import feature in the APK.

The minimum server-version check now accepts genuine MariaDB identities. It does
not certify seed import, the Pocket Realm packaged MariaDB build, gameplay, TLS
deployment, or Android lifecycle behavior. Those are measured in the milestones
above; no successful server startup or client login is claimed by this branch's
compile checks.
