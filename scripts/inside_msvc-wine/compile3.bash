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

/opt/msvc/bin/x64/cl \
   /EHsc /std:c++20  /I./includes-symb/  \
   /I/home/ephemssss/novorender/oda-sdk/vc16/Sdai/Include  \
   /I/home/ephemssss/novorender/oda-sdk/vc16/Ifc/Include  \
   /I/home/ephemssss/novorender/oda-sdk/vc16/Kernel/Include \
   /I/home/ephemssss/novorender/oda-sdk/vc16/KernelBase/Include \
   /I/home/ephemssss/novorender/oda-sdk/vc16/Ifc/Include \
   /I/home/ephemssss/novorender/oda-sdk/vc16/Ifc/Include/Common \
   \
   ./src/first_ifcapp.cpp \
   \
   -Fo./out/ \
   -Fe./out/a3.exe  \
   \
   /link /LIBPATH:/home/ephemssss/novorender/oda-sdk/vc16/lib/vc16_amd64dll \
   IfcCore.lib IfcBrepModeler.lib IfcFacetModeler.lib TB_Common.lib


ls -alth ./out

WINEDEBUG="-fixme-all" wine64 ./out/a3.exe

