set -eux

# to be run after: scripts/inside_msvc-wine/compile3.bash whic itself is run inside scripts/wine_init_sol3.bash
# based on: scripts/wine_cmd.exe.bash

echo "This script runs exe (compiled using sol3 env) in the "sol2" env"


# framework's common envs
source env_sol3.env

# source env1_sol2.env
# Contains the "sol2"'s env for running wine64
source env2_sol2.env
# Contains the built executable and its reauquired PATH
source built_s23_a3.env
env
ls -1 $WINEPREFIX >/dev/null  # verify it exists
ls -1 $BUILT_FILENAME >/dev/null  # verify it exists



gitrepo_reset_to_root

# sol2
echo "Sol2Env: Wine folder is: $WINEPREFIX"
echo "Wine folder is: $WINEPREFIX    for  $WINE_COMMAND_ using arch:$WINEARCH"
echo "X-Windows \$DISPLAY=$DISPLAY"
# sol3 (from)
echo "ODA DLLs are in: $DLL_PATH"
echo "executable in: $BUILT_FILENAME"



# DLL_PATH
# DLL_PREFIX_WINE="z:\\home\\ephemssss\\novorender\\oda-sdk\\vc16\\exe\\vc16_amd64dll"
# BUILDOUTPUT="./build-output"

# WINEPATH="$DLL_PATH;${WINEPATH:-}" wine64 ./build-output/a3.exe

echo $WINEARCH $WINEPREFIX $DISPLAY $WINE_COMMAND_
echo $DLL_PATH $BUILT_FILENAME

export WINEPATH="$DLL_PATH;${WINEPATH:-}"
$WINE_COMMAND_  $BUILT_FILENAME
