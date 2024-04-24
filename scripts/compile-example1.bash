#!/bin/bash
set -exu
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR
REPO_ROOT=$(git rev-parse --show-toplevel)
cd $REPO_ROOT


# better than CMake

FILE_BASENAME=test_ifcsdk_compiletion

BIN_OUTPUT=$REPO_ROOT/out
SRC_INPUT=$REPO_ROOT/src
INPUT_INCLUDES=$REPO_ROOT/includes-symb
mkdir -p $BIN_OUTPUT
mkdir -p $INPUT_INCLUDES

# Backup
mv -f  "$BIN_OUTPUT/$FILE_BASENAME.out"  "$BIN_OUTPUT/$FILE_BASENAME.out.old" || :  # Don't err

# includes
# /IFC4
ln -s "$REPO_ROOT/external/oda-ifc-sdk"  $INPUT_INCLUDES/ifcsdk

# Compile

clang++  \
   -std=c++20  -stdlib=libstdc++  \
   ../includes-symb   \
   $SRC_INPUT/$FILE_BASENAME.cpp   \
  -o $BIN_OUTPUT/$FILE_BASENAME.out
#  -v  -lstdc++
