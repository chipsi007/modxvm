""" XVM (c) www.modxvm.com 2013-2015 """

from xfw import *
from logger import *

# PUBLIC

# returns tuple of camo values: standing, moving, shooting
def getCamoValues(veh_name, turret_is_top = True, gun = None):
    return _getCamoValues(veh_name, turret_is_top, gun)

# PRIVATE

# Data from: http://forum.worldoftanks.ru/index.php?/topic/1047590-
# Updated 28.03.2015
# Big thanks to authors of data!

# percentage of lowering vision: [ standing, moving, shooting, top turret modifier ]
_tanks_camo = {
# USSR
    # Light
    'ussr:MS-1':                              [ 14.99 , 11.29 , 3.70 , 1     ],
    'ussr:Tetrarch_LL':                       [ 15.67 , 11.74 , 4.00 , 1     ],
    'ussr:T-60':                              [ 17.45 , 13.05 , 4.45 , 1     ],
    'ussr:BT-2':                              [ 14.95 , 11.23 , 3.81 , 1.115 ],
    'ussr:T-26':                              [ 13.81 , 10.37 , 3.52 , 1.989 ],
    'ussr:M3_Stuart_LL':                      [ 15.22 , 15.22 , 4.57 , 1     ],
    'ussr:T-127':                             [ 17.96 , 13.45 , 5.21 , 1     ],
    'ussr:BT-SV':                             [ 16.87 , 12.65 , 4.89 , 1     ],
    'ussr:BT-7':                              [ 16.53 , 16.53 , 4.96 , 1     ],
    'ussr:LTP':                               [ 20.18 , 15.16 , 5.85 , 1     ],
    'ussr:T-46':                              [ 16.12 , 12.08 , 4.45 , 1.972 ],
    'ussr:T-70':                              [ 17.61 , 13.18 , 4.86 , 1.936 ],
    'ussr:Valentine_LL':                      [ 17.95 , 17.95 , 5.21 , 1     ],
    'ussr:A-20':                              [ 16.06 , 16.06 , 4.43 , 1.116 ],
    'ussr:T80':                               [ 18.30 , 18.30 , 5.05 , 1     ],
    'ussr:T-50':                              [ 17.73 , 17.73 , 4.89 , 1     ],
    'ussr:MT25':                              [ 14.73 , 14.73 , 3.92 , 1.916 ],
    'ussr:R107_LTB':                          [ 15.39 , 15.39 , 3.66 , 1     ],
    'ussr:R109_T54S':                         [ 15.96 , 15.96 , 3.51 , 1     ],
    # Medium
    'ussr:A-32':                              [ 15.96 , 11.97 , 4.15 , 1     ],
    'ussr:T-28':                              [ 11.63 ,  8.72 , 3.09 , 1     ],
    'ussr:Matilda_II_LL':                     [ 15.11 , 11.34 , 3.93 , 1     ],
    'ussr:R04_T-34':                          [ 14.45 , 10.83 , 3.84 , 1.881 ],
    'ussr:R108_T34_85M':                      [ 14.08 , 10.55 , 3.52 , 1     ],
    'ussr:T-34-85':                           [ 13.97 , 10.49 , 3.32 , 1     ],
    'ussr:A43':                               [ 12.14 ,  9.13 , 3.23 , 1.766 ],
    'ussr:T-43':                              [ 14.71 , 11.07 , 3.50 , 1.981 ],
    'ussr:KV-13':                             [ 15.21 , 11.41 , 3.62 , 1.126 ],
    'ussr:A44':                               [ 12.54 ,  9.41 , 2.76 , 1     ],
    'ussr:T-44':                              [ 16.03 , 12.05 , 3.35 , 1.983 ],
    'ussr:Object416':                         [ 24.19 , 14.55 , 4.79 , 1.113 ],
    'ussr:T-54':                              [ 15.59 , 11.70 , 3.26 , 1.977 ],
    'ussr:R104_Object_430_II':                [ 16.59 , 12.42 , 2.56 , 1.977 ],
    'ussr:Object_907':                        [ 17.21 , 12.94 , 3.41 , 1     ],
    'ussr:Object_140':                        [ 16.15 , 12.09 , 3.20 , 1     ],
    'ussr:Object_430':                        [ 17.84 , 13.39 , 3.53 , 1     ],
    'ussr:T62A':                              [ 15.28 , 11.46 , 3.02 , 1     ],
    # Heavy
    'ussr:KV-220_action':                     [  7.13 ,  3.59 , 1.85 , 1     ],
    'ussr:Churchill_LL':                      [  8.04 ,  4.05 , 2.25 , 1     ],
    'ussr:KV1':                               [  7.30 ,  3.65 , 1.82 , 1     ],
    'ussr:KV-1s':                             [  7.87 ,  3.93 , 1.97 , 1     ],
    'ussr:T150':                              [  6.51 ,  3.28 , 1.43 , 1.914 ],
    'ussr:R106_KV85':                         [  6.90 ,  3.48 , 1.52 , 1     ],
    'ussr:KV2':                               [  4.05 ,  2.02 , 0.61 , 1.365 ],
    'ussr:KV-3':                              [  5.87 ,  2.93 , 1.12 , 1.971 ],
    'ussr:IS':                                [  7.92 ,  3.99 , 1.51 , 1     ],
    'ussr:KV-5':                              [  3.08 ,  1.54 , 0.68 , 1     ],
    'ussr:Object252':                         [  6.96 ,  3.48 , 1.32 , 1     ],
    'ussr:KV4':                               [  1.78 ,  0.89 , 0.37 , 1.433 ],
    'ussr:IS-3':                              [  6.75 ,  3.37 , 1.21 , 1.971 ],
    'ussr:IS8':                               [  6.07 ,  3.04 , 1.09 , 1.951 ],
    'ussr:ST_I':                              [  6.10 ,  3.08 , 1.10 , 1.915 ],
    'ussr:R110_Object_260':                   [  5.81 ,  2.91 , 1.05 , 1     ],
    'ussr:IS-7':                              [  6.61 ,  3.31 , 1.01 , 1     ],
    'ussr:IS-4':                              [  6.67 ,  3.36 , 1.20 , 1     ],
    # TD
    'ussr:AT-1':                              [ 21.21 , 12.71 , 5.05 , 1     ],
    'ussr:SU76I':                             [ 20.63 , 12.38 , 7.51 , 1     ],
    'ussr:SU-76':                             [ 22.51 , 13.51 , 6.30 , 1     ],
    'ussr:GAZ-74b':                           [ 22.63 , 13.57 , 5.39 , 1     ],
    'ussr:SU_85I':                            [ 20.41 , 12.26 , 7.14 , 1     ],
    'ussr:SU-85':                             [ 22.29 , 13.39 , 5.30 , 1     ],
    'ussr:SU100Y':                            [  6.67 ,  3.99 , 1.53 , 1     ],
    'ussr:SU-100':                            [ 22.06 , 13.22 , 4.19 , 1     ],
    'ussr:SU122_44':                          [ 21.55 , 12.94 , 5.82 , 1     ],
    'ussr:SU-152':                            [ 16.47 ,  9.86 , 2.36 , 1     ],
    'ussr:SU100M1':                           [ 20.18 , 12.09 , 4.22 , 1     ],
    'ussr:ISU-152':                           [ 15.05 ,  9.06 , 2.03 , 1     ],
    'ussr:SU-101':                            [ 20.29 , 12.20 , 3.12 , 1     ],
    'ussr:SU122_54':                          [ 21.77 , 13.05 , 3.92 , 1     ],
    'ussr:R53_Object_704':                    [ 17.61 , 10.55 , 2.38 , 1     ],
    'ussr:Object263':                         [ 14.14 ,  8.49 , 2.16 , 1     ],
    'ussr:Object268':                         [ 16.36 ,  9.80 , 2.34 , 1     ],
    # SPG
    'ussr:SU-18':                             [ 13.23 ,  6.61 , 2.75 , 1     ],
    'ussr:SU-26':                             [ 13.28 ,  6.67 , 3.45 , 1     ],
    'ussr:SU-5':                              [ 14.99 ,  7.47 , 2.25 , 1     ],
    'ussr:SU122A':                            [ 16.07 ,  8.04 , 2.30 , 1     ],
    'ussr:SU-8':                              [  8.21 ,  4.11 , 1.11 , 1     ],
    'ussr:SU14_1':                            [  7.07 ,  3.53 , 0.61 , 1     ],
    'ussr:S-51':                              [  4.67 ,  2.34 , 0.40 , 1     ],
    'ussr:SU-14':                             [  3.48 ,  1.71 , 0.30 , 1     ],
    'ussr:Object_212':                        [  3.48 ,  1.71 , 0.30 , 1     ],
    'ussr:Object_261':                        [  6.16 ,  3.08 , 0.70 , 1     ],
# Germany
    # Light
    'germany:Ltraktor':                       [ 13.43 , 10.07 , 3.43 , 1.152 ],
    'germany:H39_captured':                   [ 15.73 , 11.80 , 4.01 , 1     ],
    'germany:G108_PzKpfwII_AusfD':            [ 15.73 , 11.80 , 3.74 , 1     ],
    'germany:PzII':                           [ 15.11 , 11.34 , 3.38 , 1     ],
    'germany:PzI':                            [ 16.16 , 12.12 , 3.85 , 1.971 ],
    'germany:Pz35t':                          [ 15.16 , 11.40 , 3.87 , 1     ],
    'germany:T-15':                           [ 19.27 , 19.27 , 5.78 , 1     ],
    'germany:PzII_J':                         [ 17.39 , 13.05 , 4.87 , 1     ],
    'germany:Pz38t':                          [ 17.99 , 13.51 , 5.22 , 1.135 ],
    'germany:PzIII_A':                        [ 18.01 , 18.01 , 5.22 , 1     ],
    'germany:Pz_II_AusfG':                    [ 18.62 , 18.62 , 3.91 , 1.115 ],
    'germany:PzI_ausf_C':                     [ 19.03 , 19.03 , 5.33 , 1.137 ],
    'germany:Pz38_NA':                        [ 17.58 , 17.58 , 4.59 , 1.958 ],
    'germany:PzII_Luchs':                     [ 17.07 , 17.07 , 3.58 , 1.985 ],
    'germany:VK1602':                         [ 16.59 , 16.59 , 3.48 , 1     ],
    'germany:VK2801':                         [ 14.25 , 14.25 , 2.98 , 1     ],
    'germany:Auf_Panther':                    [ 10.43 , 10.43 , 2.71 , 1.893 ],
    'germany:G103_RU_251':                    [ 17.39 , 17.39 , 4.14 , 1     ],
    # Medium
    'germany:S35_captured':                   [ 14.25 , 10.72 , 4.13 , 1     ],
    'germany:G100_Gtraktor_Krupp':            [ 14.71 , 11.06 , 3.82 , 1     ],
    'germany:Pz_IV_AusfA':                    [ 14.53 , 10.89 , 3.78 , 1     ],
    'germany:PzIII_AusfJ':                    [ 16.34 , 12.27 , 4.51 , 1.116 ],
    'germany:VK2001DB':                       [ 15.85 , 11.91 , 4.37 , 1     ],
    'germany:Pz_IV_AusfD':                    [ 14.82 , 11.11 , 3.66 , 1     ],
    'germany:PzIV_Hydro':                     [ 14.71 , 11.06 , 3.63 , 1     ],
    'germany:T-25':                           [ 12.88 ,  9.63 , 3.35 , 1     ],
    'germany:PzIII_IV':                       [ 13.97 , 10.49 , 3.45 , 1     ],
    'germany:Pz_IV_AusfH':                    [ 14.71 , 11.06 , 3.07 , 1     ],
    'germany:PzV_PzIV':                       [ 10.55 ,  7.92 , 2.61 , 1     ],
    'germany:PzIV_schmalturm':                [ 12.94 ,  9.75 , 3.20 , 1     ],
    'germany:VK3002DB_V1':                    [ 13.77 , 10.34 , 3.22 , 1.941 ],
    'germany:VK3001P':                        [ 10.49 ,  7.85 , 2.50 , 1.112 ],
    'germany:VK3002M':                        [  9.58 ,  7.17 , 2.24 , 1.983 ],
    'germany:Panther_M10':                    [  9.23 ,  6.90 , 2.28 , 1     ],
    'germany:VK3002DB':                       [ 12.64 ,  9.49 , 3.01 , 1.921 ],
    'germany:PzV':                            [  9.15 ,  6.84 , 2.14 , 1.991 ],
    'germany:G106_PzKpfwPanther_AusfF':       [  9.03 ,  6.78 , 2.15 , 1     ],
    'germany:Panther_II':                     [  9.34 ,  6.97 , 2.22 , 1.122 ],
    'germany:Indien_Panzer':                  [ 11.86 ,  8.89 , 2.67 , 1     ],
    'germany:G105_T-55_NVA_DDR':              [ 15.56 , 11.69 , 3.25 , 1     ],
    'germany:Pro_Ag_A':                       [ 14.53 , 10.89 , 3.04 , 1     ],
    'germany:E-50':                           [  9.06 ,  6.78 , 1.89 , 1     ],
    'germany:Leopard1':                       [ 14.08 , 10.55 , 2.94 , 1     ],
    'germany:E50_Ausf_M':                     [  9.86 ,  7.41 , 2.06 , 1     ],
    # Heavy
    'germany:B-1bis_captured':                [  7.52 ,  3.76 , 2.18 , 1     ],
    'germany:DW_II':                          [  7.52 ,  3.73 , 1.96 , 1.117 ],
    'germany:VK3001H':                        [  7.33 ,  3.67 , 1.91 , 1.932 ],
    'germany:VK3601H':                        [  6.47 ,  3.21 , 1.54 , 1.866 ],
    'germany:PzVI':                           [  6.55 ,  3.34 , 1.47 , 1.164 ],
    'germany:PzVI_Tiger_P':                   [  6.67 ,  3.36 , 1.50 , 1     ],
    'germany:Lowe':                           [  3.82 ,  1.94 , 0.76 , 1     ],
    'germany:VK4502A':                        [  4.12 ,  2.06 , 0.86 , 1.914 ],
    'germany:PzVIB_Tiger_II':                 [  4.27 ,  2.17 , 0.85 , 1     ],
    'germany:E-75':                           [  4.01 ,  2.00 , 0.61 , 1.976 ],
    'germany:VK4502P':                        [  4.78 ,  2.39 , 0.73 , 1.952 ],
    'germany:VK7201':                         [  3.76 ,  1.88 , 0.51 , 1     ],
    'germany:E-100':                          [  2.91 ,  1.48 , 0.39 , 1     ],
    'germany:Maus':                           [  1.43 ,  0.68 , 0.23 , 1     ],
    # TD
    'germany:PanzerJager_I':                  [ 19.38 , 11.63 , 4.79 , 1     ],
    'germany:G20_Marder_II':                  [ 21.43 , 12.88 , 5.29 , 1     ],
    'germany:Hetzer':                         [ 24.00 , 14.42 , 5.02 , 1     ],
    'germany:Marder_III':                     [ 19.27 , 11.57 , 4.76 , 1     ],
    'germany:G101_StuG_III':                  [ 23.14 , 13.91 , 4.84 , 1     ],
    'germany:G104_Stug_IV':                   [ 20.86 , 12.54 , 5.15 , 1     ],
    'germany:StuG_40_AusfG':                  [ 21.89 , 13.11 , 5.41 , 1     ],
    'germany:Pz_Sfl_IVc':                     [ 12.79 ,  7.66 , 3.04 , 1.134 ],
    'germany:DickerMax':                      [ 16.87 , 10.09 , 5.01 , 1     ],
    'germany:JagdPzIV':                       [ 23.77 , 14.25 , 5.94 , 1     ],
    'germany:Nashorn':                        [ 12.37 ,  7.41 , 2.78 , 1     ],
    'germany:E-25':                           [ 25.14 , 15.05 , 8.82 , 1     ],
    'germany:JagdPanther':                    [ 13.11 ,  7.87 , 2.74 , 1     ],
    'germany:Sturer_Emil':                    [ 11.29 ,  6.78 , 1.73 , 1     ],
    'germany:JagdTiger_SdKfz_185':            [ 10.66 ,  6.38 , 2.40 , 1     ],
    'germany:JagdPantherII':                  [ 10.20 ,  6.10 , 1.65 , 1     ],
    'germany:Ferdinand':                      [ 10.89 ,  6.55 , 1.76 , 1     ],
    'germany:RhB_Waffentrager':               [ 22.51 , 13.51 , 3.44 , 1     ],
    'germany:JagdTiger':                      [ 10.66 ,  6.38 , 1.73 , 1     ],
    'germany:Waffentrager_IV':                [ 15.67 ,  9.41 , 2.40 , 1     ],
    'germany:JagdPz_E100':                    [  3.02 ,  1.82 , 0.33 , 1     ],
    'germany:Waffentrager_E100':              [  0.40 ,  0.23 , 0.06 , 1     ],
    # SPG
    'germany:GW_Mk_VIe':                      [ 16.13 ,  8.10 , 3.02 , 1     ],
    'germany:Wespe':                          [ 16.19 ,  8.09 , 3.38 , 1     ],
    'germany:Bison_I':                        [  8.83 ,  4.39 , 1.33 , 1     ],
    'germany:Pz_Sfl_IVb':                     [ 16.76 ,  8.38 , 3.50 , 1     ],
    'germany:Sturmpanzer_II':                 [ 17.33 ,  8.66 , 2.60 , 1     ],
    'germany:Grille':                         [ 15.39 ,  7.70 , 2.31 , 1     ],
    'germany:Hummel':                         [ 12.20 ,  6.10 , 1.74 , 1     ],
    'germany:G_Panther':                      [  3.76 ,  1.88 , 0.51 , 1     ],
    'germany:GW_Tiger_P':                     [  3.19 ,  1.60 , 0.27 , 1     ],
    'germany:G_Tiger':                        [  4.90 ,  2.45 , 0.42 , 1     ],
    'germany:G_E':                            [  1.60 ,  0.80 , 0.14 , 1     ],
# USA
    # Light
    'usa:T1_Cunningham':                      [ 12.76 ,  9.59 , 2.86 , 1.995 ],
    'usa:T2_lt':                              [ 14.99 , 11.29 , 3.36 , 1     ],
    'usa:T1_E6':                              [ 14.25 , 10.72 , 2.78 , 1     ],
    'usa:T7_Combat_Car':                      [ 13.51 , 10.09 , 3.22 , 1     ],
    'usa:M2_lt':                              [ 13.56 , 10.20 , 3.46 , 1.918 ],
    'usa:MTLS-1G14':                          [ 12.54 ,  9.41 , 3.01 , 1     ],
    'usa:M22_Locust':                         [ 20.35 , 20.35 , 6.11 , 1     ],
    'usa:M3_Stuart':                          [ 15.31 , 15.31 , 4.59 , 1.116 ],
    'usa:M5_Stuart':                          [ 16.19 , 16.19 , 3.88 , 1.144 ],
    'usa:M24_Chaffee':                        [ 15.68 , 15.68 , 3.87 , 1     ],
    'usa:T21':                                [ 15.28 , 15.28 , 3.77 , 1     ],
    'usa:A94_T37':                            [ 13.67 , 13.67 , 3.20 , 1.952 ],
    'usa:T71':                                [ 14.08 , 14.08 , 3.29 , 1     ],
    'usa:M41_Bulldog':                        [ 14.25 , 14.25 , 3.33 , 1     ],
    'usa:T49':                                [ 15.27 , 15.27 , 2.29 , 1.218 ],
    # Medium
    'usa:T2_med':                             [ 10.26 ,  7.70 , 2.62 , 1     ],
    'usa:M2_med':                             [ 12.22 ,  9.15 , 3.18 , 1.199 ],
    'usa:M3_Grant':                           [  7.87 ,  5.87 , 2.05 , 1     ],
    'usa:M4A2E4':                             [ 11.74 ,  8.78 , 3.05 , 1     ],
    'usa:Ram-II':                             [ 12.65 ,  9.52 , 3.54 , 1     ],
    'usa:M4_Sherman':                         [ 12.57 ,  9.40 , 2.77 , 1.976 ],
    'usa:M7_med':                             [ 14.71 , 11.06 , 4.12 , 1     ],
    'usa:A104_M4A3E8A':                       [ 11.34 ,  8.49 , 2.80 , 1     ],
    'usa:M4A3E8_Sherman':                     [ 12.25 ,  9.18 , 3.03 , 1     ],
    'usa:Sherman_Jumbo':                      [ 11.51 ,  8.67 , 2.53 , 1     ],
    'usa:T23E3':                              [ 14.42 , 10.83 , 3.75 , 1     ],
    'usa:T20':                                [ 16.04 , 12.05 , 3.82 , 1.162 ],
    'usa:T26_E4_SuperPershing':               [ 13.17 ,  9.86 , 2.96 , 1     ],
    'usa:T69':                                [ 12.65 ,  9.52 , 3.01 , 1     ],
    'usa:Pershing':                           [ 12.99 ,  9.71 , 2.92 , 1.118 ],
    'usa:M46_Patton':                         [ 13.34 , 10.03 , 2.64 , 1     ],
    'usa:T54E1':                              [  9.86 ,  7.35 , 1.95 , 1     ],
    'usa:M60':                                [  6.95 ,  5.19 , 1.45 , 1     ],
    'usa:M48A1':                              [  8.27 ,  6.21 , 1.73 , 1     ],
    # Heavy
    'usa:T14':                                [  7.75 ,  3.88 , 2.02 , 1     ],
    'usa:T1_hvy':                             [  4.37 ,  2.19 , 1.14 , 1.959 ],
    'usa:M6':                                 [  4.45 ,  2.23 , 1.11 , 1     ],
    'usa:T29':                                [  4.79 ,  2.39 , 1.05 , 1     ],
    'usa:M6A2E1':                             [  1.03 ,  0.51 , 0.21 , 1     ],
    'usa:T34_hvy':                            [  3.93 ,  1.94 , 0.71 , 1     ],
    'usa:T32':                                [  5.81 ,  2.91 , 1.22 , 1     ],
    'usa:M103':                               [  4.62 ,  2.34 , 0.83 , 1     ],
    'usa:T110':                               [  4.56 ,  2.28 , 0.82 , 1     ],
    'usa:T57_58':                             [  4.90 ,  2.45 , 0.88 , 1     ],
    # TD
    'usa:T18':                                [ 19.38 , 13.68 , 4.28 , 1     ],
    'usa:T82':                                [ 24.11 , 14.48 , 5.30 , 1     ],
    'usa:T40':                                [ 20.98 , 12.60 , 5.45 , 1     ],
    'usa:M8A1':                               [ 21.49 , 12.89 , 5.72 , 1.979 ],
    'usa:T67':                                [ 20.63 , 12.36 , 5.36 , 1.885 ],
    'usa:M10_Wolverine':                      [ 17.79 , 10.66 , 4.39 , 1     ],
    'usa:M36_Slagger':                        [ 15.26 ,  9.16 , 3.63 , 1.878 ],
    'usa:M18_Hellcat':                        [ 20.97 , 12.58 , 5.24 , 1.994 ],
    'usa:A102_T28_concept':                   [ 14.76 ,  8.83 , 3.25 , 1     ],
    'usa:T25_AT':                             [ 19.61 , 11.74 , 4.10 , 1     ],
    'usa:T25_2':                              [ 15.13 ,  9.10 , 3.40 , 1.841 ],
    'usa:T28':                                [ 18.18 , 10.89 , 3.27 , 1     ],
    'usa:T28_Prototype':                      [ 12.60 ,  7.53 , 2.27 , 1     ],
    'usa:T95':                                [ 18.18 , 10.89 , 2.45 , 1     ],
    'usa:T30':                                [  9.18 ,  5.53 , 1.24 , 1     ],
    'usa:T110E4':                             [  9.07 ,  5.42 , 1.22 , 1     ],
    'usa:T110E3':                             [  9.97 ,  5.99 , 1.35 , 1     ],
    # SPG
    'usa:T57':                                [ 15.85 ,  7.92 , 3.50 , 1     ],
    'usa:M7_Priest':                          [ 12.54 ,  6.27 , 2.76 , 1     ],
    'usa:M37':                                [ 14.36 ,  7.18 , 3.16 , 1     ],
    'usa:M41':                                [ 16.19 ,  8.09 , 2.43 , 1     ],
    'usa:M44':                                [  9.75 ,  4.90 , 1.46 , 1     ],
    'usa:M12':                                [ 11.69 ,  5.81 , 1.67 , 1     ],
    'usa:M40M43':                             [ 10.55 ,  5.30 , 0.91 , 1     ],
    'usa:M53_55':                             [  6.10 ,  3.08 , 0.52 , 1     ],
    'usa:T92':                                [  7.75 ,  3.88 , 0.44 , 1     ],
# France
    # Light
    'france:RenaultFT':                       [ 13.57 , 10.20 , 3.99 , 1     ],
    'france:D1':                              [ 12.75 ,  9.59 , 3.75 , 1.895 ],
    'france:Hotchkiss_H35':                   [ 15.73 , 11.80 , 4.63 , 1     ],
    'france:AMX38':                           [ 15.96 , 11.97 , 4.63 , 1     ],
    'france:AMX40':                           [ 13.19 ,  9.89 , 3.43 , 1.918 ],
    'france:ELC_AMX':                         [ 21.89 , 21.89 , 5.21 , 1     ],
    'france:AMX_12t':                         [ 17.96 , 17.96 , 4.20 , 1     ],
    'france:AMX_13_75':                       [ 17.67 , 17.67 , 4.14 , 1     ],
    'france:AMX_13_90':                       [ 17.67 , 17.67 , 4.21 , 1     ],
    # Medium
    'france:D2':                              [ 12.64 ,  9.49 , 3.67 , 1.921 ],
    'france:F68_AMX_Chasseur_de_char_46':     [ 11.12 ,  8.32 , 2.50 , 1     ],
    'france:Lorraine40t':                     [ 11.63 ,  8.72 , 2.30 , 1     ],
    'france:Bat_Chatillon25t':                [ 16.87 , 12.65 , 3.34 , 1     ],
    # Heavy  vs. Machine guns =)
    'france:B1':                              [  7.46 ,  3.71 , 2.16 , 1.913 ],
    'france:BDR_G1B':                         [  6.28 ,  3.14 , 1.57 , 1.112 ],
    'france:ARL_44':                          [  5.25 ,  2.62 , 1.18 , 2.421 ],
    'france:AMX_M4_1945':                     [  6.22 ,  3.14 , 1.40 , 1.139 ],
    'france:FCM_50t':                         [  4.33 ,  2.17 , 0.97 , 1     ],
    'france:AMX_50_100':                      [  5.59 ,  2.62 , 1.11 , 1     ],
    'france:AMX_50_120':                      [  4.73 ,  2.34 , 0.66 , 1     ],
    'france:F10_AMX_50B':                     [  3.82 ,  1.94 , 0.53 , 1     ],
    # TD
    'france:RenaultFT_AC':                    [ 14.71 ,  8.84 , 3.63 , 1     ],
    'france:FCM_36Pak40':                     [ 18.30 , 10.95 , 6.42 , 1     ],
    'france:RenaultUE57':                     [ 26.85 , 16.13 , 6.77 , 1     ],
    'france:Somua_Sau_40':                    [ 16.07 ,  9.63 , 3.54 , 1     ],
    'france:S_35CA':                          [ 21.09 , 12.65 , 4.41 , 1     ],
    'france:ARL_V39':                         [ 16.25 ,  9.75 , 3.66 , 1     ],
    'france:AMX_AC_Mle1946':                  [ 10.32 ,  6.21 , 2.04 , 1     ],
    'france:AMX_AC_Mle1948':                  [ 13.28 ,  7.98 , 2.39 , 1     ],
    'france:AMX50_Foch':                      [ 13.85 ,  8.32 , 2.49 , 1     ],
    'france:AMX_50Fosh_155':                  [ 13.85 ,  8.32 , 1.87 , 1     ],
    # SPG
    'france:RenaultBS':                       [ 13.85 ,  6.95 , 3.06 , 1     ],
    'france:Lorraine39_L_AM':                 [ 17.61 ,  8.83 , 3.88 , 1     ],
    'france:AMX_Ob_Am105':                    [ 19.27 ,  9.63 , 4.03 , 1     ],
    'france:_105_leFH18B2':                   [  7.69 ,  3.88 , 1.61 , 1     ],
    'france:AMX_105AM':                       [ 14.42 ,  7.24 , 3.01 , 1     ],
    'france:AMX_13F3AM':                      [ 17.79 ,  8.89 , 2.40 , 1     ],
    'france:Lorraine155_50':                  [  8.49 ,  4.22 , 1.15 , 1     ],
    'france:Lorraine155_51':                  [ 11.00 ,  5.53 , 1.57 , 1     ],
    'france:Bat_Chatillon155_55':             [  6.90 ,  3.48 , 0.99 , 1     ],
    'france:Bat_Chatillon155_58':             [ 11.69 ,  5.81 , 1.67 , 1     ],
# UK
    # Light
    'uk:GB76_Mk_VIC':                         [ 15.67 , 11.74 , 3.73 , 1     ],
    'uk:GB03_Cruiser_Mk_I':                   [ 12.71 ,  9.52 , 2.48 , 1     ],
    'uk:GB58_Cruiser_Mk_III':                 [ 12.94 ,  9.69 , 3.30 , 1     ],
    'uk:GB14_M2':                             [ 13.08 ,  9.84 , 3.34 , 1.918 ],
    'uk:GB69_Cruiser_Mk_II':                  [ 14.84 , 11.15 , 3.71 , 1.113 ],
    'uk:GB59_Cruiser_Mk_IV':                  [ 15.39 , 11.57 , 3.46 , 1     ],
    'uk:GB15_Stuart_I':                       [ 15.04 , 11.28 , 4.51 , 1.147 ],
    'uk:GB60_Covenanter':                     [ 16.76 , 16.76 , 3.77 , 1     ],
    'uk:GB04_Valentine':                      [ 17.84 , 13.39 , 4.75 , 1     ],
    'uk:GB20_Crusader':                       [ 16.76 , 16.76 , 4.46 , 1     ],
    # Medium
    'uk:GB01_Medium_Mark_I':                  [  8.04 ,  6.04 , 1.91 , 1     ],
    'uk:GB05_Vickers_Medium_Mk_II':           [  9.25 ,  6.98 , 2.20 , 1.121 ],
    'uk:GB06_Vickers_Medium_Mk_III':          [ 11.86 ,  8.89 , 3.56 , 1     ],
    'uk:GB07_Matilda':                        [ 15.11 , 11.34 , 4.31 , 1     ],
    'uk:GB17_Grant_I':                        [  9.52 ,  7.13 , 2.48 , 1     ],
    'uk:GB68_Matilda_Black_Prince':           [ 14.14 , 10.60 , 3.76 , 1     ],
    'uk:GB50_Sherman_III':                    [ 10.98 ,  8.23 , 2.85 , 1.963 ],
    'uk:GB21_Cromwell':                       [ 14.42 , 10.83 , 3.56 , 1     ],
    'uk:GB19_Sherman_Firefly':                [ 11.97 ,  8.95 , 2.80 , 1     ],
    'uk:GB22_Comet':                          [ 14.90 , 11.19 , 3.68 , 1.133 ],
    'uk:GB23_Centurion':                      [ 10.99 ,  8.29 , 2.62 , 1.914 ],
    'uk:GB24_Centurion_Mk3':                  [ 11.51 ,  8.66 , 2.74 , 1     ],
    'uk:GB70_FV4202_105':                     [ 13.74 , 10.32 , 2.87 , 1     ],
    # Heavy
    'uk:GB51_Excelsior':                      [  8.49 ,  4.28 , 2.10 , 1     ],
    'uk:GB08_Churchill_I':                    [  8.09 ,  4.05 , 2.00 , 1     ],
    'uk:GB63_TOG_II':                         [  5.13 ,  2.57 , 1.20 , 1     ],
    'uk:GB09_Churchill_VII':                  [  7.47 ,  3.71 , 1.84 , 1     ],
    'uk:GB10_Black_Prince':                   [  7.07 ,  3.53 , 1.65 , 1     ],
    'uk:GB11_Caernarvon':                     [  5.02 ,  2.48 , 1.19 , 1.917 ],
    'uk:GB12_Conqueror':                      [  4.81 ,  2.41 , 0.91 , 1.981 ],
    'uk:GB13_FV215b':                         [  4.79 ,  2.39 , 0.91 , 1     ],
    # TD
    'uk:GB39_Universal_CarrierQF2':           [ 19.49 , 11.69 , 4.64 , 1     ],
    'uk:GB42_Valentine_AT':                   [ 20.01 , 12.03 , 5.04 , 1     ],
    'uk:GB57_Alecto':                         [ 26.73 , 16.07 , 6.36 , 1     ],
    'uk:GB73_AT2':                            [ 17.05 , 10.20 , 4.26 , 1     ],
    'uk:GB44_Archer':                         [ 20.41 , 12.25 , 4.77 , 1     ],
    'uk:GB74_AT8':                            [ 18.01 , 10.77 , 4.22 , 1     ],
    'uk:GB40_Gun_Carrier_Churchill':          [ 15.39 ,  9.23 , 3.46 , 1     ],
    'uk:GB45_Achilles_IIC':                   [ 17.27 , 10.37 , 4.04 , 1     ],
    'uk:GB71_AT_15A':                         [ 12.66 ,  7.58 , 4.28 , 1     ],
    'uk:GB75_AT7':                            [ 17.21 , 10.32 , 4.10 , 1     ],
    'uk:GB41_Challenger':                     [ 13.38 ,  7.99 , 3.13 , 1.935 ],
    'uk:GB72_AT15':                           [ 11.91 ,  7.13 , 2.84 , 1     ],
    'uk:GB80_Charioteer':                     [ 17.44 , 10.49 , 3.65 , 1     ],
    'uk:GB32_Tortoise':                       [  8.72 ,  5.25 , 1.66 , 1     ],
    'uk:GB81_FV4004':                         [  8.67 ,  5.19 , 1.65 , 1     ],
    'uk:GB48_FV215b_183':                     [  9.98 ,  5.99 , 1.14 , 1     ],
    'uk:GB83_FV4005':                         [  1.37 ,  0.85 , 0.16 , 1     ],
    # SPG
    'uk:GB25_Loyd_Carrier':                   [ 18.64 ,  9.35 , 4.12 , 1     ],
    'uk:GB78_Sexton_I':                       [ 14.53 ,  7.30 , 3.46 , 1     ],
    'uk:GB27_Sexton':                         [ 14.53 ,  7.30 , 3.46 , 1     ],
    'uk:GB26_Birch_Gun':                      [ 14.76 ,  7.35 , 3.69 , 1     ],
    'uk:GB28_Bishop':                         [ 11.40 ,  5.70 , 2.38 , 1     ],
    'uk:GB77_FV304':                          [ 19.95 ,  9.97 , 4.17 , 1     ],
    'uk:GB29_Crusader_5inch':                 [ 16.25 ,  8.15 , 2.32 , 1     ],
    'uk:GB79_FV206':                          [  7.69 ,  3.82 , 1.10 , 1     ],
    'uk:GB30_FV3805':                         [  8.15 ,  4.11 , 0.93 , 1     ],
    'uk:GB31_Conqueror_Gun':                  [  6.55 ,  3.25 , 0.39 , 1     ],
# China
    # Light
    'china:Ch06_Renault_NC31':                [ 12.60 ,  9.46 , 3.21 , 1     ],
    'china:Ch07_Vickers_MkE_Type_BT26':       [ 14.35 , 10.78 , 2.80 , 1.111 ],
    'china:Ch08_Type97_Chi_Ha':               [ 16.50 , 12.36 , 4.55 , 1.968 ],
    'china:Ch09_M5':                          [ 16.30 , 16.30 , 4.50 , 1     ],
    'china:Ch24_Type64':                      [ 15.28 , 15.28 , 3.77 , 1     ],
    'china:Ch15_59_16':                       [ 17.39 , 17.39 , 4.29 , 1     ],
    'china:Ch02_Type62':                      [ 16.42 , 16.42 , 4.10 , 1     ],
    'china:Ch16_WZ_131':                      [ 16.45 , 16.45 , 3.62 , 1.123 ],
    'china:Ch17_WZ131_1_WZ132':               [ 16.70 , 16.70 , 3.49 , 1     ],
    # Medium
    'china:Ch21_T34':                         [ 14.42 , 10.83 , 3.84 , 1     ],
    'china:Ch20_Type58':                      [ 13.97 , 10.49 , 3.49 , 1     ],
    'china:Ch04_T34_1':                       [ 17.95 , 13.43 , 3.95 , 1.981 ],
    'china:Ch01_Type59':                      [ 15.67 , 11.74 , 3.45 , 1     ],
    'china:Ch14_T34_3':                       [ 14.93 , 11.17 , 2.84 , 1     ],
    'china:Ch05_T34_2':                       [ 17.04 , 12.77 , 3.41 , 1     ],
    'china:Ch18_WZ-120':                      [ 15.39 , 11.57 , 2.77 , 1     ],
    'china:Ch19_121':                         [ 14.99 , 11.29 , 2.70 , 1     ],
    # Heavy
    'china:Ch10_IS2':                         [  7.80 ,  3.90 , 1.48 , 1.121 ],
    'china:Ch23_112':                         [  6.61 ,  3.31 , 1.26 , 1     ],
    'china:Ch03_WZ-111':                      [  6.73 ,  3.36 , 1.28 , 1     ],
    'china:Ch11_110':                         [  6.27 ,  3.14 , 1.24 , 1     ],
    'china:Ch12_111_1_2_3':                   [  6.70 ,  3.38 , 1.03 , 1.141 ],
    'china:Ch22_113':                         [  6.50 ,  3.25 , 1.17 , 1     ],
# Japan
    # Light
    'japan:NC27':                             [ 13.97 , 10.49 , 3.56 , 1     ],
    'japan:Te_Ke':                            [ 16.81 , 12.60 , 4.29 , 1     ],
    'japan:Ha_Go':                            [ 15.31 , 11.51 , 3.64 , 1.111 ],
    'japan:Ke_Ni_B':                          [ 19.61 , 19.61 , 5.88 , 1     ],
    'japan:Ke_Ni':                            [ 19.28 , 19.28 , 5.78 , 1.983 ],
    'japan:Ke_Ho':                            [ 19.21 , 19.21 , 5.11 , 1     ],
    # Medium
    'japan:Chi_Ni':                           [ 15.96 , 11.97 , 3.80 , 1     ],
    'japan:Chi_Ha':                           [ 16.50 , 12.36 , 4.79 , 1.968 ],
    'japan:Chi_He':                           [ 15.37 , 11.56 , 4.00 , 1.943 ],
    'japan:Chi_Nu_Kai':                       [ 13.85 , 10.37 , 3.60 , 1     ],
    'japan:Chi_Nu':                           [ 13.98 , 10.48 , 3.63 , 1.973 ],
    'japan:Chi_To':                           [ 12.57 ,  9.44 , 3.10 , 1.116 ],
    'japan:Chi_Ri':                           [  9.95 ,  7.46 , 2.46 , 1.839 ],
    'japan:J18_STA_2_3':                      [ 13.68 , 10.26 , 3.26 , 1     ],
    'japan:STA_1':                            [ 15.47 , 11.63 , 3.68 , 1.976 ],
    'japan:Type_61':                          [  9.21 ,  6.91 , 1.93 , 1.188 ],
    'japan:ST_B1':                            [ 13.68 , 10.26 , 2.86 , 1     ]
    }

#  Coefficient of lowering camo at shot
_gun_camo_modifier = {
# USSR
    '_12.7mm_DSHK':
        [
            [ ['ussr:T-60'], 0.238 ]
        ],
    '_20mm_TNSH':
        [
            [ ['ussr:BT-2', 'ussr:MS-1', 'ussr:T-60'], 0.238 ]
        ],
    '_23mm_VJA':
        [
            [ ['ussr:BT-7'], 0.280 ],
            [ ['ussr:BT-2', 'ussr:MS-1', 'ussr:T-26'], 0.238 ]
        ],
    '_23mm_PT-23TB':
        [
            [ ['ussr:T-60'], 0.238 ]
        ],
    '_37mm_ZiS-19':
        [
            [ ['ussr:A-20', 'ussr:BT-7', 'ussr:T-46', 'ussr:T-70'], 0.300 ],
            [ ['ussr:BT-2', 'ussr:T-26', 'ussr:T-60'], 0.255 ]
        ],
    '_37mm_ZiS-19_S':
        [
            [ ['ussr:AT-1'], 0.255 ]
        ],
    '_37mm_Gochkins':
        [
            [ ['ussr:BT-2', 'ussr:MS-1'], 0.255 ]
        ],
    '_37mm_B-3':
        [
            [ ['ussr:BT-2', 'ussr:MS-1', 'ussr:T-26'], 0.255 ]
        ],
    '_37mm_automatic_SH-37':
        [
            [ ['ussr:A-20', 'ussr:MT25', 'ussr:T-46', 'ussr:T-50', 'ussr:T80'], 0.225 ]
        ],
    '_45mm_20K':
        [
            [ ['ussr:A-20', 'ussr:BT-7', 'ussr:MT25', 'ussr:T-46', 'ussr:T-50', 'ussr:T-70', 'ussr:T80'], 0.290 ],
            [ ['ussr:BT-2', 'ussr:T-26'], 0.247 ],
            [ ['china:Ch08_Type97_Chi_Ha'], 0.290 ],
            [ ['china:Ch07_Vickers_MkE_Type_BT26'], 0.247 ]
        ],
    '_45mm_VT-42':
        [
            [ ['ussr:A-20', 'ussr:T-46', 'ussr:T-50', 'ussr:T-70', 'ussr:T80'], 0.276 ]
        ],
    '_45mm_VT-43':
        [
            [ ['ussr:MT25', 'ussr:T-50', 'ussr:T80'], 0.276 ]
        ],
    '_45mm_mod_1932':
        [
            [ ['ussr:MS-1'], 0.247 ]
        ],
    '_45mm_20K_S':
        [
            [ ['ussr:AT-1'], 0.247 ]
        ],
    '_57mm_ZiS-2':
        [
            [ ['ussr:GAZ-74b', 'ussr:SU-76'], 0.280 ]
        ],
    '_57mm_ZiS-8':
        [
            [ ['ussr:T-28'], 0.280 ]
        ],
    '_57mm_ZiS-8_S':
        [
            [ ['ussr:SU-76'], 0.280 ],
            [ ['ussr:AT-1'], 0.238 ]
        ],
    '_57mm_413':
        [
            [ ['ussr:KV1', 'ussr:T150'], 0.266 ]
        ],
    '_57mm_ZiS-4':
        [
            [ ['ussr:A43', 'ussr:A44', 'ussr:MT25', 'ussr:T-28', 'ussr:R04_T-34'], 0.266 ]
        ],
    '_76mm_L-10':
        [
            [ ['ussr:T-28', 'ussr:T-46'], 0.260 ]
        ],
    '_76mm_L-11':
        [
            [ ['ussr:A-20', 'ussr:R04_T-34'], 0.260 ]
        ],
    '_76mm_KT-28':
        [
            [ ['ussr:T-28'], 0.260 ]
        ],
    '_76mm_F-32':
        [
            [ ['ussr:T-28'], 0.260 ]
        ],
    '_76mm_F-34':
        [
            [ ['ussr:A43', 'ussr:A44', 'ussr:R04_T-34'], 0.260 ],
            [ ['china:Ch21_T34'], 0.260 ]
        ],
    '_76mm_ZiS-5':
        [
            [ ['ussr:KV-13', 'ussr:KV-1s', 'ussr:KV1', 'ussr:T150'], 0.260 ]
        ],
    '_76mm_cannon_mod_1927':
        [
            [ ['ussr:SU-26'], 0.260 ]
        ],
    '_76mm_cannon_mod_1905_30':
        [
            [ ['ussr:SU-26', 'ussr:SU-5'], 0.260 ]
        ],
    '_76mm_cannon_mod_1905_40':
        [
            [ ['ussr:SU-26', 'ussr:SU-5'], 0.260 ]
        ],
    '_76mm_S-54':
        [
            [ ['ussr:A43', 'ussr:A44', 'ussr:KV-13', 'ussr:R04_T-34'], 0.247 ]
        ],
    '_76mm_S-54_S':
        [
            [ ['ussr:SU-85'], 0.247 ]
        ],
    '_76mm_ZiS-3_mod_42':
        [
            [ ['ussr:GAZ-74b', 'ussr:SU-76'], 0.247 ]
        ],
    '_76mm_L-10_S':
        [
            [ ['ussr:AT-1'], 0.221 ]
        ],
    '_85mm_D-5S-85A':
        [
            [ ['ussr:GAZ-74b'], 0.250 ]
        ],
    '_85mm_D-5S':
        [
            [ ['ussr:SU-100', 'ussr:SU-85'], 0.250 ]
        ],
    '_85mm_ZiS_S-53':
        [
            [ ['ussr:T-43', 'ussr:T-44', 'ussr:R107_LTB'], 0.250 ]
        ],
    '_85mm_D-5T':
        [
            [ ['ussr:IS', 'ussr:R106_KV85', 'ussr:KV-13'], 0.250 ]
        ],
    '_85mm_F-30':
        [
            [ ['ussr:KV-3', 'ussr:KV1'], 0.250 ]
        ],
    '_85mm_S-31':
        [
            [ ['ussr:KV-3', 'ussr:KV-1s', 'ussr:T150'], 0.250 ]
        ],
    '_85mm_D5T-85BM':
        [
            [ ['ussr:IS', 'ussr:KV-13', 'ussr:T-43', 'ussr:T-44', 'ussr:R107_LTB'], 0.238 ]
        ],
    '_85mm_D10_85':
        [
            [ ['ussr:R107_LTB'], 0.238 ]
        ],
    '_85mm_D5S-85BM':
        [
            [ ['ussr:SU-100', 'ussr:SU-85'], 0.238 ]
        ],
    '_85mm_LB-2S':
        [
            [ ['ussr:GAZ-74b'], 0.238 ]
        ],
    '_100mm_D10T':
        [
            [ ['ussr:IS-3', 'ussr:IS', 'ussr:KV-3', 'ussr:Object416', 'ussr:T-44'], 0.238 ],
            [ ['ussr:R109_T54S'], 0.220 ]
        ],
    '_100mm_D10T_obr_45':
        [
            [ ['ussr:T-54', 'ussr:R109_T54S'], 0.220 ]
        ],
    '_100mm_D10S':
        [
            [ ['ussr:SU-100'], 0.220 ]
        ],
    '_100mm_D10S_obr_44':
        [
            [ ['ussr:SU-101', 'ussr:SU100M1'], 0.220 ]
        ],
    '_100mm_S34':
        [
            [ ['ussr:R106_KV85'], 0.220 ]
        ],
    '_100mm_D-10T2S':
        [
            [ ['ussr:T-54'], 0.209 ]
        ],
    '_100mm_LB-1':
        [
            [ ['ussr:T-44', 'ussr:T-54'], 0.209 ]
        ],
    '_100mm_LB-1S':
        [
            [ ['ussr:SU100M1'], 0.209 ]
        ],
    '_100mm_M-63':
        [
            [ ['ussr:Object416', 'ussr:R104_Object_430_II'], 0.198 ]
        ],
    '_100mm_D54_obr_45':
        [
            [ ['ussr:R104_Object_430_II', 'ussr:T-54'], 0.154 ]
        ],
    '_100mm_D54S':
        [
            [ ['ussr:SU-101', 'ussr:SU122_54'], 0.154 ]
        ],
    '_107mm_ZiS-6':
        [
            [ ['ussr:A44', 'ussr:KV-3', 'ussr:KV2', 'ussr:KV4', 'ussr:T150'], 0.220 ]
        ],
    '_107mm_ZiS-24':
        [
            [ ['ussr:KV4'], 0.209 ]
        ],
    '_122mm_M62-T2S':
        [
            [ ['ussr:SU122_54'], 0.180 ]
        ],
    '_122mm_cannon_mod_1930':
        [
            [ ['ussr:SU-5'], 0.200 ]
        ],
    '_122mm_M-30':
        [
            [ ['ussr:SU122A'], 0.200 ]
        ],
    '_122mm_cannon_M-30S':
        [
            [ ['ussr:SU-85'], 0.200 ]
        ],
    '_122mm_howitzer_A-19':
        [
            [ ['ussr:SU-8'], 0.200 ]
        ],
    '_122mm_A-19':
        [
            [ ['ussr:ISU-152', 'ussr:SU-152'], 0.200 ]
        ],
    '_122mm_cannon_U-11':
        [
            [ ['ussr:KV-13', 'ussr:KV1', 'ussr:KV2', 'ussr:T-43', 'ussr:T150'], 0.200 ]
        ],
    '_122mm_S-41':
        [
            [ ['ussr:KV-1s'], 0.200 ]
        ],
    '_122-mm_D-49':
        [
            [ ['ussr:SU122_54'], 0.190 ]
        ],
    '_122mm_D-25-44':
        [
            [ ['ussr:T-44'], 0.190 ]
        ],
    '_122-mm_D-25T_with_a_piston_shutter':
        [
            [ ['ussr:IS-3', 'ussr:IS', 'ussr:R106_KV85', 'ussr:KV-3', 'ussr:KV4'], 0.190 ]
        ],
    '_122-mm_D-25S_with_a_piston_shutter':
        [
            [ ['ussr:SU-100'], 0.190 ]
        ],
    '_122-mm_D-25T_with_wedges_shutter':
        [
            [ ['ussr:IS-3', 'ussr:IS-4', 'ussr:IS', 'ussr:IS8', 'ussr:KV-3', 'ussr:KV4', 'ussr:ST_I'], 0.190 ]
        ],
    '_122mm_D-25C_mod1944':
        [
            [ ['ussr:ISU-152', 'ussr:SU-101', 'ussr:SU-152'], 0.190 ]
        ],
    '_122mm_BL-9S':
        [
            [ ['ussr:ISU-152'], 0.190 ]
        ],
    '_122mm_BL-9':
        [
            [ ['ussr:IS-3', 'ussr:IS8', 'ussr:ST_I'], 0.180 ]
        ],
    '_122mm_M62-T2':
        [
            [ ['ussr:IS-4', 'ussr:IS8', 'ussr:ST_I'], 0.180 ]
        ],
    '_152mm_M-10':
        [
            [ ['ussr:KV2'], 0.150 ]
        ],
    '_152mm_mortar_NM_mod1931':
        [
            [ ['ussr:SU-5'], 0.150 ]
        ],
    '_152mm_ML-20CM_obr1944':
        [
            [ ['ussr:R53_Object_704'], 0.150 ]
        ],
    '_152mm_ML-20C':
        [
            [ ['ussr:ISU-152'], 0.143 ]
        ],
    '_152mm_ML-20_mod_1937':
        [
            [ ['ussr:SU-152'], 0.143 ]
        ],
    '_152mm_howitzer_D-1':
        [
            [ ['ussr:SU122A'], 0.143 ]
        ],
    '_152mm_BR-2':
        [
            [ ['ussr:Object_212', 'ussr:S-51', 'ussr:SU-14', 'ussr:SU14_1'], 0.143 ]
        ],
    '_152mm_BL-10':
        [
            [ ['ussr:ISU-152', 'ussr:R53_Object_704'], 0.135 ]
        ],
    '_152mm_howitzer_ML-20_mod_1931':
        [
            [ ['ussr:SU-8', 'ussr:SU14_1'], 0.135 ]
        ],
    '_203mm_B-4':
        [
            [ ['ussr:Object_212', 'ussr:S-51', 'ussr:SU-14', 'ussr:SU14_1'], 0.086 ]
        ],
# Germany
    '_7.92mm_Mauser_EW_141':
        [
            [ ['germany:PzI_ausf_C'], 0.280 ]
        ],
    '_20mm_KwK_38_L55':
        [
            [ ['germany:PzIII_A', 'germany:PzII_Luchs', 'germany:PzI_ausf_C', 'germany:Pz_II_AusfG'], 0.280 ],
            [ ['germany:Ltraktor', 'germany:PzI', 'germany:PzII'], 0.238 ]
        ],
    '_20mm_Flak_38_L112':
        [
            [ ['germany:Pz38_NA', 'germany:PzIII_AusfJ', 'germany:PzIII_A', 'germany:PzII_Luchs', 'germany:PzI_ausf_C', 'germany:Pz_II_AusfG', 'germany:VK1602'], 0.266 ],
            [ ['germany:Pz35t', 'germany:Pz38t', 'germany:PzII'], 0.224 ]
        ],
    '_20mm_Breda':
        [
            [ ['germany:Ltraktor', 'germany:PzI'], 0.238 ]
        ],
    '_20mm_KwK_30':
        [
            [ ['germany:Pz35t', 'germany:PzI', 'germany:PzII'], 0.238 ]
        ],
    '_30mm_MK103':
        [
            [ ['germany:PzII_Luchs', 'germany:Pz_II_AusfG', 'germany:VK1602'], 0.210 ]
        ],
    '_37mm_KwK_38t_L47':
        [
            [ ['germany:Pz38_NA'], 0.300 ],
            [ ['germany:Pz35t', 'germany:Pz38t'], 0.255 ]
        ],
    '_37mm_KwK_L46':
        [
            [ ['germany:PzIII_AusfJ', 'germany:PzIII_A', 'germany:PzII_Luchs'], 0.300 ],
            [ ['germany:Ltraktor'], 0.255 ],
            [ ['china:Ch06_Renault_NC31', 'china:Ch07_Vickers_MkE_Type_BT26'], 0.255 ]
        ],
    '_37mm_KwK_34t_L40':
        [
            [ ['germany:Pz35t'], 0.240 ]
        ],
    '_47mm_PaK_38t_L43':
        [
            [ ['germany:Pz38t', 'germany:Pz38_NA'], 0.290 ]
        ],
    '_50mm_KwK_38_L42':
        [
            [ ['germany:PzIII_AusfJ', 'germany:PzIII_A', 'germany:PzII_Luchs', 'germany:VK2001DB', 'germany:Pz_IV_AusfA', 'germany:Pz_IV_AusfD'], 0.290 ]
        ],
    '_50mm_KwK_39_L60':
        [
            [ ['germany:Auf_Panther', 'germany:DW_II', 'germany:PzIII_AusfJ', 'germany:Pz_IV_AusfD', 'germany:VK2001DB', 'germany:VK2801', 'germany:VK3001H'], 0.276 ],
            [ ['germany:Pz38_NA', 'germany:PzII_Luchs', 'germany:VK1602'], 0.261 ]
        ],
    '_75mm_StuK_37_L24':
        [
            [ ['germany:G101_StuG_III'], 0.260 ]
        ],
    '_75mm_Flak_L60':
        [
            [ ['germany:Pz_Sfl_IVc'], 0.260 ]
        ],
    '_75mm_KwK41_L58_conic':
        [
            [ ['germany:Auf_Panther', 'germany:VK3001H', 'germany:VK3601H'], 0.260 ]
        ],
    '_75mm_KwK_37_L24':
        [
            [ ['germany:DW_II', 'germany:PzIII_AusfJ', 'germany:Pz_IV_AusfA', 'germany:Pz_IV_AusfD', 'germany:VK2001DB', 'germany:VK2801', 'germany:VK3001H'], 0.260 ]
        ],
    '_75mm_PaK_39_L48':
        [
            [ ['germany:Hetzer'], 0.260 ],
            [ ['germany:JagdPzIV', 'germany:G101_StuG_III', 'germany:StuG_40_AusfG'], 0.247 ]
        ],
    '_75mm_KwK_40_L48':
        [
            [ ['germany:Auf_Panther', 'germany:PzIII_IV', 'germany:Pz_IV_AusfH', 'germany:VK2801', 'germany:VK3001H', 'germany:VK3001P', 'germany:VK3002DB', 'germany:VK3002DB_V1', 'germany:VK3002M'], 0.247 ]
        ],
    '_75mm_KwK_40_L43':
        [
            [ ['germany:PzIII_IV', 'germany:Pz_IV_AusfD', 'germany:Pz_IV_AusfH', 'germany:VK2801', 'germany:VK3001H'], 0.247 ]
        ],
    '_75mm_StuK_40_L43':
        [
            [ ['germany:Hetzer', 'germany:G101_StuG_III', 'germany:StuG_40_AusfG'], 0.247 ]
        ],
    '_75mm_PaK_40_2':
        [
            [ ['germany:G20_Marder_II', 'germany:Marder_III'], 0.247 ]
        ],
    '_75mm_PaK_40_3':
        [
            [ ['germany:Marder_III'], 0.247 ]
        ],
    '_75mm_StuK42_L70':
        [
            [ ['germany:JagdPzIV', 'germany:Nashorn', 'germany:StuG_40_AusfG'], 0.247 ],
            [ ['germany:JagdPanther'], 0.234 ]
        ],
    '_75mm_KwK45_L100':
        [
            [ ['germany:E-50', 'germany:Panther_II'], 0.247 ]
        ],
    '_75mm_KwK_L70':
        [
            [ ['germany:E-50', 'germany:Panther_II', 'germany:PzVI', 'germany:PzVI_Tiger_P', 'germany:VK3001H', 'germany:VK3001P', 'germany:VK3002DB', 'germany:VK3002DB_V1', 'germany:VK3002M', 'germany:VK3601H'], 0.234 ]
        ],
    '_76mm_PaK_36r':
        [
            [ ['germany:G20_Marder_II', 'germany:Marder_III'], 0.247 ]
        ],
    '_88mm_Flak_37_L56':
        [
            [ ['germany:Pz_Sfl_IVc'], 0.250 ]
        ],
    '_88mm_PaK_36_L56':
        [
            [ ['germany:JagdPzIV'], 0.250 ],
            [ ['germany:JagdPanther', 'germany:Nashorn'], 0.238 ]
        ],
    '_88mm_KwK_36_L56':
        [
            [ ['germany:Indien_Panzer', 'germany:PzVI', 'germany:PzVI_Tiger_P', 'germany:VK3001P', 'germany:VK3002DB', 'germany:VK3601H', 'germany:VK4502A'], 0.238 ]
        ],
    '_88mm_Flak_41_L74':
        [
            [ ['germany:Pz_Sfl_IVc'], 0.238 ]
        ],
    '_88mm_KwK_43_L71':
        [
            [ ['germany:E-50', 'germany:Panther_II'], 0.238 ],
            [ ['germany:E-75', 'germany:Indien_Panzer', 'germany:PzVI', 'germany:PzVIB_Tiger_II', 'germany:PzVI_Tiger_P', 'germany:VK4502A', 'germany:VK4502P'], 0.225 ]
        ],
    '_88mm_PaK_43_L71':
        [
            [ ['germany:Ferdinand', 'germany:JagdPanther', 'germany:JagdPantherII', 'germany:Nashorn'], 0.225 ]
        ],
    '_88mm_KwK_L100':
        [
            [ ['germany:E-50'], 0.188 ]
        ],
    '_9cm_KwK_51_L71':
        [
            [ ['germany:Indien_Panzer', 'germany:Pro_Ag_A'], 0.225 ]
        ],
    '_105mm_KwK45_L52':
        [
            [ ['germany:E-75', 'germany:PzVIB_Tiger_II', 'germany:VK4502P'], 0.220 ],
            [ ['germany:PzVIB_Tiger_II', 'germany:VK4502A', 'germany:VK4502P'], 0.209 ]
        ],
    '_105mm_K18_L52':
        [
            [ ['germany:Ferdinand', 'germany:JagdPanther', 'germany:JagdPantherII'], 0.209 ]
        ],
    '_105mm_K18_L52_R':
        [
            [ ['germany:Sturer_Emil'], 0.209 ]
        ],
    '_105mm_L7A1':
        [
            [ ['germany:Pro_Ag_A'], 0.209 ]
        ],
    '_105mm_KwK45_L52_ausf_B':
        [
            [ ['germany:E-50'], 0.209 ]
        ],
    '_105mm_leFH16_L22':
        [
            [ ['germany:Pz_Sfl_IVb', 'germany:Wespe'], 0.209 ]
        ],
    '_105mm_leFH18_L28':
        [
            [ ['germany:Pz_Sfl_IVb', 'germany:Wespe'], 0.209 ]
        ],
    '_105mm_StuH42_L28Pz':
        [
            [ ['germany:Auf_Panther', 'germany:Panther_II', 'germany:Pz_IV_AusfH', 'germany:PzVI', 'germany:PzVI_Tiger_P', 'germany:VK2801', 'germany:VK3001H', 'germany:VK3001P', 'germany:VK3002DB', 'germany:VK3601H'], 0.209 ]
        ],
    '_105mm_StuH42_L28':
        [
            [ ['germany:Hetzer', 'germany:JagdPzIV', 'germany:G101_StuG_III', 'germany:StuG_40_AusfG'], 0.209 ]
        ],
    '_105mm_KwK46_L68':
        [
            [ ['germany:E-75', 'germany:PzVIB_Tiger_II', 'germany:VK4502P'], 0.209 ]
        ],
    '_128mm_PaK44_2_L61':
        [
            [ ['germany:JagdTiger'], 0.162 ]
        ],
    '_128mm_KwK44_L55':
        [
            [ ['germany:E-100'], 0.162 ],
            [ ['germany:E-75', 'germany:VK4502P'], 0.153 ]
        ],
    '_128mm_PaK44_L55':
        [
            [ ['germany:Ferdinand', 'germany:JagdPantherII', 'germany:JagdTiger'], 0.162 ]
        ],
    '_128mm_SF_L61':
        [
            [ ['germany:Sturer_Emil'], 0.153 ]
        ],
    '_150mm_sIG33L11':
        [
            [ ['germany:Grille'], 0.150 ]
        ],
    '_150mm_sFH13_L17':
        [
            [ ['germany:Grille', 'germany:Hummel'], 0.150 ]
        ],
    '_150mm_sFH18_L30':
        [
            [ ['germany:G_Panther', 'germany:Hummel'], 0.143 ]
        ],
    '_150mm_sFH36_L43':
        [
            [ ['germany:G_Panther'], 0.135 ]
        ],
    '_150mm_KwK44_L38':
        [
            [ ['germany:E-100'], 0.135 ]
        ],
    '_170mm_K72_Sf_':
        [
            [ ['germany:GW_Tiger_P', 'germany:G_Tiger'], 0.108 ]
        ],
    '_210mm_Morser_21':
        [
            [ ['germany:GW_Tiger_P', 'germany:G_Tiger'], 0.086 ]
        ],
# USA
    '_12.7mm_MG_HB_M2':
        [
            [ ['usa:M2_lt'], 0.238 ],
            [ ['uk:GB14_M2'], 0.238 ]
        ],
    '_20mm_Hispano_Suiza_Birgikt_gun':
        [
            [ ['usa:M3_Stuart'], 0.266 ],
            [ ['usa:M2_lt', 'usa:T1_Cunningham', 'usa:T2_med'], 0.224 ]
        ],
    '_37mm_M-6_L53':
        [
            [ ['usa:M2_med', 'usa:M3_Stuart', 'usa:M5_Stuart', 'usa:M7_med'], 0.300 ],
            [ ['uk:GB15_Stuart_I'], 0.300 ],
            [ ['china:Ch09_M5'], 0.300 ]
        ],
    '_37mm_M-5':
        [
            [ ['usa:M2_med', 'usa:M3_Stuart'], 0.300 ],
            [ ['usa:M2_lt', 'usa:T2_med'], 0.255 ],
            [ ['uk:GB15_Stuart_I'], 0.300 ],
            [ ['uk:GB14_M2'], 0.255 ]
        ],
    '_37mm_M-3_antitank_gun':
        [
            [ ['usa:T18'], 0.255 ]
        ],
    '_37mm_Gun_M1916':
        [
            [ ['usa:T1_Cunningham'], 0.255 ]
        ],
    '_37mm_T16':
        [
            [ ['usa:M5_Stuart'], 0.240 ]
        ],
    '_37mm_semiautomatic_gun_M1924':
        [
            [ ['usa:T1_Cunningham', 'usa:T2_med'], 0.195 ]
        ],
    '_37mm_Browning_semiautomatic_gun':
        [
            [ ['usa:T1_Cunningham', 'usa:T2_med'], 0.195 ]
        ],
    'Ordnance_QF_2pdr_AT_Gun_Mk.X':
        [
            [ ['usa:T18'], 0.255 ]
        ],
    'QF_6_pounder_Mk_III':
        [
            [ ['usa:M7_med', 'usa:T21'], 0.280 ],
            [ ['usa:M7_med', 'usa:T21'], 0.280 ],
            [ ['uk:GB04_Valentine', 'uk:GB08_Churchill_I', 'uk:GB20_Crusader', 'uk:GB21_Cromwell', 'uk:GB17_Grant_I', 'uk:GB50_Sherman_III'], 0.280 ]
        ],
    '_57mm_Gun_M1_L50':
        [
            [ ['usa:M8A1', 'usa:T40', 'usa:T67', 'usa:T82'], 0.266 ]
        ],
    '_75mm_Howitzer_M1A1':
        [
            [ ['usa:T40', 'usa:T82'], 0.260 ],
            [ ['usa:T18'], 0.221 ]
        ],
    '_75mm_Howitzer_M3':
        [
            [ ['usa:M2_med'], 0.260 ]
        ],
    '_75mm_AT_Howitzer_M3':
        [
            [ ['usa:M8A1'], 0.260 ]
        ],
    '_75mm_Gun_M6':
        [
            [ ['usa:M24_Chaffee', 'usa:A94_T37'], 0.260 ]
        ],
    '_75mm_Gun_M3_L37':
        [
            [ ['usa:M3_Grant', 'usa:M4A3E8_Sherman', 'usa:M4_Sherman', 'usa:M7_med', 'usa:Sherman_Jumbo', 'usa:T21'], 0.260 ],
            [ ['uk:GB17_Grant_I', 'uk:GB19_Sherman_Firefly', 'uk:GB50_Sherman_III'], 0.260 ]
        ],
    '_75mm_AT_Gun_M3_L37':
        [
            [ ['usa:M8A1'], 0.260 ]
        ],
    '_75mm_Gun_M2_L28':
        [
            [ ['usa:M3_Grant', 'usa:M7_med'], 0.260 ],
            [ ['uk:GB17_Grant_I'], 0.260 ]
        ],
    '_75mm_Gun_M17':
        [
            [ ['usa:M24_Chaffee'], 0.247 ]
        ],
    '_76mm_AT_Gun_M1918':
        [
            [ ['usa:T40'], 0.260 ]
        ],
    '_75mm_Gun_M7_L50':
        [
            [ ['usa:M6', 'usa:T1_hvy'], 0.260 ]
        ],
    '_75mm_AT_Gun_M7_L50':
        [
            [ ['usa:M10_Wolverine', 'usa:M18_Hellcat', 'usa:M8A1', 'usa:T67'], 0.260 ]
        ],
    '_76mm_Gun_M1A1':
        [
            [ ['usa:M4A3E8_Sherman', 'usa:M4_Sherman', 'usa:M6', 'usa:Pershing', 'usa:Sherman_Jumbo', 'usa:T1_hvy', 'usa:T20', 'usa:T21'], 0.260 ],
            [ ['france:ARL_44'], 0.260 ],
            [ ['uk:GB19_Sherman_Firefly', 'uk:GB50_Sherman_III'], 0.260 ]
        ],
    '_76mm_AT_Gun_M1A1':
        [
            [ ['usa:M10_Wolverine', 'usa:M18_Hellcat', 'usa:T40', 'usa:T67'], 0.260 ]
        ],
    '_76mm_Gun_M1A2':
        [
            [ ['usa:M4A3E8_Sherman', 'usa:M6', 'usa:Pershing', 'usa:Sherman_Jumbo', 'usa:T20', 'usa:T21', 'usa:T29', 'usa:T71'], 0.247 ]
        ],
    '_76mm_AT_Gun_M1A2':
        [
            [ ['usa:M10_Wolverine', 'usa:M18_Hellcat', 'usa:M36_Slagger'], 0.247 ]
        ],
    '_76mm_Gun_T185':
        [
            [ ['usa:T69', 'usa:T71'], 0.234 ]
        ],
    '_76mm_Gun_T102':
        [
            [ ['usa:A94_T37'], 0.234 ]
        ],
    '_76mm_Gun_T94':
        [
            [ ['usa:A94_T37'], 0.234 ]
        ],
    '_76mm_Gun_T91':
        [
            [ ['usa:A94_T37', 'usa:M41_Bulldog'], 0.234 ]
        ],
    '_76mm_Gun_T91E5':
        [
            [ ['usa:M41_Bulldog'], 0.234 ]
        ],
    '_76mm_Gun_M32':
        [
            [ ['usa:M41_Bulldog'], 0.234 ]
        ],
    '_76mm_Gun_M32_late':
        [
            [ ['usa:M41_Bulldog'], 0.234 ]
        ],
    '_90mm_Gun_M3':
        [
            [ ['usa:M6'], 0.250 ],
            [ ['usa:M46_Patton', 'usa:Pershing', 'usa:T20', 'usa:T29'], 0.238 ]
        ],
    '_90mm_AT_Gun_M3':
        [
            [ ['usa:M18_Hellcat', 'usa:T25_2', 'usa:T25_AT'], 0.250 ],
            [ ['usa:M36_Slagger'], 0.238 ]
        ],
    '_90mm_Gun_M36':
        [
            [ ['usa:M46_Patton'], 0.238 ]
        ],
    '_90mm_Gun_T132E3':
        [
            [ ['usa:T49'], 0.238 ]
        ],
    '_90mm_Gun_T178':
        [
            [ ['usa:T54E1', 'usa:T69'], 0.238 ]
        ],
    '_90mm_Gun_M41':
        [
            [ ['usa:M48A1'], 0.238 ]
        ],
    '_90mm_Gun_T15E2M2':
        [
            [ ['usa:M46_Patton', 'usa:Pershing'], 0.225 ]
        ],
    '_90mm_Gun_T15E2':
        [
            [ ['usa:T32'], 0.225 ]
        ],
    '_90mm_AT_Gun_T15E2':
        [
            [ ['usa:T25_2', 'usa:T25_AT', 'usa:T28', 'usa:T28_Prototype'], 0.225 ]
        ],
    '_105mm_Howitzer_M3':
        [
            [ ['usa:M37', 'usa:M7_Priest'], 0.220 ]
        ],
    '_105mm_AT_Howitzer_M3':
        [
            [ ['usa:T40', 'usa:T82'], 0.220 ]
        ],
    '_105mm_Howitzer_M2A1':
        [
            [ ['usa:M7_Priest'], 0.220 ]
        ],
    '_105mm_Howitzer_M4':
        [
            [ ['usa:M37'], 0.220 ]
        ],
    '_105mm_SPH_M4_L23':
        [
            [ ['usa:M46_Patton', 'usa:M4A3E8_Sherman', 'usa:M4_Sherman', 'usa:Pershing', 'usa:Sherman_Jumbo', 'usa:T20'], 0.220 ],
            [ ['uk:GB19_Sherman_Firefly', 'uk:GB50_Sherman_III'], 0.220 ]
        ],
    '_105mm_AT_SPH_M4_L23':
        [
            [ ['usa:M10_Wolverine'], 0.220 ]
        ],
    '_105mm_Gun_T5E1':
        [
            [ ['usa:T29'], 0.220 ],
            [ ['usa:M103', 'usa:T32'], 0.209 ]
        ],
    '_105mm_AT_Gun_T5E1':
        [
            [ ['usa:T25_AT', 'usa:T28', 'usa:T28_Prototype', 'usa:T30', 'usa:T95'], 0.209 ]
        ],
    '_105mm_Gun_M68':
        [
            [ ['usa:M48A1'], 0.209 ]
        ],
    '_105mm_Gun_T5E1M2':
        [
            [ ['usa:M46_Patton', 'usa:M48A1'], 0.198 ]
        ],
    '_105mm_Gun_T140E2':
        [
            [ ['usa:T54E1'], 0.198 ]
        ],
    '_120mm_AT_Gun_T53':
        [
            [ ['usa:T28', 'usa:T28_Prototype', 'usa:T30', 'usa:T95'], 0.180 ]
        ],
    '_120mm_Gun_T122':
        [
            [ ['usa:M103'], 0.180 ]
        ],
    '_120mm_Gun_M58':
        [
            [ ['usa:M103'], 0.180 ]
        ],
    '_152mm_Gun_Launcher_M81':
        [
            [ ['usa:T49'], 0.150 ]
        ],
    '_155mm_Howitzer_M1':
        [
            [ ['usa:M44'], 0.150 ]
        ],
    '_155mm_Howitzer_M45':
        [
            [ ['usa:M44'], 0.150 ]
        ],
    '_155mm_Gun_M1918M1':
        [
            [ ['usa:M12'], 0.143 ]
        ],
    '_155mm_Gun_M1A1':
        [
            [ ['usa:M12', 'usa:M40M43'], 0.143 ]
        ],
    '_155mm_Gun_M46':
        [
            [ ['usa:M53_55'], 0.143 ]
        ],
    '_155mm_AT_Gun_T7':
        [
            [ ['usa:T30', 'usa:T95'], 0.135 ]
        ],
    '_203mm_Howitzer_M47':
        [
            [ ['usa:M53_55'], 0.086 ]
        ],
# France
    '_13.2mm_Hotchkiss_mle._1930':
        [
            [ ['france:D1', 'france:RenaultFT'], 0.238 ],
            [ ['china:Ch06_Renault_NC31'], 0.238 ]
        ],
    '_25mm_Canon_Raccourci_Mle.1934':
        [
            [ ['france:AMX38', 'france:D2'], 0.336 ],
            [ ['france:D1', 'france:Hotchkiss_H35', 'france:RenaultFT'], 0.294 ]
        ],
    '_25mm_antichar_SA-L_mle_1934':
        [
            [ ['france:RenaultFT_AC'], 0.294 ]
        ],
    '_25mm_antichar_SA-L_mle_1937':
        [
            [ ['france:RenaultFT_AC'], 0.294 ]
        ],
    '_25mm_automatique_mle_1936':
        [
            [ ['france:RenaultFT_AC'], 0.238 ]
        ],
    '_37mm_SA38':
        [
            [ ['france:AMX38'], 0.300 ],
            [ ['france:Hotchkiss_H35'], 0.255 ]
        ],
    '_37mm_APX_SA18':
        [
            [ ['france:D1', 'france:Hotchkiss_H35', 'france:RenaultFT'], 0.255 ],
            [ ['china:Ch06_Renault_NC31'], 0.255 ],
            [ ['japan:NC27'], 0.255 ]
        ],
    '_47mm_SA37':
        [
            [ ['france:B1', 'france:D2'], 0.290 ]
        ],
    '_47mm_SA35':
        [
            [ ['france:AMX38', 'france:AMX40', 'france:B1', 'france:D2'], 0.290 ]
        ],
    '_47mm_SA34':
        [
            [ ['france:AMX38', 'france:AMX40', 'france:B1', 'france:D2'], 0.290 ],
            [ ['france:D1'], 0.247 ]
        ],
    '_47mm_SA-L_Mle.37':
        [
            [ ['france:RenaultUE57'], 0.290 ],
            [ ['france:RenaultFT_AC'], 0.247 ]
        ],
    '_57mm_6_pdr_AT_Gun_Mk_IV':
        [
            [ ['france:RenaultUE57'], 0.252 ]
        ],
    '_75mm_APX':
        [
            [ ['france:ARL_V39', 'france:Somua_Sau_40'], 0.260 ]
        ],
    '_75mm_SA32':
        [
            [ ['france:AMX40', 'france:BDR_G1B', 'france:ELC_AMX'], 0.260 ]
        ],
    '_75mm_Long_44':
        [
            [ ['france:BDR_G1B', 'france:ELC_AMX'], 0.260 ]
        ],
    '_75mm_Long_44_AC':
        [
            [ ['france:ARL_V39', 'france:Somua_Sau_40'], 0.260 ]
        ],
    '_75mm_SA49_L48':
        [
            [ ['france:AMX_12t', 'france:AMX_13_75'], 0.247 ]
        ],
    '_75mm_SA50':
        [
            [ ['france:AMX_12t', 'france:AMX_13_75', 'france:AMX_13_90'], 0.234 ]
        ],
    '_17_pdr_Gan_MK.II':
        [
            [ ['france:S_35CA'], 0.234 ]
        ],
    '_90mm_canon_DCA_30':
        [
            [ ['france:AMX_M4_1945', 'france:ARL_44', 'france:BDR_G1B'], 0.250 ]
        ],
    '_90mm_canon_DCA_30_CA':
        [
            [ ['france:AMX_AC_Mle1946', 'france:ARL_V39', 'france:S_35CA'], 0.250 ]
        ],
    '_90mm_D914':
        [
            [ ['france:ELC_AMX'], 0.238 ]
        ],
    '_90mm_F3':
        [
            [ ['france:AMX_13_90', 'france:AMX_50_100', 'france:AMX_M4_1945', 'france:ARL_44', 'france:Bat_Chatillon25t', 'france:Lorraine40t'], 0.238 ]
        ],
    '_90mm_canon_DCA_45':
        [
            [ ['france:AMX_50_100', 'france:AMX_50_120', 'france:AMX_M4_1945', 'france:ARL_44'], 0.225 ]
        ],
    '_90mm_canon_DCA_45_AC':
        [
            [ ['france:AMX_AC_Mle1946', 'france:AMX_AC_Mle1948', 'france:ARL_V39'], 0.225 ]
        ],
    '_100mm_SA_47':
        [
            [ ['france:AMX_50_100', 'france:AMX_50_120', 'france:Bat_Chatillon25t', 'france:Lorraine40t'], 0.198 ]
        ],
    '_100mm_SA_47_AC':
        [
            [ ['france:AMX_AC_Mle1946', 'france:AMX_AC_Mle1948'], 0.198 ]
        ],
    'Canon_de_105_court_mle_1935B':
        [
            [ ['france:Lorraine39_L_AM'], 0.220 ]
        ],
    'Canon_de_105_DEFA_4767_mod':
        [
            [ ['france:AMX_Ob_Am105'], 0.220 ]
        ],
    'Canon_de_105_court_mle_1934S':
        [
            [ ['france:AMX_105AM', 'france:Lorraine39_L_AM'], 0.220 ]
        ],
    'Canon_de_105_court_mle_1934S_AC':
        [
            [ ['france:Somua_Sau_40'], 0.220 ]
        ],
    'Canon_de_105_mle_1930_Schneider_AC':
        [
            [ ['france:ARL_V39', 'france:S_35CA'], 0.209 ]
        ],
    '_105mm_canon_13TR':
        [
            [ ['france:AMX_M4_1945', 'france:ARL_44'], 0.209 ]
        ],
    'Canon_de_105_mle_1930_Schneider_AM':
        [
            [ ['france:AMX_105AM', 'france:AMX_Ob_Am105'], 0.209 ]
        ],
    '_120mm_SA_46_AC':
        [
            [ ['france:AMX_AC_Mle1948'], 0.180 ]
        ],
    '_120mm_SA_46':
        [
            [ ['france:AMX_50_120'], 0.140 ]
        ],
    'Obusier_de_155mm_C_mle.1917':
        [
            [ ['france:AMX_13F3AM'], 0.150 ]
        ],
    'Canon_de_155mm_L_GPF':
        [
            [ ['france:Bat_Chatillon155_55', 'france:Lorraine155_51'], 0.143 ]
        ],
    'Canon_de_155mm_de_33_calibres':
        [
            [ ['france:AMX_13F3AM', 'france:Lorraine155_50'], 0.135 ]
        ],
    'Obusier_de_155mm_mle.1950':
        [
            [ ['france:Lorraine155_50', 'france:Lorraine155_51'], 0.135 ]
        ],
# UK
    '_15mm_Machine_gun_BESA':
        [
            [ ['uk:GB01_Medium_Mark_I', 'uk:GB58_Cruiser_Mk_III'], 0.238 ]
        ],
    '_2pdr_Gun_Mk_IX':
        [
            [ ['uk:GB03_Cruiser_Mk_I', 'uk:GB06_Vickers_Medium_Mk_III', 'uk:GB59_Cruiser_Mk_IV', 'uk:GB69_Cruiser_Mk_II', 'uk:GB15_Stuart_I'], 0.300 ],
            [ ['uk:GB58_Cruiser_Mk_III'], 0.255 ]
        ],
    '_2pdr_Gun_Mk_X':
        [
            [ ['uk:GB04_Valentine', 'uk:GB07_Matilda', 'uk:GB08_Churchill_I', 'uk:GB20_Crusader', 'uk:GB60_Covenanter'], 0.300 ]
        ],
    'QF_2pdr_Littlejohn':
        [
            [ ['uk:GB07_Matilda'], 0.285 ]
        ],
    '_40mm_Pom_Pom':
        [
            [ ['uk:GB59_Cruiser_Mk_IV', 'uk:GB60_Covenanter', 'uk:GB69_Cruiser_Mk_II'], 0.240 ],
            [ ['uk:GB03_Cruiser_Mk_I', 'uk:GB58_Cruiser_Mk_III'], 0.195 ],
            [ ['china:Ch07_Vickers_MkE_Type_BT26'], 0.195 ]
        ],
    '_40mm_Bofors_MkI':
        [
            [ ['uk:GB59_Cruiser_Mk_IV', 'uk:GB60_Covenanter'], 0.225 ]
        ],
    '_2pdr_AT_Gun_Mk_IX':
        [
            [ ['uk:GB39_Universal_CarrierQF2'], 0.225 ]
        ],
    'OQF_3pdr_Gun':
        [
            [ ['uk:GB06_Vickers_Medium_Mk_III'], 0.290 ],
            [ ['uk:GB05_Vickers_Medium_Mk_II'], 0.247 ]
        ],
    '_3pdr_gun_Hotchkiss':
        [
            [ ['uk:GB01_Medium_Mark_I', 'uk:GB05_Vickers_Medium_Mk_II'], 0.247 ]
        ],
    'QF_6_pounder_Mk_III_AT':
        [
            [ ['uk:GB73_AT2'], 0.280 ]
        ],
    'QF_6_pounder_8cwt_Mk_I':
        [
            [ ['uk:GB06_Vickers_Medium_Mk_III'], 0.280 ],
            [ ['uk:GB05_Vickers_Medium_Mk_II'], 0.238 ]
        ],
    'QF_6_pounder_Mk_II_AT':
        [
            [ ['uk:GB42_Valentine_AT', 'uk:GB57_Alecto'], 0.280 ]
        ],
    'QF_6_pounder_Mk_V':
        [
            [ ['uk:GB04_Valentine', 'uk:GB08_Churchill_I', 'uk:GB09_Churchill_VII', 'uk:GB20_Crusader', 'uk:GB21_Cromwell', 'uk:GB50_Sherman_III'], 0.266 ]
        ],
    'QF_6_pounder_Mk_V_AT':
        [
            [ ['uk:GB73_AT2', 'uk:GB74_AT8', 'uk:GB75_AT7'], 0.266 ]
        ],
    'QF_6_pounder_Mk_IV_AT':
        [
            [ ['uk:GB42_Valentine_AT', 'uk:GB57_Alecto', 'uk:GB44_Archer'], 0.252 ]
        ],
    'QF_6_pounder_8cwt_Mk_II':
        [
            [ ['uk:GB01_Medium_Mark_I', 'uk:GB05_Vickers_Medium_Mk_II'], 0.238 ]
        ],
    'QF_6_pounder_8cwt_Mk_II_AT':
        [
            [ ['uk:GB39_Universal_CarrierQF2'], 0.238 ]
        ],
    'QF_6_pounder_8cwt_Mk_I_AT':
        [
            [ ['uk:GB39_Universal_CarrierQF2'], 0.238 ]
        ],
    '_75mm_Gun_Mk_V':
        [
            [ ['uk:GB04_Valentine', 'uk:GB08_Churchill_I', 'uk:GB09_Churchill_VII', 'uk:GB21_Cromwell', 'uk:GB22_Comet'], 0.247 ]
        ],
    '_75mm_AT_Gun_Mk_V':
        [
            [ ['uk:GB74_AT8'], 0.247 ]
        ],
    '_75mm_Gun_Vickers_HV':
        [
            [ ['uk:GB08_Churchill_I', 'uk:GB09_Churchill_VII', 'uk:GB21_Cromwell', 'uk:GB22_Comet'], 0.247 ]
        ],
    '_76mm_Howitzer_MkI':
        [
            [ ['uk:GB07_Matilda', 'uk:GB08_Churchill_I', 'uk:GB20_Crusader', 'uk:GB60_Covenanter'], 0.260 ]
        ],
    '_3inch_20_cwt_MkIII_AT_Gun':
        [
            [ ['uk:GB40_Gun_Carrier_Churchill'], 0.260 ]
        ],
    '_76mm_AT_Gun_M7_L50':
        [
            [ ['uk:GB45_Achilles_IIC'], 0.260 ]
        ],
    'OQF_77mm_Gun_MkII':
        [
            [ ['uk:GB09_Churchill_VII', 'uk:GB10_Black_Prince', 'uk:GB22_Comet', 'uk:GB23_Centurion'], 0.247 ]
        ],
    'OQF_77mm_AT_Gun_MkII':
        [
            [ ['uk:GB74_AT8', 'uk:GB75_AT7'], 0.247 ]
        ],
    'OQF_17pdr_Gun_Mk_IV_SH_SH':
        [
            [ ['uk:GB19_Sherman_Firefly'], 0.234 ]
        ],
    'OQF_17pdr_Gun_Mk_VII':
        [
            [ ['uk:GB10_Black_Prince', 'uk:GB11_Caernarvon', 'uk:GB23_Centurion', 'uk:GB19_Sherman_Firefly'], 0.234 ]
        ],
    '_17pdr_OQF_AT_1':
        [
            [ ['uk:GB72_AT15', 'uk:GB74_AT8', 'uk:GB75_AT7', 'uk:GB44_Archer', 'uk:GB41_Challenger', 'uk:GB45_Achilles_IIC'], 0.234 ]
        ],
    '_17pdr_OQF_AT_Mk_V':
        [
            [ ['uk:GB45_Achilles_IIC'], 0.234 ]
        ],
    '_17pdr_OQF_AT_Mk_II':
        [
            [ ['uk:GB44_Archer', 'uk:GB41_Challenger'], 0.234 ]
        ],
    '_20pdr_Gun_Type_A':
        [
            [ ['uk:GB11_Caernarvon', 'uk:GB12_Conqueror', 'uk:GB23_Centurion', 'uk:GB24_Centurion_Mk3'], 0.238 ]
        ],
    '_20pdr_AT_Gun_Type_A':
        [
            [ ['uk:GB72_AT15', 'uk:GB75_AT7', 'uk:GB80_Charioteer'], 0.238 ]
        ],
    '_20pdr_Gun_Type_B':
        [
            [ ['uk:GB11_Caernarvon', 'uk:GB12_Conqueror', 'uk:GB24_Centurion_Mk3'], 0.238 ]
        ],
    '_20pdr_AT_Gun_Type_B':
        [
            [ ['uk:GB32_Tortoise', 'uk:GB72_AT15', 'uk:GB80_Charioteer'], 0.238 ]
        ],
    '_18_pdr_SPG_Gun':
        [
            [ ['uk:GB26_Birch_Gun', 'uk:GB27_Sexton'], 0.250 ]
        ],
    'OQF_25pdr_Gun_Mk_II':
        [
            [ ['uk:GB26_Birch_Gun', 'uk:GB77_FV304'], 0.250 ],
            [ ['uk:GB27_Sexton', 'uk:GB28_Bishop'], 0.238 ]
        ],
    '_25pdr_AT_Field_Gun':
        [
            [ ['uk:GB57_Alecto'], 0.238 ]
        ],
    '_3.7inch_Howitzer':
        [
            [ ['uk:GB09_Churchill_VII', 'uk:GB21_Cromwell', 'uk:GB22_Comet', 'uk:GB69_Cruiser_Mk_II'], 0.250 ]
        ],
    '_3.7inch_AT_Howitzer':
        [
            [ ['uk:GB42_Valentine_AT', 'uk:GB57_Alecto', 'uk:GB73_AT2'], 0.250 ]
        ],
    '_3.7inch_QF_AA_MK_1':
        [
            [ ['uk:GB40_Gun_Carrier_Churchill'], 0.238 ]
        ],
    '_32-pounder_AT_Gun_OQF':
        [
            [ ['uk:GB32_Tortoise', 'uk:GB40_Gun_Carrier_Churchill', 'uk:GB72_AT15'], 0.225 ]
        ],
    '_105mm_AT_Gun_L7':
        [
            [ ['uk:GB80_Charioteer'], 0.209 ]
        ],
    '_105mm_Gun_L7':
        [
            [ ['uk:GB24_Centurion_Mk3'], 0.209 ]
        ],
    '_4.5inch_SPG_Howitzer':
        [
            [ ['uk:GB28_Bishop', 'uk:GB29_Crusader_5inch', 'uk:GB77_FV304'], 0.209 ]
        ],
    '_120mm_Gun_L1A1':
        [
            [ ['uk:GB12_Conqueror'], 0.190 ]
        ],
    '_120mm_AT_Gun_L1A1':
        [
            [ ['uk:GB32_Tortoise'], 0.190 ]
        ],
    '_5.5inch_SPG_Gun':
        [
            [ ['uk:GB29_Crusader_5inch', 'uk:GB30_FV3805', 'uk:GB79_FV206'], 0.143 ]
        ],
    '_6inch_SPG_Gun':
        [
            [ ['uk:GB30_FV3805', 'uk:GB79_FV206'], 0.143 ]
        ],
    '_7.2inch_SPG_Howitzer':
        [
            [ ['uk:GB30_FV3805'], 0.114 ]
        ],
# China
    '_47mm_Gun_Type_1':
        [
            [ ['china:Ch08_Type97_Chi_Ha', 'china:Ch09_M5'], 0.276 ]
        ],
    '_47mm_QFSA':
        [
            [ ['china:Ch07_Vickers_MkE_Type_BT26'], 0.247 ]
        ],
    '_57mm_Gun_Type_97':
        [
            [ ['china:Ch08_Type97_Chi_Ha'], 0.280 ]
        ],
    '_57mm_55-57FG':
        [
            [ ['china:Ch15_59_16', 'china:Ch21_T34'], 0.266 ]
        ],
    '_76mm_54-76T':
        [
            [ ['china:Ch15_59_16'], 0.247 ]
        ],
    '_76mm_54-76TG':
        [
            [ ['china:Ch15_59_16', 'china:Ch16_WZ_131'], 0.247 ]
        ],
    '_85mm_S-53':
        [
            [ ['china:Ch04_T34_1', 'china:Ch05_T34_2', 'china:Ch20_Type58'], 0.250 ]
        ],
    '_85mm_Tip_56-85JT':
        [
            [ ['china:Ch04_T34_1', 'china:Ch05_T34_2', 'china:Ch16_WZ_131', 'china:Ch20_Type58'], 0.250 ]
        ],
    '_85mm_Tip_62-85T':
        [
            [ ['china:Ch16_WZ_131'], 0.250 ]
        ],
    '_85mm_Tip_64-85T':
        [
            [ ['china:Ch16_WZ_131', 'china:Ch17_WZ131_1_WZ132'], 0.225 ]
        ],
    '_85mm_Tip_64-85TG':
        [
            [ ['china:Ch17_WZ131_1_WZ132'], 0.225 ]
        ],
    '_100mm_59-100T':
        [
            [ ['china:Ch05_T34_2', 'china:Ch16_WZ_131', 'china:Ch17_WZ131_1_WZ132', 'china:Ch18_WZ-120'], 0.220 ]
        ],
    '_100mm_44-100JT':
        [
            [ ['china:Ch04_T34_1', 'china:Ch05_T34_2', 'china:Ch10_IS2'], 0.220 ]
        ],
    '_100mm_60-100T':
        [
            [ ['china:Ch17_WZ131_1_WZ132', 'china:Ch18_WZ-120'], 0.209 ]
        ],
    '_100mm_62-100T':
        [
            [ ['china:Ch11_110', 'china:Ch12_111_1_2_3', 'china:Ch18_WZ-120'], 0.198 ]
        ],
    '_122-mm_37-122JT':
        [
            [ ['china:Ch05_T34_2', 'china:Ch10_IS2', 'china:Ch11_110'], 0.200 ]
        ],
    '_122-mm_D25-T':
        [
            [ ['china:Ch10_IS2', 'china:Ch11_110', 'china:Ch12_111_1_2_3'], 0.190 ]
        ],
    '_122-mm_60-122T':
        [
            [ ['china:Ch18_WZ-120'], 0.180 ]
        ],
    '_130mm_59-130T':
        [
            [ ['china:Ch12_111_1_2_3'], 0.153 ]
        ],
# Japan
    '_13.2mm_Type93':
        [
            [ ['japan:Chi_Ni', 'japan:NC27'], 0.238 ]
        ],
    '_37mm_Type_100':
        [
            [ ['japan:Chi_Ha', 'japan:Ke_Ni'], 0.300 ]
        ],
    '_37mm_Type1':
        [
            [ ['japan:Chi_Ha', 'japan:Ke_Ni'], 0.300 ]
        ],
    '_37mm_Type11':
        [
            [ ['japan:NC27'], 0.255 ]
        ],
    '_37mm_Sogekiho':
        [
            [ ['japan:Chi_Ni', 'japan:NC27'], 0.255 ]
        ],
    '_37mm_Type_94':
        [
            [ ['japan:Ha_Go'], 0.255 ]
        ],
    '_37mm_Type_98':
        [
            [ ['japan:Ha_Go'], 0.255 ]
        ],
    '_47mm_Gun_Type1':
        [
            [ ['japan:Chi_Ha', 'japan:Chi_He', 'japan:Ke_Ho'], 0.290 ]
        ],
    }

# returns tuple of camo values: standing, moving, shooting
def _getCamoValues(veh_name, turret_is_top = True, gun = None):
    try:
        if veh_name not in _tanks_camo:
            if IS_DEVELOPMENT:
                log("Warning: no camo_coeffs defined for vehicle '%s'" % veh_name)
            return (0, 0, 0)
        (camo_standing, camo_moving, camo_shooting, turret_modifier) = _tanks_camo[veh_name]
        if gun and gun in _gun_camo_modifier:
            for tanks_group in _gun_camo_modifier[gun]:
                if veh_name in tanks_group[0]:
                    camo_shooting = round(camo_standing * tanks_group[1], 2)
                    break
        if not turret_is_top:
            camo_standing = round(camo_standing / turret_modifier, 2)
            camo_moving = round(camo_moving / turret_modifier, 2)
            camo_shooting = round(camo_shooting / turret_modifier, 2)
        return (camo_standing, camo_moving, camo_shooting)
    except Exception as ex:
        err(traceback.format_exc())
        return (0, 0, 0)
 