#!/bin/bash
set -eux

# see scripts/setup-msvc.bash
function gitrepo_reset_to_root() {
   # set "REPO_ROOT" env variable for you
   # Navigates to your main project directory
   # Sets directory context to the root of the git repository
   # git rev-parse --show-toplevel
   export SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
   cd $SCRIPT_DIR
   export REPO_ROOT=$(git rev-parse --show-toplevel)
   cd $REPO_ROOT

   # Without `export`, these wouldn't automatically become an environment variable visible to subprocesses unless explicitly exported
}
export -f gitrepo_reset_to_root

export ERROR_ExCODE=1
export SUCCESS_ExCODE=0

function pid_from_psaux {
   # Usage: pipe with a `ps aux`
   cut -c10-16
}
export -f pid_from_psaux

# debug_log_echo, echo_debug, debug_echo, debug_log
function _debug_echo {
   echo 1>&2 "debug: $@"
}

function export_env {
   # Usage: export_env DISPLAY WINEPREFIX WINEARCH

   # local stub_env_filename="env2.env"

   # Create a regular expression pattern from the argument
   # env_vars_rexpr
   local names_rexpr=$(printf "|%s" "$@")
   names_rexpr="^(${names_rexpr:1})="
   # '^(DISPLAY|WINEPREFIX|WINEARCH)='

   function _prepend_export {
      # Prepend 'export ' prefix to each line
      # awk '{print "export " $0}'
      sed 's/^/export /'
   }

   _debug_echo "names_rexpr=$names_rexpr"
   printenv \
      | grep -E "$names_rexpr" \
      | _prepend_export \
      # | tee $stub_env_filename \
      # | grep -E '^(DISPLAY|WINEPREFIX|WINEARCH)=' \
      :

}
export -f export_env


function export_func {
   # Usage: export_func export_env pid_from_psaux gitrepo_reset_to_root
   # They don't have to be `export -f` ed before calling this function
   if [[ -z "$1" ]]; then
     echo "Error: specify at least one function name as argument. Hint: run: 'delcare -f'" >&2
     exit 1
   fi

   # Create a regular expression pattern from the argument
   local fnames=$(printf " %s" "$@")
   _debug_echo "function names=$fnames"

   function _post_process {
      # awk '{print "export " $0}'
      awk '{print "" $0 ""}'
   }
   # Function attributes: "f" & "x"
   # * f:  functions, not env variables  # does not append the declare -fx
   # * x:  exported envs (and functions?):   `declare -x CC="/usr/bin/clang"` also functions
   # * fx: Would list all functions that are both declared and exported.
   # * none: both (but does not append the `declare -fx myfuncname` after each)

   #  "declare -fx pid_from_psaux" both declared and exported
   #      exported: making it available to child processes.

   # my_functions.source
   # source.myfunctions
   # source.env

   declare -f $fnames \
      | _post_process

}

### MAIN ###
gitrepo_reset_to_root

# : || {
# env

# repoenv.env
OUTPUTFILEN=$(mktemp)
cp /dev/null $OUTPUTFILEN

echo "# env variables" >> $OUTPUTFILEN

export_env \
   SCRIPT_DIR REPO_ROOT ERROR_ExCODE SUCCESS_ExCODE \
   >> $OUTPUTFILEN

echo >> $OUTPUTFILEN
echo "# functions" >> $OUTPUTFILEN

export_func export_env \
   pid_from_psaux gitrepo_reset_to_root \
   >> $OUTPUTFILEN

_debug_echo "functions and envs over-written into $OUTPUTFILEN"

# Prints the name of the env file that is created
# echo $OUTPUTFILEN

# was env_sol3.env
cp $OUTPUTFILEN env_common.env

# Prints the contents of the env file that is created
cat $OUTPUTFILEN && rm $OUTPUTFILEN
