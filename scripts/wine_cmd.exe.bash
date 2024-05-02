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

# Must inherit this: gitrepo_reset_to_root
#   othewise, workaround
function default_wine_32 {
   # workaround

   echo "Using workaround, sincince "flow closure info" are missing as a result of headless running"

   gitrepo_reset_to_root__

   function verify_x_stack {
      echo "no verify in workaround, since it may be directly sending x-windows to client (local machine)'s XQuartz"
      # in that case, `DISPLAY` should be something like "localhost:10.0", in which, "localhost" is actually the ssh-client's local machine (runnning an insatnce of XQuartz)
   }

   WINE_PREFIX_=/mnt/volume_lon1_01/ifc2brep/wine32
   DESIRED_DISPLAY=":1"
   WINE_ARCH_="win32"
   WINE_PREFIX_="wine32"

   echo "$REPO_ROOT" >/dev/null  # verify already defined


   # Providing: $WINE_PREFIX_ $DESIRED_DISPLAY, $WINE_ARCH_, $REPO_ROOT, gitrepo_reset_to_root, verify_x_stack
   # DISPLAY=$DESIRED_DISPLAY   WINEPREFIX=$WINE_PREFIX_  WINEARCH=$WINE_ARCH_  $WINE_PREFIX_  \
      # cmd.exe or any command

}

gitrepo_reset_to_root || default_wine_32


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

# add your command here in this file

echo "DISPLAY:  $DISPLAY"
echo 'Usage:'
echo '   WINEPREFIX=$WINE_PREFIX_ WINEARCH=$WINE_ARCH_  wine  WINDOWS_MSDOS_PROGRAM_NAME'
echo '   (source env2.env && winetricks list-all)'
echo '   (source env2.env && wine  WINDOWS_MSDOS_PROGRAM_NAME)'

#   $$P$$G"
DISPLAY=$DESIRED_DISPLAY   WINEPREFIX=$WINE_PREFIX_  WINEARCH=$WINE_ARCH_  wine  \
   cmd /k scripts/inside_windows/cmd_prompt.bat
   # /k "PROMPT $$E[32m$$P$$E[34m$$G$$E[0m"

# Names: winebat -> inside_wine -> inside_windows
