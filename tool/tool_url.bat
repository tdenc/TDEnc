@echo off

call "version.bat"

set VER_URL="https://raw.githubusercontent.com/tdenc/TDEnc/master/tool/current_version"
set VER_PATH=".\latest_version"

set UPD_URL="https://github.com/tdenc/TDEnc/archive/master.zip"
set UPD_PATH="..\Archives\update.zip"

set LOG_URL="https://raw.githubusercontent.com/tdenc/TDEnc/master/tool/ChangeLog"
set LOG_PATH=".\ChangeLog"

set AVS_URL="http://jaist.dl.sourceforge.net/project/avisynth2/AviSynth%%202.6/AviSynth%%202.6.0/AviSynth_260.exe"
set AVS_PATH="..\Archives\Avisynth_260.exe"
set AVS_SIZE=6514961

set DIL_URL="http://jaist.dl.sourceforge.net/project/openil/DevIL%%20Win32/1.7.8/DevIL-EndUser-x86-1.7.8.zip"
set DIL_PATH="..\Archives\DevIL-EndUser-x86-1.7.8.zip"
set DIL_SIZE=676737

set FSS_URL="https://github.com/FFMS/ffms2/releases/download/2.21/ffms2-2.21-msvc.7z"
set FSS_PATH="..\Archives\ffms2-2.21-msvc.7z"
set FSS_SIZE=5725921

set RG1_URL="https://drive.google.com/uc?id=0B0If6OXG2yfVVExEZ2lOZGVDOVU"
set RG1_PATH="..\Archives\RemoveGrain64.zip"
set RG1_SIZE=157912

set QTS_URL="https://drive.google.com/uc?id=0B0If6OXG2yfVTWc4ZUdSMWxRSXM"
set QTS_PATH="..\Archives\QTSource.zip"
set QTS_SIZE=71577

set MIF_URL="http://jaist.dl.sourceforge.net/project/mediainfo/binary/mediainfo/0.7.61/MediaInfo_CLI_0.7.61_Windows_i386.zip"
set MIF_PATH="..\Archives\MediaInfo_CLI_0.7.61_Windows_i386.zip"
set MIF_SIZE=1437806

set YDF_URL="https://drive.google.com/uc?id=0B0If6OXG2yfVUE0xTkJJdXNJUU0"
set YDF_PATH="..\Archives\yadif17.zip"
set YDF_SIZE=52095

set A2P_URL="https://drive.google.com/uc?id=0B0If6OXG2yfVdURBTXdNMmZFQU0"
set A2P_PATH="..\Archives\avs2pipe-0.0.3.zip"
set A2P_SIZE=77539

set WVI_URL="https://drive.google.com/uc?id=0B0If6OXG2yfVZXl5ZlNWcDRqU1U"
set WVI_PATH="..\Archives\wavi106.zip"
set WVI_SIZE=24271

set NERO_URL="http://ftp6.nero.com/tools/NeroAACCodec-1.5.1.zip"
set NERO_PATH="..\Archives\NeroAACCodec-1.5.1.zip"
set NERO_SIZE=2050564

set X264_VERSION=2692
set X264_URL="http://komisar.gin.by/old/2692/x264.2692.x86.exe"
set X264_PATH="..\Archives\x264.exe"
