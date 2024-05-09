set -eux

# to be run after: scripts/inside_msvc-wine/compile3.bash whic itself is run inside scripts/wine_init_sol3.bash
# based on: scripts/wine_cmd.exe.bash

echo "This script runs exe (compiled using sol3 env) in the "sol2" env"
echo "Sol2Env: Wine folder is: $WINE_PREFIX_"


# source env1_sol2.env
# Contains the "sol2"'s env for running wine64
source env2_sol2.env
# Contains the built executable and its reauquired PATH
source built_s23_a3.env
env
ls -1 $WINE_PREFIX_ >/dev/null  # verify it exists
ls -1 $BUILT_FILENAME >/dev/null  # verify it exists



gitrepo_reset_to_root || default_wine_64


echo "Wine folder is: $WINE_PREFIX_    for  $WINE_COMMAND_"
echo "X-Windows \$DISPLAY=$DISPLAY"
echo "ODA DLLs are in: $DLL_PREFIX_WINE"
echo "executable in: $BUILT_FILENAME"




# DLL_PREFIX_WINE="z:\\home\\ephemssss\\novorender\\oda-sdk\\vc16\\exe\\vc16_amd64dll"
# BUILDOUTPUT="./build-output"

WINEPATH="$DLL_PREFIX_WINE;${WINEPATH:-}" wine64 ./build-output/a3.exe^C



WINEARCH
WINEPREFIX
DISPLAY
WINE_COMMAND_

export WINEPATH="$DLL_PREFIX_WINE;${WINEPATH:-}"
$WINE_COMMAND_
