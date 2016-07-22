/**
 * XVM Config
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.types.cfg
{
    import com.xfw.*;

    public dynamic class CStatisticForm extends Object implements ICloneable
    {
        public var showBattleTier:*;
        public var removeSquadIcon:*;
        public var removeVehicleLevel:*;
        public var removeVehicleTypeIcon:*;
        public var nameFieldShowBorder:*;
        public var vehicleFieldShowBorder:*;
        public var fragsFieldShowBorder:*;
        public var squadIconOffsetXLeft:*;
        public var squadIconOffsetXRight:*;
        public var nameFieldOffsetXLeft:*;
        public var nameFieldOffsetXRight:*;
        public var vehicleFieldOffsetXLeft:*;
        public var vehicleFieldOffsetXRight:*;
        public var vehicleIconOffsetXLeft:*;
        public var vehicleIconOffsetXRight:*;
        public var fragsOffsetXLeft:*;
        public var fragsOffsetXRight:*;
        public var clanIcon:CClanIcon;
        public var formatLeftNick:String;
        public var formatLeftVehicle:String;
        public var formatRightNick:String;
        public var formatRightVehicle:String;
        public var extraFieldsLeft:Array;
        public var extraFieldsRight:Array;

        public function clone():*
        {
            throw new Error("clone() method is not implemented");
        }
    }
}