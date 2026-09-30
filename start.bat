@echo off
rem Start Prompt Enhancer with the local Ollama server
cd /d "%~dp0"

if not exist ".venv\Scripts\activate.bat" (
    echo Creating virtual environment on Python 3.11...
    uv venv --python 3.11 .venv || goto :error
    uv pip install --python .venv\Scripts\python.exe -r requirements.txt || goto :error
)

call ".venv\Scripts\activate.bat"

curl -s http://localhost:11434/api/tags >nul 2>&1
if errorlevel 1 (
    echo Ollama is not responding on http://localhost:11434. Starting it...
    start "" /min ollama serve
    timeout /t 3 /nobreak >nul
)

streamlit run main.py
goto :eof

:error
echo Setup failed. Check that uv is installed: https://docs.astral.sh/uv/
pause
exit /b 1
