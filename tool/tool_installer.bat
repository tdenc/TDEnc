@echo off
title %INSTALLER_TITLE%

echo %HORIZON%
echo @%TDENC_NAME%  installer
echo %HORIZON%
echo;

call version.bat
call tool_url.bat

echo ^>^>%INSTALLER_ANNOUNCE%
echo;
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
echo;


.\7z.exe e -bd -y %DSS_PATH% "DirectShowSource.dll"
.\7z.exe e -bd -y %DIL_PATH% "DevIL.dll"
.\7z.exe e -bd -y %FSS_PATH% "*\x86\ffms2.dll" "*\x86\ffmsindex.exe"
.\7z.exe e -bd -y %RG1_PATH% "RemoveGrain.dll" "Repair.dll"
.\7z.exe e -bd -y %QTS_PATH% "QTSource.dll"
.\7z.exe e -bd -y %MIF_PATH% "MediaInfo.exe" "MediaInfo.dll"
.\7z.exe e -bd -y %YDF_PATH% "yadif.dll"
.\7z.exe e -bd -y %A2P_PATH% "avs2pipe_gcc.exe"
.\7z.exe e -bd -y %WVI_PATH% "silence.exe"
.\7z.exe e -bd -y %NERO_PATH% "win32\neroAacEnc.exe"
echo;
copy /y %X264_PATH% ".\x264.exe"

echo;
echo ^>^>%INSTALLER_END%
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
exit
