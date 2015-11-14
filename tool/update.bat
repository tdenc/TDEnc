@echo off

echo;
echo ^>^>%UPDATE_ANNOUNCE1%
echo;

if exist "..\Archives\update" rmdir /s /q "..\Archives\update"
.\curl.exe -o %UPD_PATH% -L %UPD_URL%
if not exist %UPD_PATH% (
    echo;
    echo ^>^>%UPDATE_ERROR%
    echo;
    exit /b
)

.\7z.exe x -bd -y "..\Archives\update.zip" -o"..\Archives\"

echo;
move ..\Archives\tde* ..\Archives\update
del ..\Archives\update\setting\user_setting.bat

echo;
xcopy /y /s ..\Archives\update\* ..\

echo;
rmdir /s /q ..\Archives\update

echo;
echo ^>^>%UPDATE_ANNOUNCE2%
echo ^>^>%UPDATE_ANNOUNCE3%
echo ^>^>%PAUSE_MESSAGE2%
pause>nul

set INIT_ANNOUNCE=関連ツール自動アップデート

call ".\initialize.bat"