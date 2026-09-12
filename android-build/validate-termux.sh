#!/usr/bin/env bash
# Native Termux validation. Invoke with bash, including from zsh/fish.
set -euo pipefail

fail() { printf 'Validation stopped: %s\n' "$*" >&2; exit 1; }
[[ $# -eq 0 ]] || fail 'No arguments expected. See android-build/README.md for environment options.'
[[ -n ${PREFIX:-} && -n ${HOME:-} ]] || fail 'Run inside native Termux (PREFIX and HOME are required).'
[[ $(uname -m) == aarch64 ]] || fail 'This validation procedure targets Android ARM64.'
for program in git cmake make clang clang++ ctest sha256sum llvm-readelf; do
    command -v "$program" >/dev/null || fail "Missing dependency: $program"
done
[[ $("$PREFIX/bin/clang" -dumpmachine) == *android* ]] || fail 'The compiler must target Android/Bionic.'

ashen_source=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
ashen_jobs=${ASHEN_JOBS:-2}
[[ $ashen_jobs =~ ^[1-9][0-9]*$ ]] || fail 'ASHEN_JOBS must be a positive integer.'
ashen_apps=${ASHEN_APPS:-all}
[[ $ashen_apps == all || $ashen_apps == auth-only ]] || fail 'ASHEN_APPS must be all or auth-only.'
ashen_gitlinks=$(git -C "$ashen_source" ls-files --stage | awk '$1 == "160000" {n++} END {print n+0}')
[[ $ashen_gitlinks == 0 ]] || fail "Found $ashen_gitlinks unresolved Gitlinks. Use the flattened branch."

ashen_mariadb_library=''
for candidate in "$PREFIX/lib/libmariadb.so" "$PREFIX/lib/aarch64-linux-android/libmariadb.so"; do
    if [[ -f $candidate ]]; then
        ashen_mariadb_library=$candidate
        break
    fi
done
[[ -n $ashen_mariadb_library ]] || fail 'Cannot find the MariaDB connector shared library.'
[[ -f $PREFIX/include/mariadb/mysql.h ]] || fail 'Missing MariaDB headers.'
for component in filesystem program_options iostreams regex; do
    [[ -f $PREFIX/lib/libboost_$component.so ]] || fail "Missing shared Boost $component library (install boost)."
done
ashen_mysql_config=$(command -v mariadb_config || command -v mysql_config || true)
ashen_mysql_client=$(command -v mariadb || command -v mysql || true)
[[ -n $ashen_mysql_config && -n $ashen_mysql_client ]] || fail 'Install the MariaDB config tool and command-line client.'

# Every invocation gets a new directory. No cache reuse, installation, database
# initialization, SQL import, configuration edits, or daemon startup occurs here.
ashen_validation=$(mktemp -d "$HOME/ashen-validation.XXXXXX")
printf 'Validation directory: %s\nSource: %s\n' "$ashen_validation" "$ashen_source"
trap 'printf "Validation failed at line %s. Logs: %s\n" "$LINENO" "$ashen_validation" >&2' ERR
git -C "$ashen_source" rev-parse HEAD > "$ashen_validation/source-commit.txt"
git -C "$ashen_source" status --porcelain=v1 > "$ashen_validation/source-status.txt"
printf '%s\n' "$ashen_gitlinks" > "$ashen_validation/gitlinks.txt"
{
    uname -a
    "$PREFIX/bin/clang" --version
    cmake --version
    "$ashen_mysql_client" --version
    "$ashen_mysql_config" --version
    command -v dpkg-query >/dev/null && dpkg-query -W
} > "$ashen_validation/environment.txt" 2>&1

# C++20 is required by this source. Android's Clang defines __ANDROID__ itself.
# System is header-only in current Boost; never alias it to Filesystem.
# Keep normal duplicate-symbol diagnostics enabled.
cmake -S "$ashen_source" -B "$ashen_validation/build" -G 'Unix Makefiles' \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$ashen_validation/stage" \
    -DCMAKE_C_COMPILER="$PREFIX/bin/clang" \
    -DCMAKE_CXX_COMPILER="$PREFIX/bin/clang++" \
    -DCMAKE_CXX_STANDARD=20 \
    -DCMAKE_CXX_FLAGS='-fexceptions -frtti -Wno-deprecated-literal-operator' \
    -DCMAKE_EXE_LINKER_FLAGS=-lunwind \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    -DCMAKE_BUILD_RPATH="$PREFIX/lib;$(dirname -- "$ashen_mariadb_library")" \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DMYSQL_INCLUDE_DIR="$PREFIX/include/mariadb" \
    -DMYSQL_LIBRARY="$ashen_mariadb_library" \
    -DMYSQL_CONFIG="$ashen_mysql_config" \
    -DMYSQL_EXECUTABLE="$ashen_mysql_client" \
    -DBoost_NO_BOOST_CMAKE=ON \
    -DBoost_NO_SYSTEM_PATHS=ON \
    -DBoost_USE_STATIC_LIBS=OFF \
    -DBOOST_ROOT="$PREFIX" \
    -DBoost_INCLUDE_DIR="$PREFIX/include" \
    -DBOOST_LIBRARYDIR="$PREFIX/lib" \
    -DWITH_WARNINGS=ON -DNOJEM=ON \
    -DAPPS_BUILD="$ashen_apps" -DTOOLS_BUILD=none \
    -DSCRIPTS=static -DMODULES=static \
    -DUSE_COREPCH=ON -DUSE_SCRIPTPCH=ON \
    -DBUILD_TESTING=OFF -DASHEN_BUILD_COMPAT_TESTS=ON \
    2>&1 | tee "$ashen_validation/configure.log"

cmake --build "$ashen_validation/build" --target ashen_compat_tests --parallel "$ashen_jobs" \
    2>&1 | tee "$ashen_validation/compat-build.log"
ctest --test-dir "$ashen_validation/build" -R '^ashen_compatibility$' --output-on-failure \
    2>&1 | tee "$ashen_validation/compat-tests.log"
cmake --build "$ashen_validation/build" --target authserver --parallel "$ashen_jobs" \
    2>&1 | tee "$ashen_validation/auth-build.log"
ashen_applications=(authserver)
if [[ $ashen_apps == all ]]; then
    cmake --build "$ashen_validation/build" --target worldserver --parallel "$ashen_jobs" \
        2>&1 | tee "$ashen_validation/world-build.log"
    ashen_applications+=(worldserver)
fi

for application in "${ashen_applications[@]}"; do
    binary="$ashen_validation/build/src/server/apps/$application"
    [[ -f $binary ]] || fail "Missing build output: $application"
    sha256sum "$binary" >> "$ashen_validation/binary-sha256.txt"
    llvm-readelf -h -l -d "$binary" > "$ashen_validation/$application-elf.txt"
    "$binary" --version > "$ashen_validation/$application-version.txt" 2>&1
done
printf 'Configure, compatibility tests, %s build and loader checks passed. Results: %s\n' "$ashen_apps" "$ashen_validation"
