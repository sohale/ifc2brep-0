
set -exu

# see scripts/bash-stub.bash
# run scripts/bash-stub.bash to generate env_common.env for you
source env_common.env
# we no longer has env_sol3.env

# : || \
{


BUILDER_NAME="MsVcWine_Builder"
#docker buildx rm ${BUILDER_NAME}  # if exists.    # || true
#docker buildx create --name ${BUILDER_NAME} --use
docker buildx use --builder ${BUILDER_NAME}

docker buildx inspect --bootstrap

cd  $REPO_ROOT/external/msvc-wine

# build the image
docker buildx build    \
          --progress=plain \
          -f Dockerfile \
          -t msvc-wine \
          . \
          #

#  docker build -f Dockerfile.hello .
#  docker build -f Dockerfile.clang .

}

cd  $REPO_ROOT

#     --env DISPLAY="$DISPLAY" \

# HWID:
#     --mac-address e2:4f:37:c1:43:80  \
#    --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
# HWID=$(sudo dmidecode -s system-uuid)

# apt install debconf dialog libterm-readline-gnu-perl


# run after building the image
docker run \
    --interactive --tty --rm \
    \
    --net=host \
    --env DISPLAY="$DISPLAY" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/.Xauthority:/root/.Xauthority \
    \
    \
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

      export DEBIAN_FRONTEND=noninteractive
      # not necessary, but very useful for debugging xwindows connection
      apt update \
         && echo "tzdata tzdata/Areas select Europe" | debconf-set-selections \
         && echo "tzdata tzdata/Zones/Europe select London" | debconf-set-selections \
         && apt install \
            debconf dialog \
            iproute2 apt-utils net-tools \
            x11-apps \
            strace \
            fwupd \
            -y

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
      echo "./scripts/inside_msvc-wine/compile1.bash" >>~/.bash_history
      echo "./scripts/inside_msvc-wine/compile2.bash" >>~/.bash_history
      echo "./scripts/inside_msvc-wine/compile3.bash" >>~/.bash_history
      cat  ~/.bash_history


      # Then, continue interactively
      unset DEBIAN_FRONTEND
      # orig:  PS1='\[\033[01;36m\]container\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n[01;32m\]$(whoami)\033[01;35m\]@\h\[\033[00m\] \[\033[01;33m\]$(cut -c1-12 /proc/1/cpuset)\[\033[00m\] \$ ' \
      # export PS1='\[\033[01;36m\]container\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\[\033[01;32m\]\u     \[\033[01;35m\]@\h\[\033[00m\] \[\033[01;33m\]$(cut -c1-12 /proc/1/cpuset)\[\033[00m\] \$ '
      # export PS1='\[\033[01;36m\]container\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n      [01;32m\]$(whoami)\033[01;35m\]@\h\[\033[00m\] \[\033[01;33m\]$(cut -c1-12 /proc/1/cpuset)\[\033[00m\] \$ '
      export PS1='\[\033[01;36m\]container\[\033[00m\]:\[\033[01;35m\]@\h \[\033[01;34m\]\w\[\033[00m\]\n\[\033[01;32m\]$(whoami) \[\033[00m\] \[\033[01;33m\]$(cut -c1-12 /proc/1/cpuset)\[\033[00m\] \$ '
      export PS1='\[\033[01;36m\]container\[\033[00m\]:\[\033[01;35m\]@\h \[\033[01;34m\]\w\[\033[00m\]\n\[\033[01;32m\]$(whoami) \[\033[00m\] \[\033[01;33m\]$(cut -c1-12 /proc/1/cpuset)\[\033[01;32m\] \$ \[\033[00m\]'

      exec bash   # --norc --noprofile
      echo "after exec bash"
EOF_STARTUP
)"

# inside:
# wineserver -p && $(command -v wine64 || command -v wine || false) wineboot

# /opt/msvc/bin/x64/cl


# z:\opt\msvc\bin\x64
#z:\opt\msvc\bin\x64\cl.exe
