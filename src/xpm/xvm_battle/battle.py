""" XVM (c) www.modxvm.com 2013-2016 """

#####################################################################
# imports

import traceback
import weakref

import BigWorld
import game
import constants
from Avatar import PlayerAvatar
from Vehicle import Vehicle
from gui.app_loader import g_appLoader
from gui.app_loader.settings import APP_NAME_SPACE
from gui.shared import g_eventBus, events
from gui.shared.utils.functions import getBattleSubTypeBaseNumder
from gui.battle_control import g_sessionProvider, avatar_getter
from gui.battle_control.battle_constants import FEEDBACK_EVENT_ID
from gui.battle_control.battle_arena_ctrl import BattleArenaController
from gui.Scaleform.genConsts.BATTLE_VIEW_ALIASES import BATTLE_VIEW_ALIASES
from gui.Scaleform.daapi.settings.views import VIEW_ALIAS
from gui.Scaleform.daapi.view.battle.shared.damage_panel import DamagePanel
from gui.Scaleform.daapi.view.battle.shared.markers2d import settings as markers2d_settings

from xfw import *
from xvm_main.python.logger import *
import xvm_main.python.xmqp_events as xmqp_events

from commands import *
import shared

#####################################################################
# constants

# Invalidation targets

class INV(object):
    NONE                = 0x00000000
    VEHICLE_STATUS      = 0x00000001 # ready, alive, not_available, stop_respawn
    #PLAYER_STATUS       = 0x00000002 # isActionDisabled, isSelected, isSquadMan, isSquadPersonal, isTeamKiller, isVoipDisabled
    SQUAD_INDEX         = 0x00000008
    CUR_HEALTH          = 0x00000010
    MAX_HEALTH          = 0x00000020
    MARKS_ON_GUN        = 0x00000040
    SPOTTED_STATUS      = 0x00000080
    FRAGS               = 0x00000100
    HITLOG              = 0x00010000
    ALL_VINFO           = VEHICLE_STATUS | SQUAD_INDEX | FRAGS # | PLAYER_STATUS
    ALL_VSTATS          = FRAGS
    ALL_ENTITY          = CUR_HEALTH | MAX_HEALTH | MARKS_ON_GUN
    ALL                 = 0x0000FFFF

class SPOTTED_STATUS(object):
    NEVER_SEEN = 'neverSeen'
    SPOTTED = 'spotted'
    LOST = 'lost'
    DEAD = 'dead'


#####################################################################
# initialization/finalization

def start():
    g_eventBus.addListener(XFWCOMMAND.XFW_CMD, g_battle.onXfwCommand)
    g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZED, g_battle.onAppInitialized)
    g_eventBus.addListener(events.AppLifeCycleEvent.DESTROYED, g_battle.onAppDestroyed)

BigWorld.callback(0, start)

@registerEvent(game, 'fini')
def fini():
    g_eventBus.removeListener(XFWCOMMAND.XFW_CMD, g_battle.onXfwCommand)
    g_eventBus.removeListener(events.AppLifeCycleEvent.INITIALIZED, g_battle.onAppInitialized)
    g_eventBus.removeListener(events.AppLifeCycleEvent.DESTROYED, g_battle.onAppDestroyed)


#####################################################################
# handlers

# PRE-BATTLE

@overrideMethod(PlayerAvatar, 'onBecomePlayer')
def _PlayerAvatar_onBecomePlayer(base, self):
    base(self)
    try:
        player = BigWorld.player()
        if player is not None and hasattr(player, 'arena'):
            arena = BigWorld.player().arena
            if arena:
                arena.onVehicleKilled += g_battle.onVehicleKilled
                arena.onAvatarReady += g_battle.onAvatarReady
                arena.onVehicleStatisticsUpdate += g_battle.onVehicleStatisticsUpdate
        ctrl = g_sessionProvider.shared.feedback
        if ctrl:
            ctrl.onMinimapVehicleAdded += g_battle.onMinimapVehicleAdded
            ctrl.onMinimapVehicleRemoved += g_battle.onMinimapVehicleRemoved
            ctrl.onVehicleFeedbackReceived += g_battle.onVehicleFeedbackReceived
        g_battle.onStartBattle()
    except Exception, ex:
        err(traceback.format_exc())

@overrideMethod(PlayerAvatar, 'onBecomeNonPlayer')
def _PlayerAvatar_onBecomeNonPlayer(base, self):
    try:
        player = BigWorld.player()
        if player is not None and hasattr(player, 'arena'):
            arena = BigWorld.player().arena
            if arena:
                arena.onVehicleKilled -= g_battle.onVehicleKilled
                arena.onAvatarReady -= g_battle.onAvatarReady
                arena.onVehicleStatisticsUpdate -= g_battle.onVehicleStatisticsUpdate
        ctrl = g_sessionProvider.shared.feedback
        if ctrl:
            ctrl.onMinimapVehicleAdded -= g_battle.onMinimapVehicleAdded
            ctrl.onMinimapVehicleRemoved -= g_battle.onMinimapVehicleRemoved
            ctrl.onVehicleFeedbackReceived -= g_battle.onVehicleFeedbackReceived
    except Exception, ex:
        err(traceback.format_exc())
    base(self)


# BATTLE

# on current player enters world
#@registerEvent(PlayerAvatar, 'onEnterWorld')
#def _PlayerAvatar_onEnterWorld(self, prereqs):
#    pass

# on current player leaves world
#@registerEvent(PlayerAvatar, 'onLeaveWorld')
#def _PlayerAvatar_onLeaveWorld(self):
#    pass

# on any player marker appear
@registerEvent(PlayerAvatar, 'vehicle_onEnterWorld')
def _PlayerAvatar_vehicle_onEnterWorld(self, vehicle):
    # debug("> _PlayerAvatar_vehicle_onEnterWorld: hp=%i" % vehicle.health)
    g_battle.updatePlayerState(vehicle.id, INV.ALL)

# on any player marker lost
#@registerEvent(PlayerAvatar, 'vehicle_onLeaveWorld')
#def _PlayerAvatar_vehicle_onLeaveWorld(self, vehicle):
#    # debug("> _PlayerAvatar_vehicle_onLeaveWorld: hp=%i" % vehicle.health)
#    pass

# update self vehicle health
@registerEvent(PlayerAvatar, 'updateVehicleHealth')
def PlayerAvatar_updateVehicleHealth(self, vehicleID, health, *args, **kwargs):
    g_battle.updatePlayerState(self.id, INV.CUR_HEALTH)

# on vehicle info updated
@registerEvent(BattleArenaController, 'updateVehiclesInfo')
def _BattleArenaController_updateVehiclesInfo(self, updated, arenaDP):
    # debug("> _BattleArenaController_updateVehiclesInfo")
    try:
        # is dynamic squad created
        if BigWorld.player().arena.guiType == constants.ARENA_GUI_TYPE.RANDOM:
            for flags, vo in updated:
                if flags & INVALIDATE_OP.PREBATTLE_CHANGED and vo.squadIndex > 0:
                    for index, (vInfoVO, vStatsVO, viStatsVO) in enumerate(arenaDP.getTeamIterator(vo.team)):
                        if vInfoVO.squadIndex > 0:
                            g_battle.updatePlayerState(vehicleID, INV.SQUAD_INDEX) # | INV.PLAYER_STATUS
    except Exception, ex:
        err(traceback.format_exc())

@registerEvent(DamagePanel, '_updateDeviceState')
def _DamagePanel_updateDeviceState(self, value):
    try:
        as_xfw_cmd(XVM_BATTLE_COMMAND.AS_UPDATE_DEVICE_STATE, *value)
    except:
        err(traceback.format_exc())

#####################################################################
# Battle

class Battle(object):

    battle_page = None

    def onAppInitialized(self, event):
        app = g_appLoader.getApp(event.ns)
        if app is not None and app.loaderManager is not None:
            app.loaderManager.onViewLoaded += self.onViewLoaded

    def onAppDestroyed(self, event):
        if event.ns == APP_NAME_SPACE.SF_BATTLE:
            self.battle_page = None
        app = g_appLoader.getApp(event.ns)
        if app is not None and app.loaderManager is not None:
            app.loaderManager.onViewLoaded -= self.onViewLoaded

    def onViewLoaded(self, view=None):
        if not view:
            return
        if view.uniqueName == VIEW_ALIAS.CLASSIC_BATTLE_PAGE:
            self.battle_page = weakref.proxy(view)

    def onStartBattle(self):
        self._spotted_cache = {}

    def getSpottedStatus(self, vehicleID):
        return self._spotted_cache.get(vehicleID, SPOTTED_STATUS.NEVER_SEEN)

    def onVehicleKilled(self, victimID, *args):
        self._spotted_cache[victimID] = SPOTTED_STATUS.DEAD
        self.updatePlayerState(victimID, INV.VEHICLE_STATUS | INV.CUR_HEALTH | INV.SPOTTED_STATUS)

    def onAvatarReady(self, vehicleID):
        self.updatePlayerState(vehicleID, INV.VEHICLE_STATUS)

    def onVehicleStatisticsUpdate(self, vehicleID):
        self.updatePlayerState(vehicleID, INV.FRAGS)

    def onMinimapVehicleAdded(self, vProxy, vInfo, guiProps):
        self._spotted_cache[vInfo.vehicleID] = SPOTTED_STATUS.SPOTTED
        self.updatePlayerState(vInfo.vehicleID, INV.SPOTTED_STATUS)

    def onMinimapVehicleRemoved(self, vehicleID):
        self._spotted_cache[vehicleID] = SPOTTED_STATUS.LOST
        self.updatePlayerState(vehicleID, INV.SPOTTED_STATUS)

    def onVehicleFeedbackReceived(self, eventID, vehicleID, value):
        if eventID == FEEDBACK_EVENT_ID.VEHICLE_HEALTH:
            inv = INV.CUR_HEALTH
            userData = None
            (newHealth, aInfo, attackReasonID) = value
            if aInfo is not None and aInfo.vehicleID == BigWorld.player().playerVehicleID:
                inv |= INV.HITLOG
                userData = {'damageFlag':self._getVehicleDamageType(aInfo),
                            'damageType':constants.ATTACK_REASONS[attackReasonID]}
            self.updatePlayerState(vehicleID, inv, userData)

    def updatePlayerState(self, vehicleID, targets, userData=None):
        try:
            data = {}

            if targets & INV.SPOTTED_STATUS:
                data['spottedStatus'] = self.getSpottedStatus(vehicleID)

            if targets & INV.HITLOG:
                data['__hitlogData'] = userData

            if targets & INV.ALL_ENTITY:
                entity = BigWorld.entity(vehicleID)

                if targets & INV.CUR_HEALTH:
                    if entity and hasattr(entity, 'health'):
                        data['curHealth'] = entity.health

                if targets & INV.MAX_HEALTH:
                    if entity and hasattr(entity, 'typeDescriptor'):
                        data['maxHealth'] = entity.typeDescriptor.maxHealth

                if targets & INV.MARKS_ON_GUN:
                    if entity and hasattr(entity, 'publicInfo'):
                        data['marksOnGun'] = entity.publicInfo.marksOnGun

            if targets & (INV.ALL_VINFO | INV.ALL_VSTATS):
                arenaDP = g_sessionProvider.getArenaDP()
                if targets & INV.ALL_VINFO:
                    vInfoVO = arenaDP.getVehicleInfo(vehicleID)
                if targets & INV.ALL_VSTATS:
                    vStatsVO = arenaDP.getVehicleStats(vehicleID)

                if targets & INV.VEHICLE_STATUS:
                    data['vehicleStatus'] = vInfoVO.vehicleStatus

                if targets & INV.SQUAD_INDEX:
                    data['squadIndex'] = vInfoVO.squadIndex

                # why vInfoVO.playerStatus == 0?
                #if targets & INV.PLAYER_STATUS:
                #    data['playerStatus'] = vInfoVO.playerStatus
                
                if targets & INV.FRAGS:
                    data['frags'] = vStatsVO.frags

            as_xfw_cmd(XVM_BATTLE_COMMAND.AS_UPDATE_PLAYER_STATE, vehicleID, data)
        except Exception, ex:
            err(traceback.format_exc())

    def invalidateArenaInfo(self):
        #debug('battle: invalidateArenaInfo')
        if self.battle_page:
            ctrl = self.battle_page.getComponent(BATTLE_VIEW_ALIASES.BATTLE_STATISTIC_DATA_CONTROLLER)
            if ctrl:
                ctrl._BattleStatisticsDataController__setArenaDescription()
                arenaDP = ctrl._battleCtx.getArenaDP()
                ctrl.invalidateVehiclesInfo(arenaDP)
                ctrl.invalidateVehiclesStats(arenaDP)
            # update vehicles data
            for (vehicleID, vData) in BigWorld.player().arena.vehicles.iteritems():
                self.updatePlayerState(vehicleID, INV.ALL)


    #####################################################################
    # onXfwCommand

    # returns: (result, status)
    def onXfwCommand(self, cmd, *args):
        try:
            if cmd == XVM_BATTLE_COMMAND.REQUEST_BATTLE_GLOBAL_DATA:
                as_xfw_cmd(XVM_BATTLE_COMMAND.AS_RESPONSE_BATTLE_GLOBAL_DATA, *shared.getGlobalBattleData())
                return (None, True)

            elif cmd == XVM_BATTLE_COMMAND.BATTLE_CTRL_SET_VEHICLE_DATA:
                self.invalidateArenaInfo()
                return (None, True)

            elif cmd == XVM_BATTLE_COMMAND.CAPTURE_BAR_GET_BASE_NUM_TEXT:
                n = int(args[0])
                res = getBattleSubTypeBaseNumder(BigWorld.player().arenaTypeID, n & 0x3F, n >> 6)
                return (res, True)

            elif cmd == XVM_BATTLE_COMMAND.MINIMAP_CLICK:
                return (xmqp_events.send_minimap_click(args[0]), True)

        except Exception, ex:
            err(traceback.format_exc())
            return (None, True)

        return (None, False)

    # misc

    def _getVehicleDamageType(self, attackerInfo):
        if not attackerInfo:
            return markers2d_settings.DAMAGE_TYPE.FROM_UNKNOWN
        attackerID = attackerInfo.vehicleID
        if attackerID == avatar_getter.getPlayerVehicleID():
            return markers2d_settings.DAMAGE_TYPE.FROM_PLAYER
        entityName = g_sessionProvider.getCtx().getPlayerGuiProps(attackerID, attackerInfo.team)
        if entityName == PLAYER_GUI_PROPS.squadman:
            return markers2d_settings.DAMAGE_TYPE.FROM_SQUAD
        if entityName == PLAYER_GUI_PROPS.ally:
            return markers2d_settings.DAMAGE_TYPE.FROM_ALLY
        if entityName == PLAYER_GUI_PROPS.enemy:
            return markers2d_settings.DAMAGE_TYPE.FROM_ENEMY
        return markers2d_settings.DAMAGE_TYPE.FROM_UNKNOWN

g_battle = Battle()
