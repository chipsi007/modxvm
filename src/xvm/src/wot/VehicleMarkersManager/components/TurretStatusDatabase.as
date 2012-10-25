/** 
* This file is automatically generated by VehicleBankParser program.
* Data extracted from WoT version 0.8.0
*/
        
class wot.VehicleMarkersManager.components.TurretStatusDatabase
{
    /**
    * Vehicles in list has two turret modules.
    * Format:
    * vehicel name, stock max hp, turret status
    * Turret status: 2 - unable to mount top gun to stock turret, 1 - able
    */
        
    private static var db:Array;

    public static function getDb():Array
    {
        if(db == null)
        {
            db = new Array();
            db["a-20"] = new Array(310, 2);
            db["amx_m4_1945"] = new Array(1100, 2);
            db["amx40"] = new Array(280, 2);
            db["arl_44"] = new Array(780, 2);
            db["b1"] = new Array(380, 2);
            db["bdr_g1b"] = new Array(600, 2);
            db["bt-2"] = new Array(140, 2);
            db["bt-7"] = new Array(200, 2);
            db["d1"] = new Array(155, 2);
            db["d2"] = new Array(210, 2);
            db["e-50"] = new Array(1650, 2);
            db["e-75"] = new Array(1820, 2);
            db["gb01_medium_mark_i"] = new Array(130, 1);
            db["gb03_cruiser_mk_i"] = new Array(150, 1);
            db["gb04_valentine"] = new Array(310, 1);
            db["gb05_vickers_medium_mk_ii"] = new Array(170, 1);
            db["gb06_vickers_medium_mk_iii"] = new Array(250, 1);
            db["gb07_matilda"] = new Array(340, 1);
            db["gb08_churchill_i"] = new Array(650, 1);
            db["gb09_churchill_vii"] = new Array(800, 2);
            db["gb11_caernarvon"] = new Array(1500, 1);
            db["gb12_conqueror"] = new Array(1850, 2);
            db["gb20_crusader"] = new Array(410, 1);
            db["gb21_cromwell"] = new Array(700, 2);
            db["gb22_comet"] = new Array(1050, 2);
            db["gb23_centurion"] = new Array(1350, 1);
            db["gb24_centurion_mk3"] = new Array(1620, 2);
            db["gb58_cruiser_mk_iii"] = new Array(140, 1);
            db["gb59_cruiser_mk_iv"] = new Array(210, 2);
            db["gb60_covenanter"] = new Array(310, 2);
            db["gb69_cruiser_mk_ii"] = new Array(220, 1);
            db["is"] = new Array(1130, 2);
            db["is-3"] = new Array(1450, 1);
            db["is8"] = new Array(1700, 1);
            db["kv"] = new Array(560, 1);
            db["kv1"] = new Array(590, 2);
            db["kv-13"] = new Array(1020, 2);
            db["kv-1s"] = new Array(760, 2);
            db["kv2"] = new Array(810, 1);
            db["kv-3"] = new Array(1300, 2);
            db["kv4"] = new Array(1600, 1);
            db["ltraktor"] = new Array(110, 2);
            db["m10_wolverine"] = new Array(340, 1);
            db["m103"] = new Array(1750, 2);
            db["m18_hellcat"] = new Array(550, 2);
            db["m2_lt"] = new Array(140, 2);
            db["m2_med"] = new Array(180, 2);
            db["m24_chaffee"] = new Array(530, 2);
            db["m3_stuart"] = new Array(220, 2);
            db["m36_slagger"] = new Array(560, 1);
            db["m4_sherman"] = new Array(400, 2);
            db["m46_patton"] = new Array(1600, 1);
            db["m4a3e8_sherman"] = new Array(720, 2);
            db["m5_stuart"] = new Array(290, 2);
            db["m6"] = new Array(840, 2);
            db["m7_med"] = new Array(400, 2);
            db["m8a1"] = new Array(250, 2);
            db["ms-1"] = new Array(90, 2);
            db["panther_ii"] = new Array(1350, 2);
            db["pershing"] = new Array(1350, 1);
            db["pz35t"] = new Array(150, 1);
            db["pz38_na"] = new Array(300, 2);
            db["pz38t"] = new Array(200, 2);
            db["pzii"] = new Array(145, 1);
            db["pzii_luchs"] = new Array(190, 2);
            db["pziii"] = new Array(310, 2);
            db["pziii_a"] = new Array(200, 2);
            db["pziii_iv"] = new Array(380, 1);
            db["pziv"] = new Array(420, 2);
            db["pzv"] = new Array(1200, 2);
            db["pzvi"] = new Array(1350, 2);
            db["pzvi_tiger_p"] = new Array(1350, 1);
            db["pzvib_tiger_ii"] = new Array(1500, 1);
            db["renaultft"] = new Array(105, 2);
            db["sherman_jumbo"] = new Array(730, 2);
            db["st_i"] = new Array(1800, 2);
            db["t_50_2"] = new Array(500, 2);
            db["t1_cunningham"] = new Array(105, 2);
            db["t1_hvy"] = new Array(600, 2);
            db["t150"] = new Array(830, 2);
            db["t2_med"] = new Array(155, 2);
            db["t20"] = new Array(1000, 2);
            db["t23"] = new Array(1310, 1);
            db["t25_2"] = new Array(800, 2);
            db["t-26"] = new Array(150, 1);
            db["t-28"] = new Array(320, 1);
            db["t29"] = new Array(1150, 1);
            db["t32"] = new Array(1400, 1);
            db["t-34"] = new Array(400, 2);
            db["t-34-85"] = new Array(670, 2);
            db["t-43"] = new Array(1000, 2);
            db["t-44"] = new Array(1200, 2);
            db["t-46"] = new Array(220, 2);
            db["t49"] = new Array(340, 2);
            db["t-54"] = new Array(1550, 2);
            db["vk2801"] = new Array(560, 2);
            db["vk3001h"] = new Array(670, 2);
            db["vk3001p"] = new Array(610, 2);
            db["vk3002db"] = new Array(1180, 2);
            db["vk3601h"] = new Array(760, 2);
            db["vk4502a"] = new Array(1470, 1);
            db["vk4502p"] = new Array(1850, 2);

        }
        return db;
    }
}
    
