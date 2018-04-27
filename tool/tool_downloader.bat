@echo off
title %DOWNLOADER_TITLE%

echo %HORIZON%
echo 　%TDENC_NAME%  ToolDownloader
echo %HORIZON%
echo;


rem ################初期処理################
if not exist ..\Archives mkdir ..\Archives
set AVS=f
set DIL=f
set FSS=f
set RG1=f
set QTS=f
set MIF=f
set YDF=f
set A2P=f
set WVI=f
set FFMPEG=f
set X264=f
call :file_check_sub
echo %AVS%%DIL%%FSS%%RG1%%QTS%%MIF%%YDF%%A2P%%WVI%%FFMPEG%%X264% | findstr "f">nul
if "%ERRORLEVEL%"=="1" exit

rem ################モード選択################
:download_mode
echo ^>^>%DOWNLOADER_ANNOUNCE%
echo;

:auto_mode
echo ^>^>%DOWNLOADER_QUESTION1%
echo ^>^>%DOWNLOADER_QUESTION2%
set /p AUTO=^>^>

:auto_main
if /i "%AUTO%"=="y" goto auto_mode_on
if /i "%AUTO%"=="n" goto auto_mode_off

echo;
echo ^>^>%RETURN_MESSAGE1%
echo;
goto auto_mode


rem ################自動モード################
:auto_mode_on
if "%AVS%"=="f" (
    echo ^>^>Avisynth
    .\curl.exe --connect-timeout 5 -f -o %AVS_PATH% -L %AVS_URL%
    echo;
)
if "%DIL%"=="f" (
    echo ^>^>DevIL
    .\curl.exe --connect-timeout 5 -f -o %DIL_PATH% -L %DIL_URL%
    echo;
)
if "%FSS%"=="f" (
    echo ^>^>FFMpegSource
    .\curl.exe --connect-timeout 5 -f -o %FSS_PATH% -L %FSS_URL%
    echo;
)
if "%RG1%"=="f" (
    echo ^>^>RemoveGrain
    .\curl.exe --connect-timeout 5 -f -o %RG1_PATH% -L %RG1_URL%
    echo;
)
if "%QTS%"=="f" (
    echo ^>^>QTSource
    .\curl.exe --connect-timeout 5 -f -o %QTS_PATH% -L %QTS_URL%
    echo;
)
if "%MIF%"=="f" (
    echo ^>^>MediaInfo
    .\curl.exe --connect-timeout 5 -f -o %MIF_PATH% -L %MIF_URL%
    echo;
)
if "%YDF%"=="f" (
    echo ^>^>Yadif
    .\curl.exe --connect-timeout 5 -f -o %YDF_PATH% -L %YDF_URL%
    echo;
)
if "%A2P%"=="f" (
    echo ^>^>avs2pipe
    .\curl.exe --connect-timeout 5 -f -o %A2P_PATH% -L %A2P_URL%
    echo;
)
if "%WVI%"=="f" (
    echo ^>^>wavi
    .\curl.exe --connect-timeout 5 -f -o %WVI_PATH% -L %WVI_URL%
    echo;
)
if "%X264%"=="f" (
    echo ^>^>x264
    .\curl.exe --connect-timeout 5 -f -o %X264_PATH% -L %X264_URL%
    echo;
)
if "%FFMPEG%"=="f" (
    echo ^>^>FFmpeg
    .\curl.exe --connect-timeout 5 -f -o %FFMPEG_PATH% -L %FFMPEG_URL%
    echo;
)
goto check


rem ################手動モード################
:auto_mode_off
echo ^>^>%DOWNLOADER_MANUAL%
echo;
if "%AVS%"=="f" echo Avisynth→%AVS_URL%
if "%DIL%"=="f" echo DevIL→%DIL_URL%
if "%FSS%"=="f" echo FFmpegSource→%FSS_URL%
if "%RG1%"=="f" echo RemoveGrain→%RG1_URL%
if "%QTS%"=="f" echo QTSource→%QTS_URL%
if "%MIF%"=="f" echo MediaInfo→%MIF_URL%
if "%YDF%"=="f" echo yadif→%YDF_URL%
if "%A2P%"=="f" echo avs2pipe→%A2P_URL%
if "%WVI%"=="f" echo wavi→%WVI_URL%
if "%FFMPEG%"=="f" echo FFmpeg→%FFMPEG_URL%
if "%X264%"=="f" echo x264→%X264_URL%
echo;


echo ^>^>%PAUSE_MESSAGE2%
pause>nul
exit


rem ################落とせたかどうかをチェック################
:check
call :file_check_sub
date /t>nul
echo %AVS%%DIL%%FSS%%RG1%%QTS%%MIF%%YDF%%A2P%%WVI%%FFMPEG%%X264% | findstr "f">nul
if "%ERRORLEVEL%"=="0" goto dl_fail


rem ################成功################
echo;
echo ^>^>%DOWNLOADER_END%
echo;
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
exit


rem ################失敗################
:dl_fail
set DL_STATUS=fail
echo;
echo ^>^>%DOWNLOADER_ERROR1%
echo ^>^>%DOWNLOADER_ERROR2%
echo;
if "%AVS%"=="f" echo Avisynth
if "%DIL%"=="f" echo DevIL
if "%FSS%"=="f" echo FFmpegSource
if "%RG1%"=="f" echo RemoveGrain
if "%QTS%"=="f" echo QTSource
if "%MIF%"=="f" echo MediaInfo
if "%YDF%"=="f" echo yadif
if "%A2P%"=="f" echo avs2pipe
if "%WVI%"=="f" echo wavi
if "%FFMPEG%"=="f" echo FFmpeg
if "%X264%"=="f" echo x264
echo;
echo;
echo ^>^>%DOWNLOADER_ERROR3%
echo ^>^>%DOWNLOADER_ERROR4%
echo;
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
exit


rem ################ファイルチェックのサブルーチン################
:file_check_sub
for %%i in (%AVS_PATH%) do if %%~zi EQU %AVS_SIZE% set AVS=t
for %%i in (%DIL_PATH%) do if %%~zi EQU %DIL_SIZE% set DIL=t
for %%i in (%FSS_PATH%) do if %%~zi EQU %FSS_SIZE% set FSS=t
for %%i in (%RG1_PATH%) do if %%~zi EQU %RG1_SIZE% set RG1=t
for %%i in (%QTS_PATH%) do if %%~zi EQU %QTS_SIZE% set QTS=t
for %%i in (%MIF_PATH%) do if %%~zi EQU %MIF_SIZE% set MIF=t
for %%i in (%YDF_PATH%) do if %%~zi EQU %YDF_SIZE% set YDF=t
for %%i in (%A2P_PATH%) do if %%~zi EQU %A2P_SIZE% set A2P=t
for %%i in (%WVI_PATH%) do if %%~zi EQU %WVI_SIZE% set WVI=t
for %%i in (%FFMPEG_PATH%) do if %%~zi EQU %FFMPEG_SIZE% set FFMPEG=t
if not exist %X264_PATH% exit /b
%X264_PATH% --version>"%TEMP_DIR%\x264_version.txt" 2>nul
date /t>nul
findstr /i "%X264_VERSION%" "%TEMP_DIR%\x264_version.txt">nul 2>&1
if "%ERRORLEVEL%"=="0" set X264=t
exit /b
