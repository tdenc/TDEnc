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
    echo _keyint = String^(Round^(framerate^(^)^)^)
    echo _in_width = String^(Ceil(width^(^)^)^)
    echo _in_height = String^(Ceil(height^(^)^)^)
    echo;
    echo WriteFileStart^("time.txt","_time",append = false^)
    echo WriteFileStart^("keyint.txt","_keyint",append = false^)
    echo WriteFileStart^("fps.txt","_fps",append = false^)
    echo WriteFileStart^("in_width.txt","_in_width",append = false^)
    echo WriteFileStart^("in_height.txt","_in_height",append = false^)
    echo Trim^(0,-1^)
    echo;
    echo return last
)> %INFO_AVS1%

.\wavi.exe %INFO_AVS1% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\time.txt) do set /a TOTAL_TIME=%%i * 1000
echo PlayTime     : %TOTAL_TIME%ms

echo Format       : AVS^(Avisynth Script^)

if "%DEFAULT_FPS%"=="" (
    set CHANGE_FPS=false
    set FPS=%INPUT_FPS%
) else (
    set CHANGE_FPS=true
    set FPS=%DEFAULT_FPS%
)

for /f "delims=" %%i in (%TEMP_DIR%\keyint.txt) do set /a KEYINT=10*%%i

for /f "delims=" %%i in (%TEMP_DIR%\fps.txt) do set FPS=%%i
echo FPS          : %FPS%fps^(CFR^)

for /f "delims=" %%i in (%TEMP_DIR%\in_width.txt) do set /a IN_WIDTH=%%i
echo Width        : %IN_WIDTH%pixels

for /f "delims=" %%i in (%TEMP_DIR%\in_height.txt) do set /a IN_HEIGHT=%%i
echo Height       : %IN_HEIGHT%pixels


rem ビットレート情報の取得
(
    echo BlankClip^(length=1, width=32, height=32^)
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo;
    echo return last
)> %INFO_AVS2%

.\wavi.exe %INFO_AVS2% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul

echo;

echo ^>^>%ANALYZE_END%
echo;
echo;


rem ################設定の質問################
set RESIZE=n
call setting_question.bat


rem ################エンコ作業開始################
echo;
echo %HORIZON%
echo;
echo;
echo ^>^>%VIDEO_ENC_ANNOUNCE%
echo;

rem ################映像エンコード################
set VIDEO_AVS=%INPUT_FILE_PATH%
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
set PROMPT=$S$H
echo s>%PROCESS_S_FILE%
start process.bat 2>nul
.\wavi.exe %INPUT_FILE_PATH% %TEMP_WAV%
del %PROCESS_S_FILE% 2>nul
if exist %PROCESS_E_FILE% del %PROCESS_E_FILE%
:wav_sleep_start
ping localhost -n 1 >nul
if not exist %PROCESS_E_FILE% goto wav_sleep_start 1>nul 2>&1
del %PROCESS_E_FILE%
prompt

call m4a_enc.bat
