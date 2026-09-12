@echo off
title JalRakshak AI - Backend API (FastAPI)
echo ============================================================
echo   JalRakshak AI 2.0 - Starting Backend (FastAPI)
echo ============================================================
echo.

cd /d "%~dp0"

:: Activate virtual environment if present
if exist "%~dp0.venv\Scripts\activate.bat" (
    call "%~dp0.venv\Scripts\activate.bat"
) else if exist "%~dp0backend\.venv\Scripts\activate.bat" (
    call "%~dp0backend\.venv\Scripts\activate.bat"
)

:: Ensure backend directory
cd /d "%~dp0backend"

echo Backend API:  http://localhost:8001
echo Swagger Docs: http://localhost:8001/docs
echo Health Check: http://localhost:8001/api/v1/health
echo.

python -m uvicorn main:app --reload --host 127.0.0.1 --port 8001
if errorlevel 1 (
    echo.
    echo [ERROR] Backend server stopped with an error.
    pause
)
