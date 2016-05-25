""" XVM (c) www.modxvm.com 2013-2016 """

# PUBLIC

def getTiers(level, cls, key):
    return _getTiers(level, cls, key)


# PRIVATE

from logger import *
from gui.shared import g_itemsCache
from gui.shared.utils.requesters import REQ_CRITERIA


# Data from http://forum.worldoftanks.ru/index.php?/topic/41221-
_special = {
    # level 2
    'usa:T2_lt':                         [ 2, 4 ],
    'usa:T7_Combat_Car':                 [ 2, 2 ],
    'uk:GB76_Mk_VIC':                    [ 2, 2 ],
    'germany:PzI':                       [ 2, 2 ],

    # level 3
    'ussr:M3_Stuart_LL':                 [ 3, 4 ],
    'ussr:R86_LTP':                      [ 3, 4 ],
    'ussr:BT-SV':                        [ 3, 4 ],
    'germany:G36_PzII_J':                [ 3, 4 ],
    'ussr:R56_T-127':                    [ 3, 4 ],
    'japan:Ke_Ni_B':                     [ 3, 4 ],
    'ussr:SU76I':                        [ 3, 4 ],

    # level 4
    'ussr:Valentine_LL':                 [ 4, 4 ],
    'germany:B-1bis_captured':           [ 4, 4 ],
    'ussr:A-32':                         [ 4, 5 ],
    'france:AMX40':                      [ 4, 6 ],
    'uk:GB04_Valentine':                 [ 4, 6 ],
    'uk:GB60_Covenanter':                [ 4, 6 ],
    'ussr:A-20':                         [ 4, 6 ],
    'ussr:T80':                          [ 4, 6 ],
    'japan:Ke_Ho':                       [ 4, 6 ],

    # level 5
    'germany:PzIV_Hydro':                [ 5, 6 ],
    # TODO:0.9.15
    'germany:PzV_PzIV':                  [ 5, 6 ],
    'germany:PzV_PzIV_ausf_Alfa':        [ 5, 6 ],
    #
    'germany:G104_Stug_IV':              [ 5, 6 ],
    'ussr:Churchill_LL':                 [ 5, 6 ],
    'ussr:SU_85I':                       [ 5, 6 ],
    'ussr:Matilda_II_LL':                [ 5, 6 ],
    'usa:T14':                           [ 5, 6 ],
    'ussr:R38_KV-220':                   [ 5, 6 ],
    'ussr:R38_KV-220_action':            [ 5, 6 ],
    'usa:M4A2E4':                        [ 5, 6 ],
    'uk:GB51_Excelsior':                 [ 5, 6 ],
    'uk:GB68_Matilda_Black_Prince':      [ 5, 6 ],
    'uk:GB20_Crusader':                  [ 5, 7 ],

    # level 6
    # TODO:0.9.15
    'germany:G32_PzV_PzIV_CN':           [ 6, 7 ],
    'germany:G32_PzV_PzIV_ausf_Alfa_CN': [ 6, 7 ],
    #
    'uk:GB63_TOG_II':                    [ 6, 7 ],

    # level 7
    'germany:G78_Panther_M10':           [ 7, 8 ],
    'ussr:T44_85':                       [ 7, 8 ],
    'ussr:T44_122':                      [ 7, 8 ],
    'usa:A86_T23E3':                     [ 7, 8 ],
    'germany:G48_E-25':                  [ 7, 8 ],
    'uk:GB71_AT_15A':                    [ 7, 8 ],

    # level 8
    'ussr:R54_KV-5':                     [ 8, 9 ],
    'ussr:R61_Object252':                [ 8, 9 ],
    'france:F65_FCM_50t':                [ 8, 9 ],
    'usa:A80_T26_E4_SuperPershing':      [ 8, 9 ],
    'usa:A45_M6A2E1':                    [ 8, 9 ],
    'china:Ch23_112':                    [ 8, 9 ],
    'china:Ch14_T34_3':                  [ 8, 9 ],
    'china:Ch01_Type59':                 [ 8, 9 ],
    'china:Ch03_WZ-111':                 [ 8, 9 ],
    'germany:G65_JagdTiger_SdKfz_185':   [ 8, 9 ],
}

def _getTiers(level, cls, key):
    if key in _special:
        return _special[key]

    # HT: (=T4 max+1)
    if level == 4 and cls == 'heavyTank':
        return (4, 5)

    # LT: (=T4 max+4) & (>T4 min+1 max+3) & (>T7 min+1 max=11)
    if level >= 4 and cls == 'lightTank':
        return (level if level == 4 else level + 1, 11 if level > 7 else level + 3)

    # default: (<T3 max+1) & (>=T3 max+2) & (>T9 max=11)
    return (level, level + 1 if level < 3 else 11 if level > 9 else level + 2)

def _test_specials():
    for veh_name in _special.keys():
        if not g_itemsCache.items.getVehicles(REQ_CRITERIA.VEHICLE.SPECIFIC_BY_NAME(veh_name)):
            warn('vehinfo_tiers: vehicle %s declared in _special does not exist!' % veh_name)
