""" XVM (c) www.modxvm.com 2013-2015 """

# PUBLIC

def start():
    _g_fps.start()

def stop():
    _g_fps.stop()

# PRIVATE

import datetime

import BigWorld

from xfw import *
from xvm_main.python.logger import *
import xvm_main.python.config as config

class _Fps():

    intervalId = None

    def __init__(self):
        from BattleReplay import g_replayCtrl
        self.replayCtrl = g_replayCtrl
        self.isReplay = g_replayCtrl.isPlaying

    def start(self):
        if not config.config:
            #debug('wait')
            BigWorld.callback(0, self.start)
            return
        if self.intervalId is not None:
            stop()
        if config.config['export']['fps']['enabled']:
            #debug('fps start')
            self.interval = config.config['export']['fps']['interval']
            self.outputDir = config.config['export']['fps']['outputDir']
            self.intervalId = BigWorld.callback(self.interval, self.update)
            self.values = []

    def stop(self):
        #debug('fps stop')
        if self.intervalId is not None:
            BigWorld.cancelCallback(self.intervalId)
            self.intervalId = None
        if self.values and len(self.values):
            #log(self.values)
            try:
                if not os.path.isdir(self.outputDir):
                    os.makedirs(self.outputDir)
            except:
                LOG_ERROR('Failed to create directory for fps files')
                return
            fileName = '{0}/fps-{1}.csv'.format(self.outputDir, datetime.datetime.now().strftime('%Y%m%d-%H%M%S'))
            with open(fileName, 'w') as f:
                f.write('Time;Fps\n')
                for item in self.values:
                    f.write("{0};{1}\n".format(round(item['time'], 3), round(item['fps'], 3)))
            self.values = []

    def update(self):
        #debug('update')
        period = getArenaPeriod()
        time = BigWorld.time()
        fps = BigWorld.getFPS()[1]

        if period == 3 and time > 0:
            self.add_value(period, time, fps)

        self.intervalId = BigWorld.callback(self.interval, self.update)

    def add_value(self, period, time, fps):
        #debug('fps: {0} per: {1} time: {2}'.format(fps, period, time))
        self.values.append({'period':period,'time':time,'fps':fps})
        pass

_g_fps = None
def _init():
    global _g_fps
    _g_fps = _Fps()
BigWorld.callback(0, _init)
