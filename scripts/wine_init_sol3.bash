
set -exu

source repo.env


# : || \
{

cd  $REPO_ROOT/external/msvc-wine

# build the image
docker build      -f Dockerfile      -t msvc-wine      .
#  docker build -f Dockerfile.hello .
#  docker build -f Dockerfile.clang .

}

cd  $REPO_ROOT

#     --env DISPLAY="$DISPLAY" \

# run after building the image
docker run \
    --interactive --tty --rm \
    --env DISPLAY=10.16.0.6:10.0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --env REPO_ROOT="$REPO_ROOT" \
    --env _initial_cwd="$(pwd)" \
    --env HOST_HOME="$HOME" \
    --volume "$REPO_ROOT":"$REPO_ROOT" \
    --volume "/home/ephemssss/novorender/oda-sdk":"/home/ephemssss/novorender/oda-sdk" \
    --workdir "$(pwd)" \
    msvc-wine  \
    bash -c "$(cat <<'EOF_STARTUP'
      # pwd
      # cd $REPO_ROOT/external/msvc-wine
      # pwd
      echo "You are inside docker."

      # Particular to this Docker image:
      export WINEPREFIX=/root/.wine
      export WINEARCH=win64
      # alias wine32=error
      # alias wine=error
      export winecmd=$(command -v wine64 || command -v wine || false)
      echo $winecmd

      echo "Booting Wine64:"
      wineserver -p && $(command -v wine64 || command -v wine || false) wineboot

      # Give helpful information:
      ls -1 /opt/msvc/bin | xargs echo "Architectures: "
      export DESIRED_ARCH="x64"
      mkdir -p backups # /external/msvc-wine/backups
      export PATH="$PATH:/opt/msvc/bin/$DESIRED_ARCH"
      find /opt/msvc/bin/$DESIRED_ARCH | grep exe
      echo "..."
      echo "Docker's HOME=$HOME"
      echo "HOST_HOME=$HOST_HOME"
      echo "REPO_ROOT=$REPO_ROOT"

      echo "Added to you path: /opt/msvc/bin/$DESIRED_ARCH"
      echo "Some scripts available in: ./scripts/inside_msvc-wine/   ie.  $REPO_ROOT/scripts/inside_msvc-wine/"
      echo 'Avoid wine or wine32'
      echo 'You can:   wine64 cmd.exe'
      echo 'You can:   cd $REPO_ROOT/src'
      echo "You are inside docker. Explore the folder of: /opt/msvc/bin/x64/cl.exe"
      echo "_initial_cwd=$_initial_cwd"
      cd $_initial_cwd

      echo "Example compilation"
      echo "./scripts/inside_msvc-wine/compile1.bash"
      echo "./scripts/inside_msvc-wine/compile2.bash"
      echo "./scripts/inside_msvc-wine/compile3.bash"


      # Then, continue interactively
      exec bash
      echo "after exec bash"
EOF_STARTUP
)"

# inside:
# wineserver -p && $(command -v wine64 || command -v wine || false) wineboot

# /opt/msvc/bin/x64/cl


# z:\opt\msvc\bin\x64
#z:\opt\msvc\bin\x64\cl.exe
