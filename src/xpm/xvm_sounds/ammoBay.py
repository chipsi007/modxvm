""" XVM (c) www.modxvm.com 2013-2016 """

#####################################################################
# imports

import SoundGroups
from gui.Scaleform.daapi.view.battle.damage_panel import DamagePanel

from xfw import *
import xvm_main.python.config as config
from xvm_main.python.logger import *
import traceback

#####################################################################
# constants

class XVM_SOUND_EVENT(object):
    AMMO_BAY = "xvm_ammoBay"

#####################################################################
# handlers

@registerEvent(DamagePanel, '_updateDeviceState')
def DamagePanel_updateDeviceState(self, value):
    try:
        if config.get('sounds/enabled'):
            module, state, _ = value
            if module == 'ammoBay' and state == 'critical':
                SoundGroups.g_instance.playSound2D(XVM_SOUND_EVENT.AMMO_BAY)
    except:
        err(traceback.format_exc())