rem プリセット用オプション設定（激重） 

set BFRAMES=8
set B_ADAPT=2
set B_PYRAMID=normal
set REF=8
set RC_LOOKAHEAD=60
set QPSTEP=12
set AQ_MODE=2
set AQ_STRENGTH=0.80
set ME=tesa
set SUBME=11
set PSY_RD=0.8:0
set TRELLIS=2

rem その他手動指定で追加したいオプションがある場合はスペースで区切りながら追加
set MISC=--slow-firstpass --merange 24 --partitions all --no-fast-pskip --no-dct-decimate 
