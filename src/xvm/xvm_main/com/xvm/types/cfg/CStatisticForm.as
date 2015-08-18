/**
 * XVM Config - "statisticForm" section
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.types.cfg
{
    public dynamic class CStatisticForm extends Object
    {
        public var showBattleTier:Boolean;  // Show battle tier.
        public var removeSquadIcon:Boolean; // Hide squad icon.
        public var clanIcon:CClanIcon;      // Playes/clan icon parameters.
        // Dispay formats.
        public var formatLeftNick:String;
        public var formatLeftVehicle:String;
        public var formatRightNick:String;
        public var formatRightVehicle:String;
        public var xPositionLeftVehicle:Number;
        public var xPositionRightVehicle:Number;
        public var xPositionLeftVehicleIcon:Number;
        public var xPositionRightVehicleIcon:Number;
    }
}
