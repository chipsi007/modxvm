﻿/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm
{
    import com.xfw.*;
    import com.xvm.vo.VOVehicleData;

    public class VehicleInfo
    {
        // PUBLIC

        public static function setVehicleInfoData(data_array:Array):void
        {
            instance.onVehicleInfoData(data_array);
        }

        public static function get(vehCD:int):VOVehicleData
        {
            return instance._get(vehCD);
        }

        public static function getByIcon(icon:String):VOVehicleData
        {
            return instance._getByIcon(icon);
        }

        public static function getByLocalizedShortName(localizedShortName:String):VOVehicleData
        {
            return instance._getByLocalizedShortName(localizedShortName);
        }

        public static function getVTypeText(vtype:String):String
        {
            // vtype = HT
            // return: HT text
            if (!vtype || !Config.config.texts.vtype[vtype])
                return "";
            var v:String = Config.config.texts.vtype[vtype];
            if (v.indexOf("{{l10n:") >= 0)
                v = Locale.get(v);
            return v;
        }

        public static function getVIconName(vkey:String):String
        {
            // vkey = ussr:KV-220_action
            // return: ussr-KV-220_action
            if (!vkey)
                return "";
            return vkey.split(":").join("-");
        }

        // PRIVATE

        private var vehicles:Object;
        private var vehiclesMapKey:Object;
        private var vehiclesMapName:Object;

        // instance
        private static var _instance:VehicleInfo = null;
        private static function get instance():VehicleInfo
        {
            if (_instance == null)
                _instance = new VehicleInfo();
            return _instance;
        }

        public function VehicleInfo()
        {
            //Logger.add("VehicleInfo::ctor()")
            this.clear();
        }

        private function clear():void
        {
            this.vehicles = {};
            this.vehiclesMapKey = {};
            this.vehiclesMapName = {};
        }

        private function onVehicleInfoData(data_array:Array):void
        {
            this.clear();
            if (data_array == null)
                return;
            //Logger.add("onVehicleInfoData(): " + json_str);
            try
            {
                for each (var obj:Object in data_array)
                {
                    var data:VOVehicleData = new VOVehicleData(obj);
                    var preferredNames:Object = Config.config.vehicleNames[data.key.split(':').join('-')];
                    if (preferredNames != null)
                    {
                        if (preferredNames['name'] != null && preferredNames['name'] != '')
                            data.localizedName = preferredNames['name'];
                        if (preferredNames['short'] != null && preferredNames['short'] != '')
                            data.shortName = preferredNames['short'];
                    }
                    //Logger.addObject(data);
                    vehicles[data.vehCD] = data;
                    vehiclesMapKey[data.key] = data.vehCD; // for getByIcon()
                    vehiclesMapName[data.localizedShortName] = data.vehCD; // for getByLocalizedShortName()
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        private function _get(vehCD:int):VOVehicleData
        {
            return vehicles[vehCD];
        }

        private function _getByIcon(icon:String):VOVehicleData
        {
            // icon: "ussr-IS-3"
            //   or  "../maps/icons/vehicle/contour/ussr-IS-3.png"
            // key: "ussr:IS-3"
            var n:int = icon.lastIndexOf("/");
            if (n > 0)
                icon = icon.substring(n + 1);
            n = icon.indexOf(".");
            if (n > 0)
                icon = icon.substring(0, n);
            icon = icon.replace("-", ":");
            return vehicles[vehiclesMapKey[icon]];
        }

        private function _getByLocalizedShortName(localizedShortName:String):VOVehicleData
        {
            // localizedShortName: "ИС-3"
            return vehicles[vehiclesMapName[localizedShortName]];
        }
    }
}