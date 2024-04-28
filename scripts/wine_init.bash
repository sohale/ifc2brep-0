set -eux

# the wine_init.bash, for setting up wine on your system + wine runtime (WINE_PREFIX)

# see scripts/setup-msvc.bash
function gitrepo_reset_to_root() {
   # Sets directory context to the root of the git repository
   # git rev-parse --show-toplevel
   SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
   cd $SCRIPT_DIR
   REPO_ROOT=$(git rev-parse --show-toplevel)
   cd $REPO_ROOT
}

function installations {
   echo "Not implemented"
   # set the apt repo, key, etc
   error
   # Also: X-windows ones
}
function installations_x {
   # Also: X-windows ones
   sudo apt install xvfb

   # New affordances:

   # Xvfb :0 -screen 0 1024x768x16 &
   # jid=$!
   # echo $jid

   # xvfb-run wine64



   # sudo apt-get install xorg openbox
   # dpkg -l | grep xorg
   # dpkg -l | grep openbox


   # Verify
   sudo Xorg -version
   #   X.Org X Server 1.21.1.4
   #   X Protocol Version 11, Revision 0
   openbox --version
   # | verfy(Openbox 3.6.1)
   Xvfb -help

   echo "To be implemented ..."
   error
}

gitrepo_reset_to_root

mkdir -p $REPO_ROOT/external-tools/wine64
export WINE64_PREFIX=$REPO_ROOT/external-tools/wine64

echo "Wine folder is: $WINE64_PREFIX"

ls -1 $WINE64_PREFIX >/dev/null  # verify it exists

# now, you can run wine64 cmd

# ^ wine prefix
####################

# If already done, skip this step
#WINEPREFIX=$WINE64_PREFIX WINARCH=win64 winetricks \
#    corefonts \
#    win10
# arch=32|64  # for creating 64 or 32

#WINEPREFIX=$WINE64_PREFIX WINARCH=win64 winetricks \
#      apps list
#      #x11-apps


export DISPLAY=:1

echo "DISPLAY:  $DISPLAY"
echo 'add your command here in this file:       WINEPREFIX=$WINE64_PREFIX WINARCH=win64  xvfb-run wine64     YOURCOMMAND   '


# no 'DISPLAY=:0.0 '?
# DISPLAY=:0.0 WINEPREFIX=$WINE64_PREFIX WINARCH=win64  xvfb-run wine64  cmd

# DISPLAY=:0.0
#DISPLAY=localhost:10.0
# WINEPREFIX=$WINE64_PREFIX WINARCH=win64  xvfb-run wine64  cmd

# WINEDEBUG=warn+all  WINEPREFIX=$WINE64_PREFIX  xvfb-run wine64 explorer /desktop=name,1024x768 notepad.exe

# WINEPREFIX=$WINE64_PREFIX   xvfb-run wine64  notepad

DISPLAY=:1 WINEPREFIX=$WINE64_PREFIX WINARCH=win64  wine64  cmd
