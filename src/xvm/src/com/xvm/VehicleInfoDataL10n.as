﻿import com.xvm.Config
import com.xvm.Locale
import com.xvm.Logger

class com.xvm.VehicleInfoDataL10n
{
    public static var s_vehiclename = { };
    private static var _initialized = false;

    public static function LocalizedNameToVehicleKey(name)
    {
        VehicleInfoL10NDefaultValues();
        //Logger.add("Locale[vehicleinfo]: string: " + name + " | value: " +  Locale.s_lang.locale.vehiclename[name] + " | fallback string: " + s_vehiclename[name] );
        return Locale.s_lang.locale.vehiclename[name] || s_vehiclename[name] || name ;
    }

    private static function VehicleInfoL10NDefaultValues() {
        if (_initialized)
            return;
        _initialized = true;
        
        //level 1
        s_vehiclename["МС-1"]="ms_1";
        s_vehiclename["MS-1"]="ms_1";
        s_vehiclename["LTraktor"]="ltraktor";
        s_vehiclename["T1"]="t1_cunningham";
        s_vehiclename["FT"]="renaultft";
        s_vehiclename["Medium I"]="gb01_medium_mark_i";
        s_vehiclename["NC-31"]="ch06_renault_nc31";

        //level 2
        //en
        s_vehiclename["AT-1"]="at_1";
        s_vehiclename["T-60"]="t-60";
        s_vehiclename["BT-2"]="bt_2";
        s_vehiclename["T-26"]="t_26";
        s_vehiclename["SU-18"]="su_18";
        s_vehiclename["Tetrarch"]="tetrarch_ll";
        //ru
        s_vehiclename["АТ-1"]="at_1";
        s_vehiclename["Т-60"]="t-60";
        s_vehiclename["БТ-2"]="bt_2";
        s_vehiclename["Т-26"]="t_26";
        s_vehiclename["СУ-18"]="su_18";
        s_vehiclename["Тетрарх"]="tetrarch_ll";
        //common
        s_vehiclename["G.Pz. Mk. VI"]="gw_mk_vie";
        s_vehiclename["PzJg I"]="panzerjager_i";
        s_vehiclename["Pz. 35 (t)"]="pz35t";
        s_vehiclename["Pz. II"]="pzii";
        s_vehiclename["Pz. I"]="pzi";
        s_vehiclename["Pz. 38H"]="h39_captured";
        s_vehiclename["M2 Light"]="m2_lt";
        s_vehiclename["T18"]="t18";
        s_vehiclename["T2 Light"]="t2_lt";
        s_vehiclename["T2 Medium"]="t2_med";
        s_vehiclename["T57"]="t57";
        s_vehiclename["T1E6"]="t1_e6";
        s_vehiclename["FT AC"]="renaultft_ac";
        s_vehiclename["D1"]="d1";
        s_vehiclename["H35"]="hotchkiss_h35";
        s_vehiclename["FT BS"]="renaultbs";
        s_vehiclename["Cruiser III"]="gb58_cruiser_mk_iii";
        s_vehiclename["UC 2-pdr"]="gb39_universal_carrierqf2";
        s_vehiclename["Cruiser I"]="gb03_cruiser_mk_i";
        s_vehiclename["Medium II"]="gb05_vickers_medium_mk_ii";
        s_vehiclename["VAE Type B"]="ch07_vickers_mke_type_bt26";

        //level 3
        //en
        s_vehiclename["SU-76"]="su_76";
        s_vehiclename["T-70"]="t-70";
        s_vehiclename["BT-7"]="bt_7";
        s_vehiclename["T-127"]="t_127";
        s_vehiclename["T-46"]="t_46";
        s_vehiclename["SU-26"]="su_26";
        s_vehiclename["BT-SV"]="bt_sv";
        s_vehiclename["M3 Light"]="m3_stuart_ll";
        //ru
        s_vehiclename["СУ-76"]="su_76";
        s_vehiclename["Т-70"]="t-70";
        s_vehiclename["БТ-7"]="bt_7";
        s_vehiclename["Т-127"]="t_127";
        s_vehiclename["Т-46"]="t_46";
        s_vehiclename["СУ-26"]="su_26";
        s_vehiclename["БТ-СВ"]="bt_sv";
        s_vehiclename["М3 лёгкий"]="m3_stuart_ll";
        //common
        s_vehiclename["Bison"]="bison_i";
        s_vehiclename["Wespe"]="wespe";
        s_vehiclename["Marder II"]="g20_marder_ii";
        s_vehiclename["Pz. 38 (t)"]="pz38t";
        s_vehiclename["T-15"]="t_15";
        s_vehiclename["Pz. III A"]="pziii_a";
        s_vehiclename["Pz. II G"]="pz_ii_ausfg";
        s_vehiclename["Pz. I C"]="pzi_ausf_c";
        s_vehiclename["Pz. II J"]="pzii_j";
        s_vehiclename["Pz. S35"]="s35_captured";
        s_vehiclename["M3 Stuart"]="m3_stuart";
        s_vehiclename["T82"]="t82";
        s_vehiclename["Locust"]="m22_locust";
        s_vehiclename["M2 Medium"]="m2_med";
        s_vehiclename["M7 Priest"]="m7_priest";
        s_vehiclename["MTLS-1G14"]="mtls_1g14";
        s_vehiclename["Sexton I"]="gb78_sexton_i";
        s_vehiclename["UE 57"]="renaultue57";
        s_vehiclename["FCM36 Pak40"]="fcm_36pak40";
        s_vehiclename["D2"]="d2";
        s_vehiclename["AMX 38"]="amx38";
        s_vehiclename["Lorr. 39L AM"]="lorraine39_l_am";
        s_vehiclename["Cruiser IV"]="gb59_cruiser_mk_iv";
        s_vehiclename["Valentine AT"]="gb42_valentine_at";
        s_vehiclename["Cruiser II"]="gb69_cruiser_mk_ii";
        s_vehiclename["Medium III"]="gb06_vickers_medium_mk_iii";
        s_vehiclename["Chi-Ha"]="ch08_type97_chi_ha";

        //level 4
        //en
        s_vehiclename["SU-85B"]="gaz_74b";
        s_vehiclename["T-80"]="t80";
        s_vehiclename["A-20"]="a_20";
        s_vehiclename["Valentine II"]="valentine_ll";
        s_vehiclename["T-50"]="t_50";
        s_vehiclename["T-28"]="t_28";
        s_vehiclename["SU-5"]="su_5";
        s_vehiclename["A-32"]="a_32";
        //ru
        s_vehiclename["СУ-85Б"]="gaz_74b";
        s_vehiclename["Т-80"]="t80";
        s_vehiclename["А-20"]="a_20";
        s_vehiclename["Валентайн II"]="valentine_ll";
        s_vehiclename["Т-50"]="t_50";
        s_vehiclename["Т-28"]="t_28";
        s_vehiclename["СУ-5"]="su_5";
        s_vehiclename["А-32"]="a_32";
        //common
        s_vehiclename["Pz.Sfl. IVb"]="pz_sfl_ivb";
        s_vehiclename["StPz II"]="sturmpanzer_ii";
        s_vehiclename["Hetzer"]="hetzer";
        s_vehiclename["Pz. 38 nA"]="pz38_na";
        s_vehiclename["Pz. III"]="pziii";
        s_vehiclename["VK 20.01 D"]="vk2001db";
        s_vehiclename["Luchs"]="pzii_luchs";
        s_vehiclename["Pz. B2"]="b_1bis_captured";
        s_vehiclename["M5 Stuart"]="m5_stuart";
        s_vehiclename["M8A1"]="m8a1";
        s_vehiclename["T40"]="t40";
        s_vehiclename["M3 Lee"]="m3_grant";
        s_vehiclename["M37"]="m37";
        s_vehiclename["SAu 40"]="somua_sau_40";
        s_vehiclename["B1"]="b1";
        s_vehiclename["AMX 40"]="amx40";
        s_vehiclename["leFH18B2"]="_105_lefh18b2";
        s_vehiclename["AMX 105 AM"]="amx_ob_am105";
        s_vehiclename["Covenanter"]="gb60_covenanter";
        s_vehiclename["Alecto"]="gb57_alecto";
        s_vehiclename["Valentine"]="gb04_valentine";
        s_vehiclename["Matilda"]="gb07_matilda";
        s_vehiclename["M5A1 Stuart"]="ch09_m5";

        //level 5
        //en
        s_vehiclename["SU-85"]="su_85";
        s_vehiclename["T-34"]="t_34";
        s_vehiclename["Matilda IV"]="matilda_ii_ll";
        s_vehiclename["T-50-2"]="t_50_2";
        s_vehiclename["KV-1"]="kv1";
        s_vehiclename["Churchill III"]="churchill_ll";
        s_vehiclename["SU-122A"]="su122a";
        s_vehiclename["KV-220"]="kv_220";
        s_vehiclename["KV-220 T"]="kv_220_action";
        s_vehiclename["SU-85I"]="su_85i";
        //ru
        s_vehiclename["СУ-85"]="su_85";
        s_vehiclename["Т-34"]="t_34";
        s_vehiclename["Матильда IV"]="matilda_ii_ll";
        s_vehiclename["Т-50-2"]="t_50_2";
        s_vehiclename["КВ-1"]="kv1";
        s_vehiclename["Черчилль III"]="churchill_ll";
        s_vehiclename["СУ-122А"]="su122a";
        s_vehiclename["КВ-220"]="kv_220";
        s_vehiclename["КВ-220 Т"]="kv_220_action";
        s_vehiclename["СУ-85И"]="su_85i";
        //common
        s_vehiclename["Grille"]="grille";
        s_vehiclename["StuGIII"]="stugiii";
        s_vehiclename["T-25"]="t_25";
        s_vehiclename["Pz. IV"]="pziv";
        s_vehiclename["Pz. IV Hyd."]="pziv_hydro";
        s_vehiclename["Pz. III/IV"]="pziii_iv";
        s_vehiclename["Leopard"]="vk1602";
        s_vehiclename["Chaffee"]="m24_chaffee";
        s_vehiclename["M7"]="m7_med";
        s_vehiclename["T49"]="t49";
        s_vehiclename["Wolverine"]="m10_wolverine";
        s_vehiclename["Ram II"]="ram_ii";
        s_vehiclename["M4"]="m4_sherman";
        s_vehiclename["T1 Heavy"]="t1_hvy";
        s_vehiclename["T14"]="t14";
        s_vehiclename["M4A2E4"]="m4a2e4";
        s_vehiclename["M41"]="m41";
        s_vehiclename["S35 CA"]="s_35ca";
        s_vehiclename["BDR G1 B"]="bdr_g1b";
        s_vehiclename["ELC AMX"]="elc_amx";
        s_vehiclename["AMX 13 105 AM"]="amx_105am";
        s_vehiclename["Crusader"]="gb20_crusader";
        s_vehiclename["AT 2"]="gb73_at2";
        s_vehiclename["Churchill I"]="gb08_churchill_i";
        s_vehiclename["Matilda BP"]="gb68_matilda_black_prince";
        s_vehiclename["Type T-34"]="ch21_t34";

        //level 6
        //en
        s_vehiclename["SU-100Y"]="su100y";
        s_vehiclename["SU-100"]="su_100";
        s_vehiclename["T-34-85"]="t_34_85";
        s_vehiclename["KV-1S"]="kv_1s";
        s_vehiclename["T-150"]="t150";
        s_vehiclename["KV-2"]="kv2";
        s_vehiclename["SU-8"]="su_8";
        //ru
        s_vehiclename["СУ-100Y"]="su100y";
        s_vehiclename["СУ-100"]="su_100";
        s_vehiclename["Т-34-85"]="t_34_85";
        s_vehiclename["КВ-1С"]="kv_1s";
        s_vehiclename["Т-150"]="t150";
        s_vehiclename["КВ-2"]="kv2";
        s_vehiclename["СУ-8"]="su_8";
        //common
        s_vehiclename["Hummel"]="hummel";
        s_vehiclename["D. Max"]="dickermax";
        s_vehiclename["JagdPzIV"]="jagdpziv";
        s_vehiclename["VK 30.01 P"]="vk3001p";
        s_vehiclename["VK 36.01 H"]="vk3601h";
        s_vehiclename["VK 30.01 H"]="vk3001h";
        s_vehiclename["VK 30.01 D"]="vk3002db_v1";    
        s_vehiclename["VK 28.01"]="vk2801";
        s_vehiclename["Pz. IV S."]="pziv_schmalturm";
        s_vehiclename["Pz. V/IV"]="pzv_pziv";
        s_vehiclename["Pz. V/IV A"]="pzv_pziv_ausf_alfa";
        s_vehiclename["T21"]="t21";
        s_vehiclename["Hellcat"]="m18_hellcat";
        s_vehiclename["Jackson"]="m36_slagger";
        s_vehiclename["M4A3E8"]="m4a3e8_sherman";
        s_vehiclename["M4A3E2"]="sherman_jumbo";
        s_vehiclename["M6"]="m6";
        s_vehiclename["M44"]="m44";
        s_vehiclename["ARL V39"]="arl_v39";
        s_vehiclename["ARL 44"]="arl_44";
        s_vehiclename["AMX 12 t"]="amx_12t";
        s_vehiclename["AMX 13 F3"]="amx_13f3am";
        s_vehiclename["Cromwell"]="gb21_cromwell";
        s_vehiclename["AT 8"]="gb74_at8";
        s_vehiclename["Churchill GC"]="gb40_gun_carrier_churchill";
        s_vehiclename["Churchill VII"]="gb09_churchill_vii";
        s_vehiclename["TOG II*"]="gb63_tog_ii";
        s_vehiclename["59-16"]="ch15_59_16";
        s_vehiclename["Type 58"]="ch20_type58";

        //level 7
        //en
        s_vehiclename["SU-152"]="su_152";
        s_vehiclename["SU-100M1"]="su100m1";
        s_vehiclename["SU-122-44"]="su122_44";
        s_vehiclename["T-43"]="t_43";
        s_vehiclename["KV-13"]="kv_13";
        s_vehiclename["IS"]="is";
        s_vehiclename["KV-3"]="kv_3";
        s_vehiclename["S-51"]="s_51";
        s_vehiclename["SU-14-1"]="su14_1";
        //ru
        s_vehiclename["СУ-152"]="su_152";
        s_vehiclename["СУ-100М1"]="su100m1";
        s_vehiclename["СУ-122-44"]="su122_44";
        s_vehiclename["Т-43"]="t_43";
        s_vehiclename["КВ-13"]="kv_13";
        s_vehiclename["ИС"]="is";
        s_vehiclename["КВ-3"]="kv_3";
        s_vehiclename["С-51"]="s_51";
        s_vehiclename["СУ-14-1"]="su14_1";
        //common
        s_vehiclename["G.W. Panther"]="g_panther";
        s_vehiclename["JgPanther"]="jagdpanther";
        s_vehiclename["E-25"]="e-25";
        s_vehiclename["Tiger P"]="pzvi_tiger_p";
        s_vehiclename["Tiger"]="pzvi";
        s_vehiclename["Panther"]="pzv";
        s_vehiclename["VK 30.02 D"]="vk3002db";
        s_vehiclename["Aufkl.Panther"]="auf_panther";
        s_vehiclename["Pz. V/M10"]="panther_m10";
        s_vehiclename["T71"]="t71";
        s_vehiclename["T25/2"]="t25_2";
        s_vehiclename["T25 AT"]="t25_at";
        s_vehiclename["T20"]="t20";
        s_vehiclename["T29"]="t29";
        s_vehiclename["M12"]="m12";
        s_vehiclename["AMX AC 46"]="amx_ac_mle1946";
        s_vehiclename["AMX M4 45"]="amx_m4_1945";
        s_vehiclename["AMX 13 75"]="amx_13_75";
        s_vehiclename["Lorr. 155 50"]="lorraine155_50";
        s_vehiclename["Comet"]="gb22_comet";
        s_vehiclename["AT 7"]="gb75_at7";
        s_vehiclename["AT 15A"]="gb71_at_15a";
        s_vehiclename["Black Prince"]="gb10_black_prince";
        s_vehiclename["WZ-131"]="ch16_wz_131";
        s_vehiclename["T-34-1"]="ch04_t34_1";
        s_vehiclename["IS-2"]="ch10_is2";
        s_vehiclename["Type 62"]="ch02_type62";

        //level 8
        //en
        s_vehiclename["ISU-152"]="isu_152";
        s_vehiclename["SU-101"]="su_101";
        s_vehiclename["T-44"]="t_44";
        s_vehiclename["IS-6"]="object252";
        s_vehiclename["IS-3"]="is_3";
        s_vehiclename["KV-4"]="kv4";
        s_vehiclename["KV-5"]="kv_5";
        s_vehiclename["SU-14-2"]="su_14";
        //ru
        s_vehiclename["ИСУ-152"]="isu_152";
        s_vehiclename["СУ-101"]="su_101";
        s_vehiclename["Т-44"]="t_44";
        s_vehiclename["ИС-6"]="object252";
        s_vehiclename["ИС-3"]="is_3";
        s_vehiclename["КВ-4"]="kv4";
        s_vehiclename["КВ-5"]="kv_5";
        s_vehiclename["СУ-14-2"]="su_14";
        //common
        s_vehiclename["G.W. Tiger P"]="gw_tiger_p";
        s_vehiclename["JgTig.8;8 cm"]="jagdtiger_sdkfz_185";
        s_vehiclename["JgPanthII"]="jagdpantherii";
        s_vehiclename["Ferdinand"]="ferdinand";
        s_vehiclename["VK 45.02 A"]="vk4502a";
        s_vehiclename["Tiger II"]="pzvib_tiger_ii";
        s_vehiclename["Löwe"]="lowe";
        s_vehiclename["Panther II"]="panther_ii";
        s_vehiclename["Indien-Pz."]="indien_panzer";
        s_vehiclename["T69"]="t69";
        s_vehiclename["T28 Prot."]="t28_prototype";
        s_vehiclename["T28"]="t28";
        s_vehiclename["Pershing"]="pershing";
        s_vehiclename["T26E4"]="t26_e4_superpershing";
        s_vehiclename["T32"]="t32";
        s_vehiclename["T34"]="t34_hvy";
        s_vehiclename["M40/M43"]="m40m43";
        s_vehiclename["M6A2E1"]="m6a2e1";
        s_vehiclename["AMX AC 48"]="amx_ac_mle1948";
        s_vehiclename["AMX 50 100"]="amx_50_100";
        s_vehiclename["FCM 50 t"]="fcm_50t";
        s_vehiclename["AMX 13 90"]="amx_13_90";
        s_vehiclename["Lorr. 155 51"]="lorraine155_51";
        s_vehiclename["Centurion I"]="gb23_centurion";
        s_vehiclename["AT 15"]="gb72_at15";
        s_vehiclename["Caernarvon"]="gb11_caernarvon";
        s_vehiclename["WZ-132"]="ch17_wz131_1_wz132";
        s_vehiclename["T-34-2"]="ch05_t34_2";
        s_vehiclename["110"]="ch11_110";
        s_vehiclename["Type 59"]="ch01_type59";
        s_vehiclename["Type 59 G"]="ch01_type59_gold";
        s_vehiclename["WZ-111"]="ch03_wz_111";
        s_vehiclename["112"]="ch23_112";

        //level 9
        //en
        s_vehiclename["Obj. 704"]="object_704";
        s_vehiclename["SU-122-54"]="su122_54";
        s_vehiclename["T-54"]="t_54";
        s_vehiclename["IS-8"]="is8";
        s_vehiclename["ST-I"]="st_i";
        s_vehiclename["212A"]="object_212";
        //ru
        s_vehiclename["Об. 704"]="object_704";
        s_vehiclename["СУ-122-54"]="su122_54";
        s_vehiclename["Т-54"]="t_54";
        s_vehiclename["ИС-8"]="is8";   
        s_vehiclename["СТ-I"]="st_i";
        s_vehiclename["212А"]="object_212";
        //common
        s_vehiclename["Jagdtiger"]="jagdtiger";
        s_vehiclename["VK 45.02 P"]="vk4502p";
        s_vehiclename["E-75"]="e_75";
        s_vehiclename["E-50"]="e_50";
        s_vehiclename["Leopard PT A"]="pro_ag_a";
        s_vehiclename["G.W. Tiger"]="g_tiger";
        s_vehiclename["T54E1"]="t54e1";
        s_vehiclename["T30"]="t30";
        s_vehiclename["T95"]="t95";
        s_vehiclename["M46 Patton"]="m46_patton";
        s_vehiclename["M103"]="m103";
        s_vehiclename["Foch"]="amx50_foch";
        s_vehiclename["AMX 50 120"]="amx_50_120";
        s_vehiclename["Lorr. 40 t"]="lorraine40t";
        s_vehiclename["B-C 155 55"]="bat_chatillon155_55";
        s_vehiclename["Centurion 7/1"]="gb24_centurion_mk3";
        s_vehiclename["Tortoise"]="gb32_tortoise";
        s_vehiclename["Conqueror"]="gb12_conqueror";
        s_vehiclename["M53/M55"]="m53_55";
        s_vehiclename["WZ-120"]="ch18_wz_120";
        s_vehiclename["WZ-111 1-4"]="ch12_111_1_2_3";

        //level 10
        //en
        s_vehiclename["Obj. 268"]="object268";
        s_vehiclename["Obj. 263"]="object263";
        s_vehiclename["T-62A"]="t62a";
        s_vehiclename["IS-7"]="is_7";
        s_vehiclename["IS-4"]="is_4";
        s_vehiclename["Obj. 261"]="object_261";
        //ru
        s_vehiclename["Obj. 268"]="object268";
        s_vehiclename["Obj. 263"]="object263";
        s_vehiclename["T-62A"]="t62a";
        s_vehiclename["IS-7"]="is_7";
        s_vehiclename["IS-4"]="is_4";
        s_vehiclename["Obj. 261"]="object_261";
        //common
        s_vehiclename["Об. 268"]="object268";
        s_vehiclename["Об. 263"]="object263";
        s_vehiclename["Т-62А"]="t62a";
        s_vehiclename["ИС-7"]="is_7";
        s_vehiclename["ИС-4"]="is_4";
        s_vehiclename["Об. 261"]="object_261";
        s_vehiclename["JgPzE100"]="jagdpz_e100";
        s_vehiclename["Maus"]="maus";
        s_vehiclename["E-100"]="e_100";
        s_vehiclename["E-50M"]="e50_ausf_m";
        s_vehiclename["Leopard 1"]="leopard1";
        s_vehiclename["G.W. E 100"]="g_e";
        s_vehiclename["T57 Heavy"]="t57_58";
        s_vehiclename["T110E4"]="t110e4";
        s_vehiclename["T110E3"]="t110e3";
        s_vehiclename["M48 Patton"]="m48a1";
        s_vehiclename["T110E5"]="t110";
        s_vehiclename["T92"]="t92";
        s_vehiclename["Foch 155"]="amx_50fosh_155";
        s_vehiclename["AMX 50 B"]="f10_amx_50b";
        s_vehiclename["B-C 25 t"]="bat_chatillon25t";
        s_vehiclename["B-C 155 58"]="bat_chatillon155_58";
        s_vehiclename["FV4202"]="gb70_fv4202_105";
        s_vehiclename["FV215b 183"]="gb48_fv215b_183";
        s_vehiclename["FV215b"]="gb13_fv215b";
        s_vehiclename["121"]="ch19_121";
        s_vehiclename["113"]="ch22_113"
    };
}