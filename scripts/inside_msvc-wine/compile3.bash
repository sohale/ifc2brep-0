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

/opt/msvc/bin/x64/cl \
   /EHsc /std:c++20  /I./includes-symb/  \
   \
   $compileflags_incl_list  \
   $compileflags_definemacros  \
   \
   -Fo./out/ \
   -Fe./out/a3.exe  \
   \
   ./src/first_ifcapp.cpp \
   \
   /link /LIBPATH:$LIB_PREFIX/vc16_amd64dll \
   $compileflags_libs


ls -alth ./out

WINEDEBUG="-fixme-all" wine64 ./out/a3.exe

