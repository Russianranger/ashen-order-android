#!/usr/bin/env bash
# Native Termux validation. Run with bash, including from an interactive zsh.
set -Eeuo pipefail

usage() {
    cat <<'USAGE'
Usage: bash android-build/build-termux.sh [options]
  --fresh                 Create a new isolated build (default).
  --build-dir PATH        New, nonexistent validation directory.
  --resume PATH           Resume a directory created by this script.
  --jobs N                Parallel compiler jobs (default: 2).
  --target all|authserver|worldserver
                          Compile tests and selected server(s), default all.
  --profile strict|thor-reference
                          Default strict. Reference uses static Boost.Filesystem
                          and the historical multiple-definition linker flag.
  --configure-only        Configure and record the environment; do not compile.
  --stage                 Install into PATH/stage after a full build.
  --help                  Show this help.

PATH contains build/, logs.<attempt>/, and optionally stage/. Nothing is installed into
the working Ashen server. No packages, databases, or system settings are changed.
USAGE
}
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }
need_value() { [[ $# -ge 2 && -n $2 && $2 != --* ]] || die "$1 requires a value"; }

ashen_mode=fresh
ashen_directory=
ashen_jobs=2
ashen_target=all
ashen_profile=strict
ashen_configure_only=0
ashen_stage=0
while (($#)); do
    case $1 in
        --help) usage; exit 0 ;;
        --fresh) [[ -z $ashen_directory ]] || die 'Choose one build directory option'; ashen_mode=fresh; shift ;;
        --build-dir|--resume)
            need_value "$@"
            [[ -z $ashen_directory ]] || die 'Choose one build directory option'
            [[ $1 != --resume ]] || ashen_mode=resume
            ashen_directory=$2; shift 2 ;;
        --jobs) need_value "$@"; ashen_jobs=$2; shift 2 ;;
        --target) need_value "$@"; ashen_target=$2; shift 2 ;;
        --profile) need_value "$@"; ashen_profile=$2; shift 2 ;;
        --configure-only) ashen_configure_only=1; shift ;;
        --stage) ashen_stage=1; shift ;;
        *) die "Unknown option: $1 (use --help)" ;;
    esac
done
[[ $ashen_jobs =~ ^[1-9][0-9]*$ ]] || die '--jobs must be a positive integer'
case $ashen_target in all|authserver|worldserver) ;; *) die 'Invalid --target' ;; esac
case $ashen_profile in strict|thor-reference) ;; *) die 'Invalid --profile' ;; esac
if ((ashen_stage)); then
    [[ $ashen_target == all && $ashen_configure_only == 0 ]] || die '--stage requires a full build'
fi

[[ -n ${PREFIX:-} && -d $PREFIX/bin && -n ${HOME:-} ]] || die 'Run inside native Termux'
[[ $(uname -m) == aarch64 ]] || die 'This profile requires ARM64/aarch64'
for ashen_tool in bash git cmake ctest make clang clang++ llvm-readelf sha256sum pkg-config dpkg-query realpath tee; do
    command -v "$ashen_tool" >/dev/null || die "Missing $ashen_tool; see android-build/README.md"
done
[[ $("$PREFIX/bin/clang" -dumpmachine) == aarch64*android* ]] || die 'Expected Termux Android ARM64 Clang'
ashen_source=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
ashen_prefix=$(realpath "$PREFIX")
ashen_commit=$(git -C "$ashen_source" rev-parse HEAD)
[[ -z $(git -C "$ashen_source" status --porcelain --untracked-files=all) ]] || die 'Commit source changes before validation, or use a fresh clone'
[[ ! -f $ashen_source/conf/config.cmake ]] || die 'Local conf/config.cmake can override this profile; use a fresh clone'
ashen_gitlinks=$(git -C "$ashen_source" ls-files --stage | awk '$1 == "160000" {n++} END {print n+0}')
[[ $ashen_gitlinks == 0 ]] || die "Unresolved Gitlinks: $ashen_gitlinks"
for ashen_required in src/server/scripts/Custom/Timewalking/10Man.h src/server/scripts/Custom/custom_script_loader.cpp modules/mod-eluna/src/LuaEngine/LuaEngine.cpp; do
    [[ -s $ashen_source/$ashen_required ]] || die "Missing source: $ashen_required"
done

ashen_maria=
for ashen_candidate in "$PREFIX/lib/libmariadb.so" "$PREFIX/lib/aarch64-linux-android/libmariadb.so"; do
    if [[ -f $ashen_candidate ]]; then ashen_maria=$(realpath "$ashen_candidate"); break; fi
done
[[ -n $ashen_maria && -f $PREFIX/include/mariadb/mysql.h ]] || die 'Install mariadb (client library and headers required)'
ashen_mysql_config=
for ashen_candidate in "$PREFIX/bin/mariadb_config" "$PREFIX/bin/mysql_config"; do
    if [[ -x $ashen_candidate ]]; then ashen_mysql_config=$ashen_candidate; break; fi
done
[[ -n $ashen_mysql_config ]] || die 'Missing mariadb_config/mysql_config'
ashen_sql_client=$(command -v mariadb || command -v mysql || true)
[[ -n $ashen_sql_client ]] || die 'Install the MariaDB SQL command-line client'
[[ -f $PREFIX/include/boost/version.hpp ]] || die 'Install boost-headers'
ashen_filesystem="$PREFIX/lib/libboost_filesystem.so"
ashen_link_flags=-lunwind
if [[ $ashen_profile == thor-reference ]]; then
    ashen_filesystem="$PREFIX/lib/libboost_filesystem.a"
    ashen_link_flags='-Wl,--allow-multiple-definition -lunwind'
fi
for ashen_library in "$ashen_filesystem" "$PREFIX/lib/libboost_program_options.so" "$PREFIX/lib/libboost_iostreams.so" "$PREFIX/lib/libboost_regex.so" "$PREFIX/lib/libssl.so" "$PREFIX/lib/libcrypto.so" "$PREFIX/lib/libz.so" "$PREFIX/lib/libreadline.so"; do
    [[ -f $ashen_library ]] || die "Missing library: $ashen_library; see README dependency list"
done

if [[ $ashen_mode == resume ]]; then
    [[ -d $ashen_directory ]] || die 'Resume directory does not exist'
    ashen_directory=$(realpath "$ashen_directory")
    [[ -f $ashen_directory/build-identity.txt ]] || die 'This directory was not created by this script'
else
    if [[ -n $ashen_directory ]]; then
        [[ ! -e $ashen_directory ]] || die '--build-dir must not already exist; use --resume'
        mkdir -p -- "$ashen_directory"
    else
        ashen_directory=$(mktemp -d "$HOME/ashen-build.XXXXXX")
    fi
    ashen_directory=$(realpath "$ashen_directory")
fi
case "$ashen_directory/" in "$ashen_source/"*) die 'Build outside the source checkout' ;; esac
ashen_build="$ashen_directory/build"
ashen_log=$(mktemp -d "$ashen_directory/logs.XXXXXXXX")
on_error() {
    local ashen_exit=$?
    printf 'Build stopped (%s). Logs: %s\nResume: bash %q --resume %q --profile %q --jobs %q --target %q\n' \
        "$ashen_exit" "$ashen_log" "$ashen_source/android-build/build-termux.sh" \
        "$ashen_directory" "$ashen_profile" "$ashen_jobs" "$ashen_target" >&2
    exit "$ashen_exit"
}
trap on_error ERR
printf 'Validation directory: %s\nAttempt logs: %s\n' "$ashen_directory" "$ashen_log"

# Refuse stale objects after source, toolchain, or package changes on resume.
{
    printf 'workflow=1\nsource=%s\ncommit=%s\nprefix=%s\nprofile=%s\n' "$ashen_source" "$ashen_commit" "$ashen_prefix" "$ashen_profile"
    "$PREFIX/bin/clang" --version
    cmake --version
    for ashen_variable in CFLAGS CXXFLAGS CPPFLAGS LDFLAGS CPATH CPLUS_INCLUDE_PATH LIBRARY_PATH LD_LIBRARY_PATH; do
        printf '%s=%s\n' "$ashen_variable" "${!ashen_variable-}"
    done
    dpkg-query -W -f='${Package}\t${Version}\t${Architecture}\n' | LC_ALL=C sort
} > "$ashen_log/build-identity.txt"
if [[ $ashen_mode == resume ]]; then
    cmp -s "$ashen_directory/build-identity.txt" "$ashen_log/build-identity.txt" || die 'Source/profile/packages changed; create a fresh build directory'
else
    cp "$ashen_log/build-identity.txt" "$ashen_directory/build-identity.txt"
fi
git -C "$ashen_source" status --short > "$ashen_log/git-status.txt"
git -C "$ashen_source" ls-files --stage > "$ashen_log/source-index.txt"
printf 'Gitlinks: %s\n' "$ashen_gitlinks" > "$ashen_log/structure.txt"
{
    # Platform metadata is diagnostic; missing Android utilities must not stop CMake.
    uname -srmo 2>/dev/null || printf 'Kernel: unavailable\n'
    ashen_page_size=unavailable
    for ashen_getconf in getconf /system/bin/getconf; do
        if command -v "$ashen_getconf" >/dev/null 2>&1; then
            if ashen_page_size=$("$ashen_getconf" PAGESIZE 2>/dev/null) \
                && [[ $ashen_page_size =~ ^[1-9][0-9]*$ ]]; then
                break
            fi
        fi
        ashen_page_size=unavailable
    done
    printf 'Page size: %s\n' "$ashen_page_size"
    if command -v getprop >/dev/null 2>&1; then
        getprop ro.build.version.sdk 2>/dev/null || printf 'Android SDK: unavailable\n'
        getprop ro.product.cpu.abi 2>/dev/null || printf 'Android ABI: unavailable\n'
    fi
} > "$ashen_log/android-platform.txt"

ashen_cmake=(cmake -S "$ashen_source" -B "$ashen_build" -G 'Unix Makefiles'
    "-DCMAKE_INSTALL_PREFIX=$ashen_directory/stage"
    "-DCMAKE_C_COMPILER=$PREFIX/bin/clang" "-DCMAKE_CXX_COMPILER=$PREFIX/bin/clang++"
    -DCMAKE_CXX_STANDARD=20 -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS=
    '-DCMAKE_CXX_FLAGS=-Wno-deprecated-literal-operator -fexceptions -frtti'
    "-DCMAKE_EXE_LINKER_FLAGS=$ashen_link_flags"
    "-DCMAKE_PREFIX_PATH=$PREFIX"
    "-DCMAKE_BUILD_RPATH=$PREFIX/lib;$(dirname "$ashen_maria")"
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DWITH_WARNINGS=ON
    -DAPPS_BUILD=all -DTOOLS_BUILD=none -DSCRIPTS=static -DSCRIPTS_CUSTOM=static -DMODULES=static
    -DUSE_COREPCH=ON -DUSE_SCRIPTPCH=ON -DBUILD_TESTING=OFF -DASHEN_BUILD_COMPAT_TESTS=ON -DNOJEM=ON
    "-DMYSQL_INCLUDE_DIR=$PREFIX/include/mariadb" "-DMYSQL_LIBRARY=$ashen_maria"
    "-DMYSQL_CONFIG=$ashen_mysql_config" "-DMYSQL_EXECUTABLE=$ashen_sql_client"
    -DBoost_NO_BOOST_CMAKE=ON -DBoost_NO_SYSTEM_PATHS=ON -DBoost_USE_STATIC_LIBS=OFF
    "-DBOOST_ROOT=$PREFIX" "-DBoost_INCLUDE_DIR=$PREFIX/include" "-DBOOST_LIBRARYDIR=$PREFIX/lib"
    "-DBoost_FILESYSTEM_LIBRARY_RELEASE=$ashen_filesystem" "-DBoost_FILESYSTEM_LIBRARY_DEBUG=$ashen_filesystem")
printf '%q ' "${ashen_cmake[@]}" > "$ashen_log/configure-command.sh"
printf '\n' >> "$ashen_log/configure-command.sh"
"${ashen_cmake[@]}" 2>&1 | tee "$ashen_log/configure.log"
cp "$ashen_build/CMakeCache.txt" "$ashen_log/CMakeCache.txt"
if ((ashen_configure_only)); then
    printf 'Configure completed. Resume with --resume %q --profile %q\n' "$ashen_directory" "$ashen_profile"
    exit 0
fi
cmake --build "$ashen_build" --target ashen_compat_tests --parallel "$ashen_jobs" 2>&1 | tee "$ashen_log/build-tests.log"
ctest --test-dir "$ashen_build" --output-on-failure --no-tests=error -R '^ashen_compatibility$' 2>&1 | tee "$ashen_log/tests.log"
ashen_targets=(authserver worldserver)
[[ $ashen_target == all ]] || ashen_targets=("$ashen_target")
for ashen_app in "${ashen_targets[@]}"; do
    cmake --build "$ashen_build" --target "$ashen_app" --parallel "$ashen_jobs" 2>&1 | tee "$ashen_log/build-$ashen_app.log"
    ashen_binary="$ashen_build/src/server/apps/$ashen_app"
    "$ashen_binary" --version 2>&1 | tee "$ashen_log/$ashen_app-version.txt"
    sha256sum "$ashen_binary" > "$ashen_log/$ashen_app-sha256.txt"
    llvm-readelf -h -l -d "$ashen_binary" > "$ashen_log/$ashen_app-elf.txt"
done
if ((ashen_stage)); then
    cmake --install "$ashen_build" 2>&1 | tee "$ashen_log/install.log"
    for ashen_app in authserver worldserver; do
        "$ashen_directory/stage/bin/$ashen_app" --version 2>&1 | tee "$ashen_log/$ashen_app-staged-version.txt"
    done
fi
printf 'Validation completed. Results: %s\n' "$ashen_log"
printf 'Binaries: %s/src/server/apps/{authserver,worldserver}\n' "$ashen_build"
