#!/bin/bash
set -eux

# Kind of a Win-enhanced bash file: We caould call it: `.wine-bash`
echo "hi compiler"

echo '$REPO_ROOT=' "$REPO_ROOT"
# Define the base filename and directories
FILE_BASENAME=test_ifcsdk_compilation
OUTPUT_BIN=$REPO_ROOT/out
INPUT_SRC=$REPO_ROOT/src
INPUT_INCLUDES=$REPO_ROOT/includes-symb

# Ensure output and includes directories exist
mkdir -p $OUTPUT_BIN
mkdir -p $INPUT_INCLUDES

# Link to the IFC SDK includes
ln -s -f "$REPO_ROOT/external/oda-ifc-sdk" $INPUT_INCLUDES/ifcsdk

# Compilation command using cl.exe
cl.exe \
   /EHsc /std:c++20 \
   /I "$INPUT_INCLUDES" \
   /Fo"$OUTPUT_BIN/" \
   /Fe"$OUTPUT_BIN/$FILE_BASENAME.exe" \
   "$INPUT_SRC/$FILE_BASENAME.cpp"
