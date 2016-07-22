/**
 * XVM Config
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.types.cfg
{
    import com.xfw.*;

    public dynamic class CMarkers4 extends Object implements ICloneable
    {
        public var vehicleIcon:CMarkersVehicleIcon;
        public var healthBar:CMarkersHealthBar;
        public var damageText:CMarkersDamageText;
        public var damageTextPlayer:CMarkersDamageText;
        public var damageTextSquadman:CMarkersDamageText;
        public var contourIcon:CMarkersContourIcon;
        public var levelIcon:CMarkersLevelIcon;
        public var actionMarker:CMarkersActionMarker;
        public var textFields:Array;

        public function clone():*
        {
            throw new Error("clone() method is not implemented");
        }
    }
}