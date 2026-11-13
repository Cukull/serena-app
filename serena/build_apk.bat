@echo off
setlocal
title Serena - Build APK

REM Path proyek ini mengandung spasi. Flutter gagal menyusun native-assets
REM (objective_c lewat path_provider_foundation) kalau path SDK juga ada spasi,
REM jadi SDK dijalankan lewat junction tanpa spasi.
set "SDK_JUNCTION=D:\flutter-sdk"
set "SDK_TARGET=%~dp0src\flutter\flutter"

if not exist "%SDK_JUNCTION%\bin\flutter.bat" (
    echo [Serena] Membuat junction SDK %SDK_JUNCTION% ...
    mklink /J "%SDK_JUNCTION%" "%SDK_TARGET%"
    if errorlevel 1 (
        echo [Serena] Gagal membuat junction. Jalankan terminal sebagai Administrator.
        pause
        exit /b 1
    )
)

cd /d "%~dp0"
"%SDK_JUNCTION%\bin\flutter.bat" build apk %*
pause
endlocal
