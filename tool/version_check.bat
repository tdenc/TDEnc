@echo off

rem ------------------------------------------------------------------------------
rem 　つんでれんこ  バージョンチェック
rem ------------------------------------------------------------------------------


rem ################初期処理################
if not exist current_version echo %C_VERSION%> current_version
.\curl.exe -o %VER_PATH% -L %VER_URL% 2>nul
if not exist %VER_PATH% (
    echo;
    echo ^>^>%VER_CHECK_ERROR%
    echo;
    exit /b
)
for /f "delims=" %%i in (current_version) do set C_VERSION=%%i
for /f "delims=" %%i in (latest_version) do set L_VERSION=%%i
if "%C_VERSION%"=="%L_VERSION%" goto :eof

.\curl.exe -o %LOG_PATH% -L %LOG_URL% 2>nul
echo;
echo ^>^>%VER_CHECK_NEW1%^(%L_VERSION%^)
echo ^>^>%VER_CHECK_NEW2%
echo;
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
echo;
echo;
echo ^<%VER_CHECK_LOG%^>
type ChangeLog

echo;
echo;
echo;

:version_check
echo ^>^>%UPDATE_QUESTION1%
echo ^>^>%UPDATE_QUESTION2%
echo ^>^>%UPDATE_QUESTION3%
set /p VERSION_UP=^>^>
if /i "%VERSION_UP%"=="y" (
    echo %L_VERSION%> current_version
    call ".\update.bat"
    goto :eof
)
if /i "%VERSION_UP%"=="n" goto :eof
if /i "%VERSION_UP%"=="s" (
    echo %L_VERSION%> current_version
    goto :eof
)
echo;
echo ^>^>%RETURN_MESSAGE1%
echo;
goto version_check
