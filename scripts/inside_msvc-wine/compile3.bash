#!/bin/bash
set -eux

# To run:
# ./scripts/wine_init_sol3.bash
# ./scripts/inside_msvc-wine/compile3.bash

# which .env ?
# source repo.env
# source repo3.env


# Note: amd64 is used.
# vc16 is assumed?
# But I am using 19.39.33523 (x64)

echo '$REPO_ROOT=' "$REPO_ROOT"
cd $REPO_ROOT

INC1_PREFIX="/home/ephemssss/novorender/oda-sdk/vc16"
LIB_PREFIX="/home/ephemssss/novorender/oda-sdk/vc16/lib"

include_dirs=(
    "KernelBase"
    "KernelBase/Include"
    "Kernel/Include"
    "Kernel/Extensions/ExServices"
    "Ifc/Include"
    "Ifc/Include/Common"
    "Ifc/Include/sdai"
    "Ifc/Include/sdai/daiHeader"
    "Ifc/Extensions/ExServices"
    "Ifc/Examples/Common"
    "ThirdParty"
    "ThirdParty/activation"
)

define_macros=(
   TEIGHA_TRIAL
   My_DEFINE_MACRO=123123
)

#########

compileflags_incl_list=""
for dir in "${include_dirs[@]}"; do
    compileflags_incl_list+=" /I$INC1_PREFIX/$dir"
done

compileflags_definemacros=""
for def in "${define_macros[@]}"; do
    compileflags_definemacros+=" /D$def"
done

echo "********************"
echo $compileflags_definemacros
echo "********************"

/opt/msvc/bin/x64/cl \
   /EHsc /std:c++20  /I./includes-symb/  \
   \
   $compileflags_incl_list  \
   $compileflags_definemacros  \
   \
   ./src/first_ifcapp.cpp \
   \
   -Fo./out/ \
   -Fe./out/a3.exe  \
   \
   /link /LIBPATH:$LIB_PREFIX/vc16_amd64dll \
   IfcCore.lib IfcBrepModeler.lib IfcFacetModeler.lib TB_Common.lib


ls -alth ./out

WINEDEBUG="-fixme-all" wine64 ./out/a3.exe

