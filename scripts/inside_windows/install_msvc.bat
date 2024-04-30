cd external-tools
python portable-msvc.py

rem cd external-tools
rem external-tools/vs_buildtools.exe



rem  cd working-dir
rem  ../external-tools/vs_buildtools.exe

rem Use winetricks instead. See scripts/wine_init.bash


rem Install the "Windows Installer Service":
rem winetricks msi2
rem WINEDEBUG=+msi wine your_installer.msi

rem Re-register the "Windows Installer Service". If the installer service is malfunctioning, re-registering msiexec might help.
rem msiexec /unregister
rem msiexec /regserver
