﻿/**
 * XFW
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.vo
{
    //public dynamic class VehicleData extends BaseVO
    public class VOVehicleData extends VOBase
    {
        public var vid:int;
        public var key:String;

        public var level:int;
        public var vclass:String;
        public var nation:String;
        public var premium:Boolean;
        public var isReserved:Boolean;

        public var hpStock:int;
        public var hpTop:int;
        public var visRadius:int;
        public var firingRadius:int;
        public var artyRadius:int;

        public var tierLo:int;
        public var tierHi:int;

        public var localizedName:String; // can be overrided by user
        public var localizedShortName:String;
        public var localizedFullName:String;

        public var turret:int;

        public var wn8expDamage:Number;
        public var wn8expSpot:Number;
        public var wn8expWinRate:Number;
        public var wn8expDef:Number;
        public var wn8expFrag:Number;

        public var avgR:Number;
        public var topR:Number;
        public var avgD:Number;
        public var topD:Number;
        public var avgF:Number;
        public var topF:Number;

        // additional

        public var shortName:String;

        // PROPERTIES

        public function get vtype():String
        {
            return VClassToVType(vclass);
        }

        public function get sysname():String
        {
            return key.replace(':', '-');
        }

        public function VOVehicleData(data:Object = null)
        {
            super(data);
        }

        // PRIVATE

        // vclass = "mediumTank"
        // vtype = "MT"
        private static function VClassToVType(vclass:String):String
        {
            switch (vclass)
            {
                case "lightTank": return "LT";
                case "mediumTank": return "MT";
                case "heavyTank": return "HT";
                case "AT-SPG": return "TD";
                case "SPG": return "SPG";
                default: return "";
            }
        }
   }
}
