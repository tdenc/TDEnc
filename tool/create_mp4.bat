rem ################MP4作成################
echo ^>^>%MP4_ANNOUNCE%
echo;
if /i not "%PRETYPE%"=="s" (
    if not "%X264_VFR_ENC%"=="true" (
        set MP4_FPS=-fps %FPS%
    )
)

.\MP4Box.exe %MP4_FPS% -add %TEMP_264%#video:delay=noct -add %TEMP_M4A% -new %TEMP_MP4%

if exist "%MP4_DIR%\%FINAL_MP4%" move /y "%MP4_DIR%\%FINAL_MP4%" %MP4_DIR%\old.mp4>nul
move /y %TEMP_MP4% "%MP4_DIR%\%FINAL_MP4%">nul

if not exist "%MP4_DIR%\%FINAL_MP4%" (
    echo ^>^>%MP4_ERROR1%
    echo ^>^>%MP4_ERROR2%
    echo;
    echo ^>^>%PAUSE_MESSAGE1%
    pause>nul
    call quit.bat
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
for /f %%i in (%TEMP_INFO%) do set /a FINAL_MP4_SIZE=%%i
if /i "%ACTYPE%"=="y" goto mp4_check_premium
if %FINAL_MP4_SIZE% LEQ 41943040 (
    echo ^>^>%SIZE_SUCCESS1%
    echo ^>^>%SIZE_SUCCESS2%
    echo;
    goto last
) else (
    echo ^>^>%SIZE_ERROR%
    echo;
    goto :eof
)

:mp4_check_premium
if %FINAL_MP4_SIZE% LEQ 104857600 (
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
