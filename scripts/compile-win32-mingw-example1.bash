#!/bin/bash
set -exu
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR
REPO_ROOT=$(git rev-parse --show-toplevel)
cd $REPO_ROOT


# better than CMake

FILE_BASENAME=test_ifcsdk_compiletion

OUTPUT_BIN=$REPO_ROOT/out
INPUT_SRC=$REPO_ROOT/src
INPUT_INCLUDES=$REPO_ROOT/includes-symb
mkdir -p $OUTPUT_BIN
mkdir -p $INPUT_INCLUDES

# Backup
mv -f  "$OUTPUT_BIN/$FILE_BASENAME.out"  "$OUTPUT_BIN/$FILE_BASENAME.out.old" || :  # Don't err

PROJECT_PATH_BASE="novorender"
# ln -s "$HOME/$PROJECT_PATH_BASE/oda-sdk/vc16/Ifc"  external/oda-ifc-sdk

# includes
rm $INPUT_INCLUDES/* || :
touch $INPUT_INCLUDES/.gitkeep
# /IFC4
# ln -s -f "$REPO_ROOT/external/oda-ifc-sdk"  $INPUT_INCLUDES/ifcsdk
ln -s "$HOME/$PROJECT_PATH_BASE/oda-sdk/vc16"  $INPUT_INCLUDES/ifcsdk-win

# Compile

x86_64-w64-mingw32-g++ \
    -std=c++20 \
    -I/usr/x86_64-w64-mingw32/include \
    -L/usr/x86_64-w64-mingw32/lib \
    -I$INPUT_INCLUDES/ifcsdk-win \
    $INPUT_SRC/$FILE_BASENAME.cpp \
    -o $OUTPUT_BIN/$FILE_BASENAME.out \
    -lstdc++ -static \
    -mconsole

#    -Wl,-subsystem,console
#    -mconsole


# Cross-compiling notes:
# In theory, I could use clang++ with `-target x86_64-pc-windows-msvc` or ,`x86_64-w64-mingw32` but it didn't work
# MSVC ABI
#
#+   -target x86_64-w64-mingw32    \
#+   -I /usr/include/x86_64-linux-gnu/    \
#+   -L /usr/lib/gcc/x86_64-w64-mingw32/10-win32 \
# See also scripts/init-setup.bash: `dpkg --add-architecture i386` and `apt install mingw-w64` and `apt install wine32`
#
# Possible solution: (In theory)
#+   -target x86_64-pc-windows-msvc    \
