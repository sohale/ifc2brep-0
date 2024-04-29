set -eux

# see scripts/setup-msvc.bash
function gitrepo_reset_to_root__() {
   # Sets directory context to the root of the git repository
   # git rev-parse --show-toplevel
   SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
   cd $SCRIPT_DIR
   REPO_ROOT=$(git rev-parse --show-toplevel)
   cd $REPO_ROOT
}

function installations {
   # do we need these too?
   error
   sudo apt-get install xorg libx11-6 wine
}

gitrepo_reset_to_root

mkdir -p $REPO_ROOT/external-tools/wine64
export WINE64_PREFIX=$REPO_ROOT/external-tools/wine64

echo "Wine folder is: $WINE64_PREFIX"

ls -1 $WINE64_PREFIX >/dev/null  # verify it exists

# not: DISPLAY=:0.0
# export DESIRED_DISPLAY=:1
# maket sure this exists DESIRED_DISPLAY=":1"

# DISPLAY=:0.0 WINEPREFIX=$WINE64_PREFIX WINARCH=win64  xvfb-run wine64  cmd
# cd $REPO_ROOT/external-tools/

sleep 1
verify_x_stack

echo "DISPLAY:  $DISPLAY"
echo 'add your command here in this file:       WINEPREFIX=$WINE64_PREFIX WINARCH=win64  wine64     YOURCOMMAND   '

#   $$P$$G"
DISPLAY=$DESIRED_DISPLAY   WINEPREFIX=$WINE64_PREFIX  WINARCH=win64  wine64  \
   cmd /k scripts/inside_wine/cmd_prompt.bat
   # /k "PROMPT $$E[32m$$P$$E[34m$$G$$E[0m"
