@echo off
setlocal
title Serena - Web Dev Server

REM ==== Konfigurasi ====
set "JUNCTION=D:\IT\serena"
set "TARGET=D:\IT\Semester 7\Caps Project\serena"
set "PORT=8090"

REM ==== Pastikan junction ada (biar path tanpa spasi) ====
if not exist "%JUNCTION%\pubspec.yaml" (
    echo [Serena] Membuat junction %JUNCTION% ...
    mklink /J "%JUNCTION%" "%TARGET%"
    if errorlevel 1 (
        echo [Serena] Gagal membuat junction. Coba jalankan terminal sebagai Administrator.
        pause
        exit /b 1
    )
)

cd /d "%JUNCTION%"

echo [Serena] Menjalankan web dev server di http://localhost:%PORT%
echo [Serena] Hot reload: tekan r - Hot restart: tekan R - Keluar: tekan q
echo.
flutter run -d web-server --web-port=%PORT% --web-hostname=localhost

pause
endlocal
