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
unzip /home/$TARGET_UN/example-files-novorender.zip   -d $HOME/$PROJECT_PATH_BASE/oda-sdk
unzip /home/$TARGET_UN/oda-sdk.zip   -d $HOME/$PROJECT_PATH_BASE/oda-sdk

ln -s "$HOME/$PROJECT_PATH_BASE/oda-sdk/vc16/Ifc"  external/oda-ifc-sdk
