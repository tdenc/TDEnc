rem ################変数設定################
set INFO_AVS=%TEMP_DIR%\information.avs
set X264_TC_FILE=%TEMP_DIR%\x264.tc


rem ################動画情報取得################
echo ^>^>%ANALYZE_ANNOUNCE%
echo;
date /t>nul
echo %INPUT_FILE_TYPE% | findstr /i "jpg jpeg png bmp">nul
if "%ERRORLEVEL%"=="1" goto movie_mux_mode

rem 画像と音声のMUX
.\MediaInfo.exe --Inform=Audio;%%PlayTime%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=." %%i in (%TEMP_INFO%) do set TOTAL_TIME=%%i
if not defined TOTAL_TIME (
    echo ^>^>%ANALYZE_ERROR%
    echo;
    call error.bat
)
echo PlayTime     : %TOTAL_TIME%ms

set FPS=10

(
    echo ImageSource^(%INPUT_VIDEO%,end=1,fps=%FPS%^)
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _premium_bitrate_new = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM_NEW%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_partner_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_PARTNER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo WriteFileStart^("premium_bitrate_new.txt","_premium_bitrate_new",append = false^)
    echo WriteFileStart^("youtube_partner_bitrate.txt","_youtube_partner_bitrate",append = false^)
    echo WriteFileStart^("youtube_normal_bitrate.txt","_youtube_normal_bitrate",append = false^)
    echo;
    echo return last
)> %INFO_AVS%

.\avs2pipe_gcc.exe info %INFO_AVS% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate_new.txt) do set /a P_TEMP_BITRATE_NEW=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_partner_bitrate.txt) do set /a Y_P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_normal_bitrate.txt) do set /a Y_I_TEMP_BITRATE=%%i>nul

set /a TOTAL_TIME_SECOND=%TOTAL_TIME%/100

.\MediaInfo.exe --Inform=Image;%%Width%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_WIDTH=%%i
echo Width        : %IN_WIDTH%pixels
.\MediaInfo.exe --Inform=Image;%%Height%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_HEIGHT=%%i
echo Height       : %IN_HEIGHT%pixels


rem 出力解像度の設定
set /a IN_WIDTH_ODD=%IN_WIDTH% %% 2
set /a IN_HEIGHT_ODD=%IN_HEIGHT% %% 2
set /a OUT_HEIGHT=%DEFAULT_HEIGHT% + %DEFAULT_HEIGHT% %% 2
if defined DEFAULT_WIDTH (
    set /a OUT_WIDTH=%DEFAULT_WIDTH%
    goto image_info_end
)
set /a OUT_WIDTH_TEMP=%DEFAULT_HEIGHT% * %IN_WIDTH% / %IN_HEIGHT%
set /a OUT_WIDTH=%OUT_WIDTH_TEMP% + %OUT_WIDTH_TEMP% %% 2
rem ニコニコ新仕様用
set /a OUT_HEIGHT_NICO_NEW=%DEFAULT_HEIGHT_NEW% + %DEFAULT_HEIGHT_NEW% %% 2
set /a OUT_WIDTH_TEMP=%DEFAULT_HEIGHT_NEW% * %IN_WIDTH_MOD% / %IN_HEIGHT%
set /a OUT_WIDTH_NICO_NEW=%OUT_WIDTH_TEMP% + %OUT_WIDTH_TEMP% %% 2

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
if not defined RESIZER set RESIZER=Spline16Resize
(
    echo ImageSource^(%INPUT_VIDEO%,end=%TOTAL_TIME_SECOND%,fps=%FPS%^)
    if "%IN_WIDTH_ODD%"=="1" (
        if "%IN_HEIGHT_ODD%"=="1" (
            echo Crop^(0,0,-1,-1^)
    ) else (
            echo Crop^(0,0,-1,0^)
    )
    ) else if "%IN_HEIGHT_ODD%"=="1" echo Crop^(0,0,0,-1^)
    if "%SETTING2%"=="noresize" (
        echo # no resize
    ) else (
        echo %RESIZER%^(%WIDTH%,%HEIGHT%^)
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

if "%FULL_RANGE%"=="off" (
    set RANGE=tv
) else if "%FULL_RANGE%"=="on" (
    set RANGE=pc
) else (
    set RANGE=auto
)

.\x264.exe --range %RANGE% -I 100 -i 100 --no-scenecut -b 0 -r 1 -f -1:-1 -B %V_BITRATE% --ipratio 1.0 --aq-mode 2 --aq-strength 0.70 -p 1 --stats %TEMP_DIR%\x264_2pass.log --qcomp 0.8 --direct auto --weightp 0 --me dia -m 1 -t 1 --no-fast-pskip --no-dct-decimate --threads 0 --thread-input --colormatrix smpte170m --quiet -o "nul" %VIDEO_AVS%
echo;

rem ２pass処理
echo ^>^>２pass目～♪
echo;
.\x264.exe --range %RANGE% -I 100 -i 100 --no-scenecut -b 0 -r 1 -f -1:-1 -B %V_BITRATE% --ipratio 1.0 --aq-mode 2 --aq-strength 0.70 -p 2 --stats %TEMP_DIR%\x264_2pass.log --qcomp 0.8 --direct auto --weightp 0 --me dia -m 1 -t 1 --no-fast-pskip --no-dct-decimate --threads 0 --thread-input --colormatrix smpte170m --quiet -o %TEMP_264% %VIDEO_AVS%
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
.\MediaInfo.exe --Inform=General;%%Format/String%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo File Format    : %%i
.\MediaInfo.exe --Inform=Video;%%Codec%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Video Codec    : %%i
.\MediaInfo.exe --Inform=Video;%%BitRate%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a S_V_BITRATE=%%i/1000
echo Video Bitrate  : %S_V_BITRATE%
.\MediaInfo.exe --Inform=Audio;%%Codec%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Audio Codec    : %%i
.\MediaInfo.exe --Inform=Audio;%%Channels%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_CHANNELS=%%i
if not defined AUDIO_CHANNELS set AUDIO_CHANNELS=0
echo Audio Channels : %AUDIO_CHANNELS%
.\MediaInfo.exe --Inform=Audio;%%BitRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set ABITRATE_MODE=%%i
if defined ABITRATE_MODE echo AudioBR Mode : %ABITRATE_MODE%

rem 動画の容量書き出し
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a INPUT_FILE_SIZE=%%i
echo FileSize     : %INPUT_FILE_SIZE%byte

rem 再生時間の書き出し
.\MediaInfo.exe --Inform=General;%%PlayTime%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul

rem 再生時間・上限ビットレートの設定
for /f "delims=." %%i in (%TEMP_INFO%) do set TOTAL_TIME=%%i
echo PlayTime     : %TOTAL_TIME%ms

rem CFR（固定フレームレート）とVFR（可変フレームレート）の判断
.\MediaInfo.exe --Inform=Video;%%FrameRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set FPS_MODE=%%i
if "%FPS_MODE%"=="VFR" goto vfr_info

rem CFRの設定
set VFR=false
.\MediaInfo.exe --Inform=Video;%%FrameRate%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FPS=%%i
if defined INPUT_FPS echo FPS          : %INPUT_FPS%fps^(CFR^)
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
if not defined DEFAULT_FPS (
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
if defined SCAN_TYPE echo Scan type    : %SCAN_TYPE%
.\MediaInfo.exe --Inform=Video;%%ScanOrder%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f  %%i in (%TEMP_INFO%) do set SCAN_ORDER=%%i
if defined SCAN_ORDER echo Scan order   : %SCAN_ORDER%

rem IDRフレーム間の最大間隔・容量上限の設定
if /i "%DECODER%"=="avi" goto avisource_info
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_info
if /i "%DECODER%"=="directshow" goto directshowsource_info
if /i "%DECODER%"=="qt" goto qtsource_info

:directshowsource_info
(
    echo DirectShowSource^(%INPUT_VIDEO%, audio = false^)
)> %INFO_AVS%
goto infoavs

:qtsource_info
(
    echo LoadPlugin^("QTSource.dll"^)
    echo;
    echo QTInput^(%INPUT_VIDEO%, quality = 100, audio = 0^)
)> %INFO_AVS%
goto infoavs

:avisource_info
echo AVISource^(%INPUT_VIDEO%, audio = false^)> %INFO_AVS%
goto infoavs

:ffmpegsource_info
if "%VFR%"=="true" (
    echo;
    echo exporting timecode... it may takes a few minutes...
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
    echo FFVideoSource^(%INPUT_VIDEO%,cache=false,threads=1^)
)> %INFO_AVS%

:infoavs
(
    echo;
    echo _isyv12 = IsYV12^(^)
    echo _isrgb = IsRGB^(^)
    echo _fps = Framerate^(^)
    if defined FPS (
        echo _keyint = String^(Round^(%FPS%^)^)
    ) else (
        echo _keyint = String^(Round^(_fps^)^)
    )
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _premium_bitrate_new = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM_NEW%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_partner_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_PARTNER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _in_width = String^(Floor^(Float^(%IN_WIDTH%^) * %P_ASPECT%^)^)
    echo;
    echo WriteFileStart^("yv12.txt","_isyv12",append = false^)
    echo WriteFileStart^("rgb.txt","_isrgb",append = false^)
    echo WriteFileStart^("fps.txt","_fps",append = false^)
    echo WriteFileStart^("keyint.txt","_keyint",append = false^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo WriteFileStart^("premium_bitrate_new.txt","_premium_bitrate_new",append = false^)
    echo WriteFileStart^("in_width.txt","_in_width",append = false^)
    echo WriteFileStart^("youtube_partner_bitrate.txt","_youtube_partner_bitrate",append = false^)
    echo WriteFileStart^("youtube_normal_bitrate.txt","_youtube_normal_bitrate",append = false^)
    echo;
    echo Trim^(0,-1^)
    echo;
    echo return last
)>> %INFO_AVS%

.\avs2pipe_gcc.exe info %INFO_AVS% 1>nul 2>&1

if exist %TEMP_DIR%\yv12.txt (
    for /f "delims=" %%i in (%TEMP_DIR%\yv12.txt) do set YV12=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\rgb.txt) do set RGB=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\keyint.txt) do set /a KEYINT=%%i*10>nul
    for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate_new.txt) do set /a P_TEMP_BITRATE_NEW=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\youtube_partner_bitrate.txt) do set /a Y_P_TEMP_BITRATE=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\youtube_normal_bitrate.txt) do set /a Y_I_TEMP_BITRATE=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\in_width.txt) do set IN_WIDTH_MOD=%%i>nul

    for /f "delims=" %%i in (%TEMP_DIR%\fps.txt) do set AVS_FPS=%%i>nul 2>&1
) else (
    goto info_check
)
if not defined FPS set FPS=%AVS_FPS%

rem 出力解像度の設定
set /a IN_WIDTH_ODD=%IN_WIDTH% %% 2
set /a IN_HEIGHT_ODD=%IN_HEIGHT% %% 2
set /a OUT_HEIGHT=%DEFAULT_HEIGHT% + %DEFAULT_HEIGHT% %% 2
if defined DEFAULT_WIDTH (
    set /a OUT_WIDTH=%DEFAULT_WIDTH%
    goto info_check
)
set /a OUT_WIDTH_TEMP=%DEFAULT_HEIGHT% * %IN_WIDTH_MOD% / %IN_HEIGHT%
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
)
if not defined KEYINT (
    echo;
    if /i "%DECODER%"=="avi" (
        set DECODER=ffmpeg
        goto ffmpegsource_info
    ) else if /i "%DECODER%"=="ffmpeg" (
        set DECODER=directshow
        goto directshowsource_info
    ) else (
        echo ^>^>%DECODE_ERROR3%
        call error.bat
    )
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
if /i "%PRETYPE%"=="s" (
    set TEMP_264=%INPUT_VIDEO%
    goto mux_audio_start
)

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
if /i "%DECODER%"=="qt" goto qtsource_video

:directshowsource_video
(
    if "%VFR%"=="true" (
        echo DirectShowSource^(%INPUT_VIDEO%, audio = false, fps=%INPUT_FPS%, convertfps=true^)
    ) else (
        echo DirectShowSource^(%INPUT_VIDEO%, audio = false, fps=%INPUT_FPS%, convertfps=false^)
    )
)> %VIDEO_AVS%
goto vbr_avs

:qtsource_video
(
    echo LoadPlugin^("QTSource.dll"^)
    echo;
    echo QTInput^(%INPUT_VIDEO%, quality = 100, audio = 0^)
)> %VIDEO_AVS%
goto vbr_avs

:avisource_video
if "%RGB%"=="true" (
    echo AVISource^(%INPUT_VIDEO%, audio = false^)> %VIDEO_AVS%
) else (
    echo AVISource^(%INPUT_VIDEO%, audio = false, pixel_type="YUY2"^)> %VIDEO_AVS%
)
goto vbr_avs

:ffmpegsource_video
date /t>nul
echo %INPUT_FILE_TYPE% | findstr /i "avi mkv mp4 flv">nul
if "%ERRORLEVEL%"=="0" (
    set SEEKMODE=1
) else (
    set SEEKMODE=-1
)
ffmsindex.exe -f %INPUT_VIDEO% %TEMP_DIR%\input.ffindex
echo;
(
    echo LoadPlugin^("ffms2.dll"^)
    echo;
    echo fps_num = Int^(%FPS% * 1000^)
    if "%VFR%"=="true" (
        echo FFVideoSource^(%INPUT_VIDEO%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1^)
    ) else (
        echo FFVideoSource^(%INPUT_VIDEO%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1,fpsnum=fps_num,fpsden=1000^)
    )
)> %VIDEO_AVS%

:vbr_avs
echo;>> %VIDEO_AVS%
if "%ABITRATE_MODE%"=="VBR" (
    if not "%A_SYNC%"=="n" (
        echo EnsureVBRMP3Sync^(^)>> %VIDEO_AVS%
    )
)
echo;>> %VIDEO_AVS%
if /i "%DEINT%"=="a" (
    if "%SCAN_TYPE%"=="Interlaced" goto yadif
    if "%SCAN_TYPE%"=="MBAFF" goto yadif
) else if /i "%DEINT%"=="y" goto yadif

rem プログレッシブ
if "%IN_WIDTH_ODD%"=="1" (
    if "%IN_HEIGHT_ODD%"=="1" (
        echo Crop^(0,0,-1,-1^)>> %VIDEO_AVS%
    ) else (
        echo Crop^(0,0,-1,0^)>> %VIDEO_AVS%
    )
) else if "%IN_HEIGHT_ODD%"=="1" echo Crop^(0,0,0,-1^)>> %VIDEO_AVS%

echo ConvertToYV12^(%AVS_SCALE%interlaced=false^)>> %VIDEO_AVS%
echo;>> %VIDEO_AVS%
goto fps_avs

rem インターレース
:yadif
echo Load_Stdcall_Plugin^("yadif.dll"^)>> %VIDEO_AVS%
echo ConvertToYV12^(%AVS_SCALE%interlaced=true^)>> %VIDEO_AVS%
echo;>> %VIDEO_AVS%
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
if not defined RESIZER set RESIZER=Spline16Resize
(
    echo;
    if "%CHANGE_FPS%"=="true" echo ChangeFPS^(%FPS%^)
    echo;

    if not "%IN_WIDTH%"=="%WIDTH%" echo %RESIZER%^(%WIDTH%,last.height^(^)^)
    if not "%IN_HEIGHT%"=="%HEIGHT%" echo %RESIZER%^(last.width^(^),%HEIGHT%^)
)>> %VIDEO_AVS%

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
