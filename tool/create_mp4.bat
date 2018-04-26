rem ################MP4作成################
echo ^>^>%MP4_ANNOUNCE%
echo;
if /i not "%PRETYPE%"=="s" (
    set MP4_FPS=-fps %FPS%
)

.\MP4Box.exe %MP4_FPS% -add %TEMP_264%#video:delay=noct -add %TEMP_M4A% -new %TEMP_MP4%

if exist "%MP4_DIR%\%FINAL_MP4%" move /y "%MP4_DIR%\%FINAL_MP4%" %MP4_DIR%\old.mp4>nul
move /y %TEMP_MP4% "%MP4_DIR%\%FINAL_MP4%">nul

if not exist "%MP4_DIR%\%FINAL_MP4%" (
    echo ^>^>%MP4_ERROR1%
    echo ^>^>%MP4_ERROR2%
    echo;
    call error.bat
)

echo;
echo ^>^>%MP4_SUCCESS%
echo;


rem ################MP4の情報を表示################
echo %HORIZON%
echo   MP4 INFO
echo %HORIZON%

rem ファイル名
echo File Name     : %FINAL_MP4%

rem 容量
.\MediaInfo.exe --Inform=General;%%FileSize/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo File Size     : %%i

rem 総ビットレート
.\MediaInfo.exe --Inform=General;%%OverallBitRate/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Total Bitrate : %%i

rem FPS
.\MediaInfo.exe --Inform=Video;%%FrameRate/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo FPS           : %%i

rem 解像度
.\MediaInfo.exe --Inform=Video;%%Width/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Width         : %%i
.\MediaInfo.exe --Inform=Video;%%Height/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Height        : %%i

rem アスペクト比
.\MediaInfo.exe --Inform=Video;%%DisplayAspectRatio/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Aspect Ratio  : %%i

echo %HORIZON%
echo;


rem ################容量チェック################
if /i "%PRETYPE%"=="y" goto last
.\MediaInfo.exe --Inform=General;%%FileSize%% "%MP4_DIR%\%FINAL_MP4%"> %TEMP_INFO%
for /f %%i in (%TEMP_INFO%) do set FINAL_MP4_SIZE=%%i
set FINAL_MP4_SIZE_MB1=%FINAL_MP4_SIZE:~0,-6%
if not defined FINAL_MP4_SIZE_MB1 set FINAL_MP4_SIZE_MB1=0
set MP4_FILESIZE_NICO_NEW_MB1=%MP4_FILESIZE_NICO_NEW:~0,-6%
if /i "%UP_SITE%"=="t" (
    set /a MP4_FILESIZE_LIMIT=%MP4_FILESIZE_TWITTER%
) else if "%UP_SITE%"=="N" (
    set MP4_FILESIZE_NICO_NEW_MB1=%MP4_FILESIZE_NICO_NEW%
    set FINAL_MP4_SIZE=%FINAL_MP4_SIZE_MB1%
) else if /i "%ACTYPE%"=="y" (
    set /a MP4_FILESIZE_LIMIT=%MP4_FILESIZE_NICO_PREMIUM%
) else (
    set /a MP4_FILESIZE_LIMIT=%MP4_FILESIZE_NICO_NORMAL%
)

if %FINAL_MP4_SIZE% LEQ %MP4_FILESIZE_LIMIT% (
    echo ^>^>%SIZE_SUCCESS1%
    echo ^>^>%SIZE_SUCCESS2%
    echo;
    goto last
) else (
    echo ^>^>%SIZE_ERROR%
    echo;
    goto :eof
)


rem ################後処理################
:last
echo ^>^>%DERE_MESSAGE1%
echo;
echo ^>^>%DERE_MESSAGE2%
echo;
