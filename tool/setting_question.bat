rem ################エンコ設定選択開始################

echo %HORIZON%
echo %QUESTION_START1%
echo %QUESTION_START2%
echo %HORIZON%
echo;

rem プリセット選択
:preset
echo %INPUT_AUDIO% | findstr /r "\.wav\>">nul
if "%ERRORLEVEL%"=="0" (
    if /i "%INPUT_FILE_TYPE%"==".mp4" (
        set MUX_MODE=y
    )
)
if not "%PRETYPE%"=="" goto preset_main
:preset_question
echo;
echo ^>^>%PRESET_START1%
echo ^>^>%PRESET_START2%
echo %HORIZON%
echo   l:%PRESET_LIST1%
echo   m:%PRESET_LIST2%
echo   n:%PRESET_LIST3%
echo   o:%PRESET_LIST4%
echo   p:%PRESET_LIST5%
echo   q:%PRESET_LIST6%
if "%MUX_MODE%"=="y" echo   s:%PRESET_LIST7%
echo   x:%PRESET_LIST8%
echo %HORIZON%
set /p PRETYPE=^>^>
:preset_main
if "%PRETYPE%"=="" (
    goto preset_question
) else if /i "%PRETYPE%"=="s" (
    if "%MUX_MODE%"=="y" (
        set DECTYPE=n
        set RESIZE=n
        set T_BITRATE=%P_TEMP_BITRATE%
        set X264_VFR_ENC=true
        set TEMP_264=%INPUT_VIDEO%
        goto account
    )
    echo ^>^>%PRESET_MESSAGE%
    echo ^>^>%PAUSE_MESSAGE2%
    pause>nul
    goto preset_question
) else if /i "%PRETYPE%"=="x" (
    set ENCTYPE=n
    set DECTYPE=n
    goto account
)
echo %PRETYPE% | findstr /i "l m n o p q">nul
if "%ERRORLEVEL%"=="0" goto account
echo;
echo ^>^>%RETURN_MESSAGE1%
echo;
goto preset_question


rem アカウント分岐
:account
if not "%ACTYPE%"=="" goto account_main
:account_question
echo;
echo ^>^>%PREMIUM_START1%
echo ^>^>%PREMIUM_START2%
set /p ACTYPE=^>^>
:account_main
if /i "%ACTYPE%"=="y" goto premium
if /i "%ACTYPE%"=="n" goto normal
echo;
echo ^>^>%RETURN_MESSAGE1%
echo;
goto account_question
:premium
call :economy
call :decode
call :premium_bitrate
call :resize
call :audio_bitrate
call :audio_sync
call :confirm
exit /b
:normal
call :normal_bitrate
call :economy
call :resize
call :audio_bitrate
call :audio_sync
call :confirm
exit /b

rem エコ回避分岐
:economy
if not "%ENCTYPE%"=="" goto economy_main
:economy_question
echo;
echo ^>^>%ECONOMY_START1%
echo ^>^>%ECONOMY_START2%
set /p ENCTYPE=^>^>
:economy_main
if /i "%ENCTYPE%"=="y" (
    set SETTING1=low
    goto low
)
if /i "%ENCTYPE%"=="n" (
    set SETTING1=high
    call :premium_bitrate
    exit /b
)
echo;
echo ^>^>%RETURN_MESSAGE1%
echo;
goto economy_question
:low 
set /a L_BITRATE=%E_MAX_BITRATE%
if /i "%ACTYPE%"=="n"  goto normal_bitrate_setting

if %P_TEMP_BITRATE% LSS %E_TARGET_BITRATE% (
    set /a T_BITRATE=%P_TEMP_BITRATE%
) else (
     set /a T_BITRATE=%E_TARGET_BITRATE%
)
exit /b
:normal_bitrate_setting
if %I_TEMP_BITRATE% LSS %E_TARGET_BITRATE% (
    set /a T_BITRATE=%I_TEMP_BITRATE%
) else (
    set /a T_BITRATE=%E_TARGET_BITRATE%
)
exit /b

rem プレアカビットレート質問
:premium_bitrate
if not "%T_BITRATE%"=="" goto premium_bitrate_main
:premium_bitrate_question
echo;
echo ^>^>%BITRATE_START1%
echo ^>^>%BITRATE_START2% %P_TEMP_BITRATE%kbps
echo ^>^>%BITRATE_START3%
set /p T_BITRATE=^>^>
:premium_bitrate_main
echo %T_BITRATE% | findstr /i [a-z()\-\[\]]>nul
if "%ERRORLEVEL%"=="0" (
    echo;
    echo ^>^>%RETURN_MESSAGE2%
    echo;
    goto premium_bitrate_question
)
if %P_TEMP_BITRATE% LSS %T_BITRATE% (
    echo;
    echo ^>^>%RETURN_MESSAGE3%
    echo ^>^>%RETURN_MESSAGE4%
    echo;
    goto premium_bitrate_question
)
exit /b

rem 一般アカビットレート質問
:normal_bitrate
set /a L_BITRATE=%I_MAX_BITRATE%
if %I_TEMP_BITRATE% LSS %I_TARGET_BITRATE% (
    set /a T_BITRATE=%I_TEMP_BITRATE%
) else (
    set /a T_BITRATE=%I_TARGET_BITRATE%
)
exit /b

rem 低再生負荷分岐
:decode
if not "%DECTYPE%"=="" goto decode_main
:decode_question
echo;
echo ^>^>%DECODE_START1%
echo ^>^>%DECODE_START2%
echo ^>^>%DECODE_START3%
echo ^>^>%DECODE_START4%
set /p DECTYPE=^>^>
:decode_main
if /i "%DECTYPE%"=="y" goto fast_dec
if /i "%DECTYPE%"=="n" goto high_dec
echo;
echo ^>^>%RETURN_MESSAGE1%
echo;
goto decode_question
:fast_dec
set SETTING1=fast_decode
exit /b
:high_dec
set SETTING1=high
if /i "%ENCTYPE%"=="y" set SETTING1=low
exit /b

rem リサイズ分岐
:resize
if not "%RESIZE%"=="" goto resize_main
:resize_question1
echo;
echo ^>^>%RESIZE_START1%
echo ^>^>%RESIZE_START2%
if /i "%ACTYPE%"=="n" goto resize_question2
if /i "%ENCTYPE%"=="y" goto resize_question2
echo %HORIZON%
echo %RESIZE_START3%
echo %RESIZE_START4%
echo %HORIZON%
:resize_question2
echo ^>^>%RESIZE_START5%
set /p RESIZE=^>^>
:resize_main
if /i "%RESIZE%"=="y" goto autoconvert
if /i "%RESIZE%"=="n" goto noconvert
echo %RESIZE% | findstr ":">nul
if "%ERRORLEVEL%"=="0" goto convert

echo;
echo ^>^>%RETURN_MESSAGE1%
echo;
goto resize_question2

:convert
echo %RESIZE%> %TEMP_INFO%
set RESIZE=y
for /f "delims=: tokens=1" %%i in (%TEMP_INFO%) do set DEFAULT_WIDTH=%%i
set /a OUT_WIDTH=%DEFAULT_WIDTH%
set /a WIDTH=%DEFAULT_WIDTH% - %DEFAULT_WIDTH% %% 2
for /f "delims=: tokens=2" %%i in (%TEMP_INFO%) do set DEFAULT_HEIGHT=%%i
set /a OUT_HEIGHT=%DEFAULT_HEIGHT%
set /a HEIGHT=%OUT_HEIGHT% - %OUT_HEIGHT% %% 2
if %IN_WIDTH% LSS %DEFAULT_WIDTH% (
    set SETTING2=up_convert
    exit /b
)
if %IN_WIDTH% GTR %DEFAULT_WIDTH% (
    set SETTING2=down_convert
    exit /b
)
set SETTING2=noresize
exit /b
:autoconvert
set /a WIDTH=%DEFAULT_WIDTH% - %DEFAULT_WIDTH% %% 2
set /a HEIGHT=%OUT_HEIGHT% - %OUT_HEIGHT% %% 2
if %IN_WIDTH% LSS %DEFAULT_WIDTH% (
    call :noconvert
    exit /b
)
if %IN_WIDTH% GTR %DEFAULT_WIDTH% (
    set SETTING2=down_convert
    exit /b
)
set SETTING2=noresize
exit /b
:noconvert
set SETTING2=noresize
set /a WIDTH=%IN_WIDTH% - %IN_WIDTH% %% 2
set /a HEIGHT=%IN_HEIGHT% - %IN_HEIGHT% %% 2
exit /b

rem 音声ビットレート決定
:audio_bitrate
if /i "%PRETYPE%"=="s" (
    set /a M_BITRATE=%T_BITRATE% - %S_V_BITRATE%
) else (
    set /a M_BITRATE=%T_BITRATE%
)
if %M_BITRATE% LSS 0 (
    echo ^>^>%RETURN_MESSAGE5%
    echo ^>^>%RETURN_MESSAGE6%
    echo ^>^>%PAUSE_MESSAGE2%
    pause>nul
    set PRETYPE=
    set ACTYPE=
    set T_BITRATE=
    set ENCTYPE=
    goto preset_question
)
if not "%TEMP_BITRATE%"=="" goto audio_bitrate_main
:audio_bitrate_question
echo;
echo ^>^>%AUDIO_START1%
echo ^>^>%AUDIO_START2%
echo ^>^>%AUDIO_START3%
if /i "%PRETYPE%"=="s" (
    echo ^>^>%AUDIO_START4% %M_BITRATE%kbps
) else (
    echo ^>^>%BITRATE_START2% %M_BITRATE%kbps
)
set /p TEMP_BITRATE=^>^>
:audio_bitrate_main
echo %TEMP_BITRATE% | findstr /i [a-z()\-\[\]]>nul
if "%ERRORLEVEL%"=="1" (
    set /a A_BITRATE=%TEMP_BITRATE%
) else (
    echo;
    echo ^>^>%RETURN_MESSAGE2%
    echo;
    goto audio_bitrate_question
)
if /i "%PRETYPE%"=="s" (
    if %M_BITRATE% LSS %A_BITRATE% (
        echo;
        echo ^>^>%RETURN_MESSAGE3%
        echo ^>^>%RETURN_MESSAGE4%
        echo;
        goto audio_bitrate_question
    )
)
if /i "%PRETYPE%"=="s" (
    set /a V_BITRATE=%S_V_BITRATE%
    set /a T_BITRATE=%S_V_BITRATE% + %A_BITRATE%
) else (
    set /a V_BITRATE=%T_BITRATE% - %A_BITRATE%
)
if %V_BITRATE% LEQ 0 (
    echo;
    echo ^>^>%RETURN_MESSAGE3%
    echo ^>^>%RETURN_MESSAGE4%
    echo;
    goto audio_bitrate_question
)
if "%TEMP_BITRATE%"=="0" set A_SYNC=n
set /a VIDEO_SIZE_LIMIT=(%L_BITRATE% - %A_BITRATE%) * %TOTAL_TIME% / 8
exit /b

:audio_sync
if not "%A_SYNC%"=="" goto audio_sync_main
:audio_sync_question
echo;
echo ^>^>%SYNC_START1%
echo ^>^>%SYNC_START2%
echo ^>^>%SYNC_START3%
echo ^>^>%SYNC_START4%
set /p A_SYNC=^>^>
:audio_sync_main
echo %A_SYNC% | findstr /i "a b c d e f g h i j k l m o p q r s t u v w x z + [ ] ">nul
if "%ERRORLEVEL%"=="1" exit /b
echo;
echo ^>^>%RETURN_MESSAGE7%
echo;
goto audio_sync_question
exit /b


rem 設定最終確認
:confirm
if /i "%SKIP_MODE%"=="true" exit /b
echo;
echo %HORIZON%
if /i "%PRETYPE%"=="l" echo %CONFIRM_PRETYPE%:%PRESET_LIST1%
if /i "%PRETYPE%"=="m" echo %CONFIRM_PRETYPE%:%PRESET_LIST2%
if /i "%PRETYPE%"=="n" echo %CONFIRM_PRETYPE%:%PRESET_LIST3%
if /i "%PRETYPE%"=="o" echo %CONFIRM_PRETYPE%:%PRESET_LIST4%
if /i "%PRETYPE%"=="p" echo %CONFIRM_PRETYPE%:%PRESET_LIST5%
if /i "%PRETYPE%"=="q" echo %CONFIRM_PRETYPE%:%PRESET_LIST6%
if /i "%PRETYPE%"=="s" echo %CONFIRM_PRETYPE%:%PRESET_LIST7%
if /i "%PRETYPE%"=="x" echo %CONFIRM_PRETYPE%:%PRESET_LIST8%
if /i "%ACTYPE%"=="y" (
    echo %CONFIRM_ACCOUNT1%:%CONFIRM_ACCOUNT2%
) else (
    echo %CONFIRM_ACCOUNT1%:%CONFIRM_ACCOUNT3%
)
if /i "%ENCTYPE%"=="y" (
    echo %CONFIRM_ENCTYPE%:%CONFIRM_ON%
) else (
    echo %CONFIRM_ENCTYPE%:%CONFIRM_OFF%
)
if /i "%DECTYPE%"=="y" (
    echo %CONFIRM_DECTYPE%:%CONFIRM_ON%
) else (
    echo %CONFIRM_DECTYPE%:%CONFIRM_OFF%
)
if "%SETTING2%"=="up_convert" (
    echo %CONFIRM_RESIZE1%:%CONFIRM_RESIZE2%^(%WIDTH%x%HEIGHT%^)
) else if "%SETTING2%"=="down_convert" (
    echo %CONFIRM_RESIZE1%:%CONFIRM_RESIZE3%^(%WIDTH%x%HEIGHT%^)
) else (
    echo %CONFIRM_RESIZE1%:%CONFIRM_OFF%^(%WIDTH%x%HEIGHT%^)
)
if /i "%A_SYNC%"=="y" (
    echo %CONFIRM_SYNC1%:%CONFIRM_SYNC2%
) else if /i "%A_SYNC%"=="n" (
    echo %CONFIRM_SYNC1%:%CONFIRM_OFF%
) else (
    echo %CONFIRM_SYNC1%:%CONFIRM_SYNC3%^(%A_SYNC%ms^)
)
echo %CONFIRM_BITRATE1%:%CONFIRM_BITRATE2%=%V_BITRATE%kbps %CONFIRM_BITRATE3%=%A_BITRATE%kbps %CONFIRM_BITRATE4%=%T_BITRATE%kbps
echo %HORIZON%
echo;
echo ^>^>%CONFIRM_LAST1%
set /p CONFIRM=^>^>
if /i "%CONFIRM%"=="y" (
    exit /b
)
if /i "%CONFIRM%"=="n" (
    echo;
    echo ^>^>%CONFIRM_LAST2%
    set PRETYPE=
    set ACTYPE=
    set T_BITRATE=
    set ENCTYPE=
    set DECTYPE=
    set RESIZE=
    set TEMP_BITRATE=
    set A_SYNC=
    set SKIP_MODE=
    echo;
    goto preset
)
echo ^>^>%RETURN_MESSAGE1%
echo;
goto confirm
exit /b
