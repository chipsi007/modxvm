""" XVM (c) www.modxvm.com 2013-2015 """

#####################################################################
# MOD INFO (mandatory)

XFW_MOD_VERSION    = "3.0.0"
XFW_MOD_URL        = "http://www.modxvm.com/"
XFW_MOD_UPDATE_URL = "http://www.modxvm.com/en/download-xvm/"
XFW_GAME_VERSIONS  = ["0.9.7"]

#####################################################################

import cProfile, pstats, StringIO

import BigWorld

from xfw import *
from xvm_main.python.logger import *

import as2profiler

#####################################################################
# constants

# for AS2
COMMAND_PROF_METHOD_START = "profMethodStart"
COMMAND_PROF_METHOD_END = "profMethodEnd"

#####################################################################
# as2profiler

_BATTLE_SWF = 'battle.swf'
_VMM_SWF = 'VehicleMarkersManager.swf'
_SWFS = [_BATTLE_SWF, _VMM_SWF]

def FlashInit(self, swf, className='Flash', args=None, path=None):
    self.swf = swf
    if self.swf not in _SWFS:
        return
    self.addExternalCallback('xvm.cmd', lambda *args: onXvmCommand(self, *args))

def FlashBeforeDelete(self):
    if self.swf not in _SWFS:
        return
    # log("FlashBeforeDelete: " + self.swf)
    self.removeExternalCallback('xvm.cmd')

# onXvmCommand

def onXvmCommand(proxy, id, cmd, *args):
    try:
        if cmd == COMMAND_PROF_METHOD_START:
            as2profiler.g_as2profiler.methodStart(args[0])
        if cmd == COMMAND_PROF_METHOD_END:
            as2profiler.g_as2profiler.methodEnd(args[0])
    except Exception, ex:
        err(traceback.format_exc())

#####################################################################
# cProfile

_pr = cProfile.Profile()

# on map load (battle loading)
def PlayerAvatar_onEnterWorld(self, *args):
    def en():
        as2profiler.g_as2profiler.init()

        global _pr
        log('xvm_profiler enabled')
        _pr.enable()
    BigWorld.callback(10, en)

# on map close
def PlayerAvatar_onLeaveWorld(self, *args):
    as2profiler.g_as2profiler.showResult()

    global _pr
    _pr.disable()
    s = StringIO.StringIO()
    sortby = 'cumulative'
    p = pstats.Stats(_pr, stream=s).sort_stats(sortby)
    p.print_stats('(xfw|xvm)', 10)
    log(s.getvalue())

#####################################################################
# Register events

# Early registration
from gui.Scaleform.Flash import Flash
RegisterEvent(Flash, '__init__', FlashInit)
RegisterEvent(Flash, 'beforeDelete', FlashBeforeDelete)

# Delayed registration
def _RegisterEvents():
    from Avatar import PlayerAvatar
    RegisterEvent(PlayerAvatar, 'onEnterWorld', PlayerAvatar_onEnterWorld)
    RegisterEvent(PlayerAvatar, 'onLeaveWorld', PlayerAvatar_onLeaveWorld)

if IS_DEVELOPMENT:
    BigWorld.callback(0, _RegisterEvents)
