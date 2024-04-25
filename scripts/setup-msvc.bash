#!/bin/bash
set -exu

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


# 2
VENVFOLDER="venv-sosi"
python3 -m venv $VENVFOLDER

# defers, blocks
function activate_my_venv() {
   source $VENVFOLDER/bin/activate
}
function verify_python_3_activated() {
# block: verify python 3 is activated
expect  <<'END_EXPECT_TCL'
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
END_EXPECT_TCL
}


# 3
activate_my_venv
verify_python_3_activated


# pip install conan
pip install getgist
