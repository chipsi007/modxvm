import wot.VehicleMarkersManager.AbstractAccessProxy;
import wot.VehicleMarkersManager.ColorsManager;
import wot.VehicleMarkersManager.Xvm;

class wot.VehicleMarkersManager.components.VehicleTypeProxy extends AbstractAccessProxy
{
   /**
    * This proxy class is only for access restriction to wot.VehicleMarkersManager.Xvm
    */

    public function VehicleTypeProxy(xvm:Xvm)
    {
        super(xvm);
    }

    public function get marker():MovieClip
    {
        return xvm.proxy.marker;
    }

    public function get isSpeaking():Boolean
    {
        return xvm.m_speaking;
    }

    public function get isDead():Boolean
    {
        return xvm.m_isDead; // or xvm.vehicleDestroyed(); ?
    }

    public function get entityName():String
    {
        return xvm.m_entityName;
    }

    public function get isColorBlindMode():Boolean
    {
        return ColorsManager.isColorBlindMode;
    }

    public function setMarkerLabel(markerLabel:String):Void
    {
        xvm.proxy.gotoAndStop(markerLabel);
    }
}
