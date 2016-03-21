""" XVM (c) www.modxvm.com 2013-2015 """

#####################################################################
# MOD INFO

XFW_MOD_INFO = {
    # mandatory
    'VERSION':       '0.9.14',
    'URL':           'http://www.modxvm.com/',
    'UPDATE_URL':    'http://www.modxvm.com/en/download-xvm/',
    'GAME_VERSIONS': ['0.9.14'],
    # optional
}


#####################################################################
# imports

import traceback

import BigWorld
import SoundGroups
import WWISE
from gui.Scaleform.Battle import Battle
from gui.Scaleform.daapi.view.battle.damage_panel import DamagePanel
from gui.Scaleform.Minimap import Minimap
from gui.battle_control import g_sessionProvider

from xfw import *

import xvm_main.python.config as config
from xvm_main.python.logger import *

#####################################################################
# constants

class XVM_SOUND_EVENT(object):
    SIXTH_SENSE = "xvm_sixthSense"
    SIXTH_SENSE_RUDY = "xvm_sixthSenseRudy"
    FIRE_ALERT = "xvm_fireAlert"
    AMMO_BAY = "xvm_ammoBay"
    ENEMY_SIGHTED = "xvm_enemySighted"

#####################################################################
# handlers

@overrideMethod(WWISE, 'WG_loadBanks')
def WWISE_WG_loadBanks(base, *args, **kwargs):
    extraBanks = config.get('sounds/soundBanks/%s' % ('hangar' if args[1] else 'battle'))
    if extraBanks:
        lst = list(args)
        banks = (lst[0] + ';' + extraBanks).split(';')
        banks = set([x.strip() for x in banks if x and x.strip()])
        lst[0] = '; '.join(banks)
        args = tuple(lst)
    log('WWISE.WG_loadBanks: %s' % args[0])
    base(*args, **kwargs)


@overrideMethod(SoundGroups.g_instance, 'checkAndReplace')
def SoundGroups_g_instance_checkAndReplace(base, event):
    event = base(event)
    if not event:
        return event
    mappedEvent = config.get('sounds/soundMapping/%s' % event)
    logSoundEvents = config.get('sounds/logSoundEvents')
    if mappedEvent is not None:
        if mappedEvent == '':
            mappedEvent = 'emptyEvent'
        if logSoundEvents:
            log('SOUND EVENT: %s => %s' % (event, mappedEvent))
        return mappedEvent
    else:
        if logSoundEvents:
            log('SOUND EVENT: %s' % event)
        return event


# new sound events dispatchers

@registerEvent(Battle, '_showSixthSenseIndicator')
def Battle_showSixthSenseIndicator(self, isShow):
    try:
        vehId = BigWorld.entities[BigWorld.player().playerVehicleID].typeDescriptor.type.compactDescr
        # 59393 => Rudy
        soundId = XVM_SOUND_EVENT.SIXTH_SENSE_RUDY if vehId == 59393 else XVM_SOUND_EVENT.SIXTH_SENSE
        SoundGroups.g_instance.playSound2D(soundId)
    except:
        err(traceback.format_exc())


@registerEvent(Battle, '_setFireInVehicle')
def Battle_setFireInVehicle(self, bool):
    try:
        SoundGroups.g_instance.playSound2D(XVM_SOUND_EVENT.FIRE_ALERT)
    except:
        err(traceback.format_exc())


@registerEvent(DamagePanel, '_updateDeviceState')
def DamagePanel_updateDeviceState(self, value):
    try:
        module, state, _ = value
        if module == 'ammoBay' and state == 'critical':
            SoundGroups.g_instance.playSound2D(XVM_SOUND_EVENT.AMMO_BAY)
    except:
        err(traceback.format_exc())


enemyList = {}

@registerEvent(PlayerAvatar, '_PlayerAvatar__destroyGUI')
def PlayerAvatar_PlayerAvatar__destroyGUI(self):
    enemyList.clear()


@overrideMethod(Minimap, '_Minimap__addEntry')
def Minimap_Minimap__addEntry(base, self, vInfo, guiProps, location, doMark):
    try:
        if vInfo.vehicleID not in enemyList and not guiProps.isFriend:
            enemyList[vInfo.vehicleID] = True
            if doMark and not g_sessionProvider.getCtx().isPlayerObserver():
                SoundGroups.g_instance.playSound2D(XVM_SOUND_EVENT.ENEMY_SIGHTED)
    except:
        err(traceback.format_exc())

    return base(self, vInfo, guiProps, location, doMark)


# TEST

def _test():
    log('test')
    SoundGroups.g_instance.playSound2D(XVM_SOUND_EVENT.SIXTH_SENSE_RUDY)
    BigWorld.callback(3, _test)

#BigWorld.callback(10, _test)
