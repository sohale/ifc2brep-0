
set -exu
# export BOOTSTRAP1=./scripts/wine-restart-4.bash
# docker run -it --rm -v $(pwd):$(pwd) --workdir "$(pwd)" ubuntu:22.04 bash $BOOTSTRAP1

sudo apt-get update
sudo apt install msitools  #   libgsf-1-114 libgsf-1-common libmsi0 msitools




# waitfor: "wineserver"
function wait_for_process_finish {
   # while pgrep 2>&1 wineserver ; do echo 2>&1 -n "Waiting for:"; pgrep 2>&1 wineserver || : ; ps aux|grep 2>&1 $(pgrep wineserver) || : ; echo 2>&1 ; sleep 1 2>&1; done
   local _process_name="wineserver"
   local _process_name="$1"
   # if [[ -z "$_process_name" ]]; then
   # if [ "$#" -ne 1 ]; then
   if [ "$#" -ne 1 ] || [ -z "$_process_name" ]; then
      echo "Error: Exactly one argument is required. Specify a process name" >&2
      exit 1
   fi
   while pgrep 2>&1 $_process_name ; do echo 2>&1 -n "Waiting for:"; pgrep 2>&1 $_process_name || : ; ps aux|grep 2>&1 $(pgrep $_process_name) || : ; echo 2>&1 ; sleep 1 2>&1; done
}



# cat wine64.env
export DISPLAY=localhost:10.0
export WINEARCH=win64
export WINEPREFIX=/mnt/volume_lon1_01/ifc2brep/wine64

source repo3.env && source wine64.env && env

: || \
wine64 wineboot --init

wait_for_process_finish "wineserver"

# sudo mkdir -p /opt/msvc && sudo chown $USER:$USER /opt/msvc
# Those scripts are made for this path
export BASE1="/opt/msvc"
# export BASE1="$REPO_ROOT/try3"
mkdir -p $BASE1

# By Copyright (c) 2019 Martin Storsjo
export REPO3=$REPO_ROOT/external/msvc-wine

cp $REPO3/lowercase    $BASE1
cp $REPO3/fixinclude    $BASE1
cp $REPO3/install.sh    $BASE1
cp $REPO3/vsdownload.py   $BASE1
cp $REPO3/msvctricks.cpp   $BASE1

ls -alt  $BASE1
find $BASE1

# dont run for now, why did I start this?
: || \
PYTHONUNBUFFERED=1 ./vsdownload.py --accept-license --dest $BASE1 && \
    ./install.sh $BASE1 && \
    rm lowercase fixinclude install.sh vsdownload.py && \
    rm -rf wrappers
