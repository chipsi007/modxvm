﻿import BigWorld
from xfw import *
from xvm_main.python.logger import *
import xvm_main.python.vehinfo_xtdb as vehinfo_xtdb
import xvm_main.python.config as config
from Vehicle import Vehicle
from Avatar import PlayerAvatar
from constants import VEHICLE_SIEGE_STATE
# from gui.battle_control import g_sessionProvider
from gui.battle_control.battle_constants import PERSONAL_EFFICIENCY_TYPE
from gui.Scaleform.daapi.view.battle.shared.damage_log_panel import DamageLogPanel
from gui.Scaleform.daapi.view.battle.shared.ribbons_panel import BattleRibbonsPanel

totalDamage = 0
damage = 0
old_totalDamage = 0
totalAssist = 0
totalBlocked = 0
maxHealth = 0
damageReceived = 0
vehiclesHealth = {}
damagesSquad = 0
detection = 0
numberHitsBlocked = 0
vehCD = None
player = None
numberHitsDealt = 0
numberShotsDealt = 0
numberDamagesDealt = 0
numberShotsReceived = 0
numberHitsReceived = 0

ribbonTypes = {
    'armor': 0,
    'damage': 0,
    'ram': 0,
    'burn': 0,
    'kill': [0, 0],
    'teamKill': [0, 0],
    'spotted': [0, 0],
    'assistTrack': 0,
    'assistSpot': 0,
    'crits': [0, 0],
    'capture': 0,
    'defence': 0,
    'assist': 0
}


@registerEvent(Vehicle, 'showShooting')
def _showShooting(self, burstCount, isPredictedShot=False):
    blockShooting = self.siegeState is not None and self.siegeState != VEHICLE_SIEGE_STATE.ENABLED and self.siegeState != VEHICLE_SIEGE_STATE.DISABLED
    if self.isPlayerVehicle and self.isStarted and not blockShooting:
        global numberShotsDealt
        numberShotsDealt += 1
        as_event('ON_TOTAL_EFFICIENCY')

@registerEvent(Vehicle, 'showDamageFromShot')
def showDamageFromShot(self, attackerID, points, effectsIndex, damageFactor):
    global numberShotsReceived, numberHitsReceived
    if self.isPlayerVehicle and self.isAlive:
        numberShotsReceived += 1
        if damageFactor != 0:
            numberHitsReceived += 1
        as_event('ON_TOTAL_EFFICIENCY')


@registerEvent(DamageLogPanel, '_onTotalEfficiencyUpdated')
def _onTotalEfficiencyUpdated(self, diff):
    global totalDamage, totalAssist, totalBlocked, numberHitsBlocked, old_totalDamage, damage
    if player is not None:
        if hasattr(player.inputHandler.ctrl, 'curVehicleID'):
            vId = player.inputHandler.ctrl.curVehicleID
            v = vId.id if isinstance(vId, Vehicle) else vId
        else:
            v = player.playerVehicleID
        if player.playerVehicleID == v:
            if PERSONAL_EFFICIENCY_TYPE.DAMAGE in diff:
                totalDamage = diff[PERSONAL_EFFICIENCY_TYPE.DAMAGE]
                damage = totalDamage - old_totalDamage
                old_totalDamage = totalDamage
            if PERSONAL_EFFICIENCY_TYPE.ASSIST_DAMAGE in diff:
                totalAssist = diff[PERSONAL_EFFICIENCY_TYPE.ASSIST_DAMAGE]
            if PERSONAL_EFFICIENCY_TYPE.BLOCKED_DAMAGE in diff:
                totalBlocked = diff[PERSONAL_EFFICIENCY_TYPE.BLOCKED_DAMAGE]
                if totalBlocked == 0:
                    numberHitsBlocked = 0
                else:
                    numberHitsBlocked += 1
            as_event('ON_TOTAL_EFFICIENCY')


@registerEvent(BattleRibbonsPanel, '_BattleRibbonsPanel__addBattleEfficiencyEvent')
def addBattleEfficiencyEvent(self, ribbonType = '', leftFieldStr = '', vehName = '', vehType = '', rightFieldStr = ''):
    global ribbonTypes, numberDamagesDealt
    if player is not None:
        if hasattr(player.inputHandler.ctrl, 'curVehicleID'):
            vId = player.inputHandler.ctrl.curVehicleID
            v = vId.id if isinstance(vId, Vehicle) else vId
        else:
            v = player.playerVehicleID
        if player.playerVehicleID == v:
            if ribbonType in ['assistTrack']:
                ribbonTypes[ribbonType] = (totalAssist - ribbonTypes['assistSpot']) if totalAssist else 0
            if ribbonType in ['assistSpot']:
                ribbonTypes[ribbonType] = (totalAssist - ribbonTypes['assistTrack']) if totalAssist else 0
            if ribbonType in ['spotted', 'kill', 'teamKill', 'crits']:
                if leftFieldStr:
                    ribbonTypes[ribbonType][1] = ribbonTypes[ribbonType][0] + int(leftFieldStr[1:])
                else:
                    ribbonTypes[ribbonType][1] += 1
            if ribbonType in ['damage', 'ram', 'burn']:
                numberDamagesDealt += 1
            as_event('ON_TOTAL_EFFICIENCY')


@registerEvent(BattleRibbonsPanel, 'onHide')
def _onHide(self, ribbonType):
    global ribbonTypes
    if player is not None:
        if hasattr(player.inputHandler.ctrl, 'curVehicleID'):
            vId = player.inputHandler.ctrl.curVehicleID
            v = vId.id if isinstance(vId, Vehicle) else vId
        else:
            v = player.playerVehicleID
        if player.playerVehicleID == v:
            if ribbonType in ['spotted', 'kill', 'teamKill', 'crits']:
                ribbonTypes[ribbonType][0] = ribbonTypes[ribbonType][1]


@registerEvent(Vehicle, 'onHealthChanged')
def onHealthChanged(self, newHealth, attackerID, attackReasonID):
    global vehiclesHealth, numberHitsDealt, damageReceived, numberDamagesDealt
    isUpdate = False
    if self.isPlayerVehicle:
        damageReceived = maxHealth - max(0, newHealth)
        # if attackReasonID in [0, 2]:
        #     numberDamagesDealt += 1
        isUpdate = True
    if player is not None:
        if self.id in vehiclesHealth:
            damage = vehiclesHealth[self.id] - max(0, newHealth)
            vehiclesHealth[self.id] = newHealth
            attacker = player.arena.vehicles.get(attackerID)
            if player.guiSessionProvider.getArenaDP().isSquadMan(vID=attackerID) and attacker['name'] != player.name:
                global damagesSquad
                damagesSquad += damage
                isUpdate = True
        if (attackerID == player.playerVehicleID) and (attackReasonID == 0):
            numberHitsDealt += 1
            isUpdate = True
    if isUpdate:
        as_event('ON_TOTAL_EFFICIENCY')


@registerEvent(Vehicle, 'onEnterWorld')
def onEnterWorld(self, prereqs):
    global player
    player = BigWorld.player()
    if self.publicInfo['team'] != player.team:
        global vehiclesHealth
        vehiclesHealth[self.id] = self.health
    if self.isPlayerVehicle:
        global maxHealth, vehCD
        vehCD = self.typeDescriptor.type.compactDescr
        maxHealth = self.health


@registerEvent(PlayerAvatar, '_PlayerAvatar__destroyGUI')
def destroyGUI(self):
    global vehiclesHealth, totalDamage, totalAssist, totalBlocked, damageReceived, damagesSquad, detection
    global ribbonTypes, numberHitsBlocked, player, numberHitsDealt, old_totalDamage, damage, numberShotsDealt
    global numberDamagesDealt, numberShotsReceived, numberHitsReceived
    vehiclesHealth = {}
    totalDamage = 0
    damage = 0
    old_totalDamage = 0
    totalAssist = 0
    totalBlocked = 0
    damageReceived = 0
    damagesSquad = 0
    detection = 0
    numberHitsBlocked = 0
    player = None
    numberHitsDealt = 0
    numberShotsDealt = 0
    numberDamagesDealt = 0
    numberShotsReceived = 0
    numberHitsReceived = 0
    ribbonTypes = {
        'armor': 0,
        'damage': 0,
        'ram': 0,
        'burn': 0,
        'kill': [0, 0],
        'teamKill': [0, 0],
        'spotted': [0, 0],
        'assistTrack': 0,
        'assistSpot': 0,
        'crits': [0, 0],
        'capture': 0,
        'defence': 0,
        'assist': 0
    }


@xvm.export('xvm.totalDamageColor', deterministic=False)
def xvm_totalDamageColor():
    x = vehinfo_xtdb.calculateXTDB(vehCD, totalDamage)
    for val in config.get('colors/x'):
        if val['value'] > x:
            return '#' + val['color'][2:] if val['color'][:2] == '0x' else val['color']


@xvm.export('xvm.totalDamage', deterministic=False)
def xvm_totalDamage():
    return totalDamage


@xvm.export('xvm.totalAssist', deterministic=False)
def xvm_totalAssist():
    return totalAssist


@xvm.export('xvm.totalBlocked', deterministic=False)
def xvm_totalBlocked():
    return totalBlocked


@xvm.export('xvm.damageReceived', deterministic=False)
def xvm_damageReceived():
    return damageReceived


@xvm.export('xvm.totalDamagesBlocked', deterministic=False)
def xvm_totalDamagesBlocked():
    return totalDamage + totalBlocked


@xvm.export('xvm.totalDamagesAssist', deterministic=False)
def xvm_totalDamagesAssist():
    return totalDamage + totalAssist


@xvm.export('xvm.totalDamagesBlockedAssist', deterministic=False)
def xvm_totalDamagesBlockedAssist():
    return totalDamage + totalAssist + totalBlocked


@xvm.export('xvm.totalDamagesBlockedReceived', deterministic=False)
def xvm_totalDamagesBlockedReceived():
    return totalDamage + totalBlocked + damageReceived


@xvm.export('xvm.totalBlockedReceived', deterministic=False)
def xvm_totalBlockedReceived():
    return totalBlocked + damageReceived


@xvm.export('xvm.totalDamagesSquad', deterministic=False)
def xvm_totalDamagesSquad():
    return damagesSquad + totalDamage


@xvm.export('xvm.damagesSquad', deterministic=False)
def xvm_damagesSquad():
    return damagesSquad


@xvm.export('xvm.detection', deterministic=False)
def xvm_detection():
    return ribbonTypes['spotted'][1]


@xvm.export('xvm.frags', deterministic=False)
def xvm_frags():
    return ribbonTypes['kill'][1]


@xvm.export('xvm.assistTrack', deterministic=False)
def xvm_assistTrack():
    return ribbonTypes['assistTrack']


@xvm.export('xvm.assistSpot', deterministic=False)
def xvm_assistSpot():
    return ribbonTypes['assistSpot']


@xvm.export('xvm.crits', deterministic=False)
def xvm_crits():
    return ribbonTypes['crits'][1]


@xvm.export('xvm.numberHitsBlocked', deterministic=False)
def xvm_numberHitsBlocked():
    return numberHitsBlocked


@xvm.export('xvm.numberHitsDealt', deterministic=False)
def xvm_numberHitsDealt():
    return numberHitsDealt


@xvm.export('xvm.numberDamagesDealt', deterministic=False)
def xvm_numberDamagesDealt():
    return numberDamagesDealt


@xvm.export('xvm.numberShotsDealt', deterministic=False)
def xvm_numberShotsDealt():
    return numberShotsDealt


@xvm.export('xvm.numberShotsReceived', deterministic=False)
def xvm_numberShotsReceived():
    return numberShotsReceived


@xvm.export('xvm.numberHitsReceived', deterministic=False)
def xvm_numberHitsReceived():
    return numberHitsReceived


@xvm.export('xvm.dmg', deterministic=False)
def xvm_dmg():
    return damage
