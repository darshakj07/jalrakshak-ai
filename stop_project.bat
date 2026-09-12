@echo off
title JalRakshak AI 2.0 - Stop Services
echo ============================================================
echo         JalRakshak AI 2.0 - Stopping Services               
echo ============================================================
echo.
echo Stopping processes running on ports 8001 and 5173...
echo.

set FOUND=0

for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8001 " ^| findstr "LISTENING"') do (
    echo [*] Terminating Backend process PID %%a...
    taskkill /PID %%a /F >nul 2>&1
    set FOUND=1
)

for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":5173 " ^| findstr "LISTENING"') do (
    echo [*] Terminating Frontend process PID %%a...
    taskkill /PID %%a /F >nul 2>&1
    set FOUND=1
)

if "%FOUND%"=="0" (
    echo [i] No active services detected on ports 8001 or 5173.
) else (
    echo [+] Successfully stopped all JalRakshak AI services.
)

echo.
pause
