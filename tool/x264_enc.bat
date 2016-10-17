rem x264オプション読み込み

date /t>nul
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
echo %PRETYPE% | findstr /i "y t">nul
if "%ERRORLEVEL%"=="0" (
    set DEFAULT_PASS=0
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

if %FLASH% GEQ 2 set MISC=%MISC% --no-deblock
if %FLASH% EQU 3 set MISC=%MISC% --weightp 0

set X264_COMMON=--range %RANGE% -i %MIN_KEYINT% --scenecut %SCENECUT% -b %BFRAMES% --b-adapt %B_ADAPT% --b-pyramid %B_PYRAMID% -r %REF% --rc-lookahead %RC_LOOKAHEAD% --qpstep %QPSTEP% --aq-mode %AQ_MODE% --aq-strength %AQ_STRENGTH% --qcomp %QCOMP% --weightp %WEIGHTP% --me %ME% -m %SUBME% --psy-rd %PSY_RD% -t %TRELLIS% --threads %THREADS% --colormatrix %X264_COLORMATRIX% %X264_TIMECODE% %COMMON_MISC% %QUIET% %MISC% %VIDEO_AVS%
set /a X264_KEYINT=%KEYINT%
set /a X264_BITRATE=%V_BITRATE% - %BITRATE_MARGIN%

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
rem crfエンコード
if /i "%CRF_ENC%"=="n" goto crf_encode_end
echo ^>^>%PASS_ANNOUNCE10%
echo;
call :crf_encode
if /i "%UP_SITE%"=="y" goto :eof
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a TEMP_264_BITRATE=%%i/(%TOTAL_TIME%/8)
if "%UP_SITE%"=="N" (
   if %TEMP_264_BITRATE% LSS %BITRATE_NICO_NEW_THRESHOLD% (
       set /a X264_KEYINT=%KEYINT%/10
       set X264_COMMON=%X264_COMMON% -I %KEYINT%
       goto :crf_encode_end
   )
)
if %TEMP_264_BITRATE% LEQ %V_BITRATE% goto :eof
:crf_encode_end
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
echo ^>^>%PASS_ANNOUNCE7%
echo;
echo ^>^>%PASS_ANNOUNCE2%
echo;
call :abr_encode
goto :eof

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

:crf_encode
.\x264.exe -o %TEMP_264% %X264_COMMON% -I %X264_KEYINT% %CRF%
echo;
exit /b
:abr_encode
.\x264.exe -o %TEMP_264% %X264_COMMON% -I %X264_KEYINT% -B %X264_BITRATE%
echo;
exit /b
:first_encode
.\x264.exe -p 1 -o "nul" %X264_COMMON% -I %X264_KEYINT% -B %X264_BITRATE%
echo;
exit /b
:second_encode
.\x264.exe -p 3 -o %TEMP_264% %X264_COMMON% -I %X264_KEYINT% -B %X264_BITRATE%
echo;
exit /b
:final_encode
.\x264.exe -p 2 -o %TEMP_264% %X264_COMMON% -I %X264_KEYINT% -B %X264_BITRATE%
echo;
exit /b

