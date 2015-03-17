﻿""" XVM (c) www.modxvm.com 2013-2015 """

#####################################################################
# MOD INFO (mandatory)

XFW_MOD_VERSION = '2.0.0'
XFW_MOD_URL = 'http://www.modxvm.com/'
XFW_MOD_UPDATE_URL = 'http://www.modxvm.com/en/download-xvm/'
XFW_GAME_VERSIONS = ['0.9.6']

#####################################################################

import BigWorld

from xfw import *
import xvm_main.python.config as config
from xvm_main.python.logger import *
from xvm_main.python.vehinfo import _getRanges
from math import degrees

#####################################################################
# event handlers

# overriding tooltips for tanks in hangar, configuration in tooltips.xc
def VehicleParamsField_getValue(base, self):
    try:
        from gui.shared.utils import ItemsParameters, ParametersCache
        from helpers import i18n
        result = list()
        vehicle = self._tooltip.item
        configuration = self._tooltip.context.getParamsConfiguration(vehicle)
        params = configuration.params
        crew = configuration.crew
        eqs = configuration.eqs
        devices = configuration.devices
        veh_descr = vehicle.descriptor
        gun = vehicle.gun.descriptor
        turret = vehicle.turret.descriptor
        vehicleCommonParams = dict(ItemsParameters.g_instance.getParameters(veh_descr))
        vehicleRawParams = dict(ParametersCache.g_instance.getParameters(veh_descr))
        result.append([])
        veh_type_inconfig = vehicle.type.replace('AT-SPG', 'TD')
        if params:
            if veh_type_inconfig in config.config['hangar']['tooltips'] and len(config.config['hangar']['tooltips'][veh_type_inconfig]):
                params_list = config.config['hangar']['tooltips'][veh_type_inconfig] # overriding parameters
            else:
                params_list = self.PARAMS.get(vehicle.type, 'default')               # old way
            for paramName in params_list:
                if paramName == 'turretArmor' and not vehicle.hasTurrets:
                    continue
                #gravity
                if paramName == 'gravity':
                    gravity_str = "%g" % round(veh_descr.shot['gravity'], 2)
                    result[-1].append(['<h1>' + l10n('gravity') + '</h1>', '<h1>' + gravity_str + '</h1>'])
                    continue
                #explosionRadius
                if paramName == 'explosionRadius':
                    explosionRadiusMin = 999
                    explosionRadiusMax = 0
                    for key in gun['shots']:
                        if 'explosionRadius' in key['shell']:
                            if key['shell']['explosionRadius'] < explosionRadiusMin:
                                explosionRadiusMin = key['shell']['explosionRadius']
                            if key['shell']['explosionRadius'] > explosionRadiusMax:
                                explosionRadiusMax = key['shell']['explosionRadius']
                    if explosionRadiusMax == 0: # no HE
                        continue
                    explosionRadius_str = "%g" % round(explosionRadiusMin, 2)
                    if explosionRadiusMin != explosionRadiusMax:
                        explosionRadius_str += ' (%g %s)' % (round(explosionRadiusMax, 2), i18n.makeString('#menu:headerButtons/btnLabel/premium'))
                    result[-1].append([self._getParameterValue(paramName, vehicleCommonParams, vehicleRawParams)[0], '<h1>' + explosionRadius_str + '</h1>'])
                    continue
                #shellSpeedSummary
                if paramName == 'shellSpeedSummary':
                    shellSpeedSummary_arr = []
                    for key in gun['shots']:
                        shellSpeedSummary_arr.append(str(int(key['speed']*1.25)))
                    delimiter = "/"
                    shellSpeedSummary_str = delimiter.join(shellSpeedSummary_arr)
                    result[-1].append(['<h1>%s <p>%s</p></h1>' % (l10n('shellSpeed'), l10n('(m/sec)')), '<h1>' + shellSpeedSummary_str + '</h1>'])
                    continue
                #piercingPowerAvg
                if paramName == 'piercingPowerAvg':
                    piercingPowerAvg = "%g" % veh_descr.shot['piercingPower'][0]
                    result[-1].append([i18n.makeString('#menu:moduleInfo/params/avgPiercingPower').replace('h>', 'h1>'), '<h1>' + piercingPowerAvg + '</h1>'])
                    continue
                #piercingPowerAvgSummary
                if paramName == 'piercingPowerAvgSummary':
                    piercingPowerAvgSummary_arr = []
                    for key in gun['shots']:
                        piercingPowerAvgSummary_arr.append(str(int(key['piercingPower'][0])))
                    delimiter = "/"
                    piercingPowerAvgSummary_str = delimiter.join(piercingPowerAvgSummary_arr)
                    result[-1].append([i18n.makeString('#menu:moduleInfo/params/avgPiercingPower').replace('h>', 'h1>'), '<h1>' + piercingPowerAvgSummary_str + '</h1>'])
                    continue
                #damageAvgSummary
                if paramName == 'damageAvgSummary':
                    damageAvgSummary_arr = []
                    for key in gun['shots']:
                        damageAvgSummary_arr.append(str(int(key['shell']['damage'][0])))
                    delimiter = "/"
                    damageAvgSummary_str = delimiter.join(damageAvgSummary_arr)
                    result[-1].append([i18n.makeString('#menu:moduleInfo/params/avgDamage').replace('h>', 'h1>'), '<h1>' + damageAvgSummary_str + '</h1>'])
                    continue
                #magazine loading
                if paramName == 'reloadTimeSecs' and vehicle.gun.isClipGun():
                    (shellsCount, shellReloadingTime) = gun['clip']
                    reloadMagazineTime = gun['reloadTime']
                    shellReloadingTime_str = "%g" % round(shellReloadingTime, 2)  #nice representation
                    reloadMagazineTime_str = "%g" % round(reloadMagazineTime, 2)
                    result[-1].append([i18n.makeString('#menu:moduleInfo/params/shellsCount').replace('h>', 'h1>'), '<h1>' + str(shellsCount) + '</h1>'])
                    result[-1].append([i18n.makeString('#menu:moduleInfo/params/shellReloadingTime').replace('h>', 'h1>'), '<h1>' + shellReloadingTime_str + '</h1>'])
                    result[-1].append([i18n.makeString('#menu:moduleInfo/params/reloadMagazineTime').replace('h>', 'h1>'), '<h1>' + reloadMagazineTime_str + '</h1>'])
                    continue
                # gun traverse limits
                if paramName == 'traverseLimits' and gun['turretYawLimits']:
                    (traverseMin, traverseMax) = gun['turretYawLimits']
                    traverseLimits_str = str(int(round(degrees(traverseMin)))) + '..+' + str(int(round(degrees(traverseMax))))
                    result[-1].append(['<h1>' + l10n('traverseLimits') + '</h1>', '<h1>' + traverseLimits_str + '</h1>'])
                    continue
                # elevation limits
                if paramName == 'pitchLimits':
                    (pitchMax, pitchMin) = gun['pitchLimits']['absolute']
                    pitchLimits_str = str(int(round(degrees(-pitchMin)))) + '..+' + str(int(round(degrees(-pitchMax))))
                    result[-1].append(['<h1>' + l10n('pitchLimits') + '</h1>', '<h1>' + pitchLimits_str + '</h1>'])
                    continue
                # shooting range
                if paramName == 'shootingRadius':
                    viewRange, shellRadius, artiRadius = _getRanges(turret, gun, vehicle.nationName, vehicle.type)
                    if vehicle.type == 'SPG':
                        result[-1].append(['<h1>%s <p>%s</p></h1>' % (l10n('shootingRadius'), l10n('(m)')), '<h1>' + str(artiRadius) + '</h1>'])
                    elif shellRadius < 707:
                        result[-1].append(['<h1>%s <p>%s</p></h1>' % (l10n('shootingRadius'), l10n('(m)')), '<h1>' + str(shellRadius) + '</h1>'])
                    continue
                #reverse max speed
                if paramName == 'speedLimits':
                    (speedLimitForward, speedLimitReverse) = veh_descr.physics['speedLimits']
                    speedLimits_str = str(int(speedLimitForward*3.6)) + '/' + str(int(speedLimitReverse*3.6))
                    result[-1].append([self._getParameterValue(paramName, vehicleCommonParams, vehicleRawParams)[0], speedLimits_str])
                    continue
                #turret rotation speed
                if paramName == 'turretRotationSpeed':
                    turretRotationSpeed_str = str(int(degrees(veh_descr.turret['rotationSpeed'])))
                    result[-1].append([self._getParameterValue(paramName, vehicleCommonParams, vehicleRawParams)[0], turretRotationSpeed_str])
                    continue
                #terrain resistance
                if paramName == 'terrainResistance':
                    resistances_arr = []
                    for key in veh_descr.chassis['terrainResistance']:
                        resistances_arr.append("%g" % round(key, 2))
                    delimiter = "/"
                    terrainResistance_str = delimiter.join(resistances_arr)
                    result[-1].append(['<h1>' + l10n('terrainResistance') + '</h1>', '<h1>' + terrainResistance_str + '</h1>'])
                    continue
                if paramName in vehicleCommonParams or paramName in vehicleRawParams:
                    result[-1].append(self._getParameterValue(paramName, vehicleCommonParams, vehicleRawParams))

        # optional devices icons, must be in the end
        if 'optDevicesIcons' in params_list:
            optDevicesIcons_arr = []
            for key in vehicle.optDevices:
                if key:
                    imgPath = 'img://gui' + key.icon.lstrip('.')
                else:
                    imgPath = 'img://gui/maps/icons/artefact/empty.png'
                optDevicesIcons_arr.append('<img src="' + imgPath + '" height="16" width="16">')
            delimiter = " "
            optDevicesIcons_str = delimiter.join(optDevicesIcons_arr)
            result[-1].append(['<h1>' + i18n.makeString('#menu:inventory/menu/optionalDevice/name') + '</h1>', optDevicesIcons_str])

        # equipment icons, must be in the end
        if 'equipmentIcons' in params_list:
            equipmentIcons_arr = []
            for key in vehicle.eqs:
                if key:
                    imgPath = 'img://gui' + key.icon.lstrip('.')
                else:
                    imgPath = 'img://gui/maps/icons/artefact/empty.png'
                equipmentIcons_arr.append('<img src="' + imgPath + '" height="16" width="16">')
            delimiter = " "
            equipmentIcons_str = delimiter.join(equipmentIcons_arr)
            result[-1].append(['<h1>' + i18n.makeString('#menu:inventory/menu/equipment/name') + '</h1>', equipmentIcons_str])
        
        result.append([])
        if crew:
            currentCrewSize = 0
            if vehicle.isInInventory:
                currentCrewSize = len([ x for _, x in vehicle.crew if x is not None ])
            result[-1].append({'label': 'crew',
             'current': currentCrewSize,
             'total': len(vehicle.descriptor.type.crewRoles)})
        if eqs:
            result[-1].append({'label': 'equipments',
             'current': len([ x for x in vehicle.eqs if x ]),
             'total': len(vehicle.eqs)})
        if devices:
            result[-1].append({'label': 'devices',
             'current': len([ x for x in vehicle.descriptor.optionalDevices if x ]),
             'total': len(vehicle.descriptor.optionalDevices)})
        return result
    except Exception as ex:
        err(traceback.format_exc())
        return base(self)

    return

#####################################################################
# Register events

def _RegisterEvents():
    from gui.shared.tooltips.vehicle import VehicleParamsField
    OverrideMethod(VehicleParamsField, '_getValue', VehicleParamsField_getValue)

BigWorld.callback(0, _RegisterEvents)
