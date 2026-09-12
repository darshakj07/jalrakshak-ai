@echo off
title JalRakshak AI 2.0 - Launcher
setlocal enabledelayedexpansion

echo ============================================================
echo       JalRakshak AI 2.0 - Full Application Launcher         
echo ============================================================
echo.

cd /d "%~dp0"

:: 1. Ensure .env exists in project root
if not exist ".env" (
    if exist ".env-example" (
        echo [*] .env not found. Creating from .env-example...
        copy ".env-example" ".env" >nul
        echo [+] Created .env successfully.
    ) else (
        echo [!] Warning: .env not found.
    )
)

:: 2. Check Python availability
set "PYTHON_FOUND="
if exist "%~dp0.venv\Scripts\python.exe" (
    set "PYTHON_FOUND=1"
) else (
    where py >nul 2>&1
    if not errorlevel 1 (
        set "PYTHON_FOUND=1"
    ) else (
        where python >nul 2>&1
        if not errorlevel 1 (
            set "PYTHON_FOUND=1"
        )
    )
)

if not defined PYTHON_FOUND (
    echo [ERROR] Python 3.10+ is required but not found in PATH or .venv!
    echo Please install Python from https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

:: 3. Check Node.js / npm availability
where npm >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js and npm are required but not found in PATH!
    echo Please install Node.js 18+ from https://nodejs.org/
    echo.
    pause
    exit /b 1
)

:: 4. Check frontend dependencies
if not exist "%~dp0frontend\node_modules" (
    echo [*] Frontend dependencies missing. Installing...
    cd /d "%~dp0frontend"
    call npm install
    cd /d "%~dp0"
)

echo.
echo [*] Starting Backend server (FastAPI)...
start "JalRakshak Backend (FastAPI)" "%~dp0start_backend.bat"

echo [*] Waiting 3 seconds for backend to start...
timeout /t 3 /nobreak >nul

echo [*] Starting Frontend server (Vite/React)...
start "JalRakshak Frontend (React/Vite)" "%~dp0start_frontend.bat"

echo.
echo ============================================================
echo            JalRakshak AI 2.0 is now running!               
echo ============================================================
echo.
echo   - Web Application:       http://localhost:5173
echo   - Admin Command Center:  http://localhost:5173/admin/login
echo   - Backend API:           http://localhost:8001
echo   - API Swagger Docs:      http://localhost:8001/docs
echo.
echo   (Default Admin Credentials: admin / admin@123)
echo.
echo ============================================================
echo  Separate terminal windows have been launched for each service.
echo  Keep those windows open while using the application.
echo.
echo  To shut down, close those terminal windows or run stop_project.bat.
echo ============================================================
echo.
echo Press any key to open the web app in your browser...
pause >nul

start http://localhost:5173
