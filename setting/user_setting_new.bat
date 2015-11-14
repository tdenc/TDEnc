set USER_VERSION=18

rem ↓ここから下を適当に弄って自分好みの設定にしてくだしあ↓

rem 一般アカウント用エンコードで目指す総ビットレート（kbps）
rem ビットレートオーバーになるときは、この数値を下げる(初期値は600)
set I_TARGET_BITRATE=600
rem 一般アカウント用の限界総ビットレート（kbps）
set I_MAX_BITRATE=654

rem エコノミーモード回避用エンコードで目指す総ビットレート（kbps）
rem ビットレートオーバーになるときは、この数値を下げる(初期値は420)
rem 12/2/8の仕様変更後に変数名に_NEWを追加
set E_TARGET_BITRATE_NEW=420
rem エコノミーモード回避用の限界総ビットレート（kbps）
set E_MAX_BITRATE_NEW=445

rem 一般アカウントの解像度の上限の設定
rem 幅のデフォルトは800pixels、高さのデフォルトは600pixels
set I_MAX_WIDTH=800
set I_MAX_HEIGHT=600

rem リサイズの質問時にyを答えたときの幅と高さの設定
rem 幅のデフォルトは640pixels。変えたいときは「DEFAULT_WIDTH=768」などのようにする
rem 高さは、空欄のときは自動計算（動画ファイルのアスペクト比を維持）
rem 指定したい場合は「DEFAULT_HEIGHT=432」などのようにする
set DEFAULT_WIDTH=640
set DEFAULT_HEIGHT=

rem FPSを指定したいときは、「DEFAULT_FPS=24」などのようにする
rem 元の動画と同じのままなら空欄のままにしておく
set DEFAULT_FPS=

rem AACエンコーダの選択（NeroAacEncかQuickTimeか）
rem neroかqt（QuickTimeがインストールされてる必要があります）かを選択
set AAC_ENCODER=nero

rem AACエンコードのプロファイル選択(hev2はAAC_ENCODER=neroの時のみ有効)
rem auto、lc、he、hev2から選択(デフォルトのautoを推奨)
set AAC_PROFILE=auto

rem 音声のサンプルレートを指定したいときは「SAMPLERATE=48000」などのようにする
rem デフォルトは44100
rem あまり高くすると(192000とか)音声エンコードに失敗します
rem 元の音声のサンプルレートと同じままにしたいなら「SAMPLERATE=0」にする(非推奨)
set SAMPLERATE=44100

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
set COLORMATRIX=BT.601

rem フルレンジを有効にしたい場合はonにする
rem フルレンジにした場合のデメリット(プレイヤー互換等)を認識している人のみ使用してください
rem きちんと色空間を考慮しないと、Avisynthでエラーになります
rem 特に理由がなければ、デフォルトのoffを推奨
set FULL_RANGE=off

rem MP4の容量の設定
rem エンコード後の容量が100MB（プレアカ）や40MB（一般アカ）を超えてしまうとき
rem 下の値を小さくしてみるといいかも
rem DEFAULT_SIZE_PREMIUMかプレアカ用の設定、DEFAULT_SIZE_NOMALが一般アカ用の設定
rem 初期設定は「DEFAULT_SIZE_PREMIUM=98.5」、「DEFAULT_SIZE_NOMAL=39」
rem 容量オーバーするときは「DEFAULT_SIZE_PREMIUM=98」、「DEFAULT_SIZE_NOMAL=38」などにしてみる
set DEFAULT_SIZE_PREMIUM=98.5
set DEFAULT_SIZE_NORMAL=39
rem YouTube用の設定
rem 上限は20480MB（YouTubeパートナー）か2024MB（YouTube一般）
set DEFAULT_SIZE_YOUTUBE_PARTNER=20000
set DEFAULT_SIZE_YOUTUBE_NORMAL=2000

rem 自動バージョンチェック機能の設定
rem オンにする場合は「DEFAULT_VERSION_CHECK=true」にする（デフォルト＆激しく推奨）
rem オフにする場合は「DEFAULT_VERSION_CHECK=false」にする（激しく「非」推奨）
set DEFAULT_VERSION_CHECK=true

rem パス数の設定（画像＆音声の同時D&Dのときはこの設定は無効です）
rem 強制的に1passや2passや3passにしたいときはここを弄る
rem 「DEFAULT_PASS_**=1」「DEFAULT_PASS_**=2」「DEFAULT_PASS_**=3」でそれぞれ1pass、2pass、3passを強制する
rem 「DEFAULT_PASS_**=0」（デフォルト）だと自動判定（2pass後のビットレートから3passが必要かを判断）
rem 速度重視、バランス、画質重視の各プリセットごとに設定してください
rem SPEED、BALANCE、QUALITYがそれぞれ速度重視、バランス、画質重視を選んだ時のパス数設定になります
set DEFAULT_PASS_SPEED=1
set DEFAULT_PASS_BALANCE=0
set DEFAULT_PASS_QUALITY=0

rem エンコード後にプレイヤーを開くかどうか（開く場合はy、開かない場合はn）
rem ほかのプレイヤーで見ると、ニコニコ動画上で見るときと見え方が違う場合があるので
rem デフォルトのyをお勧めします
set MOVIE_CHECK=y

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

rem プリセット選択（l～qから選択）
rem アニメ・アイマス・MMDなどはlmnから選択
rem 実写・PCゲームなどはopqから選択
rem それぞれ左から速度重視・バランス・画質重視
set PRETYPE=

rem プレミアムアカウントの場合は下を「set ACTYPE=y」に、一般アカウントの場合は下を「set ACTYPE=n」に変えてください
set ACTYPE=

rem YouTube用のエンコードの場合、パートナープログラムに登録している場合は下を「set YTTYPE=y」に、
rem していない場合は下を「set YTTYPE=n」に変えてください
set YTTYPE=

rem プレミアムアカウントの場合の目標ビットレート（単位はkbps、入力例：set T_BITRATE=1000）
set T_BITRATE=

rem エコ回避する場合は下を「set ENCTYPE=y」に、エコ回避しない場合は下を「set ENCTYPE=n」に変えてください
set ENCTYPE=

rem 低再生負荷エンコにする場合は下を「set DECTYPE=y」に、低再生負荷エンコしない場合は下を「set DECTYPE=n」に変えてください
set DECTYPE=

rem リサイズする場合は下を「set RESIZE=y」に、リサイズしない場合は下を「set RESIZE=n」に変えてください
set RESIZE=

rem 音声のビットレートを「set TEMP_BITRATE=160」のように入力してください
rem 音声なしでエンコードする場合は「set TEMP_BITRATE=0」と入力してください
set TEMP_BITRATE=

rem 音ズレ処理
rem yを選択すると自動で処理、nを選択すると処理しない
rem 手動で指定するときは「AUDIO_SYNC=20」のように数字を書いてください（単位はミリ秒）
rem （正なら冒頭に無音を追加、負なら音声の冒頭をカット）
set A_SYNC=

rem さらに最後の確認画面もスキップしたい場合は下を「set SKIP_MODE=true」に変えてください
set SKIP_MODE=
