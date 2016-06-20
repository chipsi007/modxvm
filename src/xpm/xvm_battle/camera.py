""" XVM (c) www.modxvm.com 2013-2016 """

#####################################################################
# imports

import traceback
import math
import Math

import BigWorld
# TODO:0.9.15.1
#from AvatarInputHandler.aims import Aim
from AvatarInputHandler.control_modes import ArcadeControlMode, SniperControlMode
from AvatarInputHandler.DynamicCameras.ArcadeCamera import ArcadeCamera, MinMax
from AvatarInputHandler.DynamicCameras.SniperCamera import SniperCamera
from AvatarInputHandler.DynamicCameras.StrategicCamera import StrategicCamera

from xfw import *

from xvm_main.python.logger import *
import xvm_main.python.config as config
import xvm_main.python.utils as utils


#####################################################################
# handlers

# TODO:0.9.15.1
#@overrideMethod(ArcadeCamera, 'create')
def _ArcadeCamera_create(base, self, pivotPos, onChangeControlMode = None, postmortemMode = False):
    #debug('_ArcadeCamera_create: {}'.format(postmortemMode))

    if config.get('battle/camera/enabled'):
        mode = 'arcade' if not postmortemMode else 'postmortem'
        c = config.get('battle/camera/%s' % mode)
        cfg = self._ArcadeCamera__cfg
        bcfg = self._ArcadeCamera__baseCfg
        ucfg = self._ArcadeCamera__userCfg
        dcfg = self._ArcadeCamera__dynamicCfg

        if not c['dynamicCameraEnabled']:
            _disableDynamicCamera(dcfg)

        value = c['distRange']
        if value is not None:
            cfg['distRange'] = MinMax(float(value[0]), float(value[1]))

        value = c['startDist']
        if value is not None:
            cfg['startDist'] = float(value)

        value = c['scrollSensitivity']
        if value is not None:
            bcfg['scrollSensitivity'] = float(value)
            cfg['scrollSensitivity'] = float(value) * ucfg['scrollSensitivity']

    base(self, pivotPos, onChangeControlMode, postmortemMode)


# TODO:0.9.15.1
#@registerEvent(ArcadeCamera, 'enable')
def _ArcadeCamera_enable(self, *args, **kwargs):
    #debug('_ArcadeCamera_enable: {}'.format(postmortemMode))
    if self._ArcadeCamera__postmortemMode:
        camDist = self._ArcadeCamera__cfg.get('startDist', None)
        if camDist:
            self.setCameraDistance(camDist)


# TODO:0.9.15.1
#@overrideMethod(SniperCamera, 'create')
def _SniperCamera_create(base, self, onChangeControlMode = None):
    #debug('_SniperCamera_create')

    if config.get('battle/camera/enabled'):
        c = config.get('battle/camera/sniper')
        cfg = self._SniperCamera__cfg
        dcfg = self._SniperCamera__dynamicCfg

        if not c['dynamicCameraEnabled']:
            _disableDynamicCamera(dcfg)
        else:
            dcfg['aimMarkerDistance'] = 10.0

        value = c['zooms']
        if value:
            cfg['increasedZoom'] = True
            cfg['zooms'] = [float(i) for i in value]
            dcfg['zoomExposure'] = [ max(0, 0.7 - math.log(i, 2) * 0.1) for i in value]

    base(self, onChangeControlMode)


# TODO:0.9.15.1
#@overrideMethod(SniperCamera, '_SniperCamera__onSettingsChanged')
def _SniperCamera__onSettingsChanged(base, self, diff):
    if config.get('battle/camera/enabled') and config.get('battle/camera/sniper/zooms'):
        diff['increasedZoom'] = True
    base(self, diff)


# TODO:0.9.15.1
#@overrideMethod(SniperCamera, 'enable')
def _SniperCamera_enable(base, self, targetPos, saveZoom):
    if config.get('battle/camera/enabled'):
        zoom = config.get('battle/camera/sniper/startZoom')
        if zoom is not None:
            saveZoom = True
        else:
            zoom = self._SniperCamera__cfg['zoom']
        self._SniperCamera__cfg['zoom'] = utils.takeClosest(self._SniperCamera__cfg['zooms'], zoom)

    base(self, targetPos, saveZoom)
    _sendSniperCameraFlash(True, self._SniperCamera__zoom)


# TODO:0.9.15.1
#@registerEvent(SniperCamera, 'disable')
def _SniperCamera_disable(self):
    _sendSniperCameraFlash(False, self._SniperCamera__zoom)


# TODO:0.9.15.1
#@registerEvent(SniperCamera, '_SniperCamera__applyZoom')
def _SniperCamera__applyZoom(self, zoomFactor):
    _sendSniperCameraFlash(True, zoomFactor)


def _sendSniperCameraFlash(enable, zoom):
    if config.get('battle/camera/enabled') and config.get('battle/camera/sniper/zoomIndicator/enabled'):
        battle = getBattleApp()
        if battle:
            movie = battle.movie
            if movie is not None:
                movie.as_xvm_onSniperCamera(enable, zoom)

# TODO:0.9.15.1
#@overrideMethod(Aim, 'applySettings')
def _Aim_applySettings(base, self):
    if self._Aim__aimSettings is not None:
        if config.get('battle/camera/enabled') and config.get('battle/camera/sniper/zoomIndicator/enabled'):
             self._Aim__aimSettings['zoomIndicator'] = 0
    base(self)


_prevOffsetX = None
_prevOffsetY = None

# TODO:0.9.15.1
#@registerEvent(Aim, 'onOffsetUpdate')
def _Aim_onOffsetUpdate(self, screen, forced = False):
    global _prevOffsetX
    global _prevOffsetY
    if forced or _prevOffsetX != self._posX or _prevOffsetY != self._posY:
        _prevOffsetX = self._posX
        _prevOffsetY = self._posY
        battle = getBattleApp()
        if battle:
            movie = battle.movie
            if movie is not None:
                movie.as_xvm_onAimOffsetUpdate(_prevOffsetX, _prevOffsetY)


# TODO:0.9.15.1
#@overrideMethod(StrategicCamera, 'create')
def _StrategicCamera_create(base, self, onChangeControlMode = None):
    #debug('_StrategicCamera_create')
    if config.get('battle/camera/enabled'):
        c = config.get('battle/camera/strategic')
        cfg = self._StrategicCamera__cfg
        dcfg = self._StrategicCamera__dynamicCfg

        if not c['dynamicCameraEnabled']:
            _disableDynamicCamera(dcfg)

        value = c['distRange']
        if value is not None:
            cfg['distRange'] = [float(i) for i in value]
            self._StrategicCamera__aimingSystem._StrategicAimingSystem__height = cfg['distRange'][0]

    base(self, onChangeControlMode)


# PRIVATE

def _disableDynamicCamera(dcfg):
    for name, value in dcfg.iteritems():
        if name in ['impulseSensitivities', 'noiseSensitivities', 'impulseLimits', 'noiseLimits']:
            value = {}
        elif name in ['zoomExposure']:
            pass
        elif isinstance(value, float):
            value = 0.0
        elif isinstance(value, Math.Vector3):
            value = Math.Vector3(0.0, 0.0, 0.0)
        else:
            log('WARNING: unknown dynamic camera option type: {} {} = {}'.format(type(value), name, value))
        dcfg[name] = value
