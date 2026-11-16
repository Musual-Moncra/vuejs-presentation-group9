@echo off
chcp 65001 >nul
cd /d "%~dp0demo-vuejs"

echo ==================================================
echo   KHOI DONG DEMO VUEJS 3 - NHOM 9 (WINDOWS)
echo ==================================================

where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [LOI] May nay chua cai Node.js!
    echo Vui long cai Node.js tai https://nodejs.org roi chay lai file nay.
    pause
    exit /b 1
)

if not exist "node_modules" (
    echo [1/2] Lan dau chay: dang cai thu vien (npm install)...
    call npm.cmd install
    if %errorlevel% neq 0 (
        echo [LOI] Cai thu vien that bai. Hay kiem tra ket noi mang!
        pause
        exit /b 1
    )
)

echo [2/2] Dang mo dev server Vite tai http://localhost:5173 ...
echo (Sau vai giay trinh duyet se tu mo. KHONG TAT CUA SO DEN NAY!)
start "" cmd /c "timeout /t 3 /nobreak >nul && start http://localhost:5173"
call npm.cmd run dev
pause
