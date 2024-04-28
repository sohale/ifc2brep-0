set -eux

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
   # do we need these too?
   error
   sudo apt-get install xorg libx11-6 wine
}

gitrepo_reset_to_root

mkdir -p $REPO_ROOT/external-tools/wine64
export WINE64_PREFIX=$REPO_ROOT/external-tools/wine64

echo "Wine folder is: $WINE64_PREFIX"

ls -1 $WINE64_PREFIX >/dev/null  # verify it exists

DISPLAY=:0.0 WINEPREFIX=$WINE64_PREFIX WINARCH=win64  xvfb-run wine64  cmd
# cd $REPO_ROOT/external-tools/
