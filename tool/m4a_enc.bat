if not exist %TEMP_WAV% goto wav_not_exist

rem 音声エンコード
if /i "%AAC_PROFILE%"=="auto" (
    goto auto_profile
) else if /i "%AAC_PROFILE%"=="lc" (
    set AAC=-lc
) else if /i "%AAC_PROFILE%"=="he" (
    set AAC=-he
)　else if /i "%AAC_PROFILE%"=="hev2" (
    set AAC=-hev2
)

:auto_profile
if %A_BITRATE% LEQ 32 (
    set AAC=-hev2
) else if %A_BITRATE% LEQ 96 (
    set AAC=-he
) else (
    set AAC=-lc
)

if /i "%A_SYNC%"=="n" (
    move %TEMP_WAV% %FINAL_WAV% 1>nul 2>&1
    goto m4a_encode
)
if /i "%A_SYNC%"=="y" goto auto_sync

set M4A_LAG=%A_SYNC%
goto wav_avs

:auto_sync
if /i "%AAC_ENCODER%"=="qt" (
    move %TEMP_WAV% %FINAL_WAV% 1>nul 2>&1
    goto m4a_encode
)

rem 音ズレ修正
:sync_gap
echo ^>^>%SYNC_ANNOUNCE%
.\neroAacEnc.exe %AAC% -br %A_BITRATE%000 -if %TEMP_WAV% -of %TEMP_M4A%
.\MediaInfo.exe --Inform=General;%%PlayTime%% --LogFile=%TEMP_INFO% %TEMP_M4A%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set M4A_TIME=%%i
.\MediaInfo.exe --Inform=General;%%PlayTime%% --LogFile=%TEMP_INFO% %TEMP_WAV%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set WAV_TIME=%%i
set /a M4A_LAG_TEMP=%M4A_TIME%-%WAV_TIME%
set /a M4A_LAG=-%M4A_LAG_TEMP%/2

:wav_avs
(
    echo WAVSource^("%TEMP_WAV%"^)
    echo;
    echo _lag = Float^(%M4A_LAG%^) / 1000
    echo DelayAudio^(_lag^)
    echo;
    echo return last
)> %AUDIO_AVS%

echo ^>^>^(%M4A_LAG%ms^)
echo;

.\wavi.exe %AUDIO_AVS% %FINAL_WAV%

rem m4aにエンコード
:m4a_encode
if not exist %FINAL_WAV% goto wav_not_exist
echo;
echo ^>^>%WAV_END%
echo;
echo ^>^>%M4A_ENC_ANNOUNCE%
echo;
if /i "%AAC_ENCODER%"=="nero" (
    .\neroAacEnc.exe %AAC% -2pass -br %A_BITRATE%000 -if %FINAL_WAV% -of %TEMP_M4A%
) else if "%AAC%"=="-lc" (
    .\qtaacenc.exe --highest --cvbr %A_BITRATE% %FINAL_WAV% %TEMP_M4A%
) else (
    .\qtaacenc.exe --he --highest --cvbr %A_BITRATE% %FINAL_WAV% %TEMP_M4A%
)

:wav_not_exist
echo;
if not exist %TEMP_M4A% (
    echo ^>^>%WAV_ERROR%
    echo;
    .\silence.exe %FINAL_WAV% -l 0.1 -c 2 -s 44100 -b 16
    .\neroAacEnc.exe -lc -br 0 -if %FINAL_WAV% -of %TEMP_M4A%
)
echo ^>^>%M4A_SUCCESS%
echo;
