title %SHUT_TITLE%

if /i "%SHUTDOWN%"=="y" goto shut

:open_mp4
echo;
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
call :delete_dir
start %MP4_DIR%
if "%MOVIE_CHECK%"=="y" call "..\MP4\ここにD&Dして動画をチェック.bat" "%MP4_DIR%\%FINAL_MP4%"
exit

:shut
call :delete_dir
echo;
echo ^>^>%SHUT_ALERT%
echo ^>^>%SHUT_CANCEL%
echo;
shutdown /s /f /t 120
pause>nul
shutdown /a
echo ^>^>%CANCEL_MESSAGE%
echo;
pause>nul
goto open_mp4

rem 一時ディレクトリの削除
:delete_dir
if exist %TEMP_DIR% rmdir /s /q %TEMP_DIR%
exit /b
