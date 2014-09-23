package net.wg.gui.lobby.fortifications.data
{
    import net.wg.data.daapi.base.DAAPIDataClass;
    
    public class FortInterFilterVO extends DAAPIDataClass
    {
        
        public function FortInterFilterVO(param1:Object)
        {
            super(param1);
        }
        
        private var _clanTypes:Array = null;
        
        private var _selectedFilterType:int = -1;
        
        public function get clanTypes() : Array
        {
            return this._clanTypes;
        }
        
        public function set clanTypes(param1:Array) : void
        {
            this._clanTypes = param1;
        }
        
        public function get selectedFilterType() : int
        {
            return this._selectedFilterType;
        }
        
        public function set selectedFilterType(param1:int) : void
        {
            this._selectedFilterType = param1;
        }
        
        override protected function onDispose() : void
        {
            this._clanTypes.splice(0,this._clanTypes.length);
            this._clanTypes = null;
            super.onDispose();
        }
    }
}
