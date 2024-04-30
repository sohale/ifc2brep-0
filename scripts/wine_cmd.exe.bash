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

# Must inherit this
# mkdir -p $REPO_ROOT/external-tools/wine64
# export WINE_PREFIX_=$REPO_ROOT/external-tools/wine64

echo "Wine folder is: $WINE_PREFIX_"

ls -1 $WINE_PREFIX_ >/dev/null  # verify it exists

# not: DISPLAY=:0.0
# export DESIRED_DISPLAY=:1
# maket sure this exists DESIRED_DISPLAY=":1"

# DISPLAY=:0.0 WINEPREFIX=$WINE_PREFIX_ WINEARCH=$WINE_ARCH_  xvfb-run wine  cmd
# cd $REPO_ROOT/external-tools/

sleep 1
verify_x_stack

echo "DISPLAY:  $DISPLAY"
echo 'add your command here in this file:       WINEPREFIX=$WINE_PREFIX_ WINEARCH=$WINE_ARCH_  wine     YOURCOMMAND   '

#   $$P$$G"
DISPLAY=$DESIRED_DISPLAY   WINEPREFIX=$WINE_PREFIX_  WINEARCH=$WINE_ARCH_  wine  \
   cmd /k scripts/inside_windows/cmd_prompt.bat
   # /k "PROMPT $$E[32m$$P$$E[34m$$G$$E[0m"

# Names: winebat -> inside_wine -> inside_windows
