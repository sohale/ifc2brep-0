
set -exu

SERVICENAME="docker"
SERVICENAME_EXTRA="docker.socket"
#NEW_TEMP_BASE="/mnt/volume_lon1_01"
#NEW_TEMP="$NEW_TEMP_BASE/dockerd1"
NEW_TEMP="/mnt/volume_lon1_01/dockerd1"

echo "This script is never tested. You too, don't run it. It is for documentaiton purposes only."
exit 1


# Keep a backup somewhere
sudo systemctl cat docker.service >$(mktemp  --suffix=.docker-service-config-values-backup.txt -p .)


# Stop docker and related services
sudo systemctl stop $SERVICENAME_EXTRA
sudo systemctl stop $SERVICENAME


# {
sudo mkdir -p /etc/systemd/system/$SERVICENAME.service.d/

sudo tee /etc/systemd/system/$SERVICENAME.service.d/override.conf \
<< EOF_OVERRIDE.CONF

[Service]
# Added by Sosi
Environment="DOCKER_TMP=$NEW_TEMP"
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --data-root=$NEW_TEMP

EOF_OVERRIDE.CONF

# or manually:
# sudo systemctl edit docker.service

sudo mkdir $NEW_TEMP

# }

# Reloads the config, necessary before the start
sudo systemctl daemon-reload

# Verify changes by eye:
docker info
sudo systemctl cat docker.service
systemctl show --property=Environment $SERVICENAME

sudo systemctl start $SERVICENAME
sudo systemctl start $SERVICENAME_EXTRA

echo 'Now you can delete the old temp, traditionally in /var/lib/docker/*'
