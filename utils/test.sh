#!/bin/sh

cd $(dirname $(realpath $(cygpath --unix $0)))

./deploy.sh

[ "$WOT_DIRECTORY" = "" ] && WOT_DIRECTORY=/cygdrive/d/work/games/WoT
CURRENT_DIRECTORY=`pwd`

SAMPLE_REPLAY=cw.wotreplay
#SAMPLE_REPLAY=markers.wotreplay
#SAMPLE_REPLAY=test.wotreplay

cd "${WOT_DIRECTORY}"
REPLAY=${CURRENT_DIRECTORY}/../utils/replays/${SAMPLE_REPLAY}
#cmd /c start ./WorldOfTanks.exe `cygpath --windows $REPLAY`
cmd /c start ./xvm-stat.exe `cygpath --windows $REPLAY` &
#cmd /c start ./xvm-stat.exe /server=CT `cygpath --windows $REPLAY` &
#cmd /c start PsExec.exe -d -a 2 ./xvm-stat.exe `cygpath --windows $REPLAY` &
