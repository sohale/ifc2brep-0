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

/opt/msvc/bin/x64/cl \
   /EHsc /std:c++20  /I./includes-symb/  \
   /I$INC1_PREFIX/Sdai/Include  \
   /I$INC1_PREFIX/Ifc/Include  \
   /I$INC1_PREFIX/Kernel/Include \
   /I$INC1_PREFIX/KernelBase/Include \
   /I$INC1_PREFIX/Ifc/Include \
   /I$INC1_PREFIX/Ifc/Include/Common \
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

