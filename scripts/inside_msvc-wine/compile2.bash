#!/bin/bash
set -eux

# Compiles cli program 2 ...
# It is in Linux (container) and uses Wine to run the Windows compiler

# To run:
# ./scripts/wine_init_sol3.bash
# ./scripts/inside_msvc-wine/compile2.bash

echo '$REPO_ROOT=' "$REPO_ROOT"

ls -alth

# to find them:
#   find /home/ephemssss/novorender/oda-sdk/vc16/ |grep IfcModelProcessor

# ifcsdk-win/Ifc/Include/IfcModelProcessor.h
# /home/ephemssss/novorender/oda-sdk/vc16/Sdai/Include/daiModel.h
# ...

# MAINCPP=
/opt/msvc/bin/x64/cl \
   /EHsc /std:c++20  /I./includes-symb/  \
   /I/home/ephemssss/novorender/oda-sdk/vc16/Sdai/Include  \
   /I/home/ephemssss/novorender/oda-sdk/vc16/Ifc/Include  \
   /I/home/ephemssss/novorender/oda-sdk/vc16/Kernel/Include \
   /I/home/ephemssss/novorender/oda-sdk/vc16/KernelBase/Include \
   /I/home/ephemssss/novorender/oda-sdk/vc16/Ifc/Include \
   /I/home/ephemssss/novorender/oda-sdk/vc16/Ifc/Include/Common \
   \
   \
   -Fo./out/ \
   -Fe./out/a.exe  \
   ./src/test_ifcsdk_compiletion.cpp \
   \
   /link /LIBPATH:/home/ephemssss/novorender/oda-sdk/vc16/lib/vc16_amd64dll IfcCore.lib IfcBrepModeler.lib IfcFacetModeler.lib TB_Common.lib


ls -alth ./out

WINEDEBUG="-fixme-all" wine64 ./out/a.exe

exit 0


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


_wp() {
   # Function to convert Unix path to Windows path using winepath
   # $EEE -> $(_wp $EEE)
   # to_win_path
    winepath -w "$1"
}

_wp2() {
   # Function to convert Unix path to Windows path using winepath
   # EEE -> $(_wp2 EEE)
    winepath -w "$1"
}

# Compilation command using cl.exe
cl.exe \
   /EHsc /std:c++20 \
   /I "$(_wp $INPUT_INCLUDES)" \
   /Fo"$(_wp $OUTPUT_BIN)/" \
   /Fe"$(_wp $OUTPUT_BIN)/$FILE_BASENAME.exe" \
   "$(_wp $INPUT_SRC)/$FILE_BASENAME.cpp"

# cl.exe /EHsc /std:c++20 /I './includes-symb' '/Fo./out/' '/Fe./out/test_ifcsdk_compilation.exe' './src/test_ifcsdk_compilation.cpp'
