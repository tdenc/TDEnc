set USER_VERSION=28

rem ↓ここから下を適当に弄って自分好みの設定にしてくだしあ↓

rem 自動バージョンチェック機能の設定
rem オンにする場合は「DEFAULT_VERSION_CHECK=true」にする（デフォルト＆激しく推奨）
rem オフにする場合は「DEFAULT_VERSION_CHECK=false」にする（激しく「非」推奨）
set DEFAULT_VERSION_CHECK=true

rem 一般アカウント用エンコードで目指す総ビットレート（kbps）
rem ビットレートオーバーになるときは、この数値を下げる(初期値は600)
set I_TARGET_BITRATE=600
rem 一般アカウント用の限界総ビットレート（kbps）
set I_MAX_BITRATE=654

rem エコノミーモード回避用エンコードで目指す総ビットレート（kbps）
rem ビットレートオーバーになるときは、この数値を下げる(初期値は420)
set E_TARGET_BITRATE=420
rem エコノミーモード回避用の限界総ビットレート（kbps）
set E_MAX_BITRATE=445

rem ビットレート基準エンコードで確保しておく余分ビットレート（kbps）
rem 3pass判定緩和のために確保（初期値は5）
rem 目標ビットレートにぴったりにしたい場合は0にする（非推奨）
set BITRATE_MARGIN=5

rem crfエンコに切り替わるビットレートの閾値（kbps）
rem この数値以上のビットレートが指定されたときにcrfエンコに切り替わる
rem crfエンコの結果サイズオーバーした場合はビットレートエンコに切り替わる
rem そのときのビットレートは自動的に最大可能ビットレートになる
set BITRATE_THRESHOLD=2000

rem ニコニコ新仕様で2passエンコに切り替わるビットレートの閾値（kbps）
rem この数値以下のビットレートでCRFエンコされたときに2passエンコに切り替わる
rem Hは高解像度用，Mは中解像度，Lは低解像度用
set BITRATE_NICO_NEW_THRESHOLD_H=2000
set BITRATE_NICO_NEW_THRESHOLD_M=1000
set BITRATE_NICO_NEW_THRESHOLD_L=600

rem crfエンコのときの値
rem 数値が小さいほど高画質だが下げすぎるといろいろ問題が出る
rem YouTube用エンコ、ニコニコ新基準のときはCRF_YOUを使用する
rem ニコニプレミアムアカはCRF_HIGHの方、一般アカはCRF_LOWを使う
set CRF_YOU=18
set CRF_HIGH=23
set CRF_LOW=26

rem 一般アカウントの解像度の上限の設定
rem 幅のデフォルトは1280pixels、高さのデフォルトは720pixels
set I_MAX_WIDTH=1280
set I_MAX_HEIGHT=720

rem Twitterの解像度の上限の設定
rem 幅のデフォルトは1920pixels、高さのデフォルトは1200pixels
set T_MAX_WIDTH=1920
set T_MAX_HEIGHT=1200

rem リサイズの質問時にyを答えたときの高さと幅の設定
rem 高さのデフォルトは480pixels。変えたいときは「DEFAULT_HEIGHT=720」などのようにする
rem 幅は、空欄のときは自動計算（動画ファイルのアスペクト比を維持）
rem DEFAULT_HEIGHT_NEW_Hはニコニコ新仕様高解像度用
rem DEFAULT_HEIGHT_NEW_Mはニコニコ新仕様中解像度用
rem DEFAULT_HEIGHT_NEW_Lはニコニコ新仕様低解像度用
rem DEFAULT_HEIGHT_TWITTERはTwitter用
rem 指定したい場合は「DEFAULT_WIDTH=640」などのようにする
rem ===============================！注意！===================================
rem バージョン2.72からはWIDTHではなくHEIGHTを指定するように仕様が変更されました
rem ==========================================================================
set DEFAULT_WIDTH=
set DEFAULT_HEIGHT=480
set DEFAULT_HEIGHT_NEW_H=720
set DEFAULT_HEIGHT_NEW_M=540
set DEFAULT_HEIGHT_NEW_L=360
set DEFAULT_HEIGHT_TWITTER=1080

rem リサイザの指定
rem Avisynthのリサイザから選んでください（Spline36Resize、Lanczos4Resizeなど）
rem よくわからない人は空欄のままにしておくこと
set RESIZER=

rem デノイズの強弱
rem RemoveGrainのmode
rem よくわからない人はそのままにしておくこと
set RG_MODE=5

rem FPSを指定したいときは、「DEFAULT_FPS=24」などのようにする
rem 元の動画と同じのままなら空欄のままにしておく
set DEFAULT_FPS=

rem AACエンコーダの選択（NeroAacEncかQuickTimeか）
rem neroかqt（QuickTimeがインストールされてる必要があります）かを選択
set AAC_ENCODER=nero

rem AACエンコードのプロファイル選択(hev2はAAC_ENCODER=neroの時のみ有効)
rem auto、lc、he、hev2から選択(デフォルトのautoを推奨)
set AAC_PROFILE=auto

rem 音声のサンプルレートの選択肢
rem これは弄らないことを勧めます
set SAMPLERATE_LIST1=44100
set SAMPLERATE_LIST2=48000
set SAMPLERATE_LIST3=96000

rem 再エンコ系サイト向けの音声ビットレート
rem これは弄らないことを勧めます
set A_BITRATE_YOUTUBE=320
set A_BITRATE_NICO_NEW=256
set A_BITRATE_TWITTER=256

rem デコーダの選択
rem auto、avi、ffmpeg、directshow、qtから選択(デフォルトのautoを推奨)
rem autoは自動選択、aviはAVISource、ffmpegはFFMpegSource、directshowはDirectShowSource
rem qtはQuickTime(QuickTime7以降が必要です、一部コーデックでは非常に遅いです)
rem qtはファイル名・フォルダ名などに日本語等が含まれていると失敗するので
rem アルファベットのみにする、Cドライブ直下に置く等して対処してから使用してください
rem デコードが上手くいかない場合、directshowやffmpegを指定するとうまく行く場合も
set DECODER=auto

rem カラーマトリクス
rem よく分からない場合は弄らないのが吉
rem BT.601かBT.709を選択する
set COLORMATRIX_SD=BT.601
set COLORMATRIX_HD=BT.709

rem フルレンジを有効にしたい場合はonにする
rem フルレンジにした場合のデメリット(プレイヤー互換等)を認識している人のみ使用してください
rem きちんと色空間を考慮しないと、Avisynthでエラーになります
rem 特に理由がなければ、デフォルトのoffを推奨
set FULL_RANGE=off

rem MP4の容量の設定
rem エンコード後の容量が100MB（プレアカ）や40MB（一般アカ）を超えてしまうとき
rem 下の値を小さくしてみるといいかも
rem DEFAULT_SIZE_PREMIUMかプレアカ用の設定、DEFAULT_SIZE_NOMALが一般アカ用の設定、DEFAULT_SIZE_PREMIUM_NEWは新基準適用者向けの設定
rem 初期設定は「DEFAULT_SIZE_PREMIUM=98.5」、「DEFAULT_SIZE_NOMAL=39」「DEFAULT_SIZE_PREMIUM_NEW=1495」
rem 容量オーバーするときは「DEFAULT_SIZE_PREMIUM=98」、「DEFAULT_SIZE_NOMAL=38」などにしてみる
set DEFAULT_SIZE_PREMIUM=98.5
set DEFAULT_SIZE_NORMAL=39
set DEFAULT_SIZE_PREMIUM_NEW=1495
rem YouTube用の設定
rem 上限は20480MB（YouTubeパートナー）か2024MB（YouTube一般）
set DEFAULT_SIZE_YOUTUBE_PARTNER=20000
set DEFAULT_SIZE_YOUTUBE_NORMAL=2000
rem Twitter用の設定
rem 上限は512MB
set DEFAULT_SIZE_TWITTER=510

rem ファイル容量（最終チェック用）
rem これは弄らないことを勧めます
set MP4_FILESIZE_NICO_PREMIUM=104857600
set MP4_FILESIZE_NICO_NORMAL=41943040
set MP4_FILESIZE_NICO_NEW=1610612736
set MP4_FILESIZE_TWITTER=536870912

rem 動画の長さに関する設定（単位はすべて秒）
rem YOUTUBE_DURATIONはYouTubeパートナー閾値（初期値900）
rem NICO_NEW_DURATION_Hはニコニコ新仕様の高解像度閾値（初期値959）
rem NICO_NEW_DURATION_Mはニコニコ新仕様の中解像度閾値（初期値1859）
rem TWITTER_DURATIONはTwitterのアップロード閾値（初期値140）
set YOUTUBE_DURATION=900
set NICO_NEW_DURATION_H=959
set NICO_NEW_DURATION_M=1859
set TWITTER_DURATION=140

rem 旧仕様のニコニコ向けエンコード
rem 実験目的のみ（trueで有効化）
set OLD_NICO_FEATURE=false

rem パス数の設定（画像＆音声の同時D&Dのときはこの設定は無効です）
rem 強制的に1passや2passや3passにしたいときはここを弄る
rem 「DEFAULT_PASS_**=1」「DEFAULT_PASS_**=2」「DEFAULT_PASS_**=3」でそれぞれ1pass、2pass、3passを強制する
rem 「DEFAULT_PASS_**=0」だと自動判定
rem 2pass後のビットレートから3passが必要かを判断。1passより前にcrfエンコする場合あり
rem 速度重視、バランス、画質重視の各プリセットごとに設定してください
rem SPEED、BALANCE、QUALITYがそれぞれ速度重視、バランス、画質重視を選んだ時のパス数設定になります
set DEFAULT_PASS_SPEED=1
set DEFAULT_PASS_BALANCE=0
set DEFAULT_PASS_QUALITY=0

rem エンコード後にプレイヤーを開くかどうか（開く場合はy、開かない場合はn）
rem デフォルトのyをお勧めします
set MOVIE_CHECK=y

rem プレイヤーの種類（html5かflash）
rem デフォルトはhtml5
rem インストールされているFlash PlayerのバージョンによってFlash Playerで再生ができなくなるので
rem html5での再生をおすすめします（ニコニコもそのうちhtml5になるとのことです）
set MOVIE_PLAYER=html5

rem ファイルの出力先の指定（デフォルト推奨）
rem 指定したフォルダに同名のmp4がある場合は以前のファイルをold.mp4に変えてしまいます
rem またパス、ファイル名に日本語がある場合は不具合が起きる場合があります
set MP4_DIR=..\MP4

rem エンコード終了後の挙動（デフォルトのn推奨）
rem nだとそのまま(MP4フォルダを開きに行きます)、yだと120秒待機後にシャットダウン
rem これをyに変えたことで他のアプリケーションの未保存のデータが消えても責任は取れません
set SHUTDOWN=n

rem 質問への返答をあらかじめ入力しておくとドラッグ＆ドロップの後いちいち質問に答えなくてもよくなります
rem それぞれイコールの後ろに質問の答えを書いてください（例：「set ACTYPE=y」「set TEMP_BITRATE=160」）
rem 質問形式を維持したい場合はイコールの後ろは空欄のままにしておいてください（スペースも入れちゃだめ！）

rem 質問レベルの選択（1～3）
set Q_LEVEL=

rem アップロード先の選択（y/n）
set UP_SITE=

rem ===============================！注意！===================================
rem これ以降のいくつかの設定は、ニコニコのみか、YouTubeのみで有効になります
rem ==========================================================================

rem プリセット選択（l～q,xから選択）（ニコニコのみ）
rem ===============================！注意！===================================
rem 質問レベル「すこし」ではこの質問は非表示
rem ==========================================================================
set PRETYPE=

rem プレミアムアカウントか否か（y/n）（ニコニコのみ）
set ACTYPE=

rem パートナープログラムに登録しているか否か（y/n）（YouTubeのみ）
set YTTYPE=

rem プレミアムアカウントの場合のビットレート（ニコニコのみ）
rem 入力例：「set T_BITRATE=1500」（単位はkbps）
rem 0だと画質基準の適切なビットレートか限界ビットレートを自動選択
rem ===============================！注意！===================================
rem 質問レベル「すこし」ではこの質問は非表示
rem ==========================================================================
set T_BITRATE=

rem 品質基準エンコ（y/n、または0～51の数字）（ニコニコ、YouTube）
rem ===============================！注意！===================================
rem 質問レベル「すこし」「ふつう」ではこの質問は非表示
rem ==========================================================================
set CRF_ENC=

rem エコ回避エンコか高画質エンコか（e/h）（ニコニコのみ）
rem ===============================！注意！===================================
rem バージョン2.72からはy/nではなくe/hで答えるようにように仕様が変更されました
rem 質問レベル「すこし」「ふつう」ではこの質問は非表示
rem ==========================================================================
set ENCTYPE=

rem 低再生負荷エンコ（y/n）（ニコニコのみ）
rem ===============================！注意！===================================
rem 質問レベル「すこし」「ふつう」ではこの質問は非表示
rem ==========================================================================
set DECTYPE=

rem FlashPlayerへの対応(1～3から選択）（ニコニコのみ）
rem ===============================！注意！===================================
rem 質問レベル「すこし」ではこの質問は非表示
rem ==========================================================================
set FLASH=

rem デインターレースの選択（a/y/nから選択）（ニコニコ、YouTube）
rem ===============================！注意！===================================
rem 質問レベル「すこし」「ふつう」ではこの質問は非表示
rem ==========================================================================
set DEINT=

rem リサイズの選択（y/nなど）（ニコニコのみ）
rem 数値を直接入力する場合は「set RESIZE=640:360」などのように記入
rem ===============================！注意！===================================
rem 質問レベル「すこし」ではこの質問は非表示
rem ==========================================================================
set RESIZE=

rem デノイズの選択（a/n/1/2から選択）（ニコニコ、YouTube）
rem ===============================！注意！===================================
rem 質問レベル「すこし」「ふつう」ではこの質問は非表示
rem ==========================================================================
set DENOISE=

rem 音声のビットレート（ニコニコのみ）
rem 「set TEMP_BITRATE=160」（160kbps）「set TEMP_BITRATE=0」（音声なし）
rem ===============================！注意！===================================
rem 質問レベル「すこし」ではこの質問は非表示・無視します
rem ==========================================================================
set TEMP_BITRATE=

rem 音声のサンプルレート(0～3から選択）（ニコニコ、YouTube）
rem 0:元の音声と一緒、1:44100Hz、2:48000Hz、3:96000Hz
rem ===============================！注意！===================================
rem バージョン2.72からはサンプルレートではなく1～3からの選択に変更されました
rem 質問レベル「すこし」「ふつう」ではこの質問は非表示
rem ==========================================================================
set SAMPLERATE=

rem 音ズレ処理（y/nなど）（ニコニコ、YouTube）
rem 手動で指定するときは「AUDIO_SYNC=20」のように数字を書く（単位はミリ秒）
rem （正なら冒頭に無音を追加、負なら音声の冒頭をカット）
rem ===============================！注意！===================================
rem 質問レベル「すこし」ではこの質問は非表示
rem ==========================================================================
set A_SYNC=

rem 最後の確認画面（ニコニコ、YouTube）
rem スキップしたい場合は「set SKIP_MODE=true」にする
set SKIP_MODE=
