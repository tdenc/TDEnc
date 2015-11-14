rem x264オプション読み込み

echo %PRETYPE% | findstr /i "l o">nul
if "%ERRORLEVEL%"=="0" (
    set DEFAULT_PASS=%DEFAULT_PASS_SPEED%
    goto x264_option_setting
)
echo %PRETYPE% | findstr /i "m p">nul
if "%ERRORLEVEL%"=="0" (
    set DEFAULT_PASS=%DEFAULT_PASS_BALANCE%
    goto x264_option_setting
)
echo %PRETYPE% | findstr /i "n q x">nul
if "%ERRORLEVEL%"=="0" (
    set DEFAULT_PASS=%DEFAULT_PASS_QUALITY%
    goto x264_option_setting
)
echo %PRETYPE% | findstr /i "y">nul
if "%ERRORLEVEL%"=="0" (
    set DEFAULT_PASS=1
    goto x264_option_setting
)

:x264_option_setting
call ..\setting\x264_common.bat
call ..\setting\%PRETYPE%\%SETTING1%.bat

if "%COLORMATRIX%"=="BT.709" (
    set X264_COLORMATRIX=bt709
) else (
    set X264_COLORMATRIX=smpte170m
)
if "%FULL_RANGE%"=="off" (
    set RANGE=tv
) else if "%FULL_RANGE%"=="on" (
    set RANGE=pc
) else (
    set RANGE=auto
)
if "%X264_VFR_ENC%"=="true" set X264_TIMECODE=--tcfile-in %X264_TC_FILE%

set X264_COMMON=--range %RANGE% -I %KEYINT% -i %MIN_KEYINT% --scenecut %SCENECUT% -b %BFRAMES% --b-adapt %B_ADAPT% --b-pyramid %B_PYRAMID% -r %REF% -B %V_BITRATE% --rc-lookahead %RC_LOOKAHEAD% --qpstep %QPSTEP% --aq-mode %AQ_MODE% --aq-strength %AQ_STRENGTH% --qcomp %QCOMP% --weightp %WEIGHTP% --me %ME% -m %SUBME% --psy-rd %PSY_RD% -t %TRELLIS% --threads %THREADS% --colormatrix %X264_COLORMATRIX% %X264_TIMECODE% %COMMON_MISC% %MISC% %VIDEO_AVS%

echo ^>^>%OPTION_SUCCESS%
echo;


rem ################映像エンコード################
rem 264にエンコード
echo ^>^>%X264_ENC_START%
echo;

if "%DEFAULT_PASS%"=="0" goto auto_pass_mode
if "%DEFAULT_PASS%"=="1" goto 1_pass_mode
if "%DEFAULT_PASS%"=="2" goto 2_pass_mode
if "%DEFAULT_PASS%"=="3" goto 3_pass_mode

echo ^>^>%PASS_ERROR%
echo;
echo ^>^>%PAUSE_MESSAGE2%
pause>nul


rem パス数自動設定モード
:auto_pass_mode
echo ^>^>%PASS_ANNOUNCE1%
echo;
rem １pass処理
echo ^>^>%PASS_ANNOUNCE2%
echo;
call :first_encode
rem ２pass処理
echo ^>^>%PASS_ANNOUNCE3%
echo;
call :second_encode
rem ３pass処理
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a TEMP_264_BITRATE=%%i/(%TOTAL_TIME%/8)
if %TEMP_264_BITRATE% LEQ %V_BITRATE% goto :eof
echo ^>^>%PASS_ANNOUNCE4%
echo ^>^>%PASS_ANNOUNCE5%
echo;
echo ^>^>%PASS_ANNOUNCE6%
echo;
call :final_encode
goto :eof


rem 強制1passモード
:1_pass_mode
if /i "%PRETYPE%"=="y" (
    set YOUTUBE=--crf %CRF%
    echo ^>^>%PASS_ANNOUNCE10%
    echo;
) else (
    echo ^>^>%PASS_ANNOUNCE7%
    echo;
    echo ^>^>%PASS_ANNOUNCE2%
    echo;
)
call :abr_encode
if /i not "%PRETYPE%"=="y" goto :eof
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a TEMP_264_BITRATE=%%i/(%TOTAL_TIME%/8)
if %TEMP_264_BITRATE% LEQ %V_BITRATE% (
    goto :eof
) else (
    set YOUTUBE=
    set DEFAULT_PASS=0
    goto auto_pass_mode
)

rem 強制2passモード
:2_pass_mode
echo ^>^>%PASS_ANNOUNCE8%
echo;
rem １pass処理
echo ^>^>%PASS_ANNOUNCE2%
echo;
call :first_encode
rem ２pass処理
echo ^>^>%PASS_ANNOUNCE3%
echo;
call :final_encode
goto :eof

rem 強制3passモード
:3_pass_mode
echo ^>^>%PASS_ANNOUNCE9%
echo;
rem １pass処理
echo ^>^>%PASS_ANNOUNCE2%
echo;
call :first_encode
rem ２pass処理
echo ^>^>%PASS_ANNOUNCE3%
echo;
call :second_encode
rem ３pass処理
echo ^>^>%PASS_ANNOUNCE6%
echo;
call :final_encode
goto :eof

:abr_encode
.\x264.exe -o %TEMP_264% %X264_COMMON% %YOUTUBE%
echo;
exit /b
:first_encode
.\x264.exe -p 1 -o "nul" %X264_COMMON%
echo;
exit /b
:second_encode
.\x264.exe -p 3 -o %TEMP_264% %X264_COMMON%
echo;
exit /b
:final_encode
.\x264.exe -p 2 -o %TEMP_264% %X264_COMMON%
echo;
exit /b

