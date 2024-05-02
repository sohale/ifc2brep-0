#!/bin/bash
set -exu
# Framework: splitable/statebash/slices/segments/bashsegments/...
# Is a Bash style.
# Concepts: u/h-flow, splitable (some states), states / stage-points (numbered, named/laballed), blocks, defers, oprtations
# History: This framework is built upon the idea of "statebash" from my "cloudbeat"
## More details:
##   # Affordances:
##     # `new affordance: '...'` a string, "symbolic" (literal S&R)
##     # `bubble affordance: '...'` (todo: for venv? or general?) : # affordance to outside (-of-the-script) user
##     # affordance bubbling types: script, venv, global

# Naming history:
# scripts/get-msvc.bash -> set up

function gitrepo_reset_to_root() {
   # Sets directory context to the root of the git repository
   # git rev-parse --show-toplevel
   SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
   cd $SCRIPT_DIR
   REPO_ROOT=$(git rev-parse --show-toplevel)
   cd $REPO_ROOT
}


gitrepo_reset_to_root


# 1
# script tools
sudo apt install expect

# 2.1
# Layout the structure
mkdir -p $REPO_ROOT/external-tools/
# new affordance: '$REPO_ROOT/external-tools'
# 2.2
VENVFOLDER="venv-sosi"
: || \
python3 -m venv $VENVFOLDER
# From here on, I can do the following. I defer them.
# new affordance: "activate_my_venv" and "verify_python_3_activated"
function activate_my_venv() {
   source $VENVFOLDER/bin/activate
}

function verify_python_3_activated() {
# block: verify python 3 is activated
# todo: verify Python 3.6+
expect  <<'END_EXPECT.TCL'
   spawn python3 -V
   set timeout -1
   expect {
      -re {Python (3\..*)\r?$} {
         puts "Python installation verified: $expect_out(1,string)"
      }
      default {
         puts "ERROR: `python -V` failed: Python 3 not activated"
         exit 1
      }
   }
   expect eof
END_EXPECT.TCL
}


# 3
activate_my_venv
verify_python_3_activated


# 4
# name: "get-msvc" .bash

# pip install conan

# GetGist by https://github.com/cuducos/getgist
: || \
pip install --upgrade getgist

# Gist: https://gist.github.com//7f3162ec2988e81e56d5c4e22cde9977
getgist mmozeiko portable-msvc.py
chmod +x portable-msvc.py
mv -f portable-msvc.py $REPO_ROOT/external-tools/
# new affordance: $REPO_ROOT/external-tools/portable-msvc.py

$REPO_ROOT/external-tools/portable-msvc.py
# Expect this: "Downloading MSVC v14.39.17.9 and Windows SDK v22621"
# Expect license agreement prompt
# Leads to : "FileNotFoundError: [Errno 2] No such file or directory: 'msiexec.exe'
