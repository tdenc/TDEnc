rem ################エンコ設定選択開始################

set CONFIRM=

echo %HORIZON_B%
echo %QUESTION_START1%
echo %QUESTION_START2%
echo %HORIZON_B%
echo;

rem 質問レベル選択
:level
if defined Q_LEVEL goto level_main
:level_question
echo;
echo %HORIZON_B%
echo ^>^>%LEVEL_START1%
echo ^>^>%LEVEL_START2%
echo %HORIZON%
echo   1 : %LEVEL_LIST1%
echo   2 : %LEVEL_LIST2%
echo   3 : %LEVEL_LIST3%
echo   %LEVEL_LIST4%
echo %HORIZON%
set /p Q_LEVEL=^>^>
echo %HORIZON_B%
:level_main
if "%Q_LEVEL%"=="1" goto level_main1
if "%Q_LEVEL%"=="2" goto level_main1
if "%Q_LEVEL%"=="3" goto level_main1
echo;
echo ^>^>%RETURN_MESSAGE1%
goto level_question
:level_main1
if %Q_LEVEL% EQU 3 (
    set QUIET=--ssim
    goto site
) else if %Q_LEVEL% LEQ 2 (
    set ENCTYPE0=h
    set DECTYPE0=n
    set CRF_ENC0=y
    set DEINT0=a
    set DENOISE0=a
    set SAMPLERATE0=1
    set QUIET=--quiet
    if %Q_LEVEL% EQU 1 (
        set PRETYPE0=m
        set /a T_BITRATE0=0
        set FLASH0=1
        set RESIZE0=y
        set A_SYNC0=y
    )
    goto site
)

rem サイト選択
:site
if defined UP_SITE goto site_main
:site_question
echo;
echo %HORIZON_B%
echo ^>^>%UP_SITE_START1%
echo ^>^>%UP_SITE_START2%
echo %HORIZON%
set /p UP_SITE=^>^>
echo %HORIZON_B%
:site_main
if /i "%UP_SITE%"=="y" (
    set PRETYPE=y
    set SAMPLERATE=2
    set ENCTYPE=h
    set DECTYPE=n
    set RESIZE=n
    set FLASH=1
    goto account
) else if "%UP_SITE%"=="N" (
    call :surround_check
    set PRETYPE=y
    set ACTYPE=y
    set ENCTYPE=h
    set DECTYPE=n
    set FLASH=1
    set /a T_BITRATE0=0
    goto account
) else if /i "%UP_SITE%"=="t" (
    call :surround_check
    set PRETYPE=t
    set ACTYPE=y
    set ENCTYPE=h
    set DECTYPE=n
    set FLASH=1
    set AAC_PROFILE=lc
    set /a T_BITRATE0=0
    goto account
) else if "%UP_SITE%"=="n" (
    call :surround_check
    goto preset
) else (
    echo;
    echo ^>^>%RETURN_MESSAGE1%
    goto site_question
)

rem サラウンドのチェック
:surround_check
if %AUDIO_CHANNELS% LEQ 2 exit /b
if /i "%UP_SITE%"=="t" (
    echo ^>^>%CHANNEL_ERROR3%
) else (
    echo ^>^>%CHANNEL_ERROR1%
)
echo ^>^>%CHANNEL_ERROR2%
echo;
call error.bat
exit /b

rem プリセット選択
:preset
date /t>nul
echo %INPUT_AUDIO% | findstr /i /r "\.wav\>">nul
if "%ERRORLEVEL%"=="0" (
    if /i "%INPUT_FILE_TYPE%"==".mp4" (
        set MUX_MODE=y
    )
)
if not defined PRETYPE set PRETYPE=%PRETYPE0%
if defined PRETYPE goto preset_main
:preset_question
echo;
echo %HORIZON_B%
echo ^>^>%PRESET_START1%
echo ^>^>%PRESET_START2%
echo %HORIZON%
echo   l : %PRESET_LIST1%
echo   m : %PRESET_LIST2%
echo   n : %PRESET_LIST3%
echo   o : %PRESET_LIST4%
echo   p : %PRESET_LIST5%
echo   q : %PRESET_LIST6%
if "%MUX_MODE%"=="y" echo   s : %PRESET_LIST7%
echo   x : %PRESET_LIST8%
echo %HORIZON%
set /p PRETYPE=^>^>
echo %HORIZON_B%
:preset_main
if defined PRETYPE (
    if /i "%PRETYPE%"=="l" (
        set CRF_ENC=n
        set DENOISE=n
        goto account
    ) else if /i "%PRETYPE%"=="m" (
        goto account
    ) else if /i "%PRETYPE%"=="n" (
        goto account
    ) else if /i "%PRETYPE%"=="o" (
        set CRF_ENC=n
        set DENOISE=n
        goto account
    ) else if /i "%PRETYPE%"=="p" (
        goto account
    ) else if /i "%PRETYPE%"=="q" (
        goto account
    ) else if /i "%PRETYPE%"=="s" (
        if "%MUX_MODE%"=="y" (
            set CRF_ENC=n
            set DEINT=n
            set DENOISE=n
            set FLASH=1
            set DECTYPE=n
            set RESIZE=n
            set T_BITRATE=%P_TEMP_BITRATE%
            goto account
        )
        echo ^>^>%PRESET_MESSAGE%
        echo ^>^>%PAUSE_MESSAGE2%
        pause>nul
        goto preset_question
    ) else if /i "%PRETYPE%"=="x" (
        set ENCTYPE=h
        set DECTYPE=n
        goto account
    ) else if /i "%PRETYPE%"=="t" (
        goto account
    ) else (
        echo ^>^>%RETURN_MESSAGE1%
        goto preset_question
    )
) else (
    echo ^>^>%RETURN_MESSAGE1%
    goto preset_question
)

rem アカウント分岐
:account
if /i "%UP_SITE%"=="y" (
    if defined YTTYPE goto account_main
) else (
    if defined ACTYPE goto account_main
)
:account_question
echo;
echo %HORIZON_B%
if /i "%UP_SITE%"=="n" (
    echo ^>^>%PREMIUM_START1%
    echo ^>^>%PREMIUM_START2%
    echo %HORIZON%
    set YTTYPE=
    set /p ACTYPE=^>^>
    echo %HORIZON_B%
) else (
    echo ^>^>%PREMIUM_START3%
    echo ^>^>%PREMIUM_START4%
    echo %HORIZON%
    set /p YTTYPE=^>^>
    echo %HORIZON_B%
)
:account_main
set /a TOTAL_TIME_SEC=%TOTAL_TIME% / 1000
set /a TOTAL_TIME_LIM=0
if /i "%UP_SITE%"=="y" (
    set ACTYPE=%YTTYPE%
    set /a TOTAL_TIME_LIM=15 * 60
) else if /i "%UP_SITE%"=="t" (
    set /a TOTAL_TIME_LIM=140
)
if /i "%UP_SITE%"=="y" (
    if /i "%ACTYPE%"=="n" (
        if %TOTAL_TIME_SEC% GEQ %TOTAL_TIME_LIM% (
            echo ^>^>%YOUTUBE_ERROR1%
            echo ^>^>%YOUTUBE_ERROR2%
            set YTTYPE=
            goto account_question
        )
    )
    goto premium
) else if /i "%UP_SITE%"=="t" (
    if %TOTAL_TIME_SEC% GEQ %TOTAL_TIME_LIM% (
        echo ^>^>%TWITTER_ERROR1%
        echo ^>^>%TWITTER_ERROR2%
        echo;
        call error.bat
    )
)
if /i "%ACTYPE%"=="y" (
    echo ^>^>%PREMIUM_ERROR1%
    echo ^>^>%PREMIUM_ERROR2%
    echo ^>^>%PREMIUM_ERROR3%
    echo;
    if "%OLD_NICO_FEATURE%"=="true" (
        pause>nul
        goto premium
    ) else (
        call error.bat
    )
)
if /i "%ACTYPE%"=="n" goto normal

echo;
echo ^>^>%RETURN_MESSAGE1%
set YTTYPE=
set ACTYPE=
goto account_question

:premium
call :economy
call :premium_bitrate
call :br_mode
call :decode
call :flash
call :interlace
call :resize
call :resize_check
call :colormatrix
call :denoise
call :audio_bitrate
call :audio_samplerate
call :audio_sync
call :confirm
exit /b

:normal
call :normal_bitrate
call :economy
call :br_mode
call :flash
call :interlace
call :resize
call :colormatrix
call :denoise
call :resize_check
call :audio_bitrate
call :audio_samplerate
call :audio_sync
call :confirm
exit /b

rem エコ回避分岐
:economy
if not defined ENCTYPE set ENCTYPE=%ENCTYPE0%
if defined ENCTYPE goto economy_main
:economy_question
echo;
echo %HORIZON_B%
echo ^>^>%ECONOMY_START1%
echo ^>^>%ECONOMY_START2%
echo %HORIZON%
set /p ENCTYPE=^>^>
echo %HORIZON_B%
:economy_main
if /i "%ENCTYPE%"=="e" (
    set SETTING1=low
    goto low
)
if /i "%ENCTYPE%"=="h" (
    set SETTING1=high
    call :premium_bitrate
    exit /b
)
echo;
echo ^>^>%RETURN_MESSAGE1%
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
if /i "%UP_SITE%"=="y" (
    if /i "%ACTYPE%"=="y" (
        set /a T_BITRATE=%Y_P_TEMP_BITRATE%
        set /a TP_TEMP_BITRATE=%Y_P_TEMP_BITRATE%
    ) else (
        set /a T_BITRATE=%Y_I_TEMP_BITRATE%
        set /a TP_TEMP_BITRATE=%Y_I_TEMP_BITRATE%
    )
) else if /i "%UP_SITE%"=="t" (
    set /a TP_TEMP_BITRATE=%TW_TEMP_BITRATE%
) else if "%UP_SITE%"=="N" (
    set /a TP_TEMP_BITRATE=%P_TEMP_BITRATE_NEW%
) else (
    set /a TP_TEMP_BITRATE=%P_TEMP_BITRATE%
)
if not defined T_BITRATE set T_BITRATE=%T_BITRATE0%
if defined T_BITRATE goto premium_bitrate_main
:premium_bitrate_question
echo;
echo %HORIZON_B%
echo ^>^>%BITRATE_START1%
echo ^>^>%BITRATE_START2%
echo %HORIZON%
set /p T_BITRATE=^>^>
echo %HORIZON_B%
:premium_bitrate_main
date /t>nul
echo %T_BITRATE% | findstr /i [a-z()\-\[\]]>nul
if "%ERRORLEVEL%"=="0" (
    echo;
    echo ^>^>%RETURN_MESSAGE2%
    goto premium_bitrate_question
)
if "%T_BITRATE%"=="0" (
    set T_BITRATE=%TP_TEMP_BITRATE%
    exit /b
)
if %T_BITRATE% GTR %TP_TEMP_BITRATE% (
    set T_BITRATE=%TP_TEMP_BITRATE%
    exit /b
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

rem 品質基準エンコ
:br_mode
if %T_BITRATE% LSS %BITRATE_THRESHOLD% set CRF_ENC=n
if not defined CRF_ENC set CRF_ENC=%CRF_ENC0%
if defined CRF_ENC goto br_mode_main
:br_mode_question
echo;
echo %HORIZON_B%
echo ^>^>%BR_MODE_START1%
echo ^>^>%BR_MODE_START2%
echo ^>^>%BR_MODE_START3%
echo ^>^>%BR_MODE_START4%
echo ^>^>%BR_MODE_START5%
echo %HORIZON%
set /p CRF_ENC=^>^>
echo %HORIZON_B%
:br_mode_main
if not defined CRF_ENC (
    echo;
    echo ^>^>%RETURN_MESSAGE1%
    goto br_mode_question
)
if /i "%CRF_ENC%"=="n" (
    exit /b
) else if /i "%CRF_ENC%"=="y" (
    if /i "%UP_SITE%"=="y" (
        set CRF=--crf %CRF_YOU%
    ) else if "%UP_SITE%"=="N" (
        set CRF=--crf %CRF_YOU%
    ) else if /i "%UP_SITE%"=="t" (
        set CRF=--crf %CRF_YOU%
    ) else if /i "%ACTYPE%"=="n" (
        set CRF=--crf %CRF_LOW%
    ) else if /i "%ACTYPE%"=="y" (
        set CRF=--crf %CRF_HIGH%
    )
    exit /b
)
.\x264.exe --crf %CRF_ENC% 2>%TEMP_INFO%
for /f "tokens=3" %%i in (%TEMP_INFO%) do set X264_CRF_ERROR=%%i
if "%X264_CRF_ERROR%"=="No" (
    set CRF=--crf %CRF_ENC%
    exit /b
) else (
    set CRF_ENC=
    goto br_mode_main
)
exit /b

rem 低再生負荷分岐
:decode
if not defined DECTYPE set DECTYPE=%DECTYPE0%
if defined DECTYPE goto decode_main
:decode_question
echo;
echo %HORIZON_B%
echo ^>^>%DECODE_START1%
echo ^>^>%DECODE_START2%
echo ^>^>%DECODE_START3%
echo ^>^>%DECODE_START4%
echo %HORIZON%
set /p DECTYPE=^>^>
echo %HORIZON_B%
:decode_main
if /i "%DECTYPE%"=="y" goto fast_dec
if /i "%DECTYPE%"=="n" goto high_dec
echo;
echo ^>^>%RETURN_MESSAGE1%
goto decode_question
:fast_dec
set SETTING1=fast_decode
exit /b
:high_dec
set SETTING1=high
if /i "%ENCTYPE%"=="e" set SETTING1=low
exit /b

rem FlashPlayer関連の設定
:flash
if not defined FLASH set FLASH=%FLASH0%
if defined FLASH goto flash_main
:flash_question
echo;
echo %HORIZON_B%
echo ^>^>%FLASH_START1%
echo ^>^>%FLASH_START2%
echo ^>^>%FLASH_START3%
echo ^>^>%FLASH_START4%
echo ^>^>%FLASH_START5%
echo %HORIZON%
echo   1 : %FLASH_LIST1%
echo   2 : %FLASH_LIST2%
echo   3 : %FLASH_LIST3%
echo %HORIZON%
set /p FLASH=^>^>
echo %HORIZON_B%
:flash_main
if "%FLASH%"=="1" exit /b
if "%FLASH%"=="2" exit /b
if "%FLASH%"=="3" exit /b
echo;
echo ^>^>%RETURN_MESSAGE1%
goto flash_question
exit /b

rem デインターレース
:interlace
if not defined DEINT set DEINT=%DEINT0%
if defined DEINT goto interlace_main
:interlace_question
echo;
echo %HORIZON_B%
echo ^>^>%DEINT_START1%
echo ^>^>%DEINT_START2%
echo ^>^>%DEINT_START3%
echo %HORIZON%
set /p DEINT=^>^>
echo %HORIZON_B%
:interlace_main
if /i "%DEINT%"=="a" exit /b
if /i "%DEINT%"=="y" exit /b
if /i "%DEINT%"=="n" exit /b
echo;
echo ^>^>%RETURN_MESSAGE1%
goto interlace_question
exit /b

rem リサイズ分岐
:resize
if not defined RESIZE set RESIZE=%RESIZE0%
if defined RESIZE goto resize_main
:resize_question1
echo;
echo %HORIZON_B%
echo ^>^>%RESIZE_START1%
echo ^>^>%RESIZE_START2%
if /i "%ACTYPE%"=="n" goto resize_question2
if /i "%ENCTYPE%"=="e" goto resize_question2
echo %HORIZON%
echo %RESIZE_START3%
echo %RESIZE_START4%
:resize_question2
echo ^>^>%RESIZE_START5%
echo %HORIZON%
set /p RESIZE=^>^>
echo %HORIZON_B%
:resize_main
if /i "%RESIZE%"=="y" goto autoconvert
if /i "%RESIZE%"=="n" goto noconvert
date /t>nul
echo %RESIZE% | findstr ": x">nul
if "%ERRORLEVEL%"=="0" goto convert
echo;
echo ^>^>%RETURN_MESSAGE1%
goto resize_question2

:convert
echo %RESIZE%> %TEMP_INFO%
for /f "delims=:x tokens=1" %%i in (%TEMP_INFO%) do set WIDTH=%%i
set /a WIDTH=%WIDTH% - %WIDTH% %% 2
for /f "delims=:x tokens=2" %%i in (%TEMP_INFO%) do set HEIGHT=%%i
set /a HEIGHT=%HEIGHT% - %HEIGHT% %% 2
if %IN_WIDTH% LSS %WIDTH% (
    set SETTING2=up_convert
    if not defined RESIZER set RESIZER=BlackmanResize
    exit /b
) else if %IN_WIDTH% GTR %WIDTH% (
    set SETTING2=down_convert
    if not defined RESIZER set RESIZER=Spline16Resize
    exit /b
) else if %IN_HEIGHT% LSS %HEIGHT% (
    set SETTING2=up_convert
    if not defined RESIZER set RESIZER=BlackmanResize
    exit /b
) else if %IN_HEIGHT% GTR %HEIGHT% (
    set SETTING2=down_convert
    if not defined RESIZER set RESIZER=Spline16Resize
    exit /b
)
set SETTING2=noresize
exit /b
:autoconvert
if "%UP_SITE%"=="N" (
    set /a HEIGHT=%OUT_HEIGHT_NICO_NEW%
    set /a WIDTH=%OUT_WIDTH_NICO_NEW%
) else if /i "%UP_SITE%"=="t" (
    set /a HEIGHT=%OUT_HEIGHT_TWITTER%
    set /a WIDTH=%OUT_WIDTH_TWITTER%
) else (
    set /a HEIGHT=%OUT_HEIGHT%
    set /a WIDTH=%OUT_WIDTH%
)
if %IN_HEIGHT% LSS %HEIGHT% (
    if "%UP_SITE%"=="N" (
        set SETTING2=up_convert
        if not defined RESIZER set RESIZER=BlackmanResize
        exit /b
    ) else (
        call :noconvert
        exit /b
    )
)
if %IN_HEIGHT% GTR %HEIGHT% (
    set SETTING2=down_convert
    if not defined RESIZER set RESIZER=Spline16Resize
    exit /b
)
set SETTING2=noresize
exit /b
:noconvert
set SETTING2=noresize
if defined IN_WIDTH_MOD (
    set /a WIDTH=%IN_WIDTH_MOD% - %IN_WIDTH_MOD% %% 2
) else (
    set /a WIDTH=%IN_WIDTH% - %IN_WIDTH% %% 2
)
set /a HEIGHT=%IN_HEIGHT% - %IN_HEIGHT% %% 2
exit /b
:resize_check
if /i "%UP_SITE%"=="y" (
    exit /b
) else if /i "%UP_SITE%"=="t" (
    set LIMIT_WIDTH=%T_MAX_WIDTH%
    set LIMIT_HEIGHT=%T_MAX_HEIGHT%
) else if "%ACTYPE%"=="n" (
    set LIMIT_WIDTH=%I_MAX_WIDTH%
    set LIMIT_HEIGHT=%I_MAX_HEIGHT%
) else (
    exit /b
)
if %WIDTH% LEQ %LIMIT_WIDTH% (
    if %HEIGHT% LEQ %LIMIT_HEIGHT% (
        exit /b
    )
)
echo;
if /i "%PRETYPE%"=="s" (
    echo ^>^>%RETURN_MESSAGE8%
    echo ^>^>%RETURN_MESSAGE9%
    echo;
    rmdir /s /q %TEMP_DIR%
    call error.bat
) else if /i "%UP_SITE%"=="t" (
    echo ^>^>%RETURN_MESSAGE12%
    echo ^>^>%RETURN_MESSAGE13%
    echo;
    echo ^>^>%PAUSE_MESSAGE2%
    pause>nul
    set RESIZE=
) else (
    echo ^>^>%RETURN_MESSAGE10%
    echo ^>^>%RETURN_MESSAGE11%
    echo;
    echo ^>^>%PAUSE_MESSAGE2%
    pause>nul
    set RESIZE=
)
goto preset
exit /b

rem カラーマトリックス
:colormatrix
if %HEIGHT% LSS 720 (
    set COLORMATRIX=%COLORMATRIX_SD%
) else (
    set COLORMATRIX=%COLORMATRIX_HD%
)
exit /b

rem デノイズ
:denoise
if not defined DENOISE set DENOISE=%DENOISE0%
if defined DENOISE goto denoise_main
:denoise_question
echo;
echo %HORIZON_B%
echo ^>^>%DENOISE_START1%
echo ^>^>%DENOISE_START2%
echo ^>^>%DENOISE_START3%
echo %HORIZON%
set /p DENOISE=^>^>
echo %HORIZON_B%
:denoise_main
if /i "%DENOISE%"=="a" (
    if "%UP_SITE%"=="n" (
        set DENOISE=n
    ) else (
        set DENOISE=y
    )
    exit /b
)
if /i "%DENOISE%"=="y" exit /b
if /i "%DENOISE%"=="n" exit /b
echo ^>^>%RETURN_MESSAGE1%
goto denoise_question
exit /b

rem 音声ビットレート決定
:audio_bitrate
if /i "%PRETYPE%"=="s" (
    set /a M_BITRATE=%T_BITRATE% - %S_V_BITRATE%
) else (
    set /a M_BITRATE=%T_BITRATE%
    if /i "%UP_SITE%"=="y" (
        set /a TEMP_BITRATE=%A_BITRATE_YOUTUBE%
    ) else if "%UP_SITE%"=="N" (
        set /a TEMP_BITRATE=%A_BITRATE_NICO_NEW%
    ) else if /i "%UP_SITE%"=="t" (
        set /a TEMP_BITRATE=%A_BITRATE_TWITTER%
    ) else if %Q_LEVEL% LSS 2 (
        if /i "%ACTYPE%"=="y" (
            set /a TEMP_BITRATE=192
        ) else (
            set /a TEMP_BITRATE=128
        )
    )
)
if %M_BITRATE% LSS 0 (
    echo ^>^>%RETURN_MESSAGE5%
    echo ^>^>%RETURN_MESSAGE6%
    echo;
    rmdir /s /q %TEMP_DIR%
    call error.bat
)
if defined TEMP_BITRATE goto audio_bitrate_main
:audio_bitrate_question
echo;
echo %HORIZON_B%
echo ^>^>%AUDIO_START1%
echo ^>^>%AUDIO_START2%
echo ^>^>%AUDIO_START3%
if %M_BITRATE% LSS 320 (
    if /i "%PRETYPE%"=="s" (
        echo ^>^>%AUDIO_START4%%M_BITRATE%kbps
    ) else (
        echo ^>^>%AUDIO_START5%%M_BITRATE%kbps
    )
)
echo %HORIZON%
set /p TEMP_BITRATE=^>^>
echo %HORIZON_B%
:audio_bitrate_main
date /t>nul
echo %TEMP_BITRATE% | findstr /i [a-z()\-\[\]]>nul
if "%ERRORLEVEL%"=="1" (
    set /a A_BITRATE=%TEMP_BITRATE%
) else (
    echo;
    echo ^>^>%RETURN_MESSAGE2%
    goto audio_bitrate_question
)
if /i "%PRETYPE%"=="s" (
    if %A_BITRATE% GTR %M_BITRATE% (
        echo;
        echo ^>^>%RETURN_MESSAGE3%
        echo ^>^>%RETURN_MESSAGE4%
        echo ^>^>%AUDIO_START4% %M_BITRATE%kbps
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
    if /i "%PRETYPE%"=="s" (
        echo ^>^>%AUDIO_START4% %M_BITRATE%kbps
    ) else (
        echo ^>^>%BITRATE_START2% %M_BITRATE%kbps
    )
    goto audio_bitrate_question
)
set /a VIDEO_SIZE_LIMIT=(%L_BITRATE% - %A_BITRATE%) * %TOTAL_TIME% / 8
exit /b

rem サンプリングレート
:audio_samplerate
if not defined SAMPLERATE set SAMPLERATE=%SAMPLERATE0%
if defined SAMPLERATE goto audio_samplerate_main
:audio_samplerate_question
echo;
echo %HORIZON_B%
echo ^>^>%SAMPLERATE_START1%
echo ^>^>%SAMPLERATE_START2%
echo %HORIZON%
echo   0 : %SAMPLERATE_LIST0%
echo   1 : %SAMPLERATE_LIST1%Hz
echo   2 : %SAMPLERATE_LIST2%Hz
echo   3 : %SAMPLERATE_LIST3%Hz
echo %HORIZON%
set /p SAMPLERATE=^>^>
echo %HORIZON_B%
:audio_samplerate_main
if not defined SAMPLERATE (
    echo;
    echo ^>^>%RETURN_MESSAGE1%
    goto audio_samplerate_question
)
if "%SAMPLERATE%"=="0" (
    set SAMPLERATE_HZ=0
) else if "%SAMPLERATE%"=="3" (
    set SAMPLERATE_HZ=%SAMPLERATE_LIST3%
) else if "%SAMPLERATE%"=="2" (
    set SAMPLERATE_HZ=%SAMPLERATE_LIST2%
) else if "%SAMPLERATE%"=="1" (
    set SAMPLERATE_HZ=%SAMPLERATE_LIST1%
) else (
    set SAMPLERATE=
    goto audio_samplerate_main
)
exit /b

rem 音ズレ設定
:audio_sync
if not defined A_SYNC set A_SYNC=%A_SYNC0%
if "%A_BITRATE%"=="0" set A_SYNC=n
if defined A_SYNC goto audio_sync_main
:audio_sync_question
echo;
echo %HORIZON_B%
echo ^>^>%SYNC_START1%
echo ^>^>%SYNC_START2%
echo ^>^>%SYNC_START3%
echo ^>^>%SYNC_START4%
echo %HORIZON%
set /p A_SYNC=^>^>
echo %HORIZON_B%
:audio_sync_main
date /t>nul
echo %A_SYNC% | findstr /i "a b c d e f g h i j k l m o p q r s t u v w x z + [ ] ">nul
if "%ERRORLEVEL%"=="1" exit /b
echo;
echo ^>^>%RETURN_MESSAGE7%
goto audio_sync_question
exit /b


rem 設定最終確認
:confirm
if /i "%SKIP_MODE%"=="true" exit /b
if /i "%CONFIRM%"=="y" exit /b
echo;
echo %HORIZON_B%
echo %CONFIRM_START%
echo %HORIZON_B%
if /i "%UP_SITE%"=="y" (
    if /i "%ACTYPE%"=="y" (
        echo %CONFIRM_ACCOUNT1% : %CONFIRM_ACCOUNT5%
    ) else (
        echo %CONFIRM_ACCOUNT1% : %CONFIRM_ACCOUNT4%
    )
    echo %CONFIRM_PRETYPE% : %PRESET_LIST9%
) else if "%UP_SITE%"=="N" (
    echo %CONFIRM_ACCOUNT1% : %CONFIRM_ACCOUNT6%
) else if /i "%UP_SITE%"=="t" (
    echo %CONFIRM_ACCOUNT1% : %CONFIRM_ACCOUNT7%
) else if /i "%ACTYPE%"=="y" (
    echo %CONFIRM_ACCOUNT1% : %CONFIRM_ACCOUNT2%
) else (
    echo %CONFIRM_ACCOUNT1% : %CONFIRM_ACCOUNT3%
)
if /i "%PRETYPE%"=="l" echo %CONFIRM_PRETYPE% : %PRESET_LIST1%
if /i "%PRETYPE%"=="m" echo %CONFIRM_PRETYPE% : %PRESET_LIST2%
if /i "%PRETYPE%"=="n" echo %CONFIRM_PRETYPE% : %PRESET_LIST3%
if /i "%PRETYPE%"=="o" echo %CONFIRM_PRETYPE% : %PRESET_LIST4%
if /i "%PRETYPE%"=="p" echo %CONFIRM_PRETYPE% : %PRESET_LIST5%
if /i "%PRETYPE%"=="q" echo %CONFIRM_PRETYPE% : %PRESET_LIST6%
if /i "%PRETYPE%"=="s" echo %CONFIRM_PRETYPE% : %PRESET_LIST7%
if /i "%PRETYPE%"=="x" echo %CONFIRM_PRETYPE% : %PRESET_LIST8%
if /i "%PRETYPE%"=="s" goto audio_list
echo %CONFIRM_PLAYER% : %FLASH%
if /i not "%UP_SITE%"=="y" (
    if /i "%ENCTYPE%"=="e" (
        echo %CONFIRM_ENCTYPE% : %CONFIRM_ON%
    ) else (
        echo %CONFIRM_ENCTYPE% : %CONFIRM_OFF%
    )
    if /i "%DECTYPE%"=="y" (
        echo %CONFIRM_DECTYPE% : %CONFIRM_ON%
    ) else (
        echo %CONFIRM_DECTYPE% : %CONFIRM_OFF%
    )
)
if /i "%CRF_ENC%"=="n" (
    echo %CONFIRM_VIDEO% : %CONFIRM_BR%^(%CONFIRM_BITRATE1%:%V_BITRATE%kbps^)
) else (
    echo %CONFIRM_VIDEO% : %CONFIRM_CRF%
)
if "%SETTING2%"=="up_convert" (
    echo %CONFIRM_RESIZE1% : %CONFIRM_RESIZE2%^(%WIDTH%x%HEIGHT%^)
) else if "%SETTING2%"=="down_convert" (
    echo %CONFIRM_RESIZE1% : %CONFIRM_RESIZE3%^(%WIDTH%x%HEIGHT%^)
) else (
    echo %CONFIRM_RESIZE1% : %CONFIRM_OFF%^(%WIDTH%x%HEIGHT%^)
)
if /i "%DEINT%"=="a" (
    echo %CONFIRM_DEINT1% : %CONFIRM_DEINT2%
) else if /i "%DEINT%"=="y" (
    echo %CONFIRM_DEINT1% : %CONFIRM_DEINT3%
) else (
    echo %CONFIRM_DEINT1% : %CONFIRM_DEINT4%
)
if /i "%DENOISE%"=="a" (
    echo %CONFIRM_DENOISE1% : %CONFIRM_DENOISE2%
) else if /i "%DENOISE%"=="y" (
    echo %CONFIRM_DENOISE1% : %CONFIRM_DENOISE3%
) else (
    echo %CONFIRM_DENOISE1% : %CONFIRM_DENOISE4%
)
:audio_list
if "%A_BITRATE%"=="0" (
    set CONFIRM_AUDIOS=%CONFIRM_AUDIO% : %CONFIRM_NO_AUDIO%
) else (
    set CONFIRM_AUDIOS=%CONFIRM_AUDIO% : %A_BITRATE%kbps
)
if /i "%SAMPLERATE%"=="0" (
    set CONFIRM_AUDIOS=%CONFIRM_AUDIOS%/%SAMPLERATE_LIST0%Hz
) else (
    set CONFIRM_AUDIOS=%CONFIRM_AUDIOS%/%SAMPLERATE_HZ%Hz
)
set CONFIRM_AUDIOS=%CONFIRM_AUDIOS%/%CONFIRM_SYNC1%
if /i "%A_SYNC%"=="y" (
    set CONFIRM_AUDIOS=%CONFIRM_AUDIOS%%CONFIRM_SYNC2%
) else if /i "%A_SYNC%"=="n" (
    set CONFIRM_AUDIOS=%CONFIRM_AUDIOS%%CONFIRM_OFF%
) else (
    set CONFIRM_AUDIOS=%CONFIRM_AUDIOS%%CONFIRM_SYNC3%^(%A_SYNC%ms^)
)
echo %CONFIRM_AUDIOS%
if /i "%CRF_ENC%"=="n" (
    echo %CONFIRM_T_BITRATE% : %T_BITRATE%kbps
) else if /i not "%PRETYPE%"=="s" (
    echo %CONFIRM_T_BITRATE% : %CONFIRM_T_CRF%
)
echo %HORIZON%
echo;
echo ^>^>%CONFIRM_LAST1%
echo %HORIZON%
set /p CONFIRM=^>^>
echo %HORIZON_B%
if /i "%CONFIRM%"=="y" (
    exit /b
)
if /i "%CONFIRM%"=="n" (
    echo;
    echo ^>^>%CONFIRM_LAST2%
    echo;
    rmdir /s /q %TEMP_DIR%
    call error.bat
)
echo ^>^>%RETURN_MESSAGE1%
goto confirm
exit /b
