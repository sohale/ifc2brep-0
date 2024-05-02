
set -exu

source repo.env
cd  $REPO_ROOT/external/msvc-wine

# build the image
docker build      -f Dockerfile      -t msvc-wine      .
#  docker build -f Dockerfile.hello .
#  docker build -f Dockerfile.clang .

# run after building the image
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
