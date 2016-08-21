rem このファイルはいじらないでくだしあ。
rem いじるならuser_message.batの方をいじってくだしあ＞＜

rem 共通メッセージ
set TDENC_NAME=つんでれんこ
set PROCESS_ANNOUNCE=処理中～♪
set PAUSE_MESSAGE1=（つんでれんこを終了します、Enterキーを押してください）
set PAUSE_MESSAGE2=Enterキーを押しなさいよね！
set HORIZON=------------------------------------------------------------------------------
set HORIZON_B===============================================================================

rem 【ここに動画をD＆D】.batのメッセージ
set TDENC_TITLE=ちょっと！いきなりなによ！こ、心の準備が出来てないじゃない…
set PRESET_ALERT=プリセットのバージョンが古いわよ！
set USER_SETTING1=user_setting.batのバージョンが古いわよ！
set USER_SETTING2=user_setting.batを自動更新する？（y/n）
set PRESET_ALERT2=手動更新する場合はUSER_VERSIONの修正も忘れないでよね！
set PRESET_ALERT3=（旧バージョンの設定は無視！）
set DOUBLECLICK_ALERT1=このファイルをダブルクリックしても意味ないわよ？
set DOUBLECLICK_ALERT2=サイトの使い方をきちんと読みなさいよね！
set FILENAME_ERROR1=ファイル名の中にうまく使えない特殊な文字があるわよ！（ぷんすか
set FILENAME_ERROR2=List2で文字化けしているファイル名を変えなさいよね！（ぷぷんすか
set UNITE_AVI_ANNOUNCE1=分割AVI連結えんこも～ど
set UNITE_AVI_ANNOUNCE2=※インタレ解除・フルレンジ機能などは無効
set ONE_MOVIE_ANNOUNCE=通常えんこも～ど
set SEQUENCE_ANNOUNCE=連続えんこも～ど
set MOVIE_INFO_ERROR1=動画解析に失敗・・・
set MOVIE_INFO_ERROR2=ユーザー名、フォルダ名、ファイル名に全角のスペースが使われてる可能性があるわ
set MOVIE_INFO_ERROR3=　　対処法１：ファイル名から全角のスペースを削除する
set MOVIE_INFO_ERROR4=　　対処法２：一旦動画をドライブ（Cドライブ等）直下に移動する
set SEQUENCE_END1=お、終わったわよ！ほんと乱暴なんだから・・・
set SEQUENCE_END2=どのファイルがどのMP4かきちんとメモしてからウィンドウを閉じなさいよ！
set SEQUENCE_END3=今度からはもっとやさしく扱ってよね・・・/////
set MUX_ANNOUNCE=MUXえんこも～ど
set MUX_ALERT1=.nvvファイルは対応してないわ
set MUX_ALERT2=DirectShow出力でAVIに書き出してから使ってね！
set SWF_ALERT=swfファイルはversion1.01からサポート対象外なの
set NVV_ALERT=nvvファイルはサポート対象外なの。DirectShow出力プラグインでAVIにしてから使ってね
set VIDEO_ENC_ERROR=映像のエンコードに失敗したわ・・・
set AVS_MESSAGE1=Avisynthがインストールされていないわよ！
set AVS_MESSAGE2=インストーラを起動するから実行を許可しなさいよね！
set AVS_MESSAGE3=後は「Japanese→同意する→次へ→インストール」と答えれば完了するわよ！

rem avs.bat、cat.bat、movie.bat、mux.bat、nvv.batのメッセージ
set ANALYZE_ANNOUNCE=動画解析中～♪
set ANALYZE_END=動画解析完了～♪
set CHANNEL_ERROR1=ニコニコはステレオ（2ch）までしか対応していないわよ！
set CHANNEL_ERROR2=音声のみwav（2ch）で書き出して動画と一緒にD＆Dしなさいよね！
set ANALYZE_ERROR=動画の解析に失敗・・・
set DECODE_ERROR1=動画のデコードに失敗したわ・・・
set DECODE_ERROR2=インデックス処理をしてもう一度チャレンジするからそこで待っていなさい！
set DECODE_ERROR3=正常にデコードできなかったわ・・・
set VIDEO_ENC_ANNOUNCE=動画のエンコ作業に突入～♪
set AVS_END=映像AVS作成完了～♪
set VIDEO_ENC_END=動画エンコ完了～♪
set SILENCE_ANNOUNCE=無音ファイルを作成～♪
set AUDIO_ENC_ANNOUNCE=音声のエンコ作業に突入～♪
set WAV_ANNOUNCE=WAVファイル作成中～♪

rem create_mp4.batのメッセージ
set MP4_ANNOUNCE=MP4作成開始～♪
set MP4_ERROR1=エンコードに失敗したわ・・・
set MP4_ERROR2=ごめんなさい・・・
set MP4_SUCCESS=MP4作成完了～♪
set SIZE_SUCCESS1=動画ファイルの容量のチェック完了～♪
set SIZE_SUCCESS2=容量オーバーしてないわよ♪
set SIZE_ERROR=ニコニコの容量制限をオーバーしちゃったわ・・・
set DERE_MESSAGE1=完成～♪
set DERE_MESSAGE2=ま、また使ってくれると・・・う、うれしいな・・・（/ω＼）

rem initialize.batのメッセージ
set INIT_TITLE=は、初めてなんだからやさ（ｒｙ
set INIT_ANNOUNCE=初回起動時の設定

rem m4a_enc.batのメッセージ
set SYNC_ANNOUNCE=音ズレ修正中～♪
set WAV_END=WAVファイル作成完了～♪
set M4A_ENC_ANNOUNCE=音声エンコ開始～♪
set WAV_ERROR=音声が読み込めなかったから無音ファイルを追加するわよ
set M4A_SUCCESS=音声エンコ完了～♪

rem setting_question.batのメッセージ
set QUESTION_START1=べっ、別にあんたの好みなんてどうでもいいんだけど、しょうがないから聞いてやるわ
set QUESTION_START2=どんな設定がいいのよ？
set LEVEL_START1=質問の詳しさはどれくらいが好み？（1～3）
set LEVEL_START2=（よく分からない場合は1、慣れてきたら2を選べばいいと思うわ）
set LEVEL_LIST1=すこし（らくちんも～ど、初心者向け）
set LEVEL_LIST2=ふつう（だいたい今までのつんでれんこ）
set LEVEL_LIST3=おおめ（よくわからない人は選ばないこと）
set LEVEL_LIST4=※もっとヤリたい人はuser_setting.batを直接弄ること
set UP_SITE_START1=YouTube？それともニコニコ？（y/n/N）
set UP_SITE_START2=（YouTubeならy、ニコニコならn(一部の新基準対象者はN)を選びなさいよね）
set PRESET_START1=プリセットはどれ？（l～x）
set PRESET_START2=（よく分からない場合はとりあえずmを選べばいいと思うわ）
set PRESET_LIST1=アニメ・アイマス・MMDなど　速度重視（or 低スペックPC用）
set PRESET_LIST2=アニメ・アイマス・MMDなど　バランス（エンコ速度・画質両立）
set PRESET_LIST3=アニメ・アイマス・MMDなど　画質重視（or 高スペックPC用）
set PRESET_LIST4=実写・PCゲームなど　速度重視（or 低スペックPC用）
set PRESET_LIST5=実写・PCゲームなど　バランス（エンコ速度・画質両立）
set PRESET_LIST6=実写・PCゲームなど　画質重視（or 高スペックPC用）
set PRESET_LIST7=歌ってみたカテゴリなど（音声エンコのみ、高速）
set PRESET_LIST8=ユーザー定義プリセット（デフォルトは激重プリセット）
set PRESET_LIST9=YouTube用（リサイズなし＆大容量でエンコ）
set PRESET_MESSAGE=プリセットsはmp4+wavでしか利用できないわよ！
set RETURN_MESSAGE1=ちょっとぉ！しっかり選びなさいよ！
set PREMIUM_START1=プレミアムアカウント？（y/n）
set PREMIUM_START2=（運営に貢いでる人はy、一般アカウントの人はnよ）
set PREMIUM_START3=YouTubeのアップロード上限解除の設定は済ませてる？（y/n）
set PREMIUM_START4=（よくわからないならnを選びなさいよね）
set YOUTUBE_ERROR1=上限の解除をしていない場合は動画の長さは15分までよ！
set YOUTUBE_ERROR2=動画を短く分割するか上限解除の設定をしなさいよね！
set BR_MODE_START1=品質基準（crf）エンコを有効にする？（y/n,CRF数値）
set BR_MODE_START2=※品質基準エンコを使うことで適切なビットレートへの調整が可能
set BR_MODE_START3=　ビットレートがオーバーした場合は自動で無効に切り替わり、
set BR_MODE_START4=　ビットレート基準エンコードに自動で切り替わる
set BR_MODE_START5=（よくわからないならyを選びなさいよね）
set ECONOMY_START1=エコ回避にエンコする？高画質エンコにする？（e/h）
set ECONOMY_START2=（よくわからないならhを選びなさいよね）
set BITRATE_START1=目標ビットレート（音声＋映像）はいくつ？（単位はkbps、入力例：1000）
set BITRATE_START2=（よくわからなかったら0にすれば自動で設定するわよ）
set RETURN_MESSAGE2=ちょっとぉ！きちんと数字（だけ）を入力してよね！
set RETURN_MESSAGE3=ちょっとぉ！ビットレートが高すぎるわよ！
set RETURN_MESSAGE4=きちんとビットレートの限界値より低く設定してよね！
set DECODE_START1=再生負荷を軽くする？（y/n）
set DECODE_START2=（プレアカエンコで動画がカクつく時はyにするとちょっとだけ改善）
set DECODE_START3=（高ビットレートや高解像度はyがお勧め）
set DECODE_START4=（一般アカ用やエコ回避用の時にｙにすると画質が極端に落ちる場合あり）
set FLASH_START1=再生プレイヤーの仕様への対応はどれくらいにする？（1～3）
set FLASH_START2=（映像が崩れる問題が出たときはこの数字を上げてみてね
set FLASH_START3=　まずは1でテストして、実際の動画視聴で問題が出たら
set FLASH_START4=　2、3と変えてからエンコし直してみればいいと思うわ）
set FLASH_START5=文句ならAdobeに言ってよね！（ぷんすか
set FLASH_LIST1=それなりに対応（今まで通り、ほとんどの場合これで十分）
set FLASH_LIST2=おおげさに対応（わりと過度な対応、画質を犠牲にする）
set FLASH_LIST3=完全互換が目標（画質をかなり犠牲にする、特にフェードや暗部）
set DEINT_START1=デインターレースする？（a/y/n）
set DEINT_START2=（aは必要かどうか自動判定、yは強制的にする、nは強制的にしない）
set DEINT_START3=（よくわからないならaを選びなさいよね）
set RESIZE_START1=リサイズは？（入力例：y、n、768:432）
set RESIZE_START2=（yは自動、nはリサイズなし、:（半角）で区切って数値入力で直接指定）
set RESIZE_START3=※高解像度かつ高FPSの場合、動画視聴中にOSを巻き込んで落ちる場合があるわよ！
set RESIZE_START4=　60fpsなどの時はリサイズすることをお勧めするわ！
set RESIZE_START5=（よくわからない場合はとりあえずyを選べばいいと思うわ）
set DENOISE_START1=デノイズする？（a/y/n）
set DENOISE_START2=（aは自動設定、yはデノイズあり、nはでノイズなし）
set DENOISE_START3=（よくわからないならaを選びなさいよね）
set AUDIO_START1=音声のビットレートは？（入力例：160）
set AUDIO_START2=（画質重視：32～48、バランス：96～128、音質重視：192～224が目安かな）
set AUDIO_START3=（無音でいいなら0の入力よ！）
set AUDIO_START4=※今回の動画で可能な音声ビットレートの限界値は
set AUDIO_START5=※今回の動画の総合（映像＋音声）ビットレートは
set RETURN_MESSAGE5=元のmp4の映像ビットレートが高すぎてmuxモードが使えないわ！
set RETURN_MESSAGE6=プリセットs以外を選びなさいよね！
set SAMPLERATE_START1=音声のサンプルレートを選びなさいよね！（0～3）
set SAMPLERATE_START2=（よくわからない場合は1を選べば安全よ）
set SAMPLERATE_LIST0=元の音声と同じ
set SYNC_START1=音ズレ処理をする？（入力例：y、n、-20、30）
set SYNC_START2=（yだとズレを差分から自動計算して音声の冒頭をカット。それが嫌ならnを選択）
set SYNC_START3=（数値入力だと数値分だけ調整。負だとカット、正だと無音追加。単位はミリ秒）
set SYNC_START4=（よくわからない場合はとりあえずyを選べばいいと思うわ）
set RETURN_MESSAGE7=ちょっとぉ！きちんと入力してよね！
set RETURN_MESSAGE8=この映像ファイルは一般アカウントだとプリセットsは使えないわよ！
set RETURN_MESSAGE9=プレミアムアカウントになるか、プリセットs以外を使ってよね！
set RETURN_MESSAGE10=目標解像度が一般アカウントの制限より高いわよ！
set RETURN_MESSAGE11=プレミアムアカウントになるか、上限以下にリサイズをしなさいよね！
set CONFIRM_START=最終確認
set CONFIRM_ON=有効
set CONFIRM_OFF=無効
set CONFIRM_PRETYPE=プリセット　　　
set CONFIRM_ACCOUNT1=投稿サイト　　　
set CONFIRM_ACCOUNT2=ニコニコ（プレミアム）
set CONFIRM_ACCOUNT3=ニコニコ（一般）
set CONFIRM_ACCOUNT4=YouTube（上限あり）
set CONFIRM_ACCOUNT5=YouTube（上限なし）
set CONFIRM_ACCOUNT6=ニコニコ（新基準）
set CONFIRM_PLAYER=プレイヤー対応　
set CONFIRM_ENCTYPE=エコ回避　　　　
set CONFIRM_DECTYPE=低再生負荷　　　
set CONFIRM_RESIZE1=リサイズ　　　　
set CONFIRM_RESIZE2=拡大
set CONFIRM_RESIZE3=縮小
set CONFIRM_VIDEO=映像　　　　　　
set CONFIRM_CRF=品質基準エンコ
set CONFIRM_BR=ビットレート基準エンコ
set CONFIRM_BITRATE1=目標ビットレート
set CONFIRM_DEINT1=デインターレース
set CONFIRM_DEINT2=自動判定（必要ならば解除）
set CONFIRM_DEINT3=強制有効
set CONFIRM_DEINT4=強制無効
set CONFIRM_DENOISE1=デノイズ　　　　
set CONFIRM_DENOISE2=自動設定
set CONFIRM_DENOISE3=あり
set CONFIRM_DENOISE4=なし
set CONFIRM_AUDIO=音声　　　　　　
set CONFIRM_NO_AUDIO=無音
set CONFIRM_SYNC1=音ズレ
set CONFIRM_SYNC2=自動調整
set CONFIRM_SYNC3=手動調整
set CONFIRM_T_BITRATE=総ビットレート　
set CONFIRM_T_CRF=自動調整（素材とアップロード先に合わせた適正値）
set CONFIRM_LAST1=これでいいのね？（y/n）
set CONFIRM_LAST2=ちょっとぉ！しっかりしなさいよ！今度はきちんと設定してよね！

rem shut.batのメッセージ
set SHUT_TITLE=エンコードが終わったわよ！
set SHUT_ALERT=120秒後に全てのアプリケーションを終了後シャットダウンするわよ！
set SHUT_CANCEL=（何かキーを押すとキャンセルするわよ！）
set CANCEL_MESSAGE=シャットダウンをキャンセルしたわよ！

rem tool_downloader.batのメッセージ
set DOWNLOADER_TITLE=ちょっと！何も準備できてないじゃない。ほら、どきなさいよ！
set DOWNLOADER_ANNOUNCE=ツールをダウンロード・更新するわよ！
set DOWNLOADER_QUESTION1=すべてのツールを全部自動で落とす？（y/n）
set DOWNLOADER_QUESTION2=（自分で手動で落としたい場合はnよ）
set NERO_LICENSE1=neroAacEnc.exeを使用するにはライセンスに同意が必要よ
set NERO_LICENSE2=Nero AAC CodecのページをWEBブラウザで開くから「エンドユーザー使用許諾条項」を
set NERO_LICENSE3=読んだ後戻ってきてね！（読んだ後WEBブラウザは閉じてもいいわよ）
set NERO_QUESTION=Nero AAC Codecの「エンドユーザー使用許諾条項」に同意する？（y/n）
set DOWNLOADER_MANUAL=以下のサイトからひとつひとつ落として、Archivesフォルダに全部入れてよね！
set DOWNLOADER_END=まったく世話が焼けるんだから・・・
set DOWNLOADER_ERROR1=以下のファイルのダウンロードに失敗したわ・・・
set DOWNLOADER_ERROR2=(理由：サーバ移転、ダウンローダ不具合、ネット切断、等)
set DOWNLOADER_ERROR3=きちんとネットに繋がってるかもう一度チェックしてから再起動してね！
set DOWNLOADER_ERROR4=それでも駄目だったら、悪いけど手動でダウンロードしてね・・・

rem tool_installer.batのメッセージ
set INSTALLER_TITLE=ツールを入れ・・・る・・・・・なんて事いわせるのよ！このド変態！
set INSTALLER_ANNOUNCE=ツールをtoolフォルダに入れるわよ！
set INSTALLER_END=まったく世話が焼けるんだから・・・

rem version_check.batのメッセージ
set VER_CHECK_ERROR=バージョンチェック失敗（回線切断orダウンローダ起動失敗orサーバダウン）
set VER_CHECK_NEW1=新しいバージョンが出てるわよ！
set VER_CHECK_NEW2=（アップデートの方法はサイトの「つかいかた」をきちんと読むこと！）
set VER_CHECK_LOG=更新内容
set UPDATE_QUESTION1=自動アップデートする？（y/n/s）
set UPDATE_QUESTION2=（このままエンコードを続けるならnを選択よ）
set UPDATE_QUESTION3=（今後もこのバージョンをスキップし続けたいならsを選択よ）
set UPDATE_ERROR=アップデート失敗（回線切断orダウンローダ起動失敗orサーバダウン）
set UPDATE_ANNOUNCE1=アップデート開始～♪
set UPDATE_ANNOUNCE2=アップデート完了～♪
set UPDATE_ANNOUNCE3=次に関連ツールのアップデートをしてから終了するわよ！

rem x264_enc.batのメッセージ
set OPTION_SUCCESS=x264オプション設定完了～♪
set X264_ENC_START=動画エンコ開始～♪
set PASS_ERROR=パス数の設定が間違ってるわよ！
set PASS_ANNOUNCE1=パス数自動設定モード～♪
set PASS_ANNOUNCE2=１pass目～♪
set PASS_ANNOUNCE3=２pass目～♪
set PASS_ANNOUNCE4=こ、こんなに大きいなんて聞いてないわよ・・・////（容量的な意味で
set PASS_ANNOUNCE5=も、もう１回ヤったら収まってくれるかしら？////（３pass的な意味で
set PASS_ANNOUNCE6=３pass目～♪
set PASS_ANNOUNCE7=強制1passモード～♪
set PASS_ANNOUNCE8=強制2passモード～♪
set PASS_ANNOUNCE9=強制3passモード～♪
set PASS_ANNOUNCE10=CRFエンコ～♪
