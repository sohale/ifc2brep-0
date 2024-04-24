#!/bin/bash
set -exu

FILE_BASENAME=test_ifcsdk_compiletion

# Backup
mv -f  $FILE_BASENAME.out $FILE_BASENAME.out.old || :  # Don't err

# includes
ln -s 
# Compile

clang++  \
   -std=c++20  -stdlib=libstdc++  \
   ../includes-symb   \
   $FILE_BASENAME.cpp   \
  -o $FILE_BASENAME.out
#  -v  -lstdc++
