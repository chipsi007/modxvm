""" XVM (c) www.modxvm.com 2013-2017 """

#####################################################################
# imports

import imp
import platform
import traceback

#####################################################################
# telemetry class

class _Telemetry(object):
    def __init__(self):
        #feature detection
        self.enable_d3d9 = True
        self.enable_d3d11 = True

        try:
            import xvm_main.python.config as config
            self.enable_d3d9 = config.get('telemetry/features/d3d9')
            self.enable_d3d11 = config.get('Telemetry/features/d3d11')
        except Exception:
            pass

        #native modules loading
        self.native = imp.load_dynamic('XVMNativeTelemetry', './res_mods/mods/packages/xvm_telemetry/native/XVMNativeTelemetry.pyd')

        self.native_d3d9 = None
        if self.enable_d3d9:
            self.native_d3d9 = imp.load_dynamic('XVMNativeTelemetry_d3d9', './res_mods/mods/packages/xvm_telemetry/native/XVMNativeTelemetry_d3d9.pyd')

        self.native_d3d11 = None
        if self.enable_d3d11 and not platform.version().startswith('5.'):
            self.native_d3d11 = imp.load_dynamic('XVMNativeTelemetry_d3d11', './res_mods/mods/packages/xvm_telemetry/native/XVMNativeTelemetry_d3d11.pyd')

    def get_connection_string(self):
        """
        Build Baical/P7 connection string from XVM config file
        """
        try:
            import xvm_main.python.config as config
            return unicode(('/P7.Sink='   +config.get('telemetry/connection/sink')+
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
        except Exception:
            return unicode('/P7.Sink=Auto /P7.Name=WoT_XFW /P7.Dir=logs_xfw')


    def connect(self):
        """
        Connect P7 to Baical
        """
        self.native.connect(self.get_connection_string())

        if self.native_d3d9 is not None:
            self.native_d3d9.connect()

        if self.native_d3d11 is not None:
            self.native_d3d11.connect()

    def enable(self):
        """
        Enable telemetry hooks
        """
        if self.native_d3d9 is not None:
            self.native_d3d9.hook()

        if self.native_d3d11 is not None:
            self.native_d3d11.hook()


#####################################################################
# initialization

g_telemetry = None

def init_telemetry():
    g_telemetry = _Telemetry()
    g_telemetry.connect()
    g_telemetry.enable()

try:
    import xvm_main.python.config as config    
    if config.get('telemetry/enabled'):
        init_telemetry()
except Exception:
    init_telemetry()
