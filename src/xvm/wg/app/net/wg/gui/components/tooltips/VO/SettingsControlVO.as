package net.wg.gui.components.tooltips.VO
{
    import net.wg.data.daapi.base.DAAPIDataClass;
    
    public class SettingsControlVO extends DAAPIDataClass
    {
        
        public function SettingsControlVO(param1:Object) {
            super(param1);
        }
        
        public var name:String = "";
        
        public var descr:String = "";
        
        public var recommended:String = "";
        
        public var status:Object = null;
    }
}
