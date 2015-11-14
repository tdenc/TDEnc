@echo off
cd /d "%~d0" 1>nul 2>&1
cd "%~p0"
title ど、どうして・・・？わたし、なにか気に障るようなことした？

echo ------------------------------------------------------------------------------
echo 　つんでれんこ  アンインストーラ
echo ------------------------------------------------------------------------------
echo;

if not exist %WINDIR%\System32\avisynth.dll goto loop1
if exist %WINDIR%\SysWow64\avisynth.dll goto loop1

echo ^>^>元々Avisynthがインストールされていたので、アンインストールの必要はないわよ。
echo ^>^>つんでれんこのフォルダをとっととゴミ箱に持っていきなさいよね！
echo ^>^>もうあんたのことなんて知らないんだから・・・！
echo;
call quit.bat


:loop1
echo ^>^>ほんとにアンインストールするの？（y/n）
set /p UNINSTALL=^>^>

if /i "%UNINSTALL%"=="y" goto loop2
if /i "%UNINSTALL%"=="n" goto cancel

echo;
echo ^>^>ちょっとぉ！しっかり選びなさいよ！
echo;
goto loop1


:loop2
echo ^>^>もう一度確認するわよ？ほんとにアンインストールするの？（y/n）
set /p UNINSTALL=^>^>

if /i "%UNINSTALL%"=="y" goto loop3
if /i "%UNINSTALL%"=="n" goto cancel

echo;
echo ^>^>ちょっとぉ！しっかり選びなさいよ！
echo;
goto loop2


:loop3
echo ^>^>・・・ほんとに？（y/n）
set /p UNINSTALL=^>^>

if /i "%UNINSTALL%"=="y" goto loop4
if /i "%UNINSTALL%"=="n" goto cancel

echo;
echo ^>^>ちょっとぉ！しっかり選びなさいよ！
echo;
goto loop3


:loop4
echo ^>^>・・・どうしても？（y/n）
set /p UNINSTALL=^>^>

if /i "%UNINSTALL%"=="y" goto loop5
if /i "%UNINSTALL%"=="n" goto cancel

echo;
echo ^>^>ちょっとぉ！しっかり選びなさいよ！
echo;
goto loop4


:loop5
echo ^>^>・・・こんなにお願いしても？（y/n）
set /p UNINSTALL=^>^>

if /i "%UNINSTALL%"=="y" goto uninstall
if /i "%UNINSTALL%"=="n" goto cancel

echo;
echo ^>^>ちょっとぉ！しっかり選びなさいよ！
echo;
goto loop5


:uninstall
echo ^>^>何よ！もう勝手にすればいいじゃない！
regedit /s uninstall.reg>nul
echo ^>^>ほら！レジストリの削除は終わったわよ！
echo ^>^>あとはつんでれんこのフォルダをとっととゴミ箱に持っていきなさいよね！
echo;
echo ^>^>あんたなんて・・・もう知らないんだから・・・！
echo;
goto uninstall_end


:cancel
echo ^>^>え・・・ほんと？
echo ^>^>べ、別にうれしくなんかないんだからね！勘違いしないでよね！
echo;


:uninstall_end
call quit.bat
