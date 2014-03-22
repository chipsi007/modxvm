""" xvm (c) sirmax 2013-2014 """

from gui.mods.xpm import *
from logger import *

# PUBLIC

def getShortName(key):
    if IS_DEVELOPMENT:
        if key not in _data:
            log("Warning: no short vehicle name for '%s'" % key)
    return _data.get(key, None)

# PRIVATE

_data = {
    'ussr:Observer':                     '',

    # level 1
    'ussr:MS-1':                         'MS',
    'germany:Ltraktor':                  'Ltrak',
    'usa:T1_Cunningham':                 'Cunn',
    'china:Ch06_Renault_NC31':           '31',
    'france:RenaultFT':                  'FT',
    'japan:NC27':                        'Otsu',
    'uk:GB01_Medium_Mark_I':             'Mk1',

    # level 2
    'ussr:BT-2':                         'BT2',
    'ussr:T-26':                         'T26',
    'ussr:T-60':                         'T60',
    'ussr:Tetrarch_LL':                  'Tetr',
    'germany:H39_captured':              'H39',
    'germany:Pz35t':                     'Pz35',
    'germany:PzII':                      'Pz2',
    'usa:M2_lt':                         'M2LT',
    'usa:T1_E6':                         'T1E6',
    'usa:T7_Combat_Car':                 'T7',
    'china:Ch07_Vickers_MkE_Type_BT26':  'BT26',
    'france:D1':                         'D1',
    'france:Hotchkiss_H35':              'H35',
    'uk:GB03_Cruiser_Mk_I':              'Cru1',
    'uk:GB58_Cruiser_Mk_III':            'Crui3',
    'uk:GB76_Mk_VIC':                    'Mk6c',
    'japan:Ha_Go':                       'HaGo',
    'usa:T2_med':                        'T2MT',
    'uk:GB05_Vickers_Medium_Mk_II':      'Mk2',
    'japan:Chi_Ni':                      'ChiNi',
    'ussr:AT-1':                         'AT-1',
    'germany:PanzerJager_I':             'PzJg',
    'usa:T18':                           'T18',
    'france:RenaultFT_AC':               'FTAC',
    'uk:GB39_Universal_CarrierQF2':      'QF2',
    'ussr:SU-18':                        'Su18',
    'germany:GW_Mk_VIe':                 'Gw6e',
    'usa:T57':                           'T57',
    'france:RenaultBS':                  'BS',
    'uk:GB25_Loyd_Carrier':              '2pdr',

    # level 3
    'ussr:BT-7':                         'BT7',
    'ussr:LTP':                          'LTP',
    'ussr:T-46':                         'T46',
    'ussr:T-70':                         'T70',
    'germany:Pz_II_AusfG':               'Pz2G',
    'germany:Pz38t':                     'Pz38t',
    'germany:PzI_ausf_C':                'Pz2C',
    'germany:PzIII_A':                   'Pz3A',
    'germany:Pz_IV_AusfA':               'Pz4A',
    'germany:T-15':                      'T-15',
    'usa:M22_Locust':                    'Locus',
    'usa:M3_Stuart':                     'M3Stu',
    'usa:MTLS-1G14':                     'MTLS',
    'china:Ch08_Type97_Chi_Ha':          '97',
    'france:AMX38':                      'AMX38',
    'uk:GB59_Cruiser_Mk_IV':             'Crui4',
    'uk:GB69_Cruiser_Mk_II':             'Crui2',
    'japan:Ke_Ni':                       'KeNi',
    'japan:Ke_Ni_B':                     'KeNiB',
    'germany:G100_Gtraktor_Krupp':       'Gtrak',
    'germany:S35_captured':              'S35',
    'usa:M2_med':                        'M2MT',
    'france:D2':                         'D2',
    'uk:GB06_Vickers_Medium_Mk_III':     'Mk3',
    'japan:Chi_Ha':                      'ChiHa',
    'ussr:SU-76':                        'Su76',
    'ussr:SU76I':                        'Su76I',
    'germany:G20_Marder_II':             'Mard2',
    'usa:T82':                           'T82',
    'france:FCM_36Pak40':                'Fcm36',
    'france:RenaultUE57':                'UE57',
    'uk:GB42_Valentine_AT':              'ValAT',
    'ussr:SU-26':                        'Su26',
    'germany:Bison_I':                   'Bison',
    'germany:Wespe':                     'Wespe',
    'usa:M7_Priest':                     'Pries',
    'usa:Sexton_I':                      'Sext1usa',
    'france:Lorraine39_L_AM':            'Lor39',
    'uk:GB27_Sexton':                    'Sext',
    'uk:GB78_Sexton_I':                  'Sext1',

    # level 4
    'ussr:A-20':                         'A20',
    'ussr:T-50':                         'T50',
    'germany:Pz38_NA':                   'Pz38',
    'germany:PzII_Luchs':                'Luchs',
    'usa:M5_Stuart':                     'M5Stu',
    'china:Ch09_M5':                     'M5',
    'japan:Ke_Ho':                       'KeHo',
    'ussr:T-28':                         'T-28',
    'germany:PzIII':                     'Pz3', # not used
    'germany:PzIII_AusfJ':               'Pz3',
    'germany:Pz_IV_AusfD':               'Pz4D',
    'germany:VK2001DB':                  '2001',
    'usa:M3_Grant':                      'M3Lee',
    'uk:GB07_Matilda':                   'Matil',
    'japan:Chi_He':                      'ChiHe',
    'germany:DW_II':                     'DWII',
    'france:B1':                         'B1',
    'ussr:GAZ-74b':                      'Su85b',
    'germany:G101_StuG_III':             'StuGB',
    'germany:Hetzer':                    'Hetz',
    'germany:Marder_III':                'Mard3',
    'usa:M8A1':                          'M8A1',
    'usa:T40':                           'T40',
    'france:Somua_Sau_40':               'Somua',
    'uk:GB57_Alecto':                    'Alect',
    'ussr:SU-5':                         'Su5',
    'germany:Pz_Sfl_IVb':                'PzS4b',
    'germany:Sturmpanzer_II':            'StPz2',
    'usa:M37':                           'M37',
    'france:AMX_Ob_Am105':               'Am105',
    'uk:GB26_Birch_Gun':                 'Birch',

    # level 5
    'ussr:T_50_2':                       '50-2',
    'germany:VK1602':                    '1602',
    'france:ELC_AMX':                    'ELC',
    'ussr:T-34':                         '34',
    'germany:PzIII_IV':                  'Pz3/4',
    'germany:PzIV':                      'Pz4', # not used
    'germany:Pz_IV_AusfH':               'Pz4',
    'germany:T-25':                      'T-25',
    'usa:M4_Sherman':                    'Sherm',
    'usa:M7_med':                        'M7',
    'usa:Ram-II':                        'Ram2',
    'china:Ch21_T34':                    't-34',
    'japan:Chi_Nu':                      'ChiNu',
    'ussr:KV':                           'KV',
    'ussr:KV1':                          'KV1',
    'germany:VK3001H':                   '3001H',
    'usa:T1_hvy':                        'T1Hv',
    'france:BDR_G1B':                    'BDR',
    'uk:GB08_Churchill_I':               'Chur1',
    'ussr:SU-85':                        'Su85',
    'germany:Pz_Sfl_IVc':                'PzS4c',
    'germany:StuG_40_AusfG':             'StuG',
    'usa:M10_Wolverine':                 'Wolv',
    'usa:T49':                           'T49',
    'france:S_35CA':                     'S35',
    'uk:GB73_AT2':                       'AT2',
    'ussr:SU122A':                       '122A',
    'germany:Grille':                    'Grill',
    'usa:M41':                           'M41',
    'france:_105_leFH18B2':              'leFH',
    'france:AMX_105AM':                  '105AM',
    'uk:GB28_Bishop':                    'Bishp',

    # level 6
    'ussr:MT25':                         'MT25',
    'germany:VK2801':                    '2801',
    'usa:T21':                           'T21',
    'china:Ch15_59_16':                  '59-16',
    'china:Ch24_Type64':                 't-64',
    'france:AMX_12t':                    '12t',
    'ussr:A43':                          'A43',
    'ussr:T-34-85':                      '3485',
    'germany:PzIV_schmalturm':           'Pz4S',
    'germany:VK3001P':                   '3001P',
    'germany:VK3002DB_V1':               '3002DB',
    'germany:VK3002M':                   '3002M',
    'usa:M4A3E8_Sherman':                'SheE8',
    'usa:Sherman_Jumbo':                 'SheJm',
    'china:Ch20_Type58':                 '58',
    'uk:GB21_Cromwell':                  'Cromw',
    'japan:Chi_To':                      'ChiTo',
    'ussr:KV-1s':                        'KV1S',
    'ussr:KV2':                          'KV2',
    'ussr:T150':                         'T150',
    'germany:VK3601H':                   '3601',
    'usa:M6':                            'M6',
    'france:ARL_44':                     'ARL',
    'uk:GB09_Churchill_VII':             'Chur7',
    'ussr:SU-100':                       'Su100',
    'ussr:SU100Y':                       '100Y',
    'germany:DickerMax':                 'DMax',
    'germany:JagdPzIV':                  'JPz',
    'germany:Nashorn':                   'Nash',
    'usa:M18_Hellcat':                   'Hellc',
    'usa:M36_Slagger':                   'Jacks',
    'france:ARL_V39':                    'V39',
    'uk:GB40_Gun_Carrier_Churchill':     'GChur',
    'uk:GB74_AT8':                       'AT8',
    'ussr:SU-8':                         'Su8',
    'germany:Hummel':                    'Humm',
    'usa:M44':                           'M44',
    'france:AMX_13F3AM':                 '13F3',
    'uk:GB77_FV304':                     'FV304',

    # level 7
    'germany:Auf_Panther':               'APant',
    'usa:T71':                           '71',
    'china:Ch02_Type62':                 '62',
    'china:Ch16_WZ_131':                 '131',
    'france:AMX_13_75':                  '1375',
    'ussr:A44':                          'A44',
    'ussr:KV-13':                        'KV13',
    'ussr:T-43':                         '43',
    'germany:PzV':                       'Pant',
    'germany:VK3002DB':                  '3002D',
    'usa:T20':                           'T20',
    'usa:T23E3':                         'T23E',
    'china:Ch04_T34_1':                  '34/1',
    'uk:GB22_Comet':                     'Comet',
    'japan:Chi_Ri':                      'ChiRi',
    'ussr:IS':                           'IS',
    'ussr:KV-3':                         'KV3',
    'germany:PzVI':                      'Tger',
    'germany:PzVI_Tiger_P':              'TgerP',
    'usa:T29':                           'T29',
    'china:Ch10_IS2':                    'IS2',
    'france:AMX_M4_1945':                'AMX1945',
    'uk:GB10_Black_Prince':              'Princ',
    'ussr:SU100M1':                      '100M1',
    'ussr:SU122_44':                     '12244',
    'ussr:SU-152':                       '152',
    'germany:JagdPanther':               'JagP',
    'germany:Sturer_Emil':               'Emil',
    'usa:T25_2':                         '25/2',
    'usa:T25_AT':                        '25AT',
    'france:AMX_AC_Mle1946':             'Mle46',
    'uk:GB71_AT_15A':                    'AT15A',
    'uk:GB75_AT7':                       'AT7',
    'ussr:S-51':                         'S51',
    'ussr:SU14_1':                       'Su141',
    'germany:G_Panther':                 'GwP',
    'usa:M12':                           'M12',
    'france:Lorraine155_50':             '15550',
    'uk:GB29_Crusader_5inch':            'Crus5',

    # level 8
    'china:Ch17_WZ131_1_WZ132':          '132',
    'france:AMX_13_90':                  '1390',
    'ussr:Object416':                    'o416',
    'ussr:T-44':                         '44',
    'germany:Indien_Panzer':             'IndPz',
    'germany:Panther_II':                'Pant2',
    'usa:Pershing':                      'Persh',
    'usa:T23':                           'T23',
    'usa:T69':                           '69',
    'china:Ch05_T34_2':                  '34/2',
    'uk:GB23_Centurion':                 'Cent',
    'japan:STA_1':                       'STA1',
    'ussr:IS-3':                         '3',
    'ussr:KV4':                          'KV4',
    'germany:Lowe':                      'Lowe',
    'germany:PzVIB_Tiger_II':            'Tger2',
    'germany:VK4502A':                   '4502A',
    'usa:M6A2E1':                        'M6A2E',
    'usa:T32':                           'T32',
    'usa:T34_hvy':                       'T34Hv',
    'china:Ch03_WZ-111':                 '111',
    'china:Ch11_110':                    '110',
    'france:AMX_50_100':                 '50100',
    'uk:GB11_Caernarvon':                'Caern',
    'ussr:ISU-152':                      '152',
    'ussr:SU-101':                       'Su101',
    'germany:Ferdinand':                 'Ferd',
    'germany:JagdPantherII':             'JagP2',
    'germany:RhB_Waffentrager':          'WTRhB',
    'usa:T28':                           'T28',
    'usa:T28_Prototype':                 'T28Pr',
    'france:AMX_AC_Mle1948':             'Mle48',
    'uk:GB72_AT15':                      'AT15',
    'ussr:SU-14':                        'Su142',
    'germany:GW_Tiger_P':                'GwTP',
    'usa:M40M43':                        '4043',
    'france:Lorraine155_51':             '15551',
    'uk:GB79_FV206':                     'FV206',

    # level 9
    'ussr:R104_Object_430_II':           '430/2',
    'ussr:T-54':                         '54',
    'germany:E-50':                      '50',
    'germany:Pro_Ag_A':                  'LeoPr',
    'usa:M46_Patton':                    'Patt',
    'usa:T54E1':                         '54E1',
    'china:Ch18_WZ-120':                 '120',
    'france:Lorraine40t':                'Lor40',
    'uk:GB24_Centurion_Mk3':             'Cent3',
    'japan:Type_61':                     '61',
    'ussr:IS8':                          '8',
    'ussr:ST_I':                         'ST1',
    'germany:E-75':                      '75',
    'germany:VK4502P':                   '4502P',
    'usa:M103':                          '103',
    'china:Ch12_111_1_2_3':              '111/1',
    'france:AMX_50_120':                 '50120',
    'uk:GB12_Conqueror':                 'Conq',
    'ussr:Object_704':                   '704',
    'ussr:SU122_54':                     '12254',
    'germany:JagdTiger':                 'JagT',
    'germany:Waffentrager_IV':           'WT4',
    'usa:T30':                           'T30',
    'usa:T95':                           '95',
    'france:AMX50_Foch':                 'Foch',
    'uk:GB32_Tortoise':                  'Tort',
    'ussr:Object_212':                   '212',
    'germany:G_Tiger':                   'GwT',
    'usa:M53_55':                        '5355',
    'france:Bat_Chatillon155_55':        'Bat155',
    'uk:GB30_FV3805':                    '3805',

    # level 10
    'ussr:Object_140':                   'o140',
    'ussr:Object_430':                   '430',
    'ussr:Object_907':                   '907',
    'ussr:T62A':                         '62A',
    'germany:E50_Ausf_M':                '50M',
    'germany:Leopard1':                  'Leo',
    'usa:M48A1':                         'M48',
    'usa:M60':                           'M60',
    'usa:T95_E6':                        'T95E',
    'china:Ch19_121':                    '121',
    'france:Bat_Chatillon25t':           'Bat',
    'uk:GB70_FV4202_105':                '4202',
    'japan:ST_B1':                       'STB1',
    'ussr:IS-4':                         '4',
    'ussr:IS-7':                         '7',
    'germany:E-100':                     '100',
    'germany:Maus':                      'Maus',
    'germany:VK7201':                    '7201',
    'usa:T110':                          '110E5',
    'usa:T57_58':                        'T57H',
    'china:Ch22_113':                    '113',
    'france:F10_AMX_50B':                '50B',
    'uk:GB13_FV215b':                    '215b',
    'ussr:Object263':                    '263',
    'ussr:Object268':                    '268',
    'germany:JagdPz_E100':               'JPz100',
    'germany:Waffentrager_E100':         'WT100',
    'usa:T110E3':                        'E3',
    'usa:T110E4':                        'E4',
    'france:AMX_50Fosh_155':             'Foch155',
    'uk:GB48_FV215b_183':                '183',
    'ussr:Object_261':                   '261',
    'germany:G_E':                       'GwE',
    'usa:T92':                           'T92',
    'france:Bat_Chatillon155_58':        '15558',
    'uk:GB31_Conqueror_Gun':             'ConqG',

    # non-standard
    'germany:PzI':                       'Pz1',
    'usa:T2_lt':                         'T2LT',
    'ussr:BT-SV':                        'BTSV',
    'ussr:M3_Stuart_LL':                 'StuLL',
    'ussr:T-127':                        'T127',
    'germany:PzII_J':                    'Pz2J',
    'ussr:T80':                          'T80',
    'ussr:Valentine_LL':                 'ValLL',
    'france:AMX40':                      'AMX40',
    'uk:GB04_Valentine':                 'Val1',
    'uk:GB60_Covenanter':                'Coven',
    'ussr:A-32':                         'A32',
    'germany:B-1bis_captured':           'B1bis',
    'usa:M24_Chaffee':                   'Chaff',
    'uk:GB20_Crusader':                  'Crus',
    'ussr:Matilda_II_LL':                'MatLL',
    'germany:PzIV_Hydro':                'Pz4H',
    'usa:M4A2E4':                        'SheE4',
    'uk:GB68_Matilda_Black_Prince':      'MatilBP',
    'japan:Chi_Nu_Kai':                  'ChiNuKai',
    'ussr:Churchill_LL':                 'Chur',
    'ussr:KV-220':                       'KV220',
    'ussr:KV-220_action':                'KV220A',
    'usa:T14':                           'T14',
    'uk:GB51_Excelsior':                 'Excel',
    'ussr:SU_85I':                       'Su85i',
    'germany:PzV_PzIV':                  'Pz5/4',
    'germany:PzV_PzIV_ausf_Alfa':        'Pz5/4A',
    'uk:GB63_TOG_II':                    'TOG',
    'ussr:T44_122':                      'T44-122',
    'ussr:T44_85':                       'T44-85',
    'germany:Panther_M10':               'PaM10',
    'germany:E-25':                      'E25',
    'usa:T26_E4_SuperPershing':          'Super',
    'china:Ch01_Type59':                 '59',
    'china:Ch01_Type59_Gold':            '59G',
    'china:Ch14_T34_3':                  '34/3',
    'ussr:KV-5':                         'KV5',
    'ussr:Object252':                    'IS6',
    'china:Ch23_112':                    '112',
    'france:FCM_50t':                    'Fcm50',
    'germany:JagdTiger_SdKfz_185':       'JgT88',
}
