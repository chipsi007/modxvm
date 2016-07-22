/**
 * XVM Config
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.types.cfg
{
    import com.xfw.*;

    public dynamic class CPlayersPanelMode extends Object implements ICloneable
    {
        public var enabled:*;
        public var standardFields:Array;
        public var expandAreaWidth:*;
        public var removeSquadIcon:*;
        public var vehicleIconXOffsetLeft:*;
        public var vehicleIconXOffsetRight:*;
        public var vehicleLevelXOffsetLeft:*;
        public var vehicleLevelXOffsetRight:*;
        public var vehicleLevelAlpha:*;
        public var fragsXOffsetLeft:*;
        public var fragsXOffsetRight:*;
        public var fragsWidth:*;
        public var fragsFormatLeft:String;
        public var fragsFormatRight:String;
        public var nickXOffsetLeft:*;
        public var nickXOffsetRight:*;
        public var nickMinWidth:*;
        public var nickMaxWidth:*;
        public var nickFormatLeft:String;
        public var nickFormatRight:String;
        public var vehicleXOffsetLeft:*;
        public var vehicleXOffsetRight:*;
        public var vehicleWidth:*;
        public var vehicleFormatLeft:String;
        public var vehicleFormatRight:String;
        public var extraFieldsLeft:Array;
        public var extraFieldsRight:Array;

        public function clone():*
        {
            throw new Error("clone() method is not implemented");
        }
    }
}