rem プリセット用オプション設定（低負荷）

set BFRAMES=3
set B_ADAPT=2
set B_PYRAMID=none
set REF=5
set RC_LOOKAHEAD=50
set QPSTEP=12
set AQ_MODE=2
set AQ_STRENGTH=1.00
set ME=esa
set SUBME=9
set PSY_RD=0.2:0
set TRELLIS=0

rem その他手動指定で追加したいオプションがある場合はスペースで区切りながら追加
set MISC=--no-fast-pskip --no-dct-decimate --no-cabac
