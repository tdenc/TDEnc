if not exist %TEMP_WAV% goto wav_not_exist

(
    echo WAVSource^("%TEMP_WAV%"^)
    echo;
    if not "%SAMPLERATE%"=="0" (
        echo ResampleAudio^(%SAMPLERATE%^)
        echo;
    )
    echo return last
)> %AUDIO_AVS%

rem 音声エンコード
if /i "%AAC_PROFILE%"=="auto" (
    if %A_BITRATE% LEQ 32 (
        if "%AUDIO_CHANNELS%"=="2" (
            set AAC=-hev2
        ) else (
            set AAC=-he
        )
    ) else if %A_BITRATE% LEQ 96 (
        set AAC=-he
    ) else (
        set AAC=-lc
    )
) else if /i "%AAC_PROFILE%"=="he" (
    set AAC=-he
) else if /i "%AAC_PROFILE%"=="hev2" (
    if "%AUDIO_CHANNELS%"=="2" (
        set AAC=-hev2
    ) else (
        set AAC=-he
    )
) else (
    set AAC=-lc
)

if /i "%A_SYNC%"=="n" (
    .\avs2pipe_gcc.exe audio %AUDIO_AVS% > %FINAL_WAV%
    goto m4a_encode
)
if /i "%A_SYNC%"=="y" goto auto_sync

set M4A_LAG=%A_SYNC%
goto wav_avs

:auto_sync
if /i "%AAC_ENCODER%"=="qt" (
    .\avs2pipe_gcc.exe audio %AUDIO_AVS% > %FINAL_WAV%
    goto m4a_encode
)

rem 音ズレ修正
:sync_gap
echo ^>^>%SYNC_ANNOUNCE%
if exist %PROCESS_E_FILE% del %PROCESS_E_FILE%
echo s>%PROCESS_S_FILE%
start /b process.bat 2>nul
.\avs2pipe_gcc.exe audio %AUDIO_AVS% 2>nul | .\neroAacEnc.exe %AAC% -ignorelength -br %A_BITRATE%000 -if - -of %TEMP_M4A% 1>nul 2>&1
.\MediaInfo.exe --Inform=General;%%PlayTime%% --LogFile=%TEMP_INFO% %TEMP_M4A%>nul
for /f "delims=." %%i in (%TEMP_INFO%) do set M4A_TIME=%%i
.\MediaInfo.exe --Inform=General;%%PlayTime%% --LogFile=%TEMP_INFO% %TEMP_WAV%>nul
for /f "delims=." %%i in (%TEMP_INFO%) do set WAV_TIME=%%i
set /a M4A_LAG_TEMP=%M4A_TIME%-%WAV_TIME%
set /a M4A_LAG=-%M4A_LAG_TEMP%/2
del %PROCESS_S_FILE% 2>nul
:sync_process
ping localhost -n 1 >nul
if not exist %PROCESS_E_FILE% goto sync_process 1>nul 2>&1
del %PROCESS_E_FILE%

:wav_avs
(
    echo WAVSource^("%TEMP_WAV%"^)
    echo;
    if not "%SAMPLERATE%"=="0" (
        echo ResampleAudio^(%SAMPLERATE%^)
        echo;
    )
    echo _lag = Float^(%M4A_LAG%^) / 1000
    echo DelayAudio^(_lag^)
    echo;
    echo return last
)> %AUDIO_AVS%

echo ^>^>^(fixed : %M4A_LAG%ms^)
echo;

.\avs2pipe_gcc.exe audio %AUDIO_AVS% > %FINAL_WAV%

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
