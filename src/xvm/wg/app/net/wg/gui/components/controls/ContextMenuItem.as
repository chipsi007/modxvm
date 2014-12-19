package net.wg.gui.components.controls
{
    import net.wg.infrastructure.interfaces.IContextItem;
    import flash.display.MovieClip;
    import flash.text.TextField;
    import scaleform.clik.utils.Constraints;
    import net.wg.data.constants.SoundTypes;
    
    public class ContextMenuItem extends SoundListItemRenderer
    {
        
        public function ContextMenuItem()
        {
            this.subItems = new Array();
            super();
            soundType = SoundTypes.CONTEXT_MENU;
            useRightButton = false;
            this._items = new Vector.<IContextItem>();
            this.defItemTextWidth = this.width - textField.width;
        }
        
        public var CONTEXT_MENU_ITEM_MAIN:String = "main";
        
        public var CONTEXT_MENU_ITEM_SUB:String = "sub";
        
        public var CONTEXT_MENU_ITEM_GROUP:String = "group";
        
        public var id:String = "";
        
        private var _type:String = "";
        
        private var _items:Vector.<IContextItem>;
        
        private var defItemTextWidth:Number = 0;
        
        private var TEXT_MARGIN:Number = 5;
        
        public var subItems:Array;
        
        public var _isOpened:Boolean = false;
        
        public var arrowMc:MovieClip;
        
        public var circleMc:MovieClip;
        
        public var textFieldSub:TextField;
        
        override protected function configUI() : void
        {
            if(!constraintsDisabled && (this.textFieldSub))
            {
                constraints.addElement("textFieldSub",this.textFieldSub,Constraints.ALL);
            }
            super.configUI();
        }
        
        override protected function draw() : void
        {
            super.draw();
            switch(this.type)
            {
                case this.CONTEXT_MENU_ITEM_MAIN:
                    this.arrowMc.visible = false;
                    this.circleMc.visible = false;
                    textField.visible = true;
                    this.textFieldSub.visible = false;
                    break;
                case this.CONTEXT_MENU_ITEM_GROUP:
                    this.arrowMc.visible = true;
                    this.circleMc.visible = false;
                    textField.visible = true;
                    this.textFieldSub.visible = false;
                    break;
                case this.CONTEXT_MENU_ITEM_SUB:
                    this.arrowMc.visible = false;
                    this.circleMc.visible = true;
                    textField.visible = false;
                    this.textFieldSub.visible = true;
                    break;
            }
        }
        
        public function set type(param1:String) : void
        {
            if(param1 == this._type)
            {
                return;
            }
            this._type = param1;
            if(enabled)
            {
                setState("up");
            }
            invalidateState();
        }
        
        public function get type() : String
        {
            return this._type;
        }
        
        public function set items(param1:Vector.<IContextItem>) : void
        {
            if(!this._items)
            {
                this._items = new Vector.<IContextItem>();
            }
            if(param1 == this._items)
            {
                return;
            }
            this._items = param1;
            if(this._items.length > 0)
            {
                this.type = this.CONTEXT_MENU_ITEM_GROUP;
            }
            else
            {
                this.type = this.CONTEXT_MENU_ITEM_MAIN;
            }
        }
        
        public function get items() : Vector.<IContextItem>
        {
            return this._items;
        }
        
        public function set isOpened(param1:Boolean) : void
        {
            if(param1 == this._isOpened)
            {
                return;
            }
            this._isOpened = param1;
            if(this.arrowMc.visible)
            {
                this.arrowMc.gotoAndStop(this._isOpened?"down":"up");
            }
        }
        
        public function get isOpened() : Boolean
        {
            return this._isOpened;
        }
        
        override protected function onDispose() : void
        {
        }
        
        public function invalidWidth() : void
        {
            this.updateText();
            if(this.textFieldSub)
            {
                this.updateItemWidth(this.textFieldSub);
            }
            if(textField)
            {
                this.updateItemWidth(textField);
            }
        }
        
        override protected function updateText() : void
        {
            super.updateText();
            if(!(_label == null) && !(this.textFieldSub == null))
            {
                this.textFieldSub.text = _label;
            }
        }
        
        private function updateItemWidth(param1:TextField) : void
        {
            if(param1.width < param1.textWidth + this.TEXT_MARGIN)
            {
                this.width = this.TEXT_MARGIN + this.defItemTextWidth + param1.textWidth | 0;
            }
        }
        
        override protected function updateAfterStateChange() : void
        {
            if(!initialized)
            {
                return;
            }
            super.updateAfterStateChange();
            if(!(constraints == null) && !constraintsDisabled && !(this.textFieldSub == null))
            {
                constraints.updateElement("textFieldSub",this.textFieldSub);
            }
        }
        
        override protected function getStatePrefixes() : Vector.<String>
        {
            var _loc1_:String = this.type == this.CONTEXT_MENU_ITEM_SUB?this.CONTEXT_MENU_ITEM_SUB + "_":"";
            return _selected?Vector.<String>([_loc1_ + "selected_",""]):Vector.<String>([_loc1_]);
        }
        
        override public function toString() : String
        {
            return "[WG ContextMenuItem " + name + "]";
        }
    }
}
