""" XVM (c) www.modxvm.com 2013-2016 """

#####################################################################
# MOD INFO

XFW_MOD_INFO = {
    # mandatory
    'VERSION':       '0.9.16',
    'URL':           'http://www.modxvm.com/',
    'UPDATE_URL':    'http://www.modxvm.com/en/download-xvm/',
    'GAME_VERSIONS': ['0.9.16'],
    # optional
}


#####################################################################
# imports

import BigWorld
from Avatar import PlayerAvatar

from xfw import *

from xvm_main.python.logger import *

import fps


#####################################################################
# handlers

# on map load (battle loading)
@registerEvent(PlayerAvatar, 'onEnterWorld')
def PlayerAvatar_onEnterWorld(self, *args):
    fps.start()


# on map close
@registerEvent(PlayerAvatar, 'onLeaveWorld')
def PlayerAvatar_onLeaveWorld(self, *args):
    fps.stop()
