@echo off
setlocal enabledelayedexpansion

REM Wine API Processor Runner Script for Windows
REM Usage: run_wine_processor.bat [python|node] [csv-file] [api-key] [api-url]

REM Set title
title 🍷 Wine API Processor Runner

REM Check if help is requested
if "%1"=="-h" goto :show_help
if "%1"=="--help" goto :show_help
if "%1"=="help" goto :show_help

REM If no arguments, run interactive mode
if "%1"=="" goto :interactive_mode

REM Check if we have at least the language choice
if "%1"=="" (
    echo [ERROR] Missing required argument: language choice (python or node)
    echo.
    goto :show_help
)

set LANGUAGE=%1
set CSV_FILE=%2
set API_KEY=%3
set API_URL=%4

REM Set defaults if not provided
if "%API_KEY%"=="" set API_KEY=test_api_key_123
if "%API_URL%"=="" set API_URL=https://postman-echo.com/get

REM Validate language choice
if /i "%LANGUAGE%"=="python" goto :check_python
if /i "%LANGUAGE%"=="node" goto :check_node
echo [ERROR] Invalid language choice: %LANGUAGE%
echo [ERROR] Must be 'python' or 'node'
goto :show_help

:interactive_mode
cls
echo.
echo 🎉 🍷 WELCOME TO INTERACTIVE WINE PROCESSOR! 🍷 🎉
echo ==================================================
echo.
echo [INFO] I'll guide you through setting up your wine processing run!
echo.

REM Step 1: Choose language
echo [QUESTION] Which version would you like to run?
echo.
echo   🐍 Python - Great for data processing, includes virtual environment setup
echo   🟢 Node.js - Fast and modern, perfect for web developers
echo.
:choose_language
set /p LANGUAGE_CHOICE="Enter your choice (1-2): "
if "%LANGUAGE_CHOICE%"=="1" set LANGUAGE=python
if "%LANGUAGE_CHOICE%"=="2" set LANGUAGE=node
if not defined LANGUAGE (
    echo [ERROR] Please enter 1 or 2
    goto :choose_language
)
echo.

REM Step 2: Get CSV file
echo [QUESTION] What's the path to your CSV file?
echo.
echo 💡 Pro tip: You can drag and drop your CSV file here, then press Enter!
echo.
:get_csv_file
set /p CSV_FILE="Enter CSV file path (or drag & drop): "
REM Remove quotes if user dragged and dropped
set CSV_FILE=%CSV_FILE:"=%
if not exist "%CSV_FILE%" (
    echo [ERROR] File not found: %CSV_FILE%
    set /p RETRY="Would you like to try again? (y/n): "
    if /i "%RETRY%"=="y" goto :get_csv_file
    echo [ERROR] Exiting...
    pause
    exit /b 1
)
echo.

REM Step 3: API configuration
echo [QUESTION] Let's configure your API settings!
echo.
echo 🔑 API Key: This is like a password for your API
echo 🌐 API URL: The web address where your API is located
echo.
set /p API_KEY="What's your API key? (default: test_api_key_123): "
if "%API_KEY%"=="" set API_KEY=test_api_key_123
set /p API_URL="What's your API endpoint URL? (default: https://postman-echo.com/get): "
if "%API_URL%"=="" set API_URL=https://postman-echo.com/get
echo.

REM Step 4: Confirm settings
echo [INFO] Here's what we're about to run:
echo   🐍 Language: %LANGUAGE%
echo   📁 CSV File: %CSV_FILE%
echo   🔑 API Key: %API_KEY%
echo   🌐 API URL: %API_URL%
echo.
set /p CONFIRM="Does this look correct? Ready to process your wines? (Y/n): "
if /i "%CONFIRM%"=="n" (
    echo [WARNING] No problem! Let's start over...
    echo.
    goto :interactive_mode
)
echo.
echo [SUCCESS] ✅ Let's get this wine party started! 🍷🚀
echo.

REM Run the processor based on language choice
if /i "%LANGUAGE%"=="python" goto :check_python
if /i "%LANGUAGE%"=="node" goto :check_node

:check_python
echo [INFO] Checking Python setup...
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed!
    echo.
    echo [WARNING] Let me help you get Python installed:
    echo.
    echo 1. Go to: https://python.org/downloads/
    echo 2. Download the latest Python 3 version
    echo 3. Run the installer and CHECK 'Add to PATH'
    echo 4. Restart Command Prompt and try again
    echo.
    set /p OPEN_BROWSER="Would you like me to open the Python download page? (y/n): "
    if /i "%OPEN_BROWSER%"=="y" start https://python.org/downloads/
    echo.
    echo [ERROR] Please install Python and run this script again.
    pause
    exit /b 1
)

echo [SUCCESS] ✅ Python found: 
python --version

if not exist "wine_api_processor.py" (
    echo [ERROR] wine_api_processor.py not found in current directory
    echo.
    echo [WARNING] Make sure you're running this script from the weftful folder!
    pause
    exit /b 1
)

if not exist "requirements.txt" (
    echo [WARNING] requirements.txt not found - dependencies may not be installed
)

REM Check if virtual environment exists
if exist "wine_env\Scripts\activate.bat" (
    echo [INFO] Found Python virtual environment, activating...
    call wine_env\Scripts\activate.bat
    echo [SUCCESS] ✅ Virtual environment activated
) else (
    echo [WARNING] No virtual environment found. Let me help you create one:
    echo.
    echo Creating virtual environment...
    python -m venv wine_env
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment
        pause
        exit /b 1
    )
    
    echo Activating virtual environment...
    call wine_env\Scripts\activate.bat
    
    echo Installing dependencies...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo [ERROR] Failed to install dependencies
        pause
        exit /b 1
    )
    
    echo [SUCCESS] ✅ Virtual environment created and dependencies installed!
)

goto :run_python

:check_node
echo [INFO] Checking Node.js setup...
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js is not installed!
    echo.
    echo [WARNING] Let me help you get Node.js installed:
    echo.
    echo 1. Go to: https://nodejs.org/
    echo 2. Download the LTS version (recommended)
    echo 3. Run the installer and check 'Add to PATH'
    echo 4. Restart Command Prompt and try again
    echo.
    set /p OPEN_BROWSER="Would you like me to open the Node.js download page? (y/n): "
    if /i "%OPEN_BROWSER%"=="y" start https://nodejs.org/
    echo.
    echo [ERROR] Please install Node.js and run this script again.
    pause
    exit /b 1
)

echo [SUCCESS] ✅ Node.js found: 
node --version
echo [SUCCESS] ✅ npm found: 
npm --version

if not exist "wine_api_processor.js" (
    echo [ERROR] wine_api_processor.js not found in current directory
    echo.
    echo [WARNING] Make sure you're running this script from the weftful folder!
    pause
    exit /b 1
)

if not exist "package.json" (
    echo [WARNING] package.json not found - dependencies may not be installed
)

REM Check if node_modules exists
if not exist "node_modules" (
    echo [WARNING] Dependencies not installed. Installing now...
    echo This might take a minute...
    npm install
    if errorlevel 1 (
        echo [ERROR] Failed to install dependencies. Please check your internet connection.
        pause
        exit /b 1
    )
    echo [SUCCESS] ✅ Dependencies installed successfully!
) else (
    echo [SUCCESS] ✅ Dependencies already installed
)

goto :run_node

:run_python
echo [INFO] Running Python version...
echo [INFO] CSV: %CSV_FILE%
echo [INFO] API Key: %API_KEY%
echo [INFO] API URL: %API_URL%
echo.
echo [INFO] 🚀 Starting wine processing with Python...
echo [INFO] This will process your CSV and make API calls to: %API_URL%
echo [INFO] Results will be saved to a new CSV file.
echo.
echo [INFO] Processing complete! Check the output files for results.
echo.
goto :end

:run_node
echo [INFO] Running Node.js version...
echo [INFO] CSV: %CSV_FILE%
echo [INFO] API Key: %API_KEY%
echo [INFO] API URL: %API_URL%
echo.
echo [INFO] 🚀 Starting wine processing with Node.js...
echo [INFO] This will process your CSV and make API calls to: %API_URL%
echo [INFO] Results will be saved to a new CSV file.
echo.
echo [INFO] Processing complete! Check the output files for results.
echo.
goto :end

:show_help
echo 🍷 Wine API Processor Runner for Windows
echo.
echo Usage: %0 [python^|node] [csv-file] [api-key] [api-url]
echo.
echo Arguments:
echo   python^|node    Choose Python or Node.js version
echo   csv-file       Path to your CSV file
echo   api-key        Your API key
echo   api-url        API endpoint URL
echo.
echo Examples:
echo   %0 python "Frenchie 10 Wines - Simple.csv" test_api_key_123 https://postman-echo.com/get
echo   %0 node "Frenchie 10 Wines - Simple.csv" test_api_key_123 https://postman-echo.com/get
echo.
echo Default values:
echo   api-key: test_api_key_123
echo   api-url: https://postman-echo.com/get
echo.
echo Note: Use quotes around file paths with spaces
echo.
echo 💡 Pro tip: Run without arguments for interactive mode!
echo.
echo 🚀 For Eric: Just double-click this file and follow the prompts!
goto :end

:end
echo.
echo [SUCCESS] Processing complete! 🎉
pause
