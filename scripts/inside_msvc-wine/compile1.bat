
rem ./scripts/inside_msvc-wine/compile1.bat

set REPO_ROOT="Z:\home\ephemssss\novorender\ifc2brep-0"
set FILE_BASENAME=test_ifcsdk_compilation
set OUTPUT_BIN=%REPO_ROOT%/out
set INPUT_SRC=%REPO_ROOT%/src
set INPUT_INCLUDES=%REPO_ROOT%/includes-symb


z:\opt\msvc\bin\x64\cl.exe      ^
   /EHsc /std:c++20              ^
   /I "%INPUT_INCLUDES%"   ^
   /Fo"%OUTPUT_BIN%/"      ^
   /Fe"%OUTPUT_BIN%/%FILE_BASENAME%.exe"  ^
   "%INPUT_SRC%/%FILE_BASENAME%.cpp"

echo
echo

