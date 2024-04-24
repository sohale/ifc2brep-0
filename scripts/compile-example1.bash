#!/bin/bash
set -exu

FILE_BASENAME=test_ifcsdk_compiletion

mv -f  $FILE_BASENAME.out $FILE_BASENAME.out.old || :  # Don't err

clang++  -std=c++20  -stdlib=libstdc++  $FILE_BASENAME.cpp   \
  -o $FILE_BASENAME.out
#  -v  -lstdc++
