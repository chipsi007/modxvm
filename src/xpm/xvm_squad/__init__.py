""" XVM (c) www.modxvm.com 2013-2015 """

#####################################################################
# MOD INFO

XFW_MOD_INFO = {
    # mandatory
    'VERSION':       '3.1.0',
    'URL':           'http://www.modxvm.com/',
    'UPDATE_URL':    'http://www.modxvm.com/en/download-xvm/',
    'GAME_VERSIONS': ['0.9.9','0.9.10'],
    # optional
}


#####################################################################
# imports

import BigWorld
import game
from gui.shared import g_eventBus, g_itemsCache
from gui.Scaleform.daapi.view.lobby.prb_windows.SquadView import SquadView

from xfw import *

import xvm_main.python.config as config
from xvm_main.python.logger import *
from xvm_main.python.xvm import l10n
from xvm_main.python.vehinfo_tiers import getTiers


#####################################################################
# constants/globals

class COMMANDS(object):
    AS_UPDATE_TIERS = 'xvm_squad.as_update_tiers'
    WINDOW_POPULATED = 'xvm_squad.window_populated'
    WINDOW_DISPOSED = 'xvm_squad.window_disposed'

window_populated = False
squad_window_handler = None


#####################################################################
# initialization/finalization

def start():
    g_eventBus.addListener(XFWCOMMAND.XFW_CMD, onXfwCommand)

BigWorld.callback(0, start)


@registerEvent(game, 'fini')
def fini():
    g_eventBus.removeListener(XFWCOMMAND.XFW_CMD, onXfwCommand)


#####################################################################
# onXfwCommand

# returns: (result, status)
def onXfwCommand(cmd, *args):
    global window_populated
    if cmd == COMMANDS.WINDOW_POPULATED:
        window_populated = True
        squad_update_tiers(squad_window_handler) # squad_window_handler should be set by now
        return (None, True)
    if cmd == COMMANDS.WINDOW_DISPOSED:
        window_populated = False
        return (None, True)
    return (None, False)


#####################################################################
# handlers

@registerEvent(SquadView, '__init__')
def SquadView__init__(self, *args, **kwargs):
    squad_update_tiers(self, *args, **kwargs)


@registerEvent(SquadView, 'onUnitVehicleChanged')
def SquadView_onUnitVehicleChanged(self, *args, **kwargs):
    squad_update_tiers(self, *args, **kwargs)


def squad_update_tiers(self, *args, **kwargs):
    try:
        global squad_window_handler
        squad_window_handler = self
        if not window_populated:
            return
        min_tier = 0
        max_tier = 0
        squad_unitFunctional = self.unitFunctional.getUnit()[1]
        if not squad_unitFunctional:
            as_xfw_cmd(COMMANDS.AS_UPDATE_TIERS, '')
            return
        for squad_vehicle in squad_unitFunctional.getVehicles().values():
            veh = g_itemsCache.items.getItemByCD(squad_vehicle['vehTypeCompDescr'])
            (veh_tier_low, veh_tier_high) = getTiers(veh.level, veh.type, veh.name)
            min_tier = max(veh_tier_low, min_tier)
            max_tier = max(veh_tier_high, max_tier)

        text_tiers = ''
        if min_tier > 0:
            text_tiers = ' - %s: %s..%s' % (l10n('Squad battle tiers'), min_tier, max_tier)
        as_xfw_cmd(COMMANDS.AS_UPDATE_TIERS, text_tiers)
    except Exception, ex:
        err(traceback.format_exc())
