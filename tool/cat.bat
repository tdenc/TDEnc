rem ################変数設定################
set INFO_AVS1=%TEMP_DIR%\information1.avs
set INFO_AVS2=%TEMP_DIR%\information2.avs


rem ################動画情報取得################
echo;
echo ^>^>%ANALYZE_ANNOUNCE%
echo;

rem 再生時間取得
(
    echo AVISource^(%INPUT_FILE_PATH%^)
    echo;
    echo _time = String^(Ceil^(framecount^(^) / framerate^(^)^)^)
    echo _fps = String^(framerate^(^)^)
    echo _isyv12 = IsYV12^(^)
    echo _isrgb = IsRGB^(^)
    echo _keyint = String^(Round^(framerate^(^)^)^)
    echo _in_width = String^(Ceil(width^(^)^)^)
    echo _in_height = String^(Ceil(height^(^)^)^)
    echo _out_width = String^(Round^(%DEFAULT_HEIGHT%*width^(^)/height^(^)^)^)
    echo _channels = String^(audiochannels^(^)^)
    echo;
    echo WriteFileStart^("time.txt","_time",append = false^)
    echo WriteFileStart^("yv12.txt","_isyv12",append = false^)
    echo WriteFileStart^("rgb.txt","_isrgb",append = false^)
    echo WriteFileStart^("keyint.txt","_keyint",append = false^)
    echo WriteFileStart^("fps.txt","_fps",append = false^)
    echo WriteFileStart^("in_width.txt","_in_width",append = false^)
    echo WriteFileStart^("in_height.txt","_in_height",append = false^)
    echo WriteFileStart^("out_width.txt","_out_width",append = false^)
    echo WriteFileStart^("channels.txt","_channels",append = false^)
    echo Trim^(0,-1^)
    echo;
    echo return last
)> %INFO_AVS1%

.\avs2pipe_gcc.exe info %INFO_AVS1% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\time.txt) do set /a TOTAL_TIME=%%i * 1000
for /f "delims=" %%i in (%TEMP_DIR%\yv12.txt) do set YV12=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\rgb.txt) do set RGB=%%i>nul
echo PlayTime     : %TOTAL_TIME%ms

echo Format       : AVS^(Avisynth Script^)

for /f "delims=" %%i in (%TEMP_DIR%\keyint.txt) do set /a KEYINT=10*%%i

for /f "delims=" %%i in (%TEMP_DIR%\fps.txt) do set INPUT_FPS=%%i
echo FPS          : %INPUT_FPS%fps^(CFR^)

if not defined DEFAULT_FPS (
    set CHANGE_FPS=false
    set FPS=%INPUT_FPS%
) else (
    set CHANGE_FPS=true
    set FPS=%DEFAULT_FPS%
)

for /f "delims=" %%i in (%TEMP_DIR%\in_width.txt) do set /a IN_WIDTH=%%i
echo Width        : %IN_WIDTH%pixels

for /f "delims=" %%i in (%TEMP_DIR%\in_height.txt) do set /a IN_HEIGHT=%%i
echo Height       : %IN_HEIGHT%pixels

for /f "delims=" %%i in (%TEMP_DIR%\channels.txt) do set /a AUDIO_CHANNELS=%%i
if not defined AUDIO_CHANNELS set AUDIO_CHANNELS=0
echo Audio Channels : %AUDIO_CHANNELS%

rem ビットレート情報の取得
(
    echo BlankClip^(length=1, width=32, height=32^)
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _premium_bitrate_new = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM_NEW%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_partner_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_PARTNER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _twitter_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM_TWITTER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo WriteFileStart^("premium_bitrate_new.txt","_premium_bitrate_new",append = false^)
    echo WriteFileStart^("youtube_partner_bitrate.txt","_youtube_partner_bitrate",append = false^)
    echo WriteFileStart^("youtube_normal_bitrate.txt","_youtube_normal_bitrate",append = false^)
    echo WriteFileStart^("twitter_bitrate.txt","_twitter_bitrate",append = false^)
    echo;
    echo return last
)> %INFO_AVS2%

.\avs2pipe_gcc.exe info %INFO_AVS2% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate_new.txt) do set /a P_TEMP_BITRATE_NEW=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_partner_bitrate.txt) do set /a Y_P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_normal_bitrate.txt) do set /a Y_I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\twitter_bitrate.txt) do set /a TW_TEMP_BITRATE=%%i>nul

rem 出力解像度の設定
set /a IN_WIDTH_ODD=%IN_WIDTH% %% 2
set /a IN_HEIGHT_ODD=%IN_HEIGHT% %% 2
set /a OUT_HEIGHT=%DEFAULT_HEIGHT% + %DEFAULT_HEIGHT% %% 2
if defined DEFAULT_WIDTH (
    set /a OUT_WIDTH=%DEFAULT_WIDTH%
    goto info_check
)
for /f "delims=" %%i in (%TEMP_DIR%\out_width.txt) do set /a OUT_WIDTH_TEMP=%%i
set /a OUT_WIDTH=%OUT_WIDTH_TEMP% + %OUT_WIDTH_TEMP% %% 2
rem ニコニコ新仕様用
set /a OUT_HEIGHT_NICO_NEW=%DEFAULT_HEIGHT_NEW% + %DEFAULT_HEIGHT_NEW% %% 2
set /a OUT_WIDTH_TEMP=%DEFAULT_HEIGHT_NEW% * %IN_WIDTH_MOD% / %IN_HEIGHT%
set /a OUT_WIDTH_NICO_NEW=%OUT_WIDTH_TEMP% + %OUT_WIDTH_TEMP% %% 2

:info_check
echo;
if not defined TOTAL_TIME (
    echo ^>^>%ANALYZE_ERROR%
    call error.bat
    echo;
)
if not defined KEYINT (
    echo ^>^>%ANALYZE_ERROR%
    call error.bat
    echo;
)

echo ^>^>%ANALYZE_END%
echo;
echo;


rem ################設定の質問################
call setting_question.bat


rem ################エンコ作業開始################
echo;
echo %HORIZON%
echo;
echo;
echo ^>^>%VIDEO_ENC_ANNOUNCE%
echo;

rem ################映像エンコード################
rem AVSファイル作成
if /i "%RGB%"=="true" (
    if /i "%FULL_RANGE%"=="on" (
        if /i "%COLORMATRIX%"=="BT.709" (
            set AVS_SCALE=matrix^=^"PC.709^"^,
        ) else (
            set AVS_SCALE=matrix^=^"PC.601^"^,
        )
    ) else (
        if /i "%COLORMATRIX%"=="BT.709" (
            set AVS_SCALE=matrix^=^"Rec709^"^,
        ) else (
            set AVS_SCALE=matrix^=^"Rec601^"^,
        )
    )
) else (
    set AVS_SCALE=
)
if not defined RESIZER set RESIZER=Spline16Resize
(
    if "%RGB%"=="true" (
        echo AVISource^(%INPUT_FILE_PATH%^)
    ) else (
        echo AVISource^(%INPUT_FILE_PATH%,pixel_type="YUY2"^)
    )
    echo;

    if "%IN_WIDTH_ODD%"=="1" (
        if "%IN_HEIGHT_ODD%"=="1" (
            echo Crop^(0,0,-1,-1^)
    ) else (
            echo Crop^(0,0,-1,0^)
    )
    ) else if "%IN_HEIGHT_ODD%"=="1" echo Crop^(0,0,0,-1^)

    echo ConvertToYV12^(%AVS_SCALE%interlaced=false^)
    echo;

    if "%CHANGE_FPS%"=="true" echo ChangeFPS^(%FPS%^)
    echo;

    if not "%IN_WIDTH%"=="%WIDTH%" echo %RESIZER%^(%WIDTH%,last.height^(^)^)
    if not "%IN_HEIGHT%"=="%HEIGHT%" echo %RESIZER%^(last.width^(^),%HEIGHT%^)
)> %VIDEO_AVS%

:denoise_avs
(
    if not "%DENOISE%"=="n" (
        echo LoadPlugin^("RemoveGrain.dll"^)
        echo LoadPlugin^("Repair.dll"^)
        echo src=last
        echo blur=src.RemoveGrain^(%RG_MODE%^)
        echo last=Repair^(blur, src^)
    )
    echo;
    echo return last
)>> %VIDEO_AVS%

echo ^>^>%AVS_END%
echo;

call x264_enc.bat

rem ################音声エンコード################
echo ^>^>%VIDEO_ENC_END%
echo;

if "%A_BITRATE%"=="0" (
    echo ^>^>%SILENCE_ANNOUNCE%
    echo;
    .\silence.exe %FINAL_WAV% -l 0.1 -c 2 -s 44100 -b 16
    .\neroAacEnc.exe -lc -br 0 -if %FINAL_WAV% -of %TEMP_M4A%
    goto :eof
)

echo ^>^>%AUDIO_ENC_ANNOUNCE%
echo;
echo ^>^>%WAV_ANNOUNCE%
if exist %PROCESS_E_FILE% del %PROCESS_E_FILE%
echo s>%PROCESS_S_FILE%
start /b process.bat 2>nul
.\avs2pipe_gcc.exe audio %INPUT_FILE_PATH% > %TEMP_WAV% 2>nul
del %PROCESS_S_FILE% 2>nul
:wav_process
ping localhost -n 1 >nul
if not exist %PROCESS_E_FILE% goto wav_process 1>nul 2>&1
del %PROCESS_E_FILE%

call m4a_enc.bat
