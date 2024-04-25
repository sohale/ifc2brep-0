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

# sudo apt remove wine
# wine winetricks win32
# wine32:i386
# ...
sudo apt install --install-recommends winehq-stable
