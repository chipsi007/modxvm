""" XVM (c) www.modxvm.com 2013-2017 """

#####################################################################
# imports
import os
import time

import game
from xfw.events import registerEvent
from yappi import yappi as yappi

#####################################################################
# imports

class _Profiler_Yappi(object):
    def __init__(self):
        self.filedir = 'logs_xfw/'
        self.filename = 'callgrind.profiler.yappi'
        self.filetype = 'callgrind'
        yappi.set_clock_type('cpu')

    def start(self):
        yappi.start(builtins=True, profile_threads=True)

    def stop(self):
        yappi.stop()

    def save(self):
        if not os.path.exists(self.filedir):
            os.makedirs(self.filedir)

        yappi.get_func_stats().save(self.filedir+self.filename+' '+time.strftime('%Y%m%d__%H%M'), type=self.filetype)

g_profiler_yappi = None
g_profiler_yappi = _Profiler_Yappi()

#####################################################################
# event hooking

g_profiler_yappi.start()

@registerEvent(game, 'fini')
def _fini():
    g_profiler_yappi.stop()
    g_profiler_yappi.save()
