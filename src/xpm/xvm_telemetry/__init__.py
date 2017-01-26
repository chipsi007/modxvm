""" XVM (c) www.modxvm.com 2013-2016 """

#####################################################################
# MOD INFO

XFW_MOD_INFO = {
    # mandatory
    'VERSION':       '0.9.17.0.3',
    'URL':           'http://www.modxvm.com/',
    'UPDATE_URL':    'http://ww.modxvm.com/en/download-xvm/',
    'GAME_VERSIONS': ['0.9.17.0.3'],
    # optional
}


#####################################################################
# imports

import imp
import platform
import traceback

from Avatar import PlayerAvatar
from gui.shared import g_eventBus

from xfw import *
from xfw.constants import PATH

import xvm_main.python.config as config
from xvm_main.python.consts import *
from xvm_main.python.logger import *
from xvm_main.python.utils import fixXvmPath

#####################################################################
# telemetry class

class Telemetry(object):
    def __init__(self):
        self.XVMNativeTelemetry = imp.load_dynamic('XVMNativeTelemetry', './res_mods/mods/packages/xvm_telemetry/native/XVMNativeTelemetry.pyd')

        if config.get('telemetry/features/d3d9'):
            self.XVMNativeTelemetry_d3d9 = imp.load_dynamic('XVMNativeTelemetry_d3d9', './res_mods/mods/packages/xvm_telemetry/native/XVMNativeTelemetry_d3d9.pyd')
          

        if config.get('telemetry/features/d3d11'):
            self.XVMNativeTelemetry_d3d11 = imp.load_dynamic('XVMNativeTelemetry_d3d11', './res_mods/mods/packages/xvm_telemetry/native/XVMNativeTelemetry_d3d11.pyd')

    def getConnectionString(self):
        return unicode((' /P7.Sink='   +config.get('telemetry/connection/sink')+
                        ' /P7.Name='   +config.get('telemetry/connection/name')+
                        ' /P7.Pool='   +str(config.get('telemetry/connection/memoryPool'))+
                        ' /P7.Addr='   +config.get('telemetry/connection/serverAddress')+
                        ' /P7.Port='   +str(config.get('telemetry/connection/serverPort'))+
                        ' /P7.PSize='  +str(config.get('telemetry/connection/packetSize'))+
                        ' /P7.Window=' +str(config.get('telemetry/connection/packetWindow'))+
                        ' /P7.Format="'+config.get('telemetry/connection/format')+'"'+
                        ' /P7.Dir='    +config.get('telemetry/connection/logDirectory')+
                        ' /P7.Roll='   +config.get('telemetry/connection/logRolling')+
                        ' /P7.Files='  +str(config.get('telemetry/connection/logMaxFiles'))))

    def connect(self):
        self.XVMNativeTelemetry.connect(self.getConnectionString())

        if self.XVMNativeTelemetry_d3d9 is not None:
            self.XVMNativeTelemetry_d3d9.connect()

        if self.XVMNativeTelemetry_d3d11 is not None:
            self.XVMNativeTelemetry_d3d11.connect()

    def enable(self):
        if self.XVMNativeTelemetry_d3d9 is not None:
            self.XVMNativeTelemetry_d3d9.hook()

        if self.XVMNativeTelemetry_d3d11 is not None:
            self.XVMNativeTelemetry_d3d11.hook()




#####################################################################
# initialization

g_xvmTelemetry = None
if config.get('telemetry/enabled'):
    g_xvmTelemetry = Telemetry()
    g_xvmTelemetry.connect()
    g_xvmTelemetry.enable()