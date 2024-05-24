#!/bin/bash
set -exu

# language-server
# Language Server Protocol (LSP) server
# clangd

# input parameters
CLANGD_BIN="/usr/lib/llvm-18/bin/clangd"
CLANGD_uSOCKET="/tmp/clangd_socket"

#CLANGD_FLAGS=${CLANGD_FLAGS:-CLANGD_FLAGS}

# (other) inputs
#echo "CLANGD_FLAGS=$CLANGD_FLAGS"

$CLANGD_BIN --help
#  -j <uint>  : Number of async workers used by clangd. Background index also uses this many workers.
ehco "THIS SOLUTION IS INCOMPLETE"

# --check[=<string>]  : Parse one file in isolation instead of acting as a language server. Useful to investigate/reproduce crashes or configuration problems. With --check=<filename>, attempts to parse a particular file.
$CLANGD_BIN \
    --pretty \
    --log=verbose \
    --socket=$CLANGD_uSOCKET \
    &

CLANGD_PID=$!
ps aux | grep clangd
sleep 2  # Give clangd some time to start


echo "clangd LSP pid: $CLANGD_PID"

# no effect, just for readability
export CLANGD_PID, CLANGD_uSOCKET
