#!avoid_running_this dont run
# This is not a real script
echo "This is not to be exexcuted, just drafted notes for documentation purposes: On how to set up the project" ; exit 1

# How to set up the project
# Typical setup commands for working on remote machine

PROJECT_PATH_BASE="novorender"

# On local machine
# ----------------
# copy downloaded files to remove
TARGET_UN="ephemssss"
TARGET_IP="46.101.15.163"
TARGET_SSH="$TARGET_UN@$TARGET_IP"
scp ~/install/novorender-oda/archive/example-files-novorender.zip \
    $TARGET_SSH:/home/$TARGET_UN/example-files-novorender.zip

# Large file
scp ~/install/novorender-oda/archive/Kernel_Drawings_Architecture_Civil_BimNv_BimRv_Mechanical_Visualize_Publish_PRC_IFC_Map_OpenCloud.zip \
    $TARGET_SSH:/home/$TARGET_UN/oda-sdk.zip

ssh $TARGET_SSH

# On Linux (Target), e.g. Ubuntu 22
# ----------------

cd "$HOME/$PROJECT_PATH_BASE"

git clone git@github.com:sohale/ifc2brep-0.git
cd ifc2brep-0.git

# unzip
# (after some moving of files)
unzip /home/$TARGET_UN/example-files-novorender.zip   -d $HOME/$PROJECT_PATH_BASE/oda-sdk
unzip /home/$TARGET_UN/oda-sdk.zip   -d $HOME/$PROJECT_PATH_BASE/oda-sdk

ln -s "$HOME/$PROJECT_PATH_BASE/oda-sdk/vc16/Ifc"  external/oda-ifc-sdk


# Install nvm. Check https://github.com/nvm-sh/nvm for the latest version.
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# The following is appended already. Close and reopen your terminal to start using nvm or run the following to use it now
# ```txt
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# ```

## log out and log back in

nvm install --lts
nvm use lts/iron

# For cross-compiling on windows
sudo apt install mingw-w64

sudo apt install wine

sudo dpkg --add-architecture i386
sudo apt update
sudo apt install wine32

sudo apt install wine64
# Winelib

# Possible approach (not used)
# sudo apt install virtualbox

# MSVC Build Tools
# ...

wine cmd.exe
# then, `exit`
# available: msiexec
# This `wine cmd.exe` is wonderful. opens many doors.

sudo apt install winetrick
winetricks python26



# Here in this file, I repeats what I instantiated: (actually did)
lsb_release -a

# Note: My Linux version (where these commands/notes are tested)
lsb_release -a
# No LSB modules are available.
# Distributor ID:	Ubuntu
# Description:	Ubuntu 22.04.4 LTS
# Release:	22.04
# Codename:	jammy

# Why not first get the latest Wine?
# Use this: https://wiki.winehq.org/Ubuntu
#  security via key verification
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key



# Particular to: Ubuntu 22.04 (Jammy Jellyfish)
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources

# Note: `-N` means: "only if the remote file is newer than the local one or if the local file does not exist"
# `-P`: a prefix directory where all files are saved

ls /etc/apt/sources.list.d/

# affordance to outside (-of-the-script) user
export REPO_ROOT=/home/ephemssss/novorender/ifc2brep-0
mkdir -p $REPO_ROOT/external-tools/

mkdir -p $REPO_ROOT/external-tools/relevant-sources.list.d

sudo wget -NP $REPO_ROOT/external-tools/relevant-sources.list.d/  https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
# ls -alth $REPO_ROOT/external-tools/relevant-sources.list.d
#   # -rw-r--r-- 1 root      root       163 Apr  6 07:16 winehq-jammy.sources
sudo ln -s  $REPO_ROOT/external-tools/relevant-sources.list.d/winehq-jammy.sources    /etc/apt/sources.list.d/

# cat /etc/apt/keyrings/winehq-archive.key
# ...

# cat /etc/apt/sources.list.d/winehq-jammy.sources
#Types: deb
#URIs: https://dl.winehq.org/wine-builds/ubuntu
#Suites: jammy
#Components: main
#Architectures: amd64 i386
#Signed-By: /etc/apt/keyrings/winehq-archive.key

# reminder: I am: https://wiki.winehq.org/Ubuntu   ---ing

sudo apt update

# sudo apt remove wine  # removed winetricks too
# wine winetricks win32
# wine32:i386
# sudo apt remove wine winetricks wine32

# ...

# Cleaning up & removing
# Previous installations so far:
#   sudo apt install clang
#   sudo apt reinstall clang
#   sudo apt install gcc
#   sudo apt install mingw-w64
#   sudo apt install wine
#   sudo apt install wine32
#   sudo apt install winetricks
sudo apt remove wine wine32 wine64
sudo apt autoremove
sudo apt upgrade
sudo apt-get clean   # free disk

sudo apt install --install-recommends winehq-stable
# /opt/wine-<branch>/
# binaries: /opt/wine-stable/  , data: ~/.wine/drive_c/
# installation finished? https://wiki.winehq.org/Ubuntu

# Next step: Winetricks
# https://wiki.winehq.org/Winetricks

git clone git@github.com:Winetricks/winetricks.git
cd ...
sudo make install # sudo winetricks --self-update? no.
# https://github.com/Winetricks/winetricks/tree/master?tab=readme-ov-file#updating

# This is great: (led to wine/winetricks)
# https://askubuntu.com/questions/678277/how-to-install-python3-in-wine


# Add repo for faudio package.  Required for winedev
add-apt-repository -y ppa:cybermax-dexter/sdl2-backport
sudo apt update
# sudo apt install faudio # ?
# todo: install it ^

# environment is ready

set -u

# x-windows GUI set-up
# NOT NEEDED(?):
sudo apt install xvfb
# Start the X-windows server
# Note uppercase 'X'
Xvfb :0 -screen 0 1024x768x16 &
jid=$!
echo $jid


# Downlaod Python installers
cd $REPO_ROOT/external-tools/
wget https://www.python.org/ftp/python/3.7.6/python-3.7.6-amd64.exe
wget https://www.python.org/ftp/python/3.7.6/python-3.7.6.exe
# We want to run those in win64 (64-bit) (and in a window? No)

sudo apt install cabextract
mkdir -p $REPO_ROOT/external-tools/wine64
export WINE_PREFIX_=$REPO_ROOT/external-tools/wine64

# typo: WINARCH WINEARCH
WINEPREFIX=$WINE_PREFIX_ WINEARCH=win64 winetricks \
    corefonts \
    win10
# Microsoft Windows 10.0.19043

# Run the python installer ( in win64 and (?no-) GUI )
# why not WINEARCH=win64  ?? No, maybe since winetricks already set that?
DISPLAY=:0.0 WINEPREFIX=$WINE_PREFIX_ wine cmd /c \
    python-3.7.6-amd64.exe /quiet PrependPath=1 \
    && echo "Python Installation complete by Wine! in $WINE_PREFIX_ "
# The `/quiet` flag of the python installer exe makes it command-line only (no GUI , "quiet" mode)
# Even in quiet mode (non-GUI), the `DISPLAY=:0.0` prevents some errors.
# Completed
# Python Installation complete by Wine! in /home/ephemssss/novorender/ifc2brep-0/external-tools/wine64
# Thanks to the method in https://askubuntu.com/a/1200679/407596

WINEPREFIX=$WINE_PREFIX_ wine cmd
# Now you can run python
# Python 3.7.6 (tags/v3.7.6:43364a7ae0, Dec 19 2019, 00:42:30) [MSC v.1916 64 bit (AMD64)] on win32

export WINE_ARCH_=win64
WINEPREFIX=$WINE_PREFIX_ WINEARCH=$WINE_ARCH_  wine64  cmd
# still win32 ? --> because: WINARCH vs WINEARCH?

# Environment is ready
# tested on wine-9.0
# I now know how to install software in Wine / Wine-dows

cd $REPO_ROOT/external-tools/
# Bootstrappers
wget https://aka.ms/vs/17/release/vs_community.exe
wget https://aka.ms/vs/17/release/vs_buildtools.exe

DISPLAY=:0.0 WINEPREFIX=$WINE_PREFIX_ WINEARCH=win64  wine64  cmd

./vs_buildtools.exe /quiet PrependPath=1

DISPLAY=:0.0 WINEPREFIX=$WINE_PREFIX_   winecfg


# How to set up X (MacOS)

# revealed:
# https://wiki.winehq.org/Mono
# Spare me from automating this. You can just clock on it. The reason is, there is a table for choosing the compatible versions between Wine & Mono ...

sudo apt install x11vnc

# linux
# for debugging:
sudo apt install xterm
sudo apt-get install x11-apps libx11-6
# libx11-6 ?
# will make avvailable xclock, xeyes, xterm
sudo apt-get install xorg openbox
sudo apt install x11vnc

# dont use xvfb-run
# fixed it.

sudo apt-get install openbox

##############
# up the x stack:

export DESIRED_DISPLAY=:1

Xvfb "$DESIRED_DISPLAY" -screen 0 1024x768x16 &
# Without openbox: This works. So ugly (tightvnc), but works: shows the notepad.
# With openbox: Suddenly it has a proper window too.
openbox &
x11vnc -display "$DESIRED_DISPLAY" -nopw   -ncache 10   &
# ^ gives you a port number

export DISPLAY="$DESIRED_DISPLAY"
# DISPLAY shoud Not be "localhost:10.0" or anything with "localhost" in it. That would mean, the server would be (incorrectly) on local client side (XQuartz). We currently don't use XQuartz if we use "Xvfb + vnc11"
# no xvfb-run
# must have DISPLAY set correctly
WINEPREFIX=$WINE_PREFIX_ WINEARCH=win64  wine64  cmd


######
# On client local machine (MacBook)
# use `ssh -Y``
# Install a VNC. I used TightVNC
# run VNC:
#    use port number given by "x11vnc" command
# XQuartz (not sued here!)

# Idea: tunelling
# IDea: directly sent to XQuartz


# Digital Ocean Volume added (100 GB) at:
# /mnt/volume_lon1_01
# It is utilised in scripts/wine_init.bash
#
mkdir -p /mnt/volume_lon1_01
mount -o discard,defaults,noatime /dev/disk/by-id/scsi-0DO_Volume_volume-lon1-01 /mnt/volume_lon1_01
# Change fstab so the volume will be mounted after a reboot too
echo '/dev/disk/by-id/scsi-0DO_Volume_volume-lon1-01 /mnt/volume_lon1_01 ext4 defaults,nofail,discard 0 0' | sudo tee -a /etc/fstab

# winetricks can insatll vc !
# winetricks list-all | grep vcrun
# force reinstall:
# winetricks --force vcrun2019
# oh, gui?!


# finally this worked, on win32. You can use directly XQuartz. No need for Xvfb

# worked: downloa from this URL, it worked:

wget  -O winsdksetup.exe \
      "https://go.microsoft.com/fwlink/?linkid=2120843"
# afford: winsdksetup.exe /quiet

#  mv ./index.html\?linkid\=2120843 rrr --> msvc-dl/rrr.exe

# This helped it working ^
# ref: https://learn.microsoft.com/en-us/answers/questions/706690/install-visual-studio-2019-build-tools

# Now, rest of that file (yet to be done) :

wget -O vs_buildtools.exe \
    https://download.visualstudio.microsoft.com/download/pr/378e5eb4-c1d7-4c05-8f5f-55678a94e7f4/b9619acc0f9a1dfbdc1b67fddf9972e169916ceae237cf95f286c9e5547f804f/vs_BuildTools.exe

```bat
REM where the vs_buildtools.exe is downloaded:
cd external-tools
start /w vs_buildtools.exe --quiet --wait --norestart --nocache modify --installPath "%ProgramFiles%\Microsoft Visual Studio\2019\BuildTools" --add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64
echo "ERRORLEVEL (should not be 3010): ERRORLEVEL=%ERRORLEVEL%"
```
# Still didn't work ^


# Does not work
```bat
MsiExec.exe /i https://nodejs.org/dist/v14.9.0/node-v14.9.0-x64.msi /qn
echo %ERRORLEVEL%
```
# You can delete vs_buildtools.exe now
# && del /q vs_buildtools.exe

# ENTRYPOINT ["cmd", "/c", "dir", "C:\\Program Files (x86)\\Microsoft Visual Studio"]


# In search of

# Cross compilation with MSVC on Linux
# https://github.com/mstorsjo/msvc-wine
# https://github.com/mstorsjo/msvc-wine/blob/master/Dockerfile

# https://wiki.winehq.org/Category:List_of_Commands

# https://wiki.winehq.org/Wineboot

# msiexec is a Linux command in Wine 🤦 !
# https://wiki.winehq.org/Msiexec



# ncdu ~/.wine
# ncdu ~/.wine64/
#
# rm -rf ~/.wine
# rm -rf ~/.wine64/

# This seems to work
cd external
git clone git@github.com:mstorsjo/msvc-wine

# docker build .
# docker build -t myimage-msvc-wine .
# docker build -t myimage-msvc-wine:v1.0 .

docker build \
     -f Dockerfile \
     -t msvc-wine \
     .

# Test using the installed tools
docker build -f Dockerfile.hello .
# Test using the installation with Clang
docker build -f Dockerfile.clang .

# see also: external/msvc-wine/.github/workflows/build.yml

# I admit, using `docker` is much better

# manual:

# (scripted verion: scripts/wine_init_sol3.bash )

# docker run -it msvc-wine bash
docker run -it -e DISPLAY=$DISPLAY msvc-wine bash

# each time you need to:  (see external/msvc-wine/Dockerfile.hello )
#  To "start a persistent wine server"
wineserver -p && $(command -v wine64 || command -v wine || false) wineboot

# /usr/bin/wine64 wineboot

# ls /opt/msvc/bin
#     arm  arm64  msvctricks.exe  x64  x86

/opt/msvc/bin/x64/cl


# Don't forget to:
# export DISPLAY=localhost:10.0
# export WINEARCH=win32
# export WINEPREFIX=/mnt/volume_lon1_01/ifc2brep/wine32
