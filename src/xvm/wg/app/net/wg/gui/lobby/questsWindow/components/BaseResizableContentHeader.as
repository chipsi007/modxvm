package net.wg.gui.lobby.questsWindow.components
{
    import scaleform.clik.core.UIComponent;
    
    public class BaseResizableContentHeader extends UIComponent
    {
        
        public function BaseResizableContentHeader()
        {
            super();
        }
        
        private var _selected:Boolean;
        
        private var _data:Object;
        
        public function setData(param1:Object) : void
        {
            this._data = param1;
        }
        
        override protected function onDispose() : void
        {
            this._data = null;
            super.onDispose();
        }
        
        public function get selected() : Boolean
        {
            return this._selected;
        }
        
        public function set selected(param1:Boolean) : void
        {
            this._selected = param1;
        }
    }
}
