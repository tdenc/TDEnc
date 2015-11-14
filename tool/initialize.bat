@echo off
title %INIT_TITLE%

echo %HORIZON%
echo Å@%TDENC_NAME%  %INIT_ANNOUNCE%
echo %HORIZON%
echo;


start /wait call tool_downloader.bat
if not "%DL_STATUS%"=="fail" start /wait call tool_installer.bat

exit