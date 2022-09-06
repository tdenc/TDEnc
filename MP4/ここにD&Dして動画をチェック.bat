@echo off
cd /d "%~d0" 1>nul 2>&1
cd "%~p0..\tool\" 1>nul 2>&1

set TEMP_FILE=temp.txt
set HTML_FILE=player.html
set MOVIE_FILE=%~dp1%~nx1
set SIZE_JS=size.js

echo;
echo ^>^>HTML %PROCESS_ANNOUNCE%
echo;

.\MediaInfo.exe --Inform=Video;%%Width%% --LogFile=%TEMP_FILE% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_FILE%) do set IN_WIDTH=%%i
.\MediaInfo.exe --Inform=Video;%%Height%% --LogFile=%TEMP_FILE% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_FILE%) do set IN_HEIGHT=%%i
.\MediaInfo.exe --Inform=Video;%%DisplayAspectRatio/String%% --LogFile=%TEMP_FILE% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_FILE%) do set ASPECT=%%i
.\MediaInfo.exe --Inform=Video;%%Duration/String3%% --LogFile=%TEMP_FILE% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_FILE%) do set DURATION=%%i
.\MediaInfo.exe --Inform=Video;%%FrameRate/String%% --LogFile=%TEMP_FILE% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_FILE%) do set FPS=%%i
.\MediaInfo.exe --Inform=General;%%OverallBitRate%% --LogFile=%TEMP_FILE% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_FILE%) do set /a T_BITRATE=(%%i+500)/1000
.\MediaInfo.exe --Inform=Video;%%BitRate%% --LogFile=%TEMP_FILE% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_FILE%) do set /a V_BITRATE=(%%i+500)/1000
.\MediaInfo.exe --Inform=Audio;%%BitRate%% --LogFile=%TEMP_FILE% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_FILE%) do set /a A_BITRATE=(%%i+500)/1000
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_FILE% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_FILE%) do set SIZE=%%i

set /a PLAYER_HEIGHT=480
set /a PLAYER_WIDTH=854

(
  echo var n = %SIZE%/1024.0/1024.0;
  echo n = n * 100;
  echo n = Math.floor^(n^);
  echo n = n / 100;
  echo document.write^(n^);
 )> %SIZE_JS%


(
  echo ^<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"^>
  echo ^<html lang="ja"^>
  echo ^<head^>
  echo ^<meta http-equiv="Content-type" content="text/html; charset=Shift_JIS"^>
  echo ^<meta http-equiv="Pragma" content="no-cache"^>
  echo ^<meta http-equiv="Cache-Control" content="no-cache"^>
  echo ^<meta http-equiv="Expires" content="0"^>
  echo ^<title^>%~xn1^</title^>
  echo ^<meta http-equiv="Content-Style-Type" content="text/css"^>
  echo ^</head^>
  echo;
  echo ^<body bgcolor="#ffeaea" text="#000000" link="#0000ff" vlink="#800080" alink="#ff0000"^>
  echo ^<center^>
  echo ^<h3^>%~nx1^</h3^>
  echo ^<p^>���j�R�j�R�ł̌������ƈႤ�ꍇ�����邩�����J�ŃA�b�v���[�h���Ċm�F���邱�Ƃ��������߂����I^<p^>
  echo ^<video src="file:///%MOVIE_FILE:\=/%" width="%PLAYER_WIDTH%" height="%PLAYER_HEIGHT%" controls preload^>
  echo ^<p^>������Đ�����ɂ�HTML5��video�^�O���T�|�[�g�����u���E�U���K�v��I^</p^>
  echo ^</video^>
  echo ^<hr^>
  echo;
  echo ^<div class="table"^>
  echo ^<table border=2 summary="������"^>
  echo   ^<caption^>^<h3^>������^</h3^>^</caption^>
  echo   ^<tr align=center^>
  echo  ^<td^>�t�@�C����
  echo  ^<td^>%~nx1
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo   ^<td^>�t�H���_
  echo   ^<td^>%~dp1
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�𑜓x
  echo   ^<td^>%IN_WIDTH%x%IN_HEIGHT%
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�A�X�y�N�g��
  echo  ^<td^>%ASPECT%
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�Đ�����
  echo  ^<td^>%DURATION%
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�t���[�����[�g
  echo  ^<td^>%FPS%fps
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�r�b�g���[�g
  echo  ^<td^>%T_BITRATE%kbps ^(�f��%V_BITRATE%kbps�A����%A_BITRATE%kbps^)
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�t�@�C���e��
  echo  ^<td^>^<script type="text/javascript" src="%SIZE_JS%"^>^</script^>MB
  echo   ^</tr^>
  echo ^</table^>
  echo ^</div^>
  echo;
  echo ^<hr^>
  echo;
  echo ^<p^>^<a href="http://www.upload.nicovideo.jp/upload" target="_blank"^>SMILEVIDEO^</a^>^</p^>
  echo;
  echo ^</center^>
  echo;
  echo ^</body^>
  echo ^</html^>
)> %HTML_FILE%
echo;

start rundll32 url.dll,FileProtocolHandler "%HTML_FILE%"
