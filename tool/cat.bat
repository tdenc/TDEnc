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
    echo _out_width = %DEFAULT_WIDTH%
    echo _out_height = String^(Round^(%DEFAULT_WIDTH%*height^(^)/width^(^)^)^)
    echo;
    echo WriteFileStart^("time.txt","_time",append = false^)
    echo WriteFileStart^("yv12.txt","_isyv12",append = false^)
    echo WriteFileStart^("rgb.txt","_isrgb",append = false^)
    echo WriteFileStart^("keyint.txt","_keyint",append = false^)
    echo WriteFileStart^("fps.txt","_fps",append = false^)
    echo WriteFileStart^("in_width.txt","_in_width",append = false^)
    echo WriteFileStart^("in_height.txt","_in_height",append = false^)
    echo WriteFileStart^("out_width.txt","_out_width",append = false^)
    echo WriteFileStart^("out_height.txt","_out_height",append = false^)
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

.\avs2pipe_gcc.exe info %INFO_AVS2% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul

set /a IN_WIDTH_ODD=%IN_WIDTH% %% 2
set /a IN_HEIGHT_ODD=%IN_HEIGHT% %% 2
set /a OUT_WIDTH=%IN_WIDTH%
if not "%DEFAULT_HEIGHT%"=="" (
    set /a OUT_HEIGHT=%DEFAULT_HEIGHT%
    goto info_check
)

for /f "delims=" %%i in (%TEMP_DIR%\out_width.txt) do set /a OUT_WIDTH=%%i
for /f "delims=" %%i in (%TEMP_DIR%\out_height.txt) do set /a OUT_HEIGHT=%%i
set /a OUT_HEIGHT_ODD=%OUT_HEIGHT% %% 2
set /a OUT_HEIGHT-=%OUT_HEIGHT_ODD%

:info_check
if "%TOTAL_TIME%"=="" (
    echo ^>^>%ANALYZE_ERROR%
    call quit.bat
    echo;
)

if "%KEYINT%"=="" (
    echo ^>^>%ANALYZE_ERROR%
    call quit.bat
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

(
    echo AVISource^(%INPUT_FILE_PATH%^)
    echo;

    if /i not "%YV12%"=="true" (
        if "%IN_WIDTH_ODD%"=="1" echo Crop^(0,0,-1,0^)
        if "%IN_HEIGHT_ODD%"=="1" echo Crop^(0,0,0,-1^)
        echo ConvertToYV12^(%AVS_SCALE%interlaced=false^)
    )
    echo;

    if "%CHANGE_FPS%"=="true" echo ChangeFPS^(%FPS%^)
    echo;

    if not "%IN_WIDTH%"=="%WIDTH%" echo BlackmanResize^(%WIDTH%,last.height^(^)^)
    if not "%IN_HEIGHT%"=="%HEIGHT%" echo BlackmanResize^(last.width^(^),%HEIGHT%^)
    echo;
    echo return last
)> %VIDEO_AVS%

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
