@echo off

echo;
echo ^>^>%UPDATE_ANNOUNCE1%
echo;

date /t>nul
if exist "..\Archives\update" rmdir /s /q "..\Archives\update"
.\curl.exe --connect-timeout 5 -f -o %UPD_PATH% -L %UPD_URL%
if "%ERRORLEVEL%"=="22" (
    echo;
    echo ^>^>%UPDATE_ERROR%
    echo;
    exit /b
)

.\7z.exe x -bd -y %UPD_PATH% -o"..\Archives\"

echo;
move ..\Archives\TDEnc-devel ..\Archives\update
move /y ..\Archives\update\setting\user_setting.bat ..\Archives\update\setting\user_setting_new.bat
copy /y ..\setting\user_message.bat ..\setting\user_message_old.bat 1>nul 2>&1

echo;
xcopy /y /s ..\Archives\update\* ..\ 2>nul

echo;
rmdir /s /q ..\Archives\update 2>nul

echo;
echo ^>^>%UPDATE_ANNOUNCE2%
echo ^>^>%UPDATE_ANNOUNCE3%
echo ^>^>%PAUSE_MESSAGE2%
pause>nul

set INIT_ANNOUNCE=関連ツール自動アップデート

call ".\initialize.bat"
