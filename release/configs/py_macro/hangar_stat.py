
#####################################################################
# calculate the number of wins to the desired percentage
# расчет количества побед до нужного процента

import traceback
from xvm_main.python.logger import *

from gui.Scaleform.daapi.view.lobby.hangar.Hangar import Hangar
from helpers import dependency
from skeletons.gui.game_control import IBootcampController
from skeletons.gui.shared import IItemsCache

@xvm.export('winrate_next')
def winrate_next(diff):
    if dependency.instance(IBootcampController).isInBootcamp():
        return
    itemsCache = dependency.instance(IItemsCache)
    wins = itemsCache.items.getAccountDossier().getRandomStats().getWinsCount()
    battles = itemsCache.items.getAccountDossier().getRandomStats().getBattlesCount()
    winrate = itemsCache.items.getAccountDossier().getRandomStats().getWinsEfficiency() * 100
    if wins is None or battles is None or winrate is None:
        return '-'
    f = winrate - int(winrate)
    if f < diff:
        next = int(winrate) + diff
    elif f + diff < 1:
        next = round(winrate,2) + diff
    else:
        next = int(winrate) + diff + 1
    value = int((100 * wins - next * battles) / (next - 100)) + 1
    if next == int(next):
        next = int(next)
    return '<font color="#F8F400">{}</font>{}<font color="#F8F400">{}%</font>'.format(value, '{{l10n:toWithSpaces}}', next)
