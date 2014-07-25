package scaleform.clik.controls
{
    import scaleform.clik.core.UIComponent;
    import scaleform.clik.interfaces.IDataProvider;
    import flash.display.MovieClip;
    import scaleform.clik.data.DataProvider;
    import flash.events.Event;
    import scaleform.clik.events.ButtonEvent;
    import scaleform.clik.events.InputEvent;
    import flash.utils.getDefinitionByName;
    import scaleform.clik.events.IndexEvent;
    import scaleform.clik.constants.InvalidationType;
    import scaleform.clik.ui.InputDetails;
    import scaleform.clik.constants.InputValue;
    import scaleform.clik.constants.NavigationCode;
    import net.wg.utils.IEventCollector;
    import flash.display.DisplayObject;
    import net.wg.infrastructure.interfaces.entity.IDisposable;
    import flash.text.TextFieldAutoSize;
    import scaleform.clik.events.ButtonBarEvent;
    
    public class ButtonBar extends UIComponent
    {
        
        public function ButtonBar() {
            super();
        }
        
        public static var DIRECTION_HORIZONTAL:String = "horizontal";
        
        public static var DIRECTION_VERTICAL:String = "vertical";
        
        protected var _autoSize:String = "none";
        
        protected var _buttonWidth:Number = 0;
        
        protected var _dataProvider:IDataProvider;
        
        protected var _direction:String = "horizontal";
        
        protected var _group:ButtonGroup;
        
        protected var _itemRenderer:String = "Button";
        
        protected var _itemRendererClass:Class;
        
        protected var _labelField:String = "label";
        
        protected var _labelFunction:Function;
        
        protected var _renderers:Array;
        
        protected var _spacing:Number = 0;
        
        protected var _selectedIndex:Number = -1;
        
        public var container:MovieClip;
        
        override protected function initialize() : void {
            super.initialize();
            this.dataProvider = new DataProvider();
            this._renderers = [];
        }
        
        override protected function onDispose() : void {
            if(this._dataProvider)
            {
                this._dataProvider.cleanUp();
                this._dataProvider.removeEventListener(Event.CHANGE,this.handleDataChange,false);
                this._dataProvider = null;
            }
            if(this._group)
            {
                this._group.removeEventListener(ButtonEvent.CLICK,this.handleButtonGroupChange,false);
                this._group = null;
            }
            removeEventListener(InputEvent.INPUT,this.handleInput,false);
            super.onDispose();
        }
        
        override public function get enabled() : Boolean {
            return super.enabled;
        }
        
        override public function set enabled(param1:Boolean) : void {
            if(this.enabled == param1)
            {
                return;
            }
            super.enabled = param1;
            var _loc2_:Number = 0;
            while(_loc2_ < this._renderers.length)
            {
                if(this._itemRendererClass)
                {
                    (this._renderers[_loc2_] as this._itemRendererClass).enabled = param1;
                }
                else
                {
                    (this._renderers[_loc2_] as UIComponent).enabled = param1;
                }
                _loc2_++;
            }
        }
        
        override public function get focusable() : Boolean {
            return _focusable;
        }
        
        override public function set focusable(param1:Boolean) : void {
            super.focusable = param1;
        }
        
        public function get dataProvider() : IDataProvider {
            return this._dataProvider;
        }
        
        public function set dataProvider(param1:IDataProvider) : void {
            if(this._dataProvider == param1)
            {
                return;
            }
            if(this._dataProvider != null)
            {
                this._dataProvider.removeEventListener(Event.CHANGE,this.handleDataChange,false);
            }
            this._dataProvider = param1;
            if(this._dataProvider == null)
            {
                return;
            }
            this._dataProvider.addEventListener(Event.CHANGE,this.handleDataChange,false,0,true);
            invalidateData();
        }
        
        public function set itemRendererName(param1:String) : void {
            var classRef:Class = null;
            var value:String = param1;
            if((_inspector) && value == "Button" || value == "")
            {
                return;
            }
            try
            {
                classRef = getDefinitionByName(value) as Class;
            }
            catch(error:*)
            {
                throw new Error("The class " + value + " cannot be found in your library. Please ensure it exists.");
            }
            if(classRef != null)
            {
                this._itemRendererClass = classRef;
                invalidate();
            }
        }
        
        public function get spacing() : Number {
            return this._spacing;
        }
        
        public function set spacing(param1:Number) : void {
            this._spacing = param1;
            this.invalidateSettings();
        }
        
        public function get direction() : String {
            return this._direction;
        }
        
        public function set direction(param1:String) : void {
            this._direction = param1;
            this.invalidateSettings();
        }
        
        public function get autoSize() : String {
            return this._autoSize;
        }
        
        public function set autoSize(param1:String) : void {
            if(param1 == this._autoSize)
            {
                return;
            }
            this._autoSize = param1;
            var _loc2_:Number = 0;
            while(_loc2_ < this._renderers.length)
            {
                (this._renderers[_loc2_] as this._itemRendererClass).autoSize = this._autoSize;
                _loc2_++;
            }
            this.invalidateSettings();
        }
        
        public function get buttonWidth() : Number {
            return this._buttonWidth;
        }
        
        public function set buttonWidth(param1:Number) : void {
            this._buttonWidth = param1;
            invalidate();
        }
        
        public function get selectedIndex() : int {
            return this._selectedIndex;
        }
        
        public function set selectedIndex(param1:int) : void {
            if(param1 == this._selectedIndex)
            {
                return;
            }
            var _loc2_:int = this._selectedIndex;
            var _loc3_:Button = this._renderers[_loc2_] as Button;
            if(_loc3_)
            {
                _loc3_.selected = false;
            }
            this._selectedIndex = param1;
            _loc3_ = this._renderers[this._selectedIndex] as Button;
            if(_loc3_)
            {
                _loc3_.selected = true;
            }
            dispatchEvent(new IndexEvent(IndexEvent.INDEX_CHANGE,true,true,this._selectedIndex,_loc2_,this._dataProvider[this._selectedIndex]));
        }
        
        public function get selectedItem() : Object {
            return this._dataProvider.requestItemAt(this._selectedIndex);
        }
        
        public function get data() : Object {
            return this.selectedItem.data;
        }
        
        public function get labelField() : String {
            return this._labelField;
        }
        
        public function set labelField(param1:String) : void {
            this._labelField = param1;
            invalidateData();
        }
        
        public function get labelFunction() : Function {
            return this._labelFunction;
        }
        
        public function set labelFunction(param1:Function) : void {
            this._labelFunction = param1;
            invalidateData();
        }
        
        public function invalidateSettings() : void {
            invalidate(InvalidationType.SETTINGS);
        }
        
        public function itemToLabel(param1:Object) : String {
            if(param1 == null)
            {
                return "";
            }
            if(this._labelFunction != null)
            {
                return this._labelFunction(param1);
            }
            if(param1 is String)
            {
                return param1 as String;
            }
            if(!(this._labelField == null) && !(param1[this._labelField] == null))
            {
                return param1[this._labelField];
            }
            return param1.toString();
        }
        
        public function getButtonAt(param1:int) : Button {
            if(param1 >= 0 && param1 < this._renderers.length)
            {
                return this._renderers[param1];
            }
            return null;
        }
        
        override public function handleInput(param1:InputEvent) : void {
            var _loc6_:* = NaN;
            if(param1.handled)
            {
                return;
            }
            var _loc2_:Button = this._renderers[this._selectedIndex] as Button;
            if(_loc2_ != null)
            {
                _loc2_.handleInput(param1);
                if(param1.handled)
                {
                    return;
                }
            }
            var _loc3_:InputDetails = param1.details;
            var _loc4_:Boolean = _loc3_.value == InputValue.KEY_DOWN || _loc3_.value == InputValue.KEY_HOLD;
            if(!_loc4_)
            {
                return;
            }
            var _loc5_:* = false;
            switch(_loc3_.navEquivalent)
            {
                case NavigationCode.LEFT:
                    if(this._direction == DIRECTION_HORIZONTAL)
                    {
                        _loc6_ = this._selectedIndex - 1;
                        _loc5_ = true;
                    }
                    break;
                case NavigationCode.RIGHT:
                    if(this._direction == DIRECTION_HORIZONTAL)
                    {
                        _loc6_ = this._selectedIndex + 1;
                        _loc5_ = true;
                    }
                    break;
                case NavigationCode.UP:
                    if(this._direction == DIRECTION_VERTICAL)
                    {
                        _loc6_ = this._selectedIndex - 1;
                        _loc5_ = true;
                    }
                    break;
                case NavigationCode.DOWN:
                    if(this._direction == DIRECTION_VERTICAL)
                    {
                        _loc6_ = this._selectedIndex + 1;
                        _loc5_ = true;
                    }
                    break;
            }
            if(_loc5_)
            {
                _loc6_ = Math.max(0,Math.min(this._dataProvider.length - 1,_loc6_));
                if(_loc6_ != this._selectedIndex)
                {
                    this.selectedIndex = _loc6_;
                    param1.handled = true;
                }
            }
        }
        
        override public function toString() : String {
            return "[CLIK ButtonBar " + name + "]";
        }
        
        override protected function configUI() : void {
            super.configUI();
            tabEnabled = (_focusable) && (this.enabled);
            if(this._group == null)
            {
                this._group = new ButtonGroup(name + "Group",this);
            }
            this._group.addEventListener(ButtonEvent.CLICK,this.handleButtonGroupChange,false,0,true);
            if(this.container == null)
            {
                this.container = new MovieClip();
                addChild(this.container);
            }
            addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
        }
        
        override protected function draw() : void {
            var _loc1_:IEventCollector = null;
            if((isInvalid(InvalidationType.RENDERERS)) || (isInvalid(InvalidationType.DATA)) || (isInvalid(InvalidationType.SETTINGS)) || (isInvalid(InvalidationType.SIZE)))
            {
                _loc1_ = App.utils.events;
                _loc1_.disableDisposingForObj(this.container);
                removeChild(this.container);
                setActualSize(_width,_height);
                this.container.scaleX = 1 / scaleX;
                this.container.scaleY = 1 / scaleY;
                addChild(this.container);
                _loc1_.enableDisposingForObj(this.container);
                this.updateRenderers();
            }
        }
        
        protected function refreshData() : void {
            this.selectedIndex = Math.min(this._dataProvider.length - 1,this._selectedIndex);
            if(this._dataProvider)
            {
                this._dataProvider.requestItemRange(0,this._dataProvider.length - 1,this.populateData);
            }
        }
        
        protected function updateRenderers() : void {
            var _loc5_:* = 0;
            var _loc6_:DisplayObject = null;
            var _loc7_:Button = null;
            var _loc8_:* = false;
            var _loc9_:* = 0;
            var _loc10_:Button = null;
            var _loc1_:Number = 0;
            var _loc2_:Number = 0;
            var _loc3_:* = -1;
            if(this._renderers[0] is this._itemRendererClass)
            {
                while(this._renderers.length > this._dataProvider.length)
                {
                    _loc5_ = this._renderers.length - 1;
                    if(this.container.contains(this._renderers[_loc5_]))
                    {
                        if(this._renderers[_loc5_] is IDisposable)
                        {
                            IDisposable(this._renderers[_loc5_]).dispose();
                        }
                        this.container.removeChild(this._renderers[_loc5_]);
                    }
                    this._renderers.splice(_loc5_--,1);
                }
            }
            else
            {
                while(this.container.numChildren > 0)
                {
                    _loc6_ = this.container.removeChildAt(0);
                    if(_loc6_ is IDisposable)
                    {
                        IDisposable(_loc6_).dispose();
                    }
                }
                this._renderers.length = 0;
            }
            var _loc4_:uint = 0;
            while(_loc4_ < this._dataProvider.length && _loc3_ == -1)
            {
                _loc8_ = false;
                if(_loc4_ < this._renderers.length)
                {
                    _loc7_ = this._renderers[_loc4_];
                }
                else
                {
                    _loc7_ = new this._itemRendererClass();
                    this.setupRenderer(_loc7_,_loc4_);
                    _loc8_ = true;
                }
                this.populateRendererData(_loc7_,_loc4_);
                if(this._autoSize == TextFieldAutoSize.NONE && this._buttonWidth > 0)
                {
                    _loc7_.width = this._buttonWidth;
                }
                else if(this._autoSize != TextFieldAutoSize.NONE)
                {
                    _loc7_.autoSize = this._autoSize;
                }
                
                _loc7_.validateNow();
                if(this._direction == DIRECTION_HORIZONTAL)
                {
                    if(Math.round(_width) >= Math.round(_loc7_.width + this._spacing + _loc1_))
                    {
                        _loc7_.y = 0;
                        _loc7_.x = _loc1_;
                        _loc1_ = _loc1_ + (_loc7_.width + this._spacing);
                    }
                    else
                    {
                        _loc3_ = _loc4_;
                        _loc7_ = null;
                    }
                }
                else if(_height > _loc7_.height + this._spacing + _loc2_)
                {
                    _loc7_.x = 0;
                    _loc7_.y = _loc2_;
                    _loc2_ = _loc2_ + (_loc7_.height + this._spacing);
                }
                else
                {
                    _loc3_ = _loc4_;
                    _loc7_ = null;
                }
                
                if((_loc8_) && !(_loc7_ == null))
                {
                    _loc7_.group = this._group;
                    this.container.addChild(_loc7_);
                    this._renderers.push(_loc7_);
                }
                _loc4_++;
            }
            if(_loc3_ > -1)
            {
                _loc9_ = this._renderers.length - 1;
                while(_loc9_ >= _loc3_)
                {
                    _loc10_ = this._renderers[_loc9_];
                    if(_loc10_)
                    {
                        if(this.container.contains(_loc10_))
                        {
                            this.container.removeChild(_loc10_);
                        }
                        this._renderers.splice(_loc9_,1);
                    }
                    _loc9_--;
                }
            }
            this.selectedIndex = Math.min(this._dataProvider.length - 1,this._selectedIndex);
        }
        
        protected function populateData(param1:Array) : void {
            var _loc3_:Button = null;
            var _loc2_:uint = 0;
            while(_loc2_ < this._renderers.length)
            {
                _loc3_ = this._renderers[_loc2_] as Button;
                this.populateRendererData(_loc3_,_loc2_);
                _loc3_.validateNow();
                _loc2_++;
            }
        }
        
        protected function populateRendererData(param1:Button, param2:uint) : void {
            param1.label = this.itemToLabel(this._dataProvider.requestItemAt(param2));
            param1.data = this._dataProvider.requestItemAt(param2);
            param1.selected = param2 == this.selectedIndex;
        }
        
        protected function setupRenderer(param1:Button, param2:uint) : void {
            param1.owner = this;
            param1.focusable = false;
            param1.focusTarget = this;
            param1.toggle = true;
            param1.allowDeselect = false;
        }
        
        protected function handleButtonGroupChange(param1:Event) : void {
            if(this._group.selectedIndex != this.selectedIndex)
            {
                this.selectedIndex = this._group.selectedIndex;
                dispatchEvent(new ButtonBarEvent(ButtonBarEvent.BUTTON_SELECT,false,true,this._selectedIndex,param1.target as Button));
            }
        }
        
        protected function handleDataChange(param1:Event) : void {
            invalidate(InvalidationType.DATA);
        }
        
        override protected function changeFocus() : void {
            var _loc1_:Button = this._renderers[this._selectedIndex] as Button;
            if(_loc1_ == null)
            {
                return;
            }
            _loc1_.displayFocus = _focused > 0;
        }
    }
}
