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
export -f gitrepo_reset_to_root

##############
# Some generic utils
export ERROR_ExCODE=1
export SUCCESS_ExCODE=0

function pid_from_psaux {
   # Usage: pipe with a `ps aux`
   cut -c10-16
}
export -f pid_from_psaux

##############

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
   # but not recommended. Dont use `xvfb-run` with `wine64`. Simply. wine64, but set $DIPLAY before it.

   sudo apt-get install xorg openbox
   sudo apt install x11vnc

   sudo apt install xterm
   #sudo apt-get install x11-apps libx11-6
   # will make avvailable xclock, xeyes, xterm
   sudo apt-get install xorg openbox
   sudo apt-get install openbox

   # Wine -> xvfb -> openbox -> x11vnc -> (client) TightVNC

   # Verify
   # dpkg -l | grep xorg
   # dpkg -l | grep openbox
   sudo Xorg -version
   #   X.Org X Server 1.21.1.4
   #   X Protocol Version 11, Revision 0
   openbox --version
   # | verfy(Openbox 3.6.1)
   Xvfb -help


   echo "Not re-tested from clean slate"

}
function ONCE {
   # how to keep env var local?
   local commandname="$1"
   shift  # Remove the first argument `ONCE` and shift the rest to the left

   # Protection mechanism: Use 'command -v' to check if the program is in PATH
   if ! command -v "$commandname" > /dev/null; then
      echo "Error: Command not found: $commandname"
      return $ERROR_ExCODE
   fi

   #  Check if the process is already running. We only want one instance of tha running.
   if ! pgrep -f $commandname > /dev/null; then

      echo "An instance of \"$commandname\" is not running. Going to run it: $commandname $*"
      # Run it, and return the code:
      ##############################
      "$commandname" "${@}"
      ##############################

      local exitcode=$?
      return $exitcode

   else
      echo "Verified: $commandname is already running. Skipping."
   fi
   # return $SUCCESS_ExCODE
}

function run_x_stack {

   echo "---"
   ps aux | grep -v grep  | grep -e Xvfb -e openbox -e vnc || :
   # Kill if any are up (a distributed "restart")
   ps aux | grep -v grep  | grep -e Xvfb -e openbox -e vnc | pid_from_psaux | xargs kill || :
   ps aux | grep -v grep  | grep -e Xvfb -e openbox -e vnc || :


   sleep 1
   export DESIRED_DISPLAY=":1"

   #########################
   # "Up" the three processes that are necessary for directing Wine GUI graphical output to your local computer.
   # In method one, the stack is:
   #    windows_program -> cmd -> $DISPLAY -> Xvfb -> openbox -> x11vnc --> (Linux --> MacOS) --> `ssh -Y`  --> TightVNC (MacOS)
   # You need to have  connected using `ssh -Y user@host` to be able to connect to (receive the GUI from) `x11vnc`
   # No xvfb-run, no XQuartz

   echo DISPLAY1=$DISPLAY
   ONCE Xvfb "$DESIRED_DISPLAY" -screen 0 1024x768x16 &
   echo DISPLAY2=$DISPLAY
   sleep 0.5
   echo DISPLAY3=$DISPLAY
   # Suddenly it has a proper window too:
   # a "stacking window manager"
   # don't need session management (r.g. lxsession ) capabilities (such as saving and restoring sessions) => no need to set SESSION_MANAGER
   DISPLAY=$DESIRED_DISPLAY ONCE openbox --debug &
   # Also this ^ may affect the `DISPLAY` env?
   sleep 0.5
   echo DISPLAY4=$DISPLAY
   DISPLAY=$DESIRED_DISPLAY ONCE x11vnc -display "$DESIRED_DISPLAY" -nopw &
         # -ncache 10
         # -passwd yourPassword
         # -ssl
   echo DISPLAY5=$DISPLAY
   sleep 0.5
   echo DISPLAY6=$DISPLAY


   ##########################

   export DISPLAY="$DESIRED_DISPLAY"
   echo "DISPLAY7:  $DISPLAY"

  # verify these three (servers-like) processes are running ^
  # Only run if they are not running.

   function verify_x_stack {
   # Verificaiton + idempotency
   # renamed: run_x_stack__verify -> verify_x_stack

   # verify "visually" (also useful for cli: for user surface): "evidence"
   # Can be run before or after
   # may or may not gather info about meeting requirement
   ps aux | grep -v grep  | grep -e Xvfb -e openbox -e vnc || :

   if ! pgrep -f Xvfb > /dev/null; then
      echo "Warning: Xvfb missing"
      return $ERROR_ExCODE
   else
      echo "Verified: Xvfb"
   fi
   if ! pgrep -f openbox > /dev/null; then
      echo "Warning: openbox missing"
      return $ERROR_ExCODE
   else
      echo "Verified: openbox"
   fi
   if ! pgrep -f x11vnc > /dev/null; then
      echo "Warning: x11vnc missing"
      return $ERROR_ExCODE
   else
      echo "Verified: x11vnc"
   fi
   return $SUCCESS_ExCODE
   }
   export -f verify_x_stack

   verify_x_stack

}


gitrepo_reset_to_root

# The main difference witrh wine_cmd.exe
run_x_stack
verify_x_stack

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

$REPO_ROOT/scripts/wine_cmd.exe.bash

ExC=$?
echo "doone. exit code: $ExC"
exit $ExC
#

export DISPLAY=:1

echo "DISPLAY:  $DISPLAY should be set. to redicrect the output to above stack. I will set it based on DESIRED_DISPLAY=$DESIRED_DISPLAY"
echo 'add your command here in this file:    WINEPREFIX=$WINE64_PREFIX WINARCH=win64  wine64     YOUR_WINDOWS_MSDOS_COMMAND   '


# no 'DISPLAY=:0.0 '?
# DISPLAY=:0.0 WINEPREFIX=$WINE64_PREFIX WINARCH=win64  xvfb-run wine64  cmd

# DISPLAY=:0.0
#DISPLAY=localhost:10.0
# WINEPREFIX=$WINE64_PREFIX WINARCH=win64  xvfb-run wine64  cmd

# WINEDEBUG=warn+all  WINEPREFIX=$WINE64_PREFIX  xvfb-run wine64 explorer /desktop=name,1024x768 notepad.exe

# WINEPREFIX=$WINE64_PREFIX   xvfb-run wine64  notepad

# DISPLAY=:1 WINEPREFIX=$WINE64_PREFIX WINARCH=win64  wine64  cmd

export DISPLAY=:1


WINEPREFIX=$WINE64_PREFIX WINARCH=win64  wine64  cmd
