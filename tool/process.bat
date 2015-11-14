@echo off
echo;
echo Process Started...
set /p start_mark=0%%^|<nul
:process_start
set /p mark=#<nul
ping localhost -n 2 >nul
if exist %PROCESS_S_FILE% goto process_start 

echo ^|100%%
echo Process End.
echo;

echo e>%PROCESS_E_FILE%
ping localhost -n 2 >nul

exit