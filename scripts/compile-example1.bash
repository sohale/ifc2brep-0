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

# includes
# /IFC4
ln -s -f "$REPO_ROOT/external/oda-ifc-sdk"  $INPUT_INCLUDES/ifcsdk

# Compile

clang++  \
   -std=c++20  -stdlib=libstdc++  \
   -I $INPUT_INCLUDES   \
   $INPUT_SRC/$FILE_BASENAME.cpp   \
  -o $OUTPUT_BIN/$FILE_BASENAME.out
#  -v
# -lstdc++
# -L library
# -l link
# -I include
