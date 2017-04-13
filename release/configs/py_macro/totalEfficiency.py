﻿import xvm.total_Efficiency as te
import xvm_main.python.vehinfo_xtdb as vehinfo_xtdb
import xvm_main.python.config as config


@xvm.export('xvm.totalDamageColor', deterministic=False)
def xvm_totalDamageColor():
    x = vehinfo_xtdb.calculateXTDB(te.vehCD, te.totalDamage)
    for val in config.get('colors/x'):
        if val['value'] > x:
            return '#' + val['color'][2:] if val['color'][:2] == '0x' else val['color']


@xvm.export('xvm.totalDamage', deterministic=False)
def xvm_totalDamage():
    return te.totalDamage


@xvm.export('xvm.totalAssist', deterministic=False)
def xvm_totalAssist():
    return te.totalAssist


@xvm.export('xvm.totalStun', deterministic=False)
def xvm_totalStun():
    return te.totalStun


@xvm.export('xvm.totalBlocked', deterministic=False)
def xvm_totalBlocked():
    return te.totalBlocked


@xvm.export('xvm.damageReceived', deterministic=False)
def xvm_damageReceived():
    return te.damageReceived


@xvm.export('xvm.totalDamagesBlocked', deterministic=False)
def xvm_totalDamagesBlocked():
    return te.totalDamage + te.totalBlocked


@xvm.export('xvm.totalDamagesAssist', deterministic=False)
def xvm_totalDamagesAssist():
    return te.totalDamage + te.totalAssist


@xvm.export('xvm.totalDamagesBlockedAssist', deterministic=False)
def xvm_totalDamagesBlockedAssist():
    return te.totalDamage + te.totalAssist + te.totalBlocked


@xvm.export('xvm.totalDamagesBlockedReceived', deterministic=False)
def xvm_totalDamagesBlockedReceived():
    return te.totalDamage + te.totalBlocked + te.damageReceived


@xvm.export('xvm.totalBlockedReceived', deterministic=False)
def xvm_totalBlockedReceived():
    return te.totalBlocked + te.damageReceived


@xvm.export('xvm.totalDamagesSquad', deterministic=False)
def xvm_totalDamagesSquad():
    return te.damagesSquad + te.totalDamage


@xvm.export('xvm.damagesSquad', deterministic=False)
def xvm_damagesSquad():
    return te.damagesSquad


@xvm.export('xvm.fragsSquad', deterministic=False)
def xvm_fragsSquad():
    return te.fragsSquad


@xvm.export('xvm.totalFragsSquad', deterministic=False)
def xvm_totalFragsSquad():
    return te.fragsSquad + te.ribbonTypes['kill'][1]


@xvm.export('xvm.detection', deterministic=False)
def xvm_detection():
    return te.ribbonTypes['spotted'][1]


@xvm.export('xvm.frags', deterministic=False)
def xvm_frags():
    return te.ribbonTypes['kill'][1]


@xvm.export('xvm.assistTrack', deterministic=False)
def xvm_assistTrack():
    return te.ribbonTypes['assistTrack']


@xvm.export('xvm.assistSpot', deterministic=False)
def xvm_assistSpot():
    return te.ribbonTypes['assistSpot']


@xvm.export('xvm.crits', deterministic=False)
def xvm_crits():
    return te.ribbonTypes['crits'][1]


@xvm.export('xvm.numberHitsBlocked', deterministic=False)
def xvm_numberHitsBlocked():
    return te.numberHitsBlocked


@xvm.export('xvm.numberHitsDealt', deterministic=False)
def xvm_numberHitsDealt():
    return te.numberHitsDealt


@xvm.export('xvm.numberDamagesDealt', deterministic=False)
def xvm_numberDamagesDealt():
    return te.numberDamagesDealt


@xvm.export('xvm.numberShotsDealt', deterministic=False)
def xvm_numberShotsDealt():
    return te.numberShotsDealt


@xvm.export('xvm.numberShotsReceived', deterministic=False)
def xvm_numberShotsReceived():
    return te.numberShotsReceived


@xvm.export('xvm.numberHitsReceived', deterministic=False)
def xvm_numberHitsReceived():
    return te.numberHitsReceived


@xvm.export('xvm.numberHits', deterministic=False)
def xvm_numberHits():
    return te.numberHits


@xvm.export('xvm.isPlayerInSquad', deterministic=False)
def xvm_isPlayerInSquad():
    return 'sq' if te.isPlayerInSquad else None


@xvm.export('xvm.dmg', deterministic=False)
def xvm_dmg():
    return te.damage


@xvm.export('xvm.isStuns', deterministic=False)
def xvm_isStuns():
    return te.isStuns


@xvm.export('xvm.numberStuns', deterministic=False)
def xvm_numberStuns():
    return te.numberStuns
