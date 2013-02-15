@echo off

set swfs=battle.swf battleloading.swf PlayersPanel.swf StatisticForm.swf TeamBasesPanel.swf VehicleMarkersManager.swf Minimap.swf FinalStatistic.swf UserInfo.swf

for %%i in (%swfs%) do call :do_file %%~ni

goto :EOF

:do_file
set n=%1
if not exist %n%.xml (
  echo %n%.swf
  swfmill swf2xml orig\%n%.swf orig\%n%.xml
  swfmill swf2xml %n%.swf %n%.xml
  diff -u -I "<StackDouble value=" orig\%n%.xml %n%.xml > %n%.xml.patch
  del orig\%n%.xml %n%.xml
)
goto :EOF
