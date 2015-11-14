rem x264ƒIƒvƒVƒ‡ƒ““Ç‚Ýž‚Ý

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


rem ################‰f‘œƒGƒ“ƒR[ƒh################
rem 264‚ÉƒGƒ“ƒR[ƒh
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


rem ƒpƒX”Ž©“®Ý’èƒ‚[ƒh
:auto_pass_mode
echo ^>^>%PASS_ANNOUNCE1%
echo;
rem ‚Ppassˆ—
echo ^>^>%PASS_ANNOUNCE2%
echo;
call :first_encode
rem ‚Qpassˆ—
echo ^>^>%PASS_ANNOUNCE3%
echo;
call :second_encode
rem ‚Rpassˆ—
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


rem ‹­§1passƒ‚[ƒh
:1_pass_mode
echo ^>^>%PASS_ANNOUNCE7%
echo;
rem ‚Ppassˆ—
echo ^>^>%PASS_ANNOUNCE2%
echo;
call :abr_encode
goto :eof

rem ‹­§2passƒ‚[ƒh
:2_pass_mode
echo ^>^>%PASS_ANNOUNCE8%
echo;
rem ‚Ppassˆ—
echo ^>^>%PASS_ANNOUNCE2%
echo;
call :first_encode
rem ‚Qpassˆ—
echo ^>^>%PASS_ANNOUNCE3%
echo;
call :final_encode
goto :eof

rem ‹­§3passƒ‚[ƒh
:3_pass_mode
echo ^>^>%PASS_ANNOUNCE9%
echo;
rem ‚Ppassˆ—
echo ^>^>%PASS_ANNOUNCE2%
echo;
call :first_encode
rem ‚Qpassˆ—
echo ^>^>%PASS_ANNOUNCE3%
echo;
call :second_encode
rem ‚Rpassˆ—
echo ^>^>%PASS_ANNOUNCE6%
echo;
call :final_encode
goto :eof

:abr_encode
.\x264.exe -o %TEMP_264% %X264_COMMON%
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


