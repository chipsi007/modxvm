package net.wg.gui.components.tooltips.VO
{
    import net.wg.data.daapi.base.DAAPIDataClass;
    import net.wg.data.constants.IconsTypes;
    import net.wg.utils.ILocale;
    import net.wg.data.constants.FittingTypes;
    
    public class ToolTipActionPriceVO extends DAAPIDataClass
    {
        
        public function ToolTipActionPriceVO(param1:Object) {
            this.allowTypes = [FittingTypes.VEHICLE,FittingTypes.MODULE,FittingTypes.EQUIPMENT,FittingTypes.SHELL,FittingTypes.OPTIONAL_DEVICE];
            super(param1);
        }
        
        public var price:Number = -1;
        
        public var defaultPrice:Number = -1;
        
        public var priceStr:String = "";
        
        public var defaultPriceStr:String = "";
        
        public var actionPrc:Number = -1;
        
        public var actionName:String = "";
        
        public var ico:String = "credits";
        
        private var _itemType:String = "";
        
        private var allowTypes:Array;
        
        override protected function onDataWrite(param1:String, param2:Object) : Boolean {
            if(param1 == "defaultPrice")
            {
                this.ico = param2[0] > 0?IconsTypes.CREDITS:IconsTypes.GOLD;
                this.defaultPrice = param2[0] > 0?param2[0]:param2[1];
                return false;
            }
            if(param1 == "price")
            {
                this.price = param2[0] > 0?param2[0]:param2[1];
                return false;
            }
            return this.hasOwnProperty(param1);
        }
        
        override public function fromHash(param1:Object) : void {
            super.fromHash(param1);
            this.setStrPrices();
        }
        
        private function setStrPrices() : void {
            var _loc1_:ILocale = App.utils.locale;
            this.priceStr = this.ico == IconsTypes.GOLD?_loc1_.gold(Math.abs(this.price)):_loc1_.integer(Math.abs(this.price));
            this.defaultPriceStr = this.ico == IconsTypes.GOLD?_loc1_.gold(Math.abs(this.defaultPrice)):_loc1_.integer(Math.abs(this.defaultPrice));
        }
        
        public function get itemType() : String {
            return this._itemType;
        }
        
        public function set itemType(param1:String) : void {
            if(param1 == this._itemType)
            {
                return;
            }
            if(this.allowTypes.indexOf(param1) == -1)
            {
                DebugUtils.LOG_DEBUG("itemType in ActionPriceVO is invalid. Income type: " + param1 + ", allow types: " + this.allowTypes);
                return;
            }
            this._itemType = param1;
        }
    }
}
