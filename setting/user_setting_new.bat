set USER_VERSION=30

rem ���������牺��K���ɘM���Ď����D�݂̐ݒ�ɂ��Ă���������

rem �����o�[�W�����`�F�b�N�@�\�̐ݒ�
rem �I���ɂ���ꍇ�́uDEFAULT_VERSION_CHECK=true�v�ɂ���i�f�t�H���g�������������j
rem �I�t�ɂ���ꍇ�́uDEFAULT_VERSION_CHECK=false�v�ɂ���i�������u��v�����j
set DEFAULT_VERSION_CHECK=true

rem ��ʃA�J�E���g�p�G���R�[�h�Ŗڎw�����r�b�g���[�g�ikbps�j
rem �r�b�g���[�g�I�[�o�[�ɂȂ�Ƃ��́A���̐��l��������(�����l��600)
set I_TARGET_BITRATE=600
rem ��ʃA�J�E���g�p�̌��E���r�b�g���[�g�ikbps�j
set I_MAX_BITRATE=654

rem �G�R�m�~�[���[�h���p�G���R�[�h�Ŗڎw�����r�b�g���[�g�ikbps�j
rem �r�b�g���[�g�I�[�o�[�ɂȂ�Ƃ��́A���̐��l��������(�����l��420)
set E_TARGET_BITRATE=420
rem �G�R�m�~�[���[�h���p�̌��E���r�b�g���[�g�ikbps�j
set E_MAX_BITRATE=445

rem �r�b�g���[�g��G���R�[�h�Ŋm�ۂ��Ă����]���r�b�g���[�g�ikbps�j
rem 3pass����ɘa�̂��߂Ɋm�ہi�����l��5�j
rem �ڕW�r�b�g���[�g�ɂ҂�����ɂ������ꍇ��0�ɂ���i�񐄏��j
set BITRATE_MARGIN=5

rem crf�G���R�ɐ؂�ւ��r�b�g���[�g��臒l�ikbps�j
rem ���̐��l�ȏ�̃r�b�g���[�g���w�肳�ꂽ�Ƃ���crf�G���R�ɐ؂�ւ��
rem crf�G���R�̌��ʃT�C�Y�I�[�o�[�����ꍇ�̓r�b�g���[�g�G���R�ɐ؂�ւ��
rem ���̂Ƃ��̃r�b�g���[�g�͎����I�ɍő�\�r�b�g���[�g�ɂȂ�
set BITRATE_THRESHOLD=2000

rem �j�R�j�R�V�d�l��2pass�G���R�ɐ؂�ւ��r�b�g���[�g��臒l�ikbps�j
rem ���̐��l�ȉ��̃r�b�g���[�g��CRF�G���R���ꂽ�Ƃ���2pass�G���R�ɐ؂�ւ��
rem H�͍��𑜓x�p�CM�͒��𑜓x�CL�͒�𑜓x�p
rem set BITRATE_NICO_NEW_THRESHOLD_H=2000
set BITRATE_NICO_NEW_THRESHOLD_H=3000
set BITRATE_NICO_NEW_THRESHOLD_M=1000
set BITRATE_NICO_NEW_THRESHOLD_L=600

rem �j�R�j�R�V�d�l��1pass�G���R�ɐ؂�ւ��r�b�g���[�g��臒l�ikbps�j
rem ���̐��l�ȉ��̃r�b�g���[�g��CRF�G���R���ꂽ�Ƃ���2pass�G���R�ɐ؂�ւ��
set BITRATE_NICO_NEW_THRESHOLD=6000

rem crf�G���R�̂Ƃ��̒l
rem ���l���������قǍ��掿��������������Ƃ��낢���肪�o��
rem YouTube�p�G���R�A�j�R�j�R�V��̂Ƃ���CRF_YOU���g�p����
rem �j�R�j�v���~�A���A�J��CRF_HIGH�̕��A��ʃA�J��CRF_LOW���g��
set CRF_YOU=18
set CRF_HIGH=23
set CRF_LOW=26

rem ��ʃA�J�E���g�̉𑜓x�̏���̐ݒ�
rem ���̃f�t�H���g��1280pixels�A�����̃f�t�H���g��720pixels
set I_MAX_WIDTH=1280
set I_MAX_HEIGHT=720

rem Twitter�̉𑜓x�̏���̐ݒ�
rem ���̃f�t�H���g��1920pixels�A�����̃f�t�H���g��1200pixels
set T_MAX_WIDTH=1920
set T_MAX_HEIGHT=1200

rem ���T�C�Y�̎��⎞��y�𓚂����Ƃ��̍����ƕ��̐ݒ�
rem �����̃f�t�H���g��480pixels�B�ς������Ƃ��́uDEFAULT_HEIGHT=720�v�Ȃǂ̂悤�ɂ���
rem ���́A�󗓂̂Ƃ��͎����v�Z�i����t�@�C���̃A�X�y�N�g����ێ��j
rem DEFAULT_HEIGHT_NEW_H�̓j�R�j�R�V�d�l���𑜓x�p
rem DEFAULT_HEIGHT_NEW_M�̓j�R�j�R�V�d�l���𑜓x�p
rem DEFAULT_HEIGHT_NEW_L�̓j�R�j�R�V�d�l��𑜓x�p
rem DEFAULT_HEIGHT_TWITTER��Twitter�p
rem �w�肵�����ꍇ�́uDEFAULT_WIDTH=640�v�Ȃǂ̂悤�ɂ���
rem ===============================�I���ӁI===================================
rem �o�[�W����2.72�����WIDTH�ł͂Ȃ�HEIGHT���w�肷��悤�Ɏd�l���ύX����܂���
rem ==========================================================================
set DEFAULT_WIDTH=
set DEFAULT_HEIGHT=480
rem set DEFAULT_HEIGHT_NEW_H=720
set DEFAULT_HEIGHT_NEW_H=1080
set DEFAULT_HEIGHT_NEW_M=540
set DEFAULT_HEIGHT_NEW_L=360
set DEFAULT_HEIGHT_TWITTER=1080

rem ���T�C�U�̎w��
rem Avisynth�̃��T�C�U����I��ł��������iSpline36Resize�ALanczos4Resize�Ȃǁj
rem �悭�킩��Ȃ��l�͋󗓂̂܂܂ɂ��Ă�������
set RESIZER=

rem �f�m�C�Y�̋���
rem RemoveGrain��mode
rem �悭�킩��Ȃ��l�͂��̂܂܂ɂ��Ă�������
set RG_MODE=5

rem FPS���w�肵�����Ƃ��́A�uDEFAULT_FPS=24�v�Ȃǂ̂悤�ɂ���
rem TWITTER_FPS��Twitter�p
rem ���̓���Ɠ����̂܂܂Ȃ�󗓂̂܂܂ɂ��Ă���
set DEFAULT_FPS=
set TWITTER_FPS=30

rem AAC�G���R�[�_�̑I���iffmpeg��QuickTime���j
rem ffmpeg��qt�iQuickTime���C���X�g�[������Ă�K�v������܂��j����I��
set AAC_ENCODER=ffmpeg

rem AAC�G���R�[�h�̃v���t�@�C���I��(hev2��AAC_ENCODER=nero�̎��̂ݗL��)
rem auto�Alc�Ahe�Ahev2����I��(�f�t�H���g��auto�𐄏�)
set AAC_PROFILE=auto

rem �����̃T���v�����[�g�̑I����
rem ����͘M��Ȃ����Ƃ����߂܂�
set SAMPLERATE_LIST1=44100
set SAMPLERATE_LIST2=48000
set SAMPLERATE_LIST3=96000

rem �ăG���R�n�T�C�g�����̉����r�b�g���[�g
rem ����͘M��Ȃ����Ƃ����߂܂�
set A_BITRATE_YOUTUBE=320
set A_BITRATE_NICO_NEW=256
set A_BITRATE_TWITTER=256

rem �f�R�[�_�̑I��
rem auto�Aavi�Affmpeg�Adirectshow�Aqt����I��(�f�t�H���g��auto�𐄏�)
rem auto�͎����I���Aavi��AVISource�Affmpeg��FFMpegSource�Adirectshow��DirectShowSource
rem qt��QuickTime(QuickTime7�ȍ~���K�v�ł��A�ꕔ�R�[�f�b�N�ł͔��ɒx���ł�)
rem qt�̓t�@�C�����E�t�H���_���Ȃǂɓ��{�ꓙ���܂܂�Ă���Ǝ��s����̂�
rem �A���t�@�x�b�g�݂̂ɂ���AC�h���C�u�����ɒu�������đΏ����Ă���g�p���Ă�������
rem �f�R�[�h����肭�����Ȃ��ꍇ�Adirectshow��ffmpeg���w�肷��Ƃ��܂��s���ꍇ��
set DECODER=auto

rem �J���[�}�g���N�X
rem �悭������Ȃ��ꍇ�͘M��Ȃ��̂��g
rem BT.601��BT.709��I������
set COLORMATRIX_SD=BT.601
set COLORMATRIX_HD=BT.709

rem �t�������W��L���ɂ������ꍇ��on�ɂ���
rem �t�������W�ɂ����ꍇ�̃f�����b�g(�v���C���[�݊���)��F�����Ă���l�̂ݎg�p���Ă�������
rem ������ƐF��Ԃ��l�����Ȃ��ƁAAvisynth�ŃG���[�ɂȂ�܂�
rem ���ɗ��R���Ȃ���΁A�f�t�H���g��off�𐄏�
set FULL_RANGE=off

rem MP4�̗e�ʂ̐ݒ�
rem �G���R�[�h��̗e�ʂ�100MB�i�v���A�J�j��40MB�i��ʃA�J�j�𒴂��Ă��܂��Ƃ�
rem ���̒l�����������Ă݂�Ƃ�������
rem DEFAULT_SIZE_PREMIUM���v���A�J�p�̐ݒ�ADEFAULT_SIZE_NOMAL����ʃA�J�p�̐ݒ�ADEFAULT_SIZE_PREMIUM_NEW�͐V��K�p�Ҍ����̐ݒ�
rem �����ݒ�́uDEFAULT_SIZE_PREMIUM=98.5�v�A�uDEFAULT_SIZE_NOMAL=39�v�uDEFAULT_SIZE_PREMIUM_NEW=1495�v
rem �e�ʃI�[�o�[����Ƃ��́uDEFAULT_SIZE_PREMIUM=98�v�A�uDEFAULT_SIZE_NOMAL=38�v�Ȃǂɂ��Ă݂�
set DEFAULT_SIZE_PREMIUM=98.5
set DEFAULT_SIZE_NORMAL=39
set DEFAULT_SIZE_PREMIUM_NEW=2995
rem YouTube�p�̐ݒ�
rem �����20480MB�iYouTube�p�[�g�i�[�j��2024MB�iYouTube��ʁj
set DEFAULT_SIZE_YOUTUBE_PARTNER=20000
set DEFAULT_SIZE_YOUTUBE_NORMAL=2000
rem Twitter�p�̐ݒ�
rem �����512MB
set DEFAULT_SIZE_TWITTER=510

rem �t�@�C���e�ʁi�ŏI�`�F�b�N�p�j
rem ����͘M��Ȃ����Ƃ����߂܂�
set MP4_FILESIZE_NICO_PREMIUM=104857600
set MP4_FILESIZE_NICO_NORMAL=41943040
set MP4_FILESIZE_NICO_NEW=3221225472
set MP4_FILESIZE_TWITTER=536870912

rem ����̒����Ɋւ���ݒ�i�P�ʂ͂��ׂĕb�j
rem YOUTUBE_DURATION��YouTube�p�[�g�i�[臒l�i�����l900�j
rem NICO_NEW_DURATION_H�̓j�R�j�R�V�d�l�̍��𑜓x臒l�i�����l959�j
rem NICO_NEW_DURATION_M�̓j�R�j�R�V�d�l�̒��𑜓x臒l�i�����l1859�j
rem TWITTER_DURATION��Twitter�̃A�b�v���[�h臒l�i�����l140�j
set YOUTUBE_DURATION=900
set NICO_NEW_DURATION_H=1859
set NICO_NEW_DURATION_M=3659

rem ���d�l�̃j�R�j�R�����G���R�[�h
rem �����ړI�̂݁itrue�ŗL�����j
set OLD_NICO_FEATURE=false

rem ZenzaWatch�Ή�
rem ��API���g��������v���C���[�����̋@�\�itrue�ŗL�����j
set ZENZA=false

rem �p�X���̐ݒ�i�摜�������̓���D&D�̂Ƃ��͂��̐ݒ�͖����ł��j
rem �����I��1pass��2pass��3pass�ɂ������Ƃ��͂�����M��
rem �uDEFAULT_PASS_**=1�v�uDEFAULT_PASS_**=2�v�uDEFAULT_PASS_**=3�v�ł��ꂼ��1pass�A2pass�A3pass����������
rem �uDEFAULT_PASS_**=0�v���Ǝ�������
rem 2pass��̃r�b�g���[�g����3pass���K�v���𔻒f�B1pass���O��crf�G���R����ꍇ����
rem ���x�d���A�o�����X�A�掿�d���̊e�v���Z�b�g���Ƃɐݒ肵�Ă�������
rem SPEED�ABALANCE�AQUALITY�����ꂼ�ꑬ�x�d���A�o�����X�A�掿�d����I�񂾎��̃p�X���ݒ�ɂȂ�܂�
set DEFAULT_PASS_SPEED=1
set DEFAULT_PASS_BALANCE=0
set DEFAULT_PASS_QUALITY=0

rem �G���R�[�h��Ƀv���C���[���J�����ǂ����i�J���ꍇ��y�A�J���Ȃ��ꍇ��n�j
rem �f�t�H���g��y�������߂��܂�
set MOVIE_CHECK=y

rem �v���C���[�̎�ށihtml5��flash�j
rem �f�t�H���g��html5
rem �C���X�g�[������Ă���Flash Player�̃o�[�W�����ɂ����Flash Player�ōĐ����ł��Ȃ��Ȃ�̂�
rem html5�ł̍Đ����������߂��܂��i�j�R�j�R�����̂���html5�ɂȂ�Ƃ̂��Ƃł��j
set MOVIE_PLAYER=html5

rem �t�@�C���̏o�͐�̎w��i�f�t�H���g�����j
rem �w�肵���t�H���_�ɓ�����mp4������ꍇ�͈ȑO�̃t�@�C����old.mp4�ɕς��Ă��܂��܂�
rem �܂��p�X�A�t�@�C�����ɓ��{�ꂪ����ꍇ�͕s����N����ꍇ������܂�
set MP4_DIR=..\MP4

rem �G���R�[�h�I����̋����i�f�t�H���g��n�����j
rem n���Ƃ��̂܂�(MP4�t�H���_���J���ɍs���܂�)�Ay����120�b�ҋ@��ɃV���b�g�_�E��
rem �����y�ɕς������Ƃő��̃A�v���P�[�V�����̖��ۑ��̃f�[�^�������Ă��ӔC�͎��܂���
set SHUTDOWN=n

rem ����ւ̕ԓ������炩���ߓ��͂��Ă����ƃh���b�O���h���b�v�̌ア����������ɓ����Ȃ��Ă��悭�Ȃ�܂�
rem ���ꂼ��C�R�[���̌��Ɏ���̓����������Ă��������i��F�uset ACTYPE=y�v�uset TEMP_BITRATE=160�v�j
rem ����`�����ێ��������ꍇ�̓C�R�[���̌��͋󗓂̂܂܂ɂ��Ă����Ă��������i�X�y�[�X�����ꂿ�Ⴞ�߁I�j

rem ���⃌�x���̑I���i1�`3�j
set Q_LEVEL=

rem �A�b�v���[�h��̑I���iy/n�j
set UP_SITE=

rem ===============================�I���ӁI===================================
rem ����ȍ~�̂������̐ݒ�́A�j�R�j�R�݂̂��AYouTube�݂̂ŗL���ɂȂ�܂�
rem ==========================================================================

rem �v���Z�b�g�I���il�`q,x����I���j�i�j�R�j�R�̂݁j
rem ===============================�I���ӁI===================================
rem ���⃌�x���u�������v�ł͂��̎���͔�\��
rem ==========================================================================
set PRETYPE=

rem �v���~�A���A�J�E���g���ۂ��iy/n�j�i�j�R�j�R�̂݁j
set ACTYPE=

rem �p�[�g�i�[�v���O�����ɓo�^���Ă��邩�ۂ��iy/n�j�iYouTube�̂݁j
set YTTYPE=

rem �v���~�A���A�J�E���g�̏ꍇ�̃r�b�g���[�g�i�j�R�j�R�̂݁j
rem ���͗�F�uset T_BITRATE=1500�v�i�P�ʂ�kbps�j
rem 0���Ɖ掿��̓K�؂ȃr�b�g���[�g�����E�r�b�g���[�g�������I��
rem ===============================�I���ӁI===================================
rem ���⃌�x���u�������v�ł͂��̎���͔�\��
rem ==========================================================================
set T_BITRATE=

rem �i����G���R�iy/n�A�܂���0�`51�̐����j�i�j�R�j�R�AYouTube�j
rem ===============================�I���ӁI===================================
rem ���⃌�x���u�������v�u�ӂ��v�ł͂��̎���͔�\��
rem ==========================================================================
set CRF_ENC=

rem �G�R����G���R�����掿�G���R���ie/h�j�i�j�R�j�R�̂݁j
rem ===============================�I���ӁI===================================
rem �o�[�W����2.72�����y/n�ł͂Ȃ�e/h�œ�����悤�ɂ悤�Ɏd�l���ύX����܂���
rem ���⃌�x���u�������v�u�ӂ��v�ł͂��̎���͔�\��
rem ==========================================================================
set ENCTYPE=

rem ��Đ����׃G���R�iy/n�j�i�j�R�j�R�̂݁j
rem ===============================�I���ӁI===================================
rem ���⃌�x���u�������v�u�ӂ��v�ł͂��̎���͔�\��
rem ==========================================================================
set DECTYPE=

rem FlashPlayer�ւ̑Ή�(1�`3����I���j�i�j�R�j�R�̂݁j
rem ===============================�I���ӁI===================================
rem ���⃌�x���u�������v�ł͂��̎���͔�\��
rem ==========================================================================
set FLASH=

rem �f�C���^�[���[�X�̑I���ia/y/n����I���j�i�j�R�j�R�AYouTube�j
rem ===============================�I���ӁI===================================
rem ���⃌�x���u�������v�u�ӂ��v�ł͂��̎���͔�\��
rem ==========================================================================
set DEINT=

rem ���T�C�Y�̑I���iy/n�Ȃǁj�i�j�R�j�R�̂݁j
rem ���l�𒼐ړ��͂���ꍇ�́uset RESIZE=640:360�v�Ȃǂ̂悤�ɋL��
rem ===============================�I���ӁI===================================
rem ���⃌�x���u�������v�ł͂��̎���͔�\��
rem ==========================================================================
set RESIZE=

rem �f�m�C�Y�̑I���ia/y/n/����I���j�i�j�R�j�R�AYouTube�j
rem a:�����Ay:�����An:����
rem ===============================�I���ӁI===================================
rem ���⃌�x���u�������v�u�ӂ��v�ł͂��̎���͔�\��
rem ==========================================================================
set DENOISE=

rem �����̃r�b�g���[�g�i�j�R�j�R�̂݁j
rem �uset TEMP_BITRATE=160�v�i160kbps�j�uset TEMP_BITRATE=0�v�i�����Ȃ��j
rem ===============================�I���ӁI===================================
rem ���⃌�x���u�������v�ł͂��̎���͔�\���E�������܂�
rem ==========================================================================
set TEMP_BITRATE=

rem �����̃T���v�����[�g(0�`3����I���j�i�j�R�j�R�AYouTube�j
rem 0:���̉����ƈꏏ�A1:44100Hz�A2:48000Hz�A3:96000Hz
rem ===============================�I���ӁI===================================
rem �o�[�W����2.72����̓T���v�����[�g�ł͂Ȃ�1�`3����̑I���ɕύX����܂���
rem ���⃌�x���u�������v�u�ӂ��v�ł͂��̎���͔�\��
rem ==========================================================================
set SAMPLERATE=

rem ���Y�������iy/n�Ȃǁj�i�j�R�j�R�AYouTube�j
rem �蓮�Ŏw�肷��Ƃ��́uAUDIO_SYNC=20�v�̂悤�ɐ����������i�P�ʂ̓~���b�j
rem �i���Ȃ�`���ɖ�����ǉ��A���Ȃ特���̖`�����J�b�g�j
rem ===============================�I���ӁI===================================
rem ���⃌�x���u�������v�ł͂��̎���͔�\��
rem ==========================================================================
set A_SYNC=

rem �Ō�̊m�F��ʁi�j�R�j�R�AYouTube�j
rem �X�L�b�v�������ꍇ�́uset SKIP_MODE=true�v�ɂ���
set SKIP_MODE=
