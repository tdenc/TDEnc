rem ################変数設定################
set INFO_AVS=%TEMP_DIR%\information.avs
set X264_TC_FILE=%TEMP_DIR%\x264.tc


rem ################動画情報取得################
echo ^>^>%ANALYZE_ANNOUNCE%
echo;
echo %INPUT_FILE_TYPE% | findstr /i "jpg jpeg png bmp">nul
if "%ERRORLEVEL%"=="1" goto movie_mux_mode

rem 画像と音声のMUX
.\MediaInfo.exe --Inform=Audio;%%PlayTime%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set TOTAL_TIME=%%i
if "%TOTAL_TIME%"=="" (
    echo ^>^>%ANALYZE_ERROR%
    echo;
    call quit.bat
)
echo PlayTime     : %TOTAL_TIME%ms

(
    echo ImageSource^(%INPUT_VIDEO%,end=1,fps=1^)
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo;
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo;
    echo return last
)> %INFO_AVS%

.\avs2pipe_gcc.exe info %INFO_AVS% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul

set /a TOTAL_TIME_SECOND=%TOTAL_TIME%/1000

set FPS=1

.\MediaInfo.exe --Inform=Image;%%Width%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_WIDTH=%%i
echo Width        : %IN_WIDTH%pixels
.\MediaInfo.exe --Inform=Image;%%Height%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_HEIGHT=%%i
echo Height       : %IN_HEIGHT%pixels

set /a IN_WIDTH_ODD=%IN_WIDTH% %% 2
set /a IN_HEIGHT_ODD=%IN_HEIGHT% %% 2
set /a OUT_WIDTH=%IN_WIDTH%
if not "%DEFAULT_HEIGHT%"=="" (
    set /a OUT_HEIGHT=%DEFAULT_HEIGHT%
    goto image_info_end
)
set /a OUT_HEIGHT_TEMP=%DEFAULT_WIDTH% * %IN_HEIGHT% / %IN_WIDTH%
set /a OUT_HEIGHT_ODD=%OUT_HEIGHT_TEMP% %% 2
set /a OUT_HEIGHT=%OUT_HEIGHT_TEMP% - %OUT_HEIGHT_ODD%

:image_info_end
echo;
echo ^>^>%ANALYZE_END%
echo;
echo;

rem ################設定の質問################
set PRETYPE=m
set DECTYPE=n
set A_SYNC=n
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
(
    echo ImageSource^(%INPUT_VIDEO%,end=%TOTAL_TIME_SECOND%,fps=%FPS%^)
    if "%IN_WIDTH_ODD%"=="1" echo Crop^(0,0,-1,0^)
    if "%IN_HEIGHT_ODD%"=="1" echo Crop^(0,0,0,-1^)
    if "%SETTING2%"=="noresize" (
        echo # no resize
    ) else (
        echo BlackmanResize^(%WIDTH%,%HEIGHT%^)
        echo;
    )
    echo ConvertToYV12^(^)
    echo;
    echo return last
)> %VIDEO_AVS%

echo ^>^>%AVS_END%
echo;

rem 264にエンコード

rem １pass処理
echo ^>^>１pass目～♪
echo;
.\x264.exe --fullrange %FULL_RANGE% -I 10 -i 10 --no-scenecut -b 0 -r 1 -f -1:-1 -B %V_BITRATE% --ipratio 1.0 --aq-mode 2 --aq-strength 0.70 -p 1 --stats TEMP\x264_2pass.log --qcomp 0.8 --direct auto --weightp 0 --me dia -m 1 -t 1 --no-fast-pskip --no-dct-decimate --threads 0 --thread-input --colormatrix smpte170m --quiet -o "nul" %VIDEO_AVS%
echo;

rem ２pass処理
echo ^>^>２pass目～♪
echo;
.\x264.exe --fullrange %FULL_RANGE% -I 10 -i 10 --no-scenecut -b 0 -r 1 -f -1:-1 -B %V_BITRATE% --ipratio 1.0 --aq-mode 2 --aq-strength 0.70 -p 2 --stats TEMP\x264_2pass.log --qcomp 0.8 --direct auto --weightp 0 --me dia -m 1 -t 1 --no-fast-pskip --no-dct-decimate --threads 0 --thread-input --colormatrix smpte170m --quiet -o %TEMP_264% %VIDEO_AVS%
echo;

echo ^>^>%VIDEO_ENC_END%
echo;


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
    
(
    echo WAVSource^(%INPUT_AUDIO%^)
    echo;
    echo return last
)> %AUDIO_AVS%

echo ^>^>%WAV_ANNOUNCE%
.\avs2pipe_gcc.exe audio %AUDIO_AVS% > %TEMP_WAV%
echo;

call m4a_enc.bat

goto :eof


rem 動画と音声のMUX
:movie_mux_mode

rem 動画のフォーマット書き出し
.\MediaInfo.exe --Inform=Video;%%Format%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Video Format : %%i
.\MediaInfo.exe --Inform=Video;%%CodecID%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Video Codec  : %%i
.\MediaInfo.exe --Inform=Video;%%BitRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set VBITRATE_MODE=%%i
if not "%VBITRATE_MODE%"== "" echo VideoBR Mode : %VBITRATE_MODE%
.\MediaInfo.exe --Inform=Video;%%BitRate%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a S_V_BITRATE=%%i/1000
echo VideoBitrate : %S_V_BITRATE%
.\MediaInfo.exe --Inform=Audio;%%Format%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Audio Format : %%i
.\MediaInfo.exe --Inform=Audio;%%CodecID%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Audio Codec  : %%i
.\MediaInfo.exe --Inform=Audio;%%BitRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set ABITRATE_MODE=%%i
if not "%ABITRATE_MODE%"== "" echo AudioBR Mode : %ABITRATE_MODE%

rem 動画の容量書き出し
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a INPUT_FILE_SIZE=%%i
echo FileSize     : %INPUT_FILE_SIZE%byte

rem 再生時間の書き出し
.\MediaInfo.exe --Inform=General;%%PlayTime%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul

rem 再生時間・上限ビットレートの設定
for /f "delims=" %%i in (%TEMP_INFO%) do set TOTAL_TIME=%%i
echo PlayTime     : %TOTAL_TIME%ms

rem CFR（固定フレームレート）とVFR（可変フレームレート）の判断
.\MediaInfo.exe --Inform=Video;%%FrameRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set FPS_MODE=%%i
if "%FPS_MODE%"=="VFR" goto vfr_info

rem CFRの設定
set VFR=false
.\MediaInfo.exe --Inform=Video;%%FrameRate%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FPS=%%i
if not "%INPUT_FPS%"=="" echo FPS          : %INPUT_FPS%fps^(CFR^)
goto fps_main

rem VFRの設定
:vfr_info
set VFR=true
.\MediaInfo.exe --Inform=Video;%%FrameRate%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FPS=%%i
echo FPS          : %INPUT_FPS%fps^(VFR^)
.\MediaInfo.exe --Inform=Video;%%FrameRate_Minimum%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Minimum FPS  : %%i
.\MediaInfo.exe --Inform=Video;%%FrameRate_Maximum%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Maximum FPS  : %%i

:fps_main
if "%DEFAULT_FPS%"=="" (
    set CHANGE_FPS=false
    set FPS=%INPUT_FPS%
) else (
    set CHANGE_FPS=true
    set FPS=%DEFAULT_FPS%
)

rem 解像度の設定
.\MediaInfo.exe --Inform=Video;%%Width%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_WIDTH=%%i
echo Width        : %IN_WIDTH%pixels
.\MediaInfo.exe --Inform=Video;%%Height%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_HEIGHT=%%i
echo Height       : %IN_HEIGHT%pixels

rem アスペクト比
.\MediaInfo.exe --Inform=Video;%%DisplayAspectRatio%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set D_ASPECT=%%i
echo AspectRatio  : %D_ASPECT%
.\MediaInfo.exe --Inform=Video;%%PixelAspectRatio%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set P_ASPECT=%%i

rem インターレース関連の設定
:interlace
.\MediaInfo.exe --Inform=Video;%%ScanType%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set SCAN_TYPE=%%i
if not "%SCAN_TYPE%"=="" echo Scan type    : %SCAN_TYPE%
.\MediaInfo.exe --Inform=Video;%%ScanOrder%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f  %%i in (%TEMP_INFO%) do set SCAN_ORDER=%%i
if not "%SCAN_ORDER%"=="" echo Scan order   : %SCAN_ORDER%

rem IDRフレーム間の最大間隔・容量上限の設定
if /i "%DECODER%"=="avi" goto avisource_info
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_info
if /i "%DECODER%"=="directshow" goto directshowsource_info

:directshowsource_info
(
    echo LoadPlugin^("DirectShowSource.dll"^)
    echo;
    echo DirectShowSource^(%INPUT_VIDEO%, audio = false^)
)> %INFO_AVS%
goto infoavs

:avisource_info
echo AVISource^(%INPUT_VIDEO%, audio = false^)> %INFO_AVS%
goto infoavs

:ffmpegsource_info
if "%VFR%"=="true" (
    echo;
    echo exporting timecode...
    if exist %X264_TC_FILE% del %X264_TC_FILE%
    .\x264 --preset ultrafast -q 51 -o nul --no-progress --quiet --tcfile-out %X264_TC_FILE% %INPUT_VIDEO% 2>nul
    if exist %X264_TC_FILE% (
        echo done.
        set X264_VFR_ENC=true
        set TEMP_264=%TEMP_DIR%\video.mp4
    ) else (
        echo failed.
        echo ^(encode as cfr^)
    )
)
(
    echo LoadPlugin^("ffms2.dll"^)
    echo;
    echo FFVideoSource^("input%INPUT_FILE_TYPE%",cache=false^)
)> %INFO_AVS%

:infoavs
(
    echo;
    echo _isyv12 = IsYV12^(^)
    echo _isrgb = IsRGB^(^)
    echo _fps = Framerate^(^)
    if not "%FPS%"=="" (
        echo _keyint = String^(Round^(%FPS%^)^)
    ) else (
        echo _keyint = String^(Round^(_fps^)^)
    )
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _in_width = String^(Floor^(Float^(%IN_WIDTH%^) * %P_ASPECT%^)^)
    echo;
    echo WriteFileStart^("yv12.txt","_isyv12",append = false^)
    echo WriteFileStart^("rgb.txt","_isrgb",append = false^)
    echo WriteFileStart^("fps.txt","_fps",append = false^)
    echo WriteFileStart^("keyint.txt","_keyint",append = false^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo WriteFileStart^("in_width.txt","_in_width",append = false^)
    echo;
    echo Trim^(0,-1^)
    echo;
    echo return last
)>> %INFO_AVS%

.\avs2pipe_gcc.exe info %INFO_AVS% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\yv12.txt) do set YV12=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\rgb.txt) do set RGB=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\keyint.txt) do set /a KEYINT=%%i*10>nul
for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\in_width.txt) do set IN_WIDTH=%%i>nul

for /f "delims=" %%i in (%TEMP_DIR%\fps.txt) do set AVS_FPS=%%i>nul 2>&1
if "%FPS%"=="" set FPS=%AVS_FPS%

rem 出力解像度の設定
set /a IN_WIDTH_ODD=%IN_WIDTH% %% 2
set /a IN_HEIGHT_ODD=%IN_HEIGHT% %% 2
set /a OUT_WIDTH=%IN_WIDTH%
if not "%DEFAULT_HEIGHT%"=="" (
    set /a OUT_HEIGHT=%DEFAULT_HEIGHT%
    goto info_check
)
set /a OUT_HEIGHT_TEMP=%DEFAULT_WIDTH% * %IN_HEIGHT% / %IN_WIDTH%
set /a OUT_HEIGHT_ODD=%OUT_HEIGHT_TEMP% %% 2
set /a OUT_HEIGHT=%OUT_HEIGHT_TEMP% - %OUT_HEIGHT_ODD%

:info_check
if "%TOTAL_TIME%"=="" (
    echo ^>^>%ANALYZE_ERROR%
    call quit.bat
)
if "%KEYINT%"=="" (
    echo;
    echo ^>^>%DECODE_ERROR3%
    echo ^>^>%DECODE_ERROR4%
    echo ^>^>%DECODE_ERROR5%
    echo ^>^>%DECODE_ERROR6%
    call quit.bat
)
goto mux_mode_question


rem ################設定の質問################
:mux_mode_question
echo;
echo ^>^>%ANALYZE_END%
echo;
echo;
call setting_question.bat


rem ###############プリセットs################
if /i "%PRETYPE%"=="s" goto mux_audio_start


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

if /i "%DECODER%"=="avi" goto avisource_video
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_video
if /i "%DECODER%"=="directshow" goto directshowsource_video

:directshowsource_video
(
    echo LoadPlugin^("DirectShowSource.dll"^)
    echo;
    if "%VFR%"=="true" (
        echo DirectShowSource^(%INPUT_VIDEO%, audio = false, fps=%INPUT_FPS%, convertfps=true^)
    ) else (
        echo DirectShowSource^(%INPUT_VIDEO%, audio = false, fps=%INPUT_FPS%, convertfps=false^)
    )
)> %VIDEO_AVS%
goto vbr_avs

:avisource_video
echo AVISource^(%INPUT_VIDEO%, audio = false^)> %VIDEO_AVS%
goto vbr_avs

:ffmpegsource_video
(
    echo LoadPlugin^("ffms2.dll"^)
    echo;
    echo fps_num = Int^(%FPS% * 1000^)
    echo FFVideoSource^("input%INPUT_FILE_TYPE%",cache=false, fpsnum=fps_num,fpsden=1000^)
)> %VIDEO_AVS%

:vbr_avs
echo;>> %VIDEO_AVS%
if "%ABITRATE_MODE%"=="VBR" (
    echo EnsureVBRMP3Sync^(^)>> %VIDEO_AVS%
    echo;>> %VIDEO_AVS%
)
echo;>> %VIDEO_AVS%
if "%SCAN_TYPE%"=="Interlaced" goto interlace
if "%SCAN_TYPE%"=="MBAFF" goto interlace

rem プログレッシブ
if /i "%YV12%"=="true" goto fps_avs

if "%IN_WIDTH_ODD%"=="1" echo Crop^(0,0,-1,0^)>> %VIDEO_AVS%
if "%IN_HEIGHT_ODD%"=="1" echo Crop^(0,0,0,-1^)>> %VIDEO_AVS%

echo ConvertToYV12^(%AVS_SCALE%interlaced=false^)>> %VIDEO_AVS%
echo;>> %VIDEO_AVS%
goto fps_avs

rem インターレース
:interlace
echo Load_Stdcall_Plugin^("yadif.dll"^)>> %VIDEO_AVS%
if /i "%YV12%"=="true" goto yadif
echo ConvertToYV12^(%AVS_SCALE%interlaced=true^)>> %VIDEO_AVS%
echo;>> %VIDEO_AVS%
:yadif
if "%SCAN_TYPE%"=="MBAFF" (
    echo Yadif^(order=1^)>> %VIDEO_AVS%
    goto fps_avs
)
if "%SCAN_ORDER%"=="Top" (
    echo Yadif^(order=1^)>> %VIDEO_AVS%
    goto fps_avs
)
if "%SCAN_ORDER%"=="Bottom" (
    echo Yadif^(order=0^)>> %VIDEO_AVS%
    goto fps_avs
)
echo Yadif^(order=-1^)>> %VIDEO_AVS%

:fps_avs
(
    echo;
    if "%CHANGE_FPS%"=="true" echo ChangeFPS^(%FPS%^)
    echo;

    if not "%IN_WIDTH%"=="%WIDTH%" echo BlackmanResize^(%WIDTH%,last.height^(^)^)
    if not "%IN_HEIGHT%"=="%HEIGHT%" echo BlackmanResize^(last.width^(^),%HEIGHT%^)
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

:mux_audio_start
echo ^>^>%AUDIO_ENC_ANNOUNCE%
echo;

(
    echo WAVSource^(%INPUT_AUDIO%^)
    echo;
    echo return last
)> %AUDIO_AVS%

echo ^>^>%WAV_ANNOUNCE%
if exist %PROCESS_E_FILE% del %PROCESS_E_FILE%
echo s>%PROCESS_S_FILE%
start /b process.bat 2>nul
.\avs2pipe_gcc.exe audio %AUDIO_AVS% > %TEMP_WAV% 2>nul
del %PROCESS_S_FILE% 2>nul
:wav_process
ping localhost -n 1 >nul
if not exist %PROCESS_E_FILE% goto wav_process 1>nul 2>&1
del %PROCESS_E_FILE%

call m4a_enc.bat
