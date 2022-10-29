@REM Clone Qt6 repo
cd ..
git clone https://code.qt.io/qt/qt5.git -b 6.4.0
cd qt5
perl init-repository -f --module-subset=qt5compat,qt3d,qtbase,qtcharts,qtdeclarative,qtimageformats,qtlanguageserver,qtmqtt,qtmultimedia,qtnetworkauth,qtquick3d,qtquicktimeline,qtserialbus,qtserialport,qtshadertools,qtsvg,qtwebchannel,qtwebengine,qtwebsockets,qtwebview
@REM Create shadow build folder
cd ..
mkdir qt6_shadow
cd qt6_shadow
@REM Setup the compiler
cmd.exe /c "call `"C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat`" && set > %temp%\vcvars.txt"
Get-Content "$env:temp\vcvars.txt" | Foreach-Object { if ($_ -match "^(.*?)=(.*)$") { Set-Content "env:\$($matches[1])" $matches[2] } }
@REM Configure Qt5
..\qt5\configure.bat -release -static -static-runtime -no-pch -optimize-size -platform win32-msvc -prefix "..\Qt6_binaries" -confirm-license
cmake --build . --parallel 4
cmake --install .

@REM 修改版
perl init-repository -f --module-subset=default
-debug-and-release
..\qt5\configure.bat -release -static -static-runtime -platform win32-msvc -prefix "..\Qt6_binaries" -confirm-license -nomake examples -nomake tests