rem 共通設定

set MIN_KEYINT=1
set SCENECUT=50
set QCOMP=0.80
set WEIGHTP=1
set THREADS=0

rem その他手動指定で追加したいオプションがある場合はスペースで区切りながら追加
set COMMON_MISC=--qpmin 10 --direct auto --thread-input --no-interlaced --stats %TEMP_DIR%\x264.log
