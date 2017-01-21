""" XVM (c) www.modxvm.com 2013-2016 """

#####################################################################
# MOD INFO

XFW_MOD_INFO = {
    # mandatory
    'VERSION':       '0.9.17.0.1',
    'URL':           'http://www.modxvm.com/',
    'UPDATE_URL':    'http://www.modxvm.com/en/download-xvm/',
    'GAME_VERSIONS': ['0.9.17.0.1'],
    # optional
}


#####################################################################
# imports

import imp
XVMNativeTelemetry = imp.load_dynamic('XVMNativeTelemetry', './res_mods/mods/packages/xvm_telemetry/native/XVMNativeTelemetry.pyd')
XVMNativeTelemetry.d3d_hook()