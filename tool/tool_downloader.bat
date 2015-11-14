@echo off
title %DOWNLOADER_TITLE%

echo %HORIZON%
echo 　%TDENC_NAME%  ToolDownloader
echo %HORIZON%
echo;


rem ################初期処理################
if not exist ..\Archives mkdir ..\Archives
if exist %X264_PATH% del %X264_PATH%
call :file_check_sub


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
if not "%AVS%"=="t" (
    echo ^>^>Avisynth
    .\curl.exe --connect-timeout 5 -f -o %AVS_PATH% -L %AVS_URL%
    echo;
)
if not "%DSS%"=="t" (
    echo ^>^>DirectShowSource
    .\curl.exe --connect-timeout 5 -f -o %DSS_PATH% -L %DSS_URL%
    echo;
)
if not "%DIL%"=="t" (
    echo ^>^>DevIL
    .\curl.exe --connect-timeout 5 -f -o %DIL_PATH% -L %DIL_URL%
    echo;
)

if not "%FSS%"=="t" (
    echo ^>^>FFMpegSource
    .\curl.exe --connect-timeout 5 -f -o %FSS_PATH% -L %FSS_URL%
    echo;
)
if not "%QTS%"=="t" (
    echo ^>^>QTSource
    .\curl.exe --connect-timeout 5 -f -o %QTS_PATH% -L %QTS_URL%
    echo;
)
if not "%MIF%"=="t" (
    echo ^>^>MediaInfo
    .\curl.exe --connect-timeout 5 -f -o %MIF_PATH% -L %MIF_URL%
    echo;
)
if not "%YDF%"=="t" (
    echo ^>^>Yadif
    .\curl.exe --connect-timeout 5 -f -o %YDF_PATH% -L %YDF_URL%
    echo;
)
if not "%A2P%"=="t" (
    echo ^>^>avs2pipe
    .\curl.exe --connect-timeout 5 -f -o %A2P_PATH% -L %A2P_URL%
    echo;
)
if not "%WVI%"=="t" (
    echo ^>^>wavi
    .\curl.exe --connect-timeout 5 -f -o %WVI_PATH% -L %WVI_URL%
    echo;
)
if not "%X264%"=="t" (
    echo ^>^>x264
    .\curl.exe --connect-timeout 5 -f -o %X264_PATH% -L %X264_URL%
    if ERRORLEVEL 22 (
        .\curl.exe --connect-timeout 5 -f -o %X264_PATH% -L %X264_S_URL%
    )
    echo;
)
if "%NERO%"=="t" goto check
echo;
echo;
echo;
echo ^>^>%NERO_LICENSE1%
echo ^>^>%NERO_LICENSE2%
echo ^>^>%NERO_LICENSE3%
echo;
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
echo;
start rundll32 url.dll,FileProtocolHandler "http://www.nero.com/jpn/downloads-nerodigital-nero-aac-codec.php"

:agree
echo ^>^>%NERO_QUESTION%
set /p AGREE=^>^>

if /i "%AGREE%"=="y" goto agree_main
if /i "%AGREE%"=="n" exit

echo;
echo ^>^>%RETURN_MESSAGE1%
echo;
goto agree

:agree_main
echo ^>^>neroAacEnc
.\curl.exe --connect-timeout 5 -f -o %NERO_PATH% -L %NERO_URL%
echo;

goto check


rem ################手動モード################
:auto_mode_off
echo ^>^>%DOWNLOADER_MANUAL%
echo;
if not "%AVS%"=="t" echo Avisynth→%AVS_URL%
echo;
if not "%DSS%"=="t" echo DirectShowSource→%DSS_URL%
echo;
if not "%DIL%"=="t" echo DevIL→%DIL_URL%
echo;
if not "%FSS%"=="t" echo FFmpegSource→%FSS_URL%
echo;
if not "%QTS%"=="t" echo QTSource→%QTS_URL%
echo;
if not "%MIF%"=="t" echo MediaInfo→%MIF_URL%
echo;
if not "%YDF%"=="t" echo yadif→%YDF_URL%
echo;
if not "%A2P%"=="t" echo avs2pipe→%A2P_URL%
echo;
if not "%WVI%"=="t" echo wavi→%WVI_URL%
echo;
if not "%NERO%"=="t" echo NeroDigitalAudio→%NERO_URL%
echo;
if not "%X264%"=="t" echo x264→%X264_URL%
echo;


echo ^>^>%PAUSE_MESSAGE2%
pause>nul
exit


rem ################落とせたかどうかをチェック################
:check
call :file_check_sub

if not "%AVS%%DSS%%DIL%%FSS%%QTS%%MIF%%YDF%%A2P%%WVI%%NERO%%X264%"=="ttttttttttt" goto dl_fail


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
if "%AVS%"=="" echo Avisynth
if "%DSS%"=="" echo DirectShowSource
if "%DIL%"=="" echo DevIL
if "%FSS%"=="" echo FFmpegSource
if "%QTS%"=="" echo QTSource
if "%MIF%"=="" echo MediaInfo
if "%YDF%"=="" echo yadif
if "%A2P%"=="" echo avs2pipe
if "%WVI%"=="" echo wavi
if "%NERO%"=="" echo NeroDigitalAudio
if "%X264%"=="" echo x264
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
for %%i in (%DSS_PATH%) do if %%~zi EQU %DSS_SIZE% set DSS=t
for %%i in (%DIL_PATH%) do if %%~zi EQU %DIL_SIZE% set DIL=t
for %%i in (%FSS_PATH%) do if %%~zi EQU %FSS_SIZE% set FSS=t
for %%i in (%QTS_PATH%) do if %%~zi EQU %QTS_SIZE% set QTS=t
for %%i in (%MIF_PATH%) do if %%~zi EQU %MIF_SIZE% set MIF=t
for %%i in (%YDF_PATH%) do if %%~zi EQU %YDF_SIZE% set YDF=t
for %%i in (%A2P_PATH%) do if %%~zi EQU %A2P_SIZE% set A2P=t
for %%i in (%WVI_PATH%) do if %%~zi EQU %WVI_SIZE% set WVI=t
for %%i in (%NERO_PATH%) do if %%~zi EQU %NERO_SIZE% set NERO=t
if not exist %X264_PATH% exit /b
%X264_PATH% --version>"%TEMP_DIR%\x264_version.txt" 2>nul
findstr /i "%X264_VERSION%" "%TEMP_DIR%\x264_version.txt">nul 2>&1
if "%ERRORLEVEL%"=="0" set X264=t
exit /b
