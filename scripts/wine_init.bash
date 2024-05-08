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

function installations_base {
   sudo apt install msitools

   # todo: winehq-apt
   # todo: winehq
   # set the apt repo, key, etc

   echo "Installations: not fully automated"
   # error
}
function installations_x {
   # Also: X-windows ones
   sudo apt install xvfb


   # New affordances:

   # Xvfb :0 -screen 0 1024x768x16 &
   # jid=$!
   # echo $jid

   # xvfb-run $WINE_COMMAND_
   # but not recommended. Dont use `xvfb-run` with `wine`. Simply `wine`, but set `$DISPLAY` before it.

   sudo apt-get install xorg openbox
   sudo apt install x11vnc
   # sudo apt-get install xorg libx11-6 wine

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

function run_x_stack1 {

   echo "re-run_x_stack"

   ps aux | grep -v grep  | grep -e Xvfb -e openbox -e vnc || :
   # Kill if any are up (a distributed "restart")
   ps aux | grep -v grep  | grep -e Xvfb -e openbox -e vnc | pid_from_psaux | xargs kill || :
   ps aux | grep -v grep  | grep -e Xvfb -e openbox -e vnc || :

   sleep 0.5
   export DESIRED_DISPLAY=":1"

   #########################
   # "Up" the three processes that are necessary for directing Wine GUI graphical output to your local computer.
   # In method one, the stack is:
   #    windows_program -> cmd -> $DISPLAY -> Xvfb -> openbox -> x11vnc --> (Linux --> MacOS) --> `ssh -Y`  --> TightVNC (MacOS)
   # You need to have  connected using `ssh -Y user@host` to be able to connect to (receive the GUI from) `x11vnc`
   # No xvfb-run, no XQuartz

   ONCE Xvfb "$DESIRED_DISPLAY" -screen 0 800x600x16 &
   sleep 0.5

   # Suddenly it has a proper window too:
   # a "stacking window manager"
   # don't need session management (r.g. lxsession ) capabilities (such as saving and restoring sessions) => no need to set SESSION_MANAGER
   DISPLAY=$DESIRED_DISPLAY ONCE openbox &   # --debug
   # Does this ^ may affect the `DISPLAY` env? No.
   sleep 0.5

   DISPLAY=$DESIRED_DISPLAY ONCE x11vnc -display "$DESIRED_DISPLAY" -nopw &
         # -ncache 10
         # -passwd yourPassword
         # -ssl
   sleep 0.5

   ##########################

   export DISPLAY="$DESIRED_DISPLAY"
   echo "DISPLAY:  $DISPLAY"

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


function run_x_stack2 {

   echo "re-run_x_stack 2"

   sleep 0.5
   echo "before:DISPLAY:  $DISPLAY"

   export DISPLAY="localhost:10.0"
   export DESIRED_DISPLAY=$DISPLAY

   ############################
   # In method one, the stack is:
   #    windows_program -> cmd -> wine32 -> $DISPLAY -> (as localhost: which via ssh, it refers to MacOS's) --> (Linux --> MacOS) --> `ssh -Y`  --> XQuartz (MacOS)
   # You need to have  connected using `ssh -Y user@host` to be able to connect to (receive the GUI from) `wine` to XQuartz
   # No Xvfb openbox x11vnc, xvfb-run, yes: XQuartz
   #

   # DISPLAY shoud be "localhost:10.0"

   # export DISPLAY="$DESIRED_DISPLAY"
   echo "DISPLAY:  $DISPLAY"


   # Kill if any from tje other method (stack) are up
   ps aux | grep -v grep  | grep -e Xvfb -e openbox -e vnc | pid_from_psaux | xargs kill || :


   function verify_x_stack {
      ps aux | grep -v grep  | grep -e Xvfb -e openbox -e vnc && exit $ERROR_ExCODE
      return $SUCCESS_ExCODE
   }
   export -f verify_x_stack

   verify_x_stack

}

# todo: run_x_stack2 # for without Xvfb,openbox

gitrepo_reset_to_root

installations_base
# installations_x

# The main difference witrh wine_cmd.exe
# run_x_stack1
run_x_stack2
verify_x_stack

export CLOUD_STORAGE_VOLUME=/mnt/volume_lon1_01
: || {
# SKIP

export WINE_STORAGE_BASE=$CLOUD_STORAGE_VOLUME/ifc2brep

sudo mkdir -p $WINE_STORAGE_BASE
sudo chown $USER:$USER $WINE_STORAGE_BASE
sudo chmod 775 $WINE_STORAGE_BASE

echo "Storage base is: $WINE_STORAGE_BASE"
ls -1 $WINE_STORAGE_BASE >/dev/null

# Create $REPO_ROOT/working-dir that is inside the Cloud Storage
mkdir -p $WINE_STORAGE_BASE/working-dir
rm $REPO_ROOT/working-dir
ln -s -f $WINE_STORAGE_BASE/working-dir  $REPO_ROOT/working-dir
export WORKING_DIR=$REPO_ROOT/working-dir
# cd $REPO_ROOT/working-dir  # Dont.  You will lose the REPO_ROOT

echo "WORKING_DIR=$WORKING_DIR"

# SKIP
}

# export WINE_ARCH_=win32
export WINE_ARCH_=win64
export ARCH_BITS=64
export WINE_COMMAND_=wine64
###########

# Note that many winetrick & softwares only currently support wine32, and some don't support win64.
# Hence, we focus only on wine32 for now.
# Update: since, `wine-msvc`, I focus on wine64


# mkdir -p $REPO_ROOT/external-tools/wine64
# export WINE_PREFIX_=$REPO_ROOT/external-tools/wine64
# export WINE_PREFIX_=$WINE_STORAGE_BASE/wine32
export WINE_PREFIX_=$CLOUD_STORAGE_VOLUME/$WINE_ARCH_
sudo mkdir -p $WINE_PREFIX_
sudo chown -R $USER:$USER $WINE_PREFIX_

echo "Wine folder is: $WINE_PREFIX_"
ls -1 $WINE_PREFIX_ >/dev/null  # verify it exists

# Enable verbose debug messages
export WINEDEBUG=warn+all

# now, you can run $WINE_COMMAND_ cmd
# $WINE_COMMAND_:
# wine wine32 win64

# ^ wine prefix
####################



# If already done, skip this step
# WINEARCH=win64
# arch=32|64  # for creating 64 or 32
: || \
WINEPREFIX=$WINE_PREFIX_  WINEARCH=$WINE_ARCH_ winetricks arch=$ARCH_BITS \
    corefonts \
    win10

: || \
WINEPREFIX=$WINE_PREFIX_  WINEARCH=$WINE_ARCH_  winetricks \
    msi2
# WINEDEBUG=+msi $WINE_COMMAND_  your_installer.msi
# Also see note: "Re-register the Windows Installer Service"
# Also check `winecfg`` for "msiexec" being "builtin"
# msi2: Unknown arg msi2

: || \
WINEPREFIX=$WINE_PREFIX_  WINEARCH=$WINE_ARCH_ winetricks \
   --force vcrun2019 corefonts dotnet48
# Keep checking the GUI !
# Missing? : Windows Modules Installer Service
# .Net 4.8 installed
#   vcrun2022

: || \
WINEPREFIX=$WINE_PREFIX_  WINEARCH=$WINE_ARCH_ winetricks \
   vcrun2019

# then
# vs_buildtools.exe

# Useful, but requires X-windows in place
# 64 vs 32?
: || \
WINEPREFIX=$WINE_PREFIX_ WINEARCH=$WINE_ARCH_ winecfg
# echo "ok $?"
# exit
# Make sure that Wine is configured to use its built-in msiexec rather than attempting to use a native version:
# Go to the "Libraries" tab. Look for msiexec in the list. If it's set to "native" or has any specific overrides, you might want to change it to "builtin" to ensure Wine uses its internal version.

# # Enable .NET
# WINEPREFIX=$WINE_PREFIX_ arch=$ARCH_BITS winetricks \
#     mono
# no mono

#WINEPREFIX=$WINE_PREFIX_ WINEARCH=$WINE_ARCH_ winetricks \
#      apps list
#      #x11-apps

WINEPREFIX=$WINE_PREFIX_ arch=$ARCH_BITS winetricks \
  list-all | grep vcrun

# IF installed, vcrun2019 already installed, skipping
: || \
WINEPREFIX=$WINE_PREFIX_ arch=$ARCH_BITS winetricks \
   -q \
   vcrun2019
# oh !! MSVC?
# requires GUI
# -q => quiet (no GUI)

# This was an important step (?)
# wget  -O winsdksetup.exe \
#      "https://go.microsoft.com/fwlink/?linkid=2120843"


# New affordances enabled:
# dir "C:\Program Files\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools"
#         such as: lc.exe, wsdl.exe
#         but not what I am looking after
# dir "C:\Program Files\Microsoft Visual Studio\Installer"
#         lots of installer files (only installer, not the executables)

# And this (Where did this come from?) Probably by one of the `winetricks` ones (vcrun2019 ?) (no: vs_buildtools.exe ?)
#          `winetricks --force vcrun2019`
#    msvc/VC/Tools/MSVC/14.39.33519/bin/Hostx64/x64/cl.exe

################

function prepend_export {
   # Prepend 'export ' to each line
   sed 's/^/export /'
   # awk '{print "export " $0}'
}

printenv

printenv | grep -E '^(WINE_PREFIX_|DESIRED_DISPLAY|WINE_ARCH_|REPO_ROOT|WINE_COMMAND_)=' \
    | prepend_export \
    | tee env1_sol2.env

DISPLAY=$DESIRED_DISPLAY   WINEPREFIX=$WINE_PREFIX_  WINEARCH=$WINE_ARCH_  printenv | grep -E '^(DISPLAY|WINEPREFIX|WINEARCH|WINE_COMMAND_)=' \
    | prepend_export \
    | tee env2_sol2.env

# There are two levels of `env`s here

# then use:   (source env2_sol2.env && $WINE_COMMAND_ cmd)
# (source env2_sol2.env && winetricks list)
# (source env2_sol2.env && winetricks list-all) | grep -ie insta
# or eval "$(cat env2_sol2.env)"

echo 'Usage:'
echo '   (source env2_sol2.env && winetricks list-all)'
echo '   (source env2_sol2.env && $WINE_COMMAND_  WINDOWS_MSDOS_PROGRAM_NAME)'

#
# The environment is ready. Ready to cmd.exe:
#
# Providing: $WINE_PREFIX_ $DESIRED_DISPLAY, $WINE_ARCH_, $REPO_ROOT, gitrepo_reset_to_root, verify_x_stack
# DISPLAY=$DESIRED_DISPLAY   WINEPREFIX=$WINE_PREFIX_  WINEARCH=$WINE_ARCH_  $WINE_COMMAND_  \
   # cmd.exe or any command

# The environment is ready.
##################################################
source env1_sol2.env
source env2_sol2.env
env

################
# ok, now let's install a few more things to reduce the warnings


: || \
winetricks arch=$ARCH_BITS \
    corefonts
# winepath -w /home/ephemssss/.local/share/icons

# may be useful:
# wineserver -k  # restart

#################


$REPO_ROOT/scripts/wine_cmd.exe.bash

ExC=$?
echo "doone. exit code: $ExC"
exit $ExC
#

export DISPLAY=:1

echo "DISPLAY:  $DISPLAY should be set. to redicrect the output to above stack. I will set it based on DESIRED_DISPLAY=$DESIRED_DISPLAY"
echo 'add your command here in this file:    WINEPREFIX=$WINE_PREFIX_ WINEARCH=$WINE_ARCH_  $WINE_COMMAND_     YOUR_WINDOWS_MSDOS_COMMAND   '
echo 'or:    (source env2_sol2.env && winetricks list-all)'
echo 'or:    (source env2_sol2.env && $WINE_COMMAND_  YOUR_WINDOWS_MSDOS_COMMAND)'

echo "scripts/inside_windows/install_python.bat"

# no 'DISPLAY=:0.0 '?
# DISPLAY=:0.0 WINEPREFIX=$WINE_PREFIX_ WINEARCH=$WINE_ARCH_  xvfb-run $WINE_COMMAND_  cmd

# DISPLAY=:0.0
#DISPLAY=localhost:10.0
# WINEPREFIX=$WINE_PREFIX_ WINEARCH=$WINE_ARCH_  xvfb-run $WINE_COMMAND_  cmd

# WINEDEBUG=warn+all  WINEPREFIX=$WINE_PREFIX_  xvfb-run $WINE_COMMAND_ explorer /desktop=name,1024x768 notepad.exe

# WINEPREFIX=$WINE_PREFIX_   xvfb-run $WINE_COMMAND_  notepad

# DISPLAY=:1 WINEPREFIX=$WINE_PREFIX_ WINEARCH=$WINE_ARCH_  $WINE_COMMAND_  cmd

export DISPLAY=:1


WINEPREFIX=$WINE_PREFIX_ WINEARCH=$WINE_ARCH_  $WINE_COMMAND_  cmd
