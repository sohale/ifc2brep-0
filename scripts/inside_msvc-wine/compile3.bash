#!/bin/bash
set -eux

# To run:
# ./scripts/wine_init_sol3.bash
# ./scripts/inside_msvc-wine/compile3.bash

# which .env ?
# source repo.env
# source repo3.env


# Note:
# platform: `amd64`
# vc16 is assumed?
# But I am using 19.39.33523 (x64)
# vc16 — Microsoft Visual C++ 2019 ( see https://docs.intellicad.org/files/oda/2021_11/oda_ifc_docs/frames.html?frmname=topic&frmfile=ifc_getting_started_downloading.html )

echo '$REPO_ROOT=' "$REPO_ROOT"
cd $REPO_ROOT

INC1_PREFIX="/home/ephemssss/novorender/oda-sdk/vc16"
LIB_PREFIX="/home/ephemssss/novorender/oda-sdk/vc16/lib"
DLL_PREFIX_WINE="z:\\home\\ephemssss\\novorender\\oda-sdk\\vc16\\exe\\vc16_amd64dll"

BUILDOUTPUT="./build-output"

OdActivationInfoFILE="$REPO_ROOT/secrets/OdActivationInfo"
# OdActivationInfoINCLUDE="$REPO_ROOT/secrets"
ACTIVATION_INCLUDE="$REPO_ROOT/secrets"

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

    # for daiModule.h
    "Sdai/Include"

    "Sdai/Include/daiHeader"
)

# preprocessor definitions
define_macros=(

   UNICODE
   # Trial version is used
   TEIGHA_TRIAL
   ODA_LICENSING_ENABLED
   IFC_DYNAMIC_BUILD
   _TOOLKIT_IN_DLL_
   CMAKE_INTDIR="Release"
   My_DEFINE_MACRO=123123

)

libraries_to_link=(
   IfcCore.lib
   sdai.lib
   TD_Gi.lib
   TD_Ge.lib
   TD_Root.lib
   TD_DbRoot.lib
   TD_ExamplesCommon.lib
   TD_Alloc.lib

   # IfcCore.lib IfcBrepModeler.lib IfcFacetModeler.lib TB_Common.lib
)
# The .tx files are loaded in runtime, don't add them to libraries_to_link

#########

compileflags_incl_list=""
for dir in "${include_dirs[@]}"; do
    compileflags_incl_list+=" /I$INC1_PREFIX/$dir"
done

compileflags_definemacros=""
for def in "${define_macros[@]}"; do
    compileflags_definemacros+=" /D$def"
done

compileflags_libs=""
for lib1 in "${libraries_to_link[@]}"; do
    compileflags_libs+=" $lib1"
done


echo "********************"
echo $compileflags_definemacros
echo "********************"

mkdir -p $BUILDOUTPUT



export RED='\033[0;31m'
export GREEN='\033[0;32m'
export NC='\033[0m'  # Color Reset

# compileflags_incl_list+=" /I$ACTIVATION_INCLUDE"

/opt/msvc/bin/x64/cl \
   /EHsc /std:c++20  /I./includes-symb/  \
   \
   $compileflags_incl_list  \
   /I$ACTIVATION_INCLUDE   \
   \
   $compileflags_definemacros  \
   \
   -Fo$BUILDOUTPUT/ \
   -Fe$BUILDOUTPUT/a3.exe  \
   \
   ./src/first_ifcapp.cpp \
   \
   /link /LIBPATH:$LIB_PREFIX/vc16_amd64dll \
   $compileflags_libs

set +x  # echo off

ls -alth $BUILDOUTPUT
export EXEFILE=$BUILDOUTPUT/a3.exe

echo -e "Compile ${GREEN} successful${NC}: ${EXEFILE}"

echo "Executing ..."
export WINEPATH="$DLL_PREFIX_WINE;${WINEPATH:-}"
echo "WINEPATH: $WINEPATH"

#    strace -f -e trace=file,process,network -o output.txt \

# Skip running the built file. Use instead: scripts/wine_run_built_exe_sol2.bash
: || \
WINEDEBUG="-fixme-all" \
   wine64 $BUILDOUTPUT/a3.exe \
   || :

# skip cmd, and return to sol3 wine-env
: || \
wine64 cmd.exe

echo -n "Note: "
echo "This, sol3, cannot execute a3.exe. Instead, use sol2 for running it."
# echo 'DLL_PREFIX_WINE="z:\\home\\ephemssss\\novorender\\oda-sdk\\vc16\\exe\\vc16_amd64dll"'
# echo 'WINEPATH="\$DLL_PREFIX_WINE;\${WINEPATH:-}" wine64 ./build-output/a3.exe'


cat << EOF_ENV > built_s23_a3.env

   export DLL_PATH="$DLL_PREFIX_WINE"
   export BUILT_FILENAME="$BUILDOUTPUT/a3.exe"

EOF_ENV
# The next script (with its own wine) will know what executable file to run

echo "$(realpath built_s23_a3.env) :"
cat built_s23_a3.env
