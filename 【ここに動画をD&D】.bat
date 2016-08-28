@echo off
cd /d "%~d0" 1>nul 2>&1
cd "%~p0tool\" 1>nul 2>&1
call ..\setting\default_message.bat
call ..\setting\user_message.bat
title %TDENC_TITLE%


rem ################ユーザー設定読み込み################
call version.bat
date /t>nul
.\curl.exe --connect-timeout 5 -f -o tool_url.bat -L "https://raw.githubusercontent.com/tdenc/TDEnc/master/tool/tool_url.bat" 2>nul
if "%ERRORLEVEL%"=="22" (
    set URL_PATH=".\tool_url_bk.bat"
) else (
    set URL_PATH=".\tool_url.bat"
    copy /y tool_url.bat tool_url_bk.bat 1>nul 2>&1
)
call %URL_PATH%

call ..\setting\default_setting.bat
call ..\setting\user_setting.bat

if not "%THIS_VERSION%"=="%PRESET_VERSION%" (
    echo ^>^>%PRESET_ALERT%
    echo;
    call error.bat
)

rem ################フォルダ作成################
rem 一時ファイルを保存するフォルダを変更したいときはTEMP_DIRの設定を弄ってください
rem ただ、エンコ後に一時ファイルを全て削除するので誤作動が怖い場合は弄らないでください
set TEMP_DIR=TEMP\%RANDOM%
mkdir %TEMP_DIR%
if not exist %MP4_DIR% mkdir %MP4_DIR%


rem ################変数設定################
set TEMP_INFO=%TEMP_DIR%\temp.txt
set PROCESS_S_FILE=%TEMP_DIR%\proccess.txt
set PROCESS_E_FILE=%TEMP_DIR%\end.txt
set VIDEO_AVS=%TEMP_DIR%\video.avs
set AUDIO_AVS=%TEMP_DIR%\audio.avs
set TEMP_264=%TEMP_DIR%\video.264
set TEMP_WAV=%TEMP_DIR%\audio.wav
set TEMP_M4A=%TEMP_DIR%\audio.m4a
set FINAL_WAV=%TEMP_DIR%\audio_repair.wav
set TEMP_MP4=%TEMP_DIR%\movie.mp4


rem ################バージョン＆プリセット表示################
echo %HORIZON_B%
echo 　　　　　　　　　　　　%TDENC_NAME%  version %C_VERSION%
echo 　　　　　　　　　　　　　preset : version %THIS_VERSION%
echo %HORIZON_B%
echo;


rem ################バージョンチェック################
if /i "%DEFAULT_VERSION_CHECK%"=="true" (
    call version_check.bat
)
if /i "%VERSION_UP%"=="y" goto :eof

rem user_setting.batの更新
if "%USER_VERSION%"=="%THIS_VERSION%" goto user_setting_update_end
:user_setting_update
echo;
echo ^>^>%USER_SETTING1%
echo ^>^>%USER_SETTING2%
set /p USER_UPDATE=^>^>
if /i "%USER_UPDATE%"=="y" (
    copy ..\setting\user_setting_new.bat ..\setting\user_setting.bat
    call ..\setting\user_setting.bat
) else if /i "%USER_UPDATE%"=="n" (
    echo ^>^>%PRESET_ALERT2%
    echo ^>^>%PAUSE_MESSAGE1%
    pause>nul
) else (
    echo ^>^>%RETURN_MESSAGE1%
    goto user_setting_update
)
echo;
:user_setting_update_end


rem ################ツール類の設定################
call :file_exist_check


rem ################Avisynthチェック################
call :avisynth_check


rem ################エンコードモード分岐################
if "%~1"=="" (
    echo;
    echo ^>^>%DOUBLECLICK_ALERT1%
    echo ^>^>%DOUBLECLICK_ALERT2%
    echo;
    call error.bat
)

set ALL_ARGUMENTS=%*
set ALL_ARGUMENTS_CMD=%ALL_ARGUMENTS:"=%
echo %ALL_ARGUMENTS_CMD%> %TEMP_INFO%
for /f "delims=" %%i in (%TEMP_INFO%) do set ALL_ARGUMENTS_TXT=%%i
if not "%ALL_ARGUMENTS_CMD%"=="%ALL_ARGUMENTS_TXT%" (
    echo ^<List1^>
    echo   "%ALL_ARGUMENTS_CMD%"
    echo ^<List2^>
    echo   "%ALL_ARGUMENTS_TXT%"
    echo;
    echo ^>^>%FILENAME_ERROR1%
    echo ^>^>%FILENAME_ERROR2%
    echo;
    call error.bat
)

if not "%~3"=="" goto sequence_mode
if not "%~2"=="" goto mux_mode


rem 1ファイルのエンコード
date /t>nul
dir "%~1" | findstr \^<\.$>nul
if "%ERRORLEVEL%"=="0" (
    echo ^>^>%UNITE_AVI_ANNOUNCE1%
    echo ^>^>%UNITE_AVI_ANNOUNCE2%
    echo;
    call :cat_avi "%~1"
    call cat.bat
    call :temp_264_check
    call create_mp4.bat
    call shut.bat
)

echo ^>^>%ONE_MOVIE_ANNOUNCE%
echo;
set INPUT_FILE_TYPE=%~x1
set FINAL_MP4=%~n1.mp4
if /i "%DECODER%"=="auto" call :codec_check "%~1"
date /t>nul
echo %DECODER% | findstr /i "avi directshow qt ffmpeg">nul
if "%ERRORLEVEL%"=="0" (
    set INPUT_FILE_PATH="%~1"
    call :normal_main
    call shut.bat
)
echo %INPUT_FILE_TYPE% | findstr /i "mkv mp4 m4v mov flv wmv asf ogm ogv vob m2v mpeg mpg m2ts mts ts dv">nul
if "%ERRORLEVEL%"=="0" (
    set DECODER=ffmpeg
    set INPUT_FILE_PATH="%~1"
    call :normal_main
    call shut.bat
)
set INPUT_FILE_PATH="%~1"
if /i "%INPUT_FILE_TYPE%"==".avi" (
    set DECODER=avi
) else (
    set DECODER=directshow
)
call :normal_main
call shut.bat


rem 複数ファイルの連続エンコード
:sequence_mode
echo;
echo ^>^>%SEQUENCE_ANNOUNCE%
:sequence_start
if "%~1"=="" goto sequence_end

echo ^>^>"%~1" %PROCESS_ANNOUNCE%
echo;

set INPUT_FILE_TYPE=%~x1
set FINAL_MP4=%~n1.mp4
if /i "%DECODER%"=="auto" call :codec_check "%~1"
date /t>nul
echo %DECODER% | findstr /i "avi directshow qt ffmpeg">nul
if "%ERRORLEVEL%"=="0" (
    set INPUT_FILE_PATH="%~1"
    goto ext_check
)
echo %INPUT_FILE_TYPE% | findstr /i "mkv mp4 m4v mov flv wmv asf ogm ogv vob m2v mpeg mpg m2ts mts ts dv">nul
if "%ERRORLEVEL%"=="0" (
    set DECODER=ffmpeg
    set INPUT_FILE_PATH="%~1"
    goto ext_check
)

set INPUT_FILE_PATH="%~1"
if /i "%INPUT_FILE_TYPE%"==".avi" (
    set DECODER=avi
) else (
    set DECODER=directshow
)

:ext_check
if "%INPUT_FILE_TYPE%"=="" (
    echo ^>^>%MOVIE_INFO_ERROR1%
    echo ^>^>%MOVIE_INFO_ERROR2%
    echo;
    echo %MOVIE_INFO_ERROR3%
    echo %MOVIE_INFO_ERROR4%
    echo;
    call error.bat
)

call :normal_main

echo;
shift

if exist %TEMP_DIR% rmdir /s /q %TEMP_DIR%
mkdir %TEMP_DIR%

goto sequence_start

:sequence_end
echo;
echo ^>^>%SEQUENCE_END1%
echo ^>^>%SEQUENCE_END2%
echo ^>^>%SEQUENCE_END3%
echo;
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
call shut.bat


rem 音声とのMUXエンコード
:mux_mode
date /t>nul
echo %~x2 | findstr /i "wav">nul
if "%ERRORLEVEL%"=="0" (
    set INPUT_AUDIO="%~2"
    set INPUT_VIDEO="%~1"
    set INPUT_FILE_TYPE=%~x1
    set FINAL_MP4=%~n1.mp4
    goto mux_mode_main
)
echo %~x1 | findstr /i "wav">nul
if "%ERRORLEVEL%"=="0" (
    set INPUT_AUDIO="%~1"
    set INPUT_VIDEO="%~2"
    set INPUT_FILE_TYPE=%~x2
    set FINAL_MP4=%~n2.mp4
    goto mux_mode_main
)

goto sequence_mode

:mux_mode_main
echo;
echo ^>^>%MUX_ANNOUNCE%
call :mux_filetype_check
call mux.bat
call :temp_264_check
call create_mp4.bat
call shut.bat


rem ################関数っぽいもの################
:file_exist_check
if not exist DirectShowSource.dll start /wait call initialize.bat
if not exist DevIL.dll start /wait call initialize.bat
if not exist ffms2.dll start /wait call initialize.bat
if not exist ffmsindex.exe start /wait call initialize.bat
if not exist QTSource.dll start /wait call initialize.bat
if not exist MediaInfo.exe start /wait call initialize.bat
if not exist MediaInfo.dll start /wait call initialize.bat
if not exist yadif.dll start /wait call initialize.bat
if not exist avs2pipe_gcc.exe start /wait call initialize.bat
if not exist silence.exe start /wait call initialize.bat
if not exist neroAacEnc.exe start /wait call initialize.bat
if not exist x264.exe start /wait call initialize.bat
.\x264.exe --version>"%TEMP_DIR%\x264_version.txt" 2>nul
date /t>nul
findstr /i "%X264_VERSION%" "%TEMP_DIR%\x264_version.txt">nul 2>&1
if "%ERRORLEVEL%"=="1" start /wait call initialize.bat
exit /b

:codec_check
.\MediaInfo.exe --Inform=Video;%%Codec%% --LogFile=%TEMP_INFO% %1>nul
date /t>nul
findstr /i "dv mpeg" "%TEMP_INFO%">nul 2>&1
if "%ERRORLEVEL%"=="0" (
    set DECODER=ffmpeg
    exit /b
)
.\MediaInfo.exe --Inform=Video;%%Codec/CC%% --LogFile=%TEMP_INFO% %1>nul
findstr /i "cvid msvc cram" "%TEMP_INFO%">nul 2>&1
if "%ERRORLEVEL%"=="0" (
    set DECODER=ffmpeg
    exit /b
)
.\MediaInfo.exe --Inform=Video;%%CodecID%% --LogFile=%TEMP_INFO% %1>nul
findstr /i "xtor" "%TEMP_INFO%">nul 2>&1
if "%ERRORLEVEL%"=="0" (
    set DECODER=directshow
    exit /b
)
exit /b

:cat_avi
set CAT_DIR=%~1
set CAT_AVI_LIST=%TEMP_DIR%\cat_avi.txt
set CAT_WAV=%TEMP_DIR%\cat_wav.txt
set INPUT_FILE_PATH="%CAT_DIR%\%~n1.avs"
set INPUT_FILE_TYPE=.avs
set FINAL_MP4=%~n1.mp4

dir /b /on "%CAT_DIR%" | findstr /i .avi$> %CAT_AVI_LIST%
dir /b "%CAT_DIR%" | findstr /i .wav$> %CAT_WAV%
for /f "delims=" %%i in (%CAT_WAV%) do set CAT_WAV_PATH=%%i
(
    if not "%CAT_WAV_PATH%"=="" (
        echo AudioDub^(AVISource^(^\
    ) else (
        echo AVISource^(^\
    )
    for /f "delims=" %%i in (%CAT_AVI_LIST%) do echo "%%i", ^\
    if not "%CAT_WAV_PATH%"=="" (
        echo audio = false^),WAVSource^("%CAT_WAV_PATH%"^)^)
    ) else (
        echo audio = true^)
    )
    echo;
    echo return last )> %INPUT_FILE_PATH%
exit /b

:normal_main
if /i "%INPUT_FILE_TYPE%"==".avs" (
    call avs.bat
    call :temp_264_check
    call create_mp4.bat
    exit /b
)
if /i "%INPUT_FILE_TYPE%"==".nvv" (
    echo ^>^>%NVV_ALERT%
    call error.bat
)
if /i "%INPUT_FILE_TYPE%"==".swf" (
    echo ^>^>%SWF_ALERT%
    call error.bat
)
call movie.bat
call :temp_264_check
call create_mp4.bat
exit /b

:mux_filetype_check
if /i "%DECODER%"=="auto" call :codec_check %INPUT_VIDEO%
if /i "%INPUT_FILE_TYPE%"==".nvv" (
    echo ^>^>%MUX_ALERT1%
    echo ^>^>%MUX_ALERT2%
    echo;
    call error.bat
)
if /i not "%DECODER%"=="auto" exit /b
date /t>nul
echo %INPUT_FILE_TYPE% | findstr /i "mkv wmv asf flv mp4 mov dv ts mts m2ts">nul
if "%ERRORLEVEL%"=="0" (
    set DECODER=ffmpeg
    exit /b
)
if /i "%INPUT_FILE_TYPE%"==".avi" (
    set DECODER=avi
) else (
    set DECODER=directshow
)
exit /b

:temp_264_check
if not exist %TEMP_264% (
    echo ^>^>%VIDEO_ENC_ERROR%
    echo;
    echo ^>^>%PAUSE_MESSAGE1%
    pause>nul
    goto :eof
)
exit /b

:avisynth_check
if exist %WINDIR%\system32\avisynth.dll (
    for %%i in (%WINDIR%\SysWow64\avisynth.dll) do if %%~zi EQU 401920 exit /b
)
if exist %WINDIR%\sysWow64\avisynth.dll (
    for %%i in (%WINDIR%\SysWow64\avisynth.dll) do if %%~zi EQU 401920 exit /b
)
echo ^>^>%AVS_MESSAGE1%
echo ^>^>%AVS_MESSAGE2%
echo ^>^>%AVS_MESSAGE3%
echo;
echo ^>^>%PAUSE_MESSAGE1%
pause>nul
..\Archives\avisynth_260.exe
exit /b

rem ################つんでれんこ終了..._φ(ﾟ∀ﾟ )ｱﾋｬ################
