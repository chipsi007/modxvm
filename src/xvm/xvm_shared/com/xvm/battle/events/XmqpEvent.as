/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * http://www.modxvm.com/
 */
package com.xvm.battle.events
{
    import com.xvm.battle.*;
    import flash.events.*;

    public class XmqpEvent extends Event
    {
        public static var XMQP_HOLA:String = "xmqp_hola";
        public static var XMQP_FIRE:String = "xmqp_fire";
        public static var XMQP_VEHICLE_TIMER:String = "xmqp_vehicle_timer";
        public static var XMQP_DEATH_ZONE_TIMER:String = "xmqp_death_zone_timer";
        public static var XMQP_SPOTTED:String = "xmqp_spotted";
        public static var XMQP_MINIMAP_CLICK:String = "xmqp_minimap_click";

        public var accountDBID:Number;
        public var data:Object;

        public function XmqpEvent(type:String, accountDBID:Number, data:Object = null)
        {
            super(type, false, false);
            this.accountDBID = accountDBID;
            this.data = data;
        }

        public override function clone():Event
        {
            return new XmqpEvent(type, accountDBID, data);
        }
    }

}
