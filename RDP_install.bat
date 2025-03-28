@echo off
setlocal EnableDelayedExpansion

:: Kiểm tra quyền Admin
openfiles >nul 2>nul
if %errorlevel% neq 0 (
    echo Bạn cần quyền Administrator để chạy script này.
    echo Vui lòng nhấn phím bất kỳ để thoát...
    pause >nul
    exit
)

echo Cài đặt RDP Wrapper bắt đầu...

:: Tạo thư mục tạm thời để tải và giải nén
set TEMP_DIR=%TEMP%\rdpwrapper
mkdir "%TEMP_DIR%"

:: Tải RDP Wrapper từ GitHub
echo Tải mã nguồn RDP Wrapper từ GitHub...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/stascorp/rdpwrap/archive/refs/heads/master.zip' -OutFile '%TEMP_DIR%\rdpwrap.zip'"

:: Giải nén tệp ZIP
echo Giải nén tệp RDP Wrapper...
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\rdpwrap.zip' -DestinationPath '%TEMP_DIR%'"

:: Di chuyển vào thư mục giải nén
cd "%TEMP_DIR%\rdpwrap-master"

:: Cài đặt RDP Wrapper bằng cách chạy install.bat
echo Cài đặt RDP Wrapper...
start /wait install.bat

:: Kiểm tra trạng thái của RDP Wrapper
echo Kiểm tra trạng thái của RDP Wrapper...
start /wait rdpconf.exe

:: Cập nhật registry để cho phép nhiều phiên Remote Desktop
echo Cập nhật registry để cho phép nhiều phiên...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "AllowMultipleTSSessions" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fSingleSessionPerUser" /t REG_DWORD /d 0 /f

:: Dọn dẹp thư mục tạm thời
rd /s /q "%TEMP_DIR%"
:: Khởi động lại máy tính để áp dụng các thay đổi

echo Khởi động lại máy tính để hoàn tất quá trình...
shutdown.exe /r /f /t 0
echo Cài đặt hoàn tất. Máy tính của bạn sẽ khởi động lại.
exit
