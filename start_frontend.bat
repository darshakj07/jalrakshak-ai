@echo off
title JalRakshak AI - Frontend (Vite + React)
echo ============================================================
echo   JalRakshak AI 2.0 - Starting Frontend (Vite + React)
echo ============================================================
echo.

cd /d "%~dp0frontend"

if not exist "node_modules" (
    echo [*] Installing frontend dependencies...
    call npm install
)

echo Frontend URL: http://localhost:5173
echo.

call npm run dev
if errorlevel 1 (
    echo.
    echo [ERROR] Frontend server stopped unexpectedly.
    pause
)
