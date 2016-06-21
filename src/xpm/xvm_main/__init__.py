""" XVM (c) www.modxvm.com 2013-2016 """

#####################################################################
# MOD INFO

XFW_MOD_INFO = {
    # mandatory
    'VERSION':       '0.9.15.1',
    'URL':           'http://www.modxvm.com/',
    'UPDATE_URL':    'http://www.modxvm.com/en/download-xvm/',
    'GAME_VERSIONS': ['0.9.15.1'],
    # optional
}


#####################################################################
# imports

from pprint import pprint
from glob import glob
import os
import re
import time
import traceback

import BigWorld
import game
from account_helpers.settings_core import settings_constants
from account_helpers.settings_core.options import SettingsContainer
from account_helpers.settings_core.SettingsCore import g_settingsCore
from Avatar import PlayerAvatar
from BattleReplay import g_replayCtrl
from PlayerEvents import g_playerEvents
from Vehicle import Vehicle
from notification.actions_handlers import NotificationsActionsHandlers
from notification.decorators import MessageDecorator
from notification.settings import NOTIFICATION_TYPE
from gui.app_loader import g_appLoader
from gui.app_loader.settings import GUI_GLOBAL_SPACE_ID
from gui.battle_control import arena_info
from gui.battle_control.arena_info.settings import INVALIDATE_OP
from gui.battle_control.battle_arena_ctrl import BattleArenaController
from gui.battle_control.controllers.dyn_squad_functional import DynSquadFunctional
from gui.shared import g_eventBus, events
from gui.Scaleform.Flash import Flash
from gui.Scaleform.daapi.view.lobby.profile.ProfileTechniqueWindow import ProfileTechniqueWindow
from gui.Scaleform.daapi.view.lobby.hangar.AmmunitionPanel import AmmunitionPanel
from gui.Scaleform.daapi.view.battle.legacy.markers import MarkersManager
from gui.Scaleform.Minimap import Minimap

from xfw import *

from constants import *
import config
import filecache
from logger import *
import svcmsg
import utils
import vehstate
from xvm import g_xvm
import xmqp_events

_LOBBY_SWF = 'lobby.swf'
_BATTLE_SWF = 'battle.swf'
_VMM_SWF = 'VehicleMarkersManager.swf'
_SWFS = [_LOBBY_SWF, _BATTLE_SWF, _VMM_SWF]


#####################################################################
# initialization/finalization

def start():
    debug('start')

    g_appLoader.onGUISpaceEntered += g_xvm.onGUISpaceEntered

    g_eventBus.addListener(XFWCOMMAND.XFW_CMD, g_xvm.onXfwCommand)
    g_eventBus.addListener(XVM_EVENT.RELOAD_CONFIG, config.load)
    g_eventBus.addListener(XVM_EVENT.CONFIG_LOADED, g_xvm.onConfigLoaded)
    g_eventBus.addListener(XVM_EVENT.SYSTEM_MESSAGE, g_xvm.onSystemMessage)
    g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZED, g_xvm.onAppInitialized)
    g_eventBus.addListener(events.AppLifeCycleEvent.DESTROYED, g_xvm.onAppDestroyed)
    g_eventBus.addListener(XVM_EVENT.XMQP_CONNECTED, xmqp_events.onXmqpConnected)
    g_eventBus.addListener(XVM_EVENT.XMQP_MESSAGE, xmqp_events.onXmqpMessage)

    # config already loaded, just send event to apply required code
    g_eventBus.handleEvent(events.HasCtxEvent(XVM_EVENT.CONFIG_LOADED))

BigWorld.callback(0, start)


@registerEvent(game, 'fini')
def fini():
    debug('fini')

    g_appLoader.onGUISpaceEntered -= g_xvm.onGUISpaceEntered

    g_eventBus.removeListener(XFWCOMMAND.XFW_CMD, g_xvm.onXfwCommand)
    g_eventBus.removeListener(XVM_EVENT.RELOAD_CONFIG, config.load)
    g_eventBus.removeListener(XVM_EVENT.CONFIG_LOADED, g_xvm.onConfigLoaded)
    g_eventBus.removeListener(XVM_EVENT.SYSTEM_MESSAGE, g_xvm.onSystemMessage)
    g_eventBus.removeListener(events.AppLifeCycleEvent.INITIALIZED, g_xvm.onAppInitialized)
    g_eventBus.removeListener(events.AppLifeCycleEvent.DESTROYED, g_xvm.onAppDestroyed)
    g_eventBus.removeListener(XVM_EVENT.XMQP_CONNECTED, xmqp_events.onXmqpConnected)
    g_eventBus.removeListener(XVM_EVENT.XMQP_MESSAGE, xmqp_events.onXmqpMessage)

    filecache.fin()


#####################################################################
# handlers

# GLOBAL

@registerEvent(game, 'handleKeyEvent')
def game_handleKeyEvent(event):
    g_xvm.onKeyEvent(event)


# TODO:0.9.15.1
#@registerEvent(Flash, '__init__')
def FlashInit(self, swf, className='Flash', args=None, path=None):
    self.swf = swf
    if self.swf not in _SWFS:
        return

    log("FlashInit: " + self.swf)

    if self.swf == _BATTLE_SWF:
        g_xvm.initBattleSwf(self)
    elif self.swf == _VMM_SWF:
        g_xvm.initVmmSwf(self)


@overrideMethod(MessageDecorator, 'getListVO')
def _NotificationDecorator_getListVO(base, self):
    return svcmsg.fixData(base(self))


@overrideMethod(NotificationsActionsHandlers, 'handleAction')
def _NotificationsActionsHandlers_handleAction(base, self, model, typeID, entityID, actionName):
    if typeID == NOTIFICATION_TYPE.MESSAGE and re.match('https?://', actionName, re.I):
        BigWorld.wg_openWebBrowser(actionName)
    else:
        base(self, model, typeID, entityID, actionName)


# LOGIN

def onClientVersionDiffers():
    savedValue = g_replayCtrl.scriptModalWindowsEnabled
    g_replayCtrl.scriptModalWindowsEnabled = savedValue and not config.get('login/confirmOldReplays')
    g_replayCtrl.onClientVersionDiffers()
    g_replayCtrl.scriptModalWindowsEnabled = savedValue

g_replayCtrl._BattleReplay__replayCtrl.clientVersionDiffersCallback = onClientVersionDiffers


# LOBBY

@overrideMethod(ProfileTechniqueWindow, 'requestData')
def ProfileTechniqueWindow_RequestData(base, self, data):
    if data.vehicleId:
        base(self, data)


# PRE-BATTLE

def onArenaCreated():
    # debug('> onArenaCreated')
    g_xvm.onArenaCreated()

g_playerEvents.onArenaCreated += onArenaCreated


@overrideMethod(PlayerAvatar, 'onBecomePlayer')
def PlayerAvatar_onBecomePlayer(base, self):
    # debug('> onBecomePlayer')
    base(self)
    g_xvm.onBecomePlayer()

@overrideMethod(PlayerAvatar, 'onBecomeNonPlayer')
def PlayerAvatar_onBecomeNonPlayer(base, self):
    # debug('> onBecomeNonPlayer')
    g_xvm.onBecomeNonPlayer()
    base(self)


# BATTLE

# on current player enters world
@registerEvent(PlayerAvatar, 'onEnterWorld')
def PlayerAvatar_onEnterWorld(self, prereqs):
    # debug('> PlayerAvatar_onEnterWorld')
    g_xvm.onEnterWorld()

# on current player leaves world
@registerEvent(PlayerAvatar, 'onLeaveWorld')
def PlayerAvatar_onLeaveWorld(self):
    # debug('> PlayerAvatar_onLeaveWorld')
    g_xvm.onLeaveWorld()

# on any player marker appear
# TODO:0.9.15.1
#@registerEvent(PlayerAvatar, 'vehicle_onEnterWorld')
def PlayerAvatar_vehicle_onEnterWorld(self, vehicle):
    # debug("> PlayerAvatar_vehicle_onEnterWorld: hp=%i" % vehicle.health)
    g_xvm.invalidate(vehicle.id, INV.BATTLE_STATE)

# on any player marker lost
# TODO:0.9.15.1
#@registerEvent(PlayerAvatar, 'vehicle_onLeaveWorld')
def PlayerAvatar_vehicle_onLeaveWorld(self, vehicle):
    # debug("> PlayerAvatar_vehicle_onLeaveWorld: hp=%i" % vehicle.health)
    g_xvm.invalidate(vehicle.id, INV.BATTLE_STATE)

# on any vehicle hit received
# TODO:0.9.15.1
#@registerEvent(Vehicle, 'onHealthChanged')
def Vehicle_onHealthChanged(self, newHealth, attackerID, attackReasonID):
    # debug("> Vehicle_onHealthChanged: %i, %i, %i" % (newHealth, attackerID, attackReasonID))
    g_xvm.invalidate(self.id, INV.BATTLE_HP)

# add vid to players panel data
# TODO:0.9.15.1
#@overrideMethod(BattleArenaController, '_makeHash')
def BattleArenaController_makeHash(base, self, index, playerFullName, vInfoVO, *args):
    res = base(self, index, playerFullName, vInfoVO, *args)
    res['vid'] = vInfoVO.vehicleType.compactDescr
    return res

# spotted status
# TODO:0.9.15.1
#@registerEvent(Minimap, '_Minimap__addEntry')
def _Minimap__addEntry(self, vInfo, guiProps, location, doMark):
    # debug('> _Minimap__addEntry: {0}'.format(vInfo.vehicleID))
    vehstate.updateSpottedStatus(vInfo.vehicleID, True)
    g_xvm.invalidate(vInfo.vehicleID, INV.BATTLE_SPOTTED)

# TODO:0.9.15.1
#@registerEvent(Minimap, '_Minimap__delEntry')
def _Minimap__delEntry(self, id, inCallback=False):
    # debug('> _Minimap__delEntry: {0}'.format(id))
    vehstate.updateSpottedStatus(id, False)
    g_xvm.invalidate(id, INV.BATTLE_SPOTTED)

# Minimap settings
in_setupMinimapSettings = False
in_updateSettings = False

# TODO:0.9.15.1
#@overrideMethod(Minimap, 'setupMinimapSettings')
def _Minimap_setupMinimapSettings(base, self, diff = None):
    global in_setupMinimapSettings
    in_setupMinimapSettings = True
    base(self, diff)
    in_setupMinimapSettings = False


# TODO:0.9.15.1
#@overrideMethod(Minimap, '_Minimap__updateSettings')
def _Minimap__updateSettings(base, self):
    global in_updateSettings
    in_updateSettings = True
    base(self)
    in_updateSettings = False


# TODO:0.9.15.1
#@overrideMethod(g_settingsCore, 'getSetting')
def __g_settingsCore_getSetting(base, name):
    value = base(name)
    if config.get('minimap/enabled'):
        global in_setupMinimapSettings
        global in_updateSettings
        if in_setupMinimapSettings or in_updateSettings:
            if name == settings_constants.GAME.MINIMAP_DRAW_RANGE:
                if not config.get('minimap/useStandardCircles'):
                    value = False
            elif name == settings_constants.GAME.MINIMAP_MAX_VIEW_RANGE:
                if not config.get('minimap/useStandardCircles'):
                    value = False
            elif name == settings_constants.GAME.MINIMAP_VIEW_RANGE:
                if not config.get('minimap/useStandardCircles'):
                    value = False
            elif name == settings_constants.GAME.SHOW_VECTOR_ON_MAP:
                if not config.get('minimap/useStandardLines'):
                    value = False
            elif name == settings_constants.GAME.SHOW_SECTOR_ON_MAP:
                if not config.get('minimap/useStandardLines'):
                    value = False
            #debug('getSetting: {} = {}'.format(name, value))
    return value


# TODO:0.9.15.1
#@overrideMethod(SettingsContainer, 'getSetting')
def __SettingsContainer_getSetting(base, self, name):
    value = base(self, name)
    if config.get('minimap/enabled'):
        global in_setupMinimapSettings
        global in_updateSettings
        if in_setupMinimapSettings or in_updateSettings:
            if name == settings_constants.GAME.SHOW_VEH_MODELS_ON_MAP:
                if not config.get('minimap/useStandardLabels'):
                    value._set(0)
            #debug('getSetting: {} = {}'.format(name, value))
    return value


# TODO:0.9.15.1
#@overrideMethod(MarkersManager, 'invokeMarker')
def MarkersManager_invokeMarker(base, self, handle, function, args=None):
    # debug("> invokeMarker: %i, %s, %s" % (handle, function, str(args)))
    base(self, handle, function, g_xvm.extendVehicleMarkerArgs(handle, function, args))


# TODO:0.9.15.1
#@registerEvent(DynSquadFunctional, 'updateVehiclesInfo')
def _DynSquadFunctional_updateVehiclesInfo(self, updated, arenaDP):
    if arena_info.getArenaGuiType() == 1: # constants.ARENA_GUI_TYPE.RANDOM
        for flags, vo in updated:
            if flags & INVALIDATE_OP.PREBATTLE_CHANGED and vo.squadIndex > 0:
                for index, (vInfoVO, vStatsVO, viStatsVO) in enumerate(arenaDP.getTeamIterator(vo.team)):
                    if vInfoVO.squadIndex > 0:
                        g_xvm.invalidate(vInfoVO.vehicleID, INV.MARKER_SQUAD | INV.MINIMAP_SQUAD)


#cache._MIN_LIFE_TIME = 15
#cache._MAX_LIFE_TIME = 24
#
#@overrideMethod(CustomFilesCache, '_CustomFilesCache__get')
#def _CustomFilesCache__get(base, self, url, showImmediately, checkedInCache):
#    debug('_CustomFilesCache__get')
#    base(self, url, showImmediately, checkedInCache)
#@overrideMethod(CustomFilesCache, '_CustomFilesCache__readLocalFile')
#def _CustomFilesCache__readLocalFile(base, self, url, showImmediately):
#    debug('_CustomFilesCache__readLocalFile')
#    base(self, url, showImmediately)
#@overrideMethod(CustomFilesCache, '_CustomFilesCache__onReadLocalFile')
#def _CustomFilesCache__onReadLocalFile(base, self, url, showImmediately, file, d1, d2):
#    debug('_CustomFilesCache__onReadLocalFile')
#    base(self, url, showImmediately, file, d1, d2)
#@overrideMethod(CustomFilesCache, '_CustomFilesCache__checkFile')
#def _CustomFilesCache__checkFile(base, self, url, showImmediately):
#    debug('_CustomFilesCache__checkFile')
#    base(self, url, showImmediately)
#@overrideMethod(CustomFilesCache, '_CustomFilesCache__onCheckFile')
#def _CustomFilesCache__onCheckFile(base, self, url, showImmediately, res, d1, d2):
#    debug('_CustomFilesCache__onCheckFile')
#    base(self, url, showImmediately, res, d1, d2)
#@overrideMethod(CustomFilesCache, '_CustomFilesCache__readRemoteFile')
#def _CustomFilesCache__readRemoteFile(base, self, url, modified_time, showImmediately):
#    debug('_CustomFilesCache__readRemoteFile')
#    base(self, url, modified_time, showImmediately)
#@overrideMethod(CustomFilesCache, '_CustomFilesCache__onReadRemoteFile')
#def _CustomFilesCache__onReadRemoteFile(base, self, url, showImmediately, file, last_modified, expires):
#    debug('_CustomFilesCache__onReadRemoteFile')
#    base(self, url, showImmediately, file, last_modified, expires)
#@overrideMethod(CustomFilesCache, '_CustomFilesCache__prepareCache')
#def _CustomFilesCache__prepareCache(base, self):
#    debug('_CustomFilesCache__prepareCache')
#    base(self)
#@overrideMethod(CustomFilesCache, '_CustomFilesCache__writeCache')
#def _CustomFilesCache__writeCache(base, self, name, packet):
#    debug('_CustomFilesCache__writeCache')
#    base(self, name, packet)
#@overrideMethod(CustomFilesCache, '_CustomFilesCache__onWriteCache')
#def _CustomFilesCache__onWriteCache(base, self, name, d1, d2, d3):
#    debug('_CustomFilesCache__onWriteCache')
#    base(self, name, d1, d2, d3)
#@overrideMethod(CustomFilesCache, '_CustomFilesCache__postTask')
#def _CustomFilesCache__postTask(base, self, url, file, invokeAndReleaseCallbacks):
#    debug('_CustomFilesCache__postTask')
#    base(self, url, file, invokeAndReleaseCallbacks)
#@overrideMethod(CustomFilesCache, '_CustomFilesCache__onPostTask')
#def _CustomFilesCache__onPostTask(base, self, url, invokeAndReleaseCallbacks, file):
#    debug('_CustomFilesCache__onPostTask')
#    base(self, url, invokeAndReleaseCallbacks, file)
#@overrideMethod(WorkerThread, '_WorkerThread__run_download')
#def _WorkerThread__run_download(base, self, url, modified_time, callback, **params):
#    debug('_WorkerThread__run_download')
#    base(self, url, modified_time, callback, **params)


#####################################################################
# Log version info + warn about installed XVM fonts

log("xvm %s (%s) for WoT %s" % (XFW_MOD_INFO['VERSION'], XFW_MOD_INFO['URL'], ", ".join(XFW_MOD_INFO['GAME_VERSIONS'])))
try:
    from __version__ import __branch__, __revision__
    log("Branch: %s, Revision: %s" % (__branch__, __revision__))
    xvm_fonts_arr = glob(os.environ['WINDIR'] + '/Fonts/*xvm*')
    if len(xvm_fonts_arr):
        warn('Following XVM fonts installed: %s' % xvm_fonts_arr)
except Exception, ex:
    err(traceback.format_exc())

# load config
config.load(events.HasCtxEvent(XVM_EVENT.RELOAD_CONFIG, {'filename':XVM.CONFIG_FILE}))
