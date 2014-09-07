package net.wg.gui.lobby.questsWindow.components
{
    import net.wg.gui.components.controls.CheckBox;
    import flash.text.TextField;
    import flash.events.Event;
    import net.wg.gui.lobby.questsWindow.data.TreeContentVO;
    
    public class TreeHeader extends BaseResizableContentHeader
    {
        
        public function TreeHeader()
        {
            super();
        }
        
        private static var INVALIDATE_HTML_LABEL:String = "invHtmlLabel";
        
        private static var INVALIDATE_LABEL:String = "invLabel";
        
        public static var TEXT_PADDING:int = 5;
        
        public var slideCheckBox:CheckBox;
        
        private var _htmlLabel:String = "";
        
        private var _label:String = "";
        
        public var htmlTF:TextField;
        
        override protected function configUI() : void
        {
            super.configUI();
            this.slideCheckBox.addEventListener(Event.SELECT,this.cbSelectHandler,false,0,true);
        }
        
        private function cbSelectHandler(param1:Event) : void
        {
            dispatchEvent(param1);
        }
        
        override protected function draw() : void
        {
            var _loc1_:* = NaN;
            super.draw();
            if(isInvalid(INVALIDATE_LABEL))
            {
                this.slideCheckBox.label = this._label;
                this.slideCheckBox.validateNow();
            }
            if(isInvalid(INVALIDATE_HTML_LABEL))
            {
                _loc1_ = this.slideCheckBox.textField.textWidth;
                this.htmlTF.x = Math.round(this.slideCheckBox.textField.x + _loc1_ + (_loc1_ > 0?TEXT_PADDING:0));
                this.htmlTF.htmlText = this._htmlLabel;
            }
        }
        
        override public function setData(param1:Object) : void
        {
            var _loc2_:TreeContentVO = TreeContentVO(param1);
            this.slideCheckBox.selected = _loc2_.isOpened;
            this.slideCheckBox.enabled = _loc2_.isResizable;
            this.label = _loc2_.headerTitle;
            this.htmlLabel = _loc2_.headerHtmlPart;
        }
        
        override public function get selected() : Boolean
        {
            return this.slideCheckBox.selected;
        }
        
        override public function set selected(param1:Boolean) : void
        {
            super.selected = param1;
            this.slideCheckBox.selected = param1;
        }
        
        override protected function onDispose() : void
        {
            this.htmlTF = null;
            this.slideCheckBox.dispose();
            this.slideCheckBox.removeEventListener(Event.SELECT,this.cbSelectHandler);
            this.slideCheckBox = null;
            super.onDispose();
        }
        
        public function get htmlLabel() : String
        {
            return this._htmlLabel;
        }
        
        public function set htmlLabel(param1:String) : void
        {
            this._htmlLabel = param1;
            invalidate(INVALIDATE_HTML_LABEL);
        }
        
        public function get label() : String
        {
            return this._label;
        }
        
        public function set label(param1:String) : void
        {
            this._label = param1;
            invalidate(INVALIDATE_LABEL);
        }
    }
}
