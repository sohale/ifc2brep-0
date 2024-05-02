
set -exu

docker run \
    --interactive --tty --rm \
    --env DISPLAY="$DISPLAY" \
    --volume "$REPO_ROOT":"$REPO_ROOT" \
    --workdir "$(pwd)" \
    msvc-wine  \
    bash

# inside:
# wineserver -p && $(command -v wine64 || command -v wine || false) wineboot

# /opt/msvc/bin/x64/cl
