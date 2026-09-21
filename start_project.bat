@echo off
title JalRakshak AI 2.0 Launcher
color 0B

echo ================================================================
echo               JalRakshak AI 2.0 - Startup Script
echo ================================================================
echo.

:: Get the directory where the batch file is located
cd /d "%~dp0"

:: Step 1: Ensure .env exists
if not exist ".env" (
    echo [*] .env file not found. Creating from .env-example...
    if exist ".env-example" (
        copy ".env-example" ".env" >nul
        echo [+] Created .env file.
    ) else (
        echo [!] Warning: .env-example not found.
    )
) else (
    echo [+] Environment configuration .env detected.
)

:: Step 2: Check & Setup Backend Virtual Environment
echo.
echo [*] Checking Backend Python Environment...
if not exist "backend\.venv\Scripts\activate.bat" (
    echo [*] Virtual environment not found. Setting up backend\.venv...
    where py >nul 2>&1
    if %errorlevel% equ 0 (
        py -3.12 -m venv backend\.venv 2>nul || py -m venv backend\.venv
    ) else (
        python -m venv backend\.venv
    )
    echo [*] Installing backend dependencies...
    call backend\.venv\Scripts\activate.bat
    python -m pip install --upgrade pip
    pip install -r backend\requirements.txt
) else (
    echo [+] Backend virtual environment is ready.
)

:: Step 3: Check & Setup Frontend Node Modules
echo.
echo [*] Checking Frontend Dependencies...
if not exist "frontend\node_modules" (
    echo [*] Installing frontend npm dependencies...
    cd frontend
    call npm install
    cd ..
) else (
    echo [+] Frontend dependencies are ready.
)

echo.
echo ================================================================
echo   Starting Services:
echo   - Backend:  http://127.0.0.1:8001  - Swagger: http://127.0.0.1:8001/docs
echo   - Frontend: http://localhost:5173
echo ================================================================
echo.

:: Step 4: Start Backend Server in a new window
start "JalRakshak AI - Backend API" cmd /k "cd /d ""%~dp0backend"" && call .venv\Scripts\activate.bat && python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reload"

:: Step 5: Start Frontend Server in a new window
start "JalRakshak AI - Frontend UI" cmd /k "cd /d ""%~dp0frontend"" && npm run dev"

:: Step 6: Wait 4 seconds for servers to initialize and open the browser
timeout /t 4 /nobreak >nul
start http://localhost:5173

echo [+] Application launched successfully!
echo.
echo Keep the backend and frontend terminal windows open while using the app.
echo You can close this window at any time.
pause
