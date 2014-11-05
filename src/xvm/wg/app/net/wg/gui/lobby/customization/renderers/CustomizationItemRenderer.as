package net.wg.gui.lobby.customization.renderers
{
    import net.wg.gui.components.controls.SoundListItemRenderer;
    import flash.display.MovieClip;
    import net.wg.gui.components.controls.UILoaderAlt;
    import net.wg.gui.components.controls.ActionPrice;
    import net.wg.gui.components.controls.IconText;
    import flash.display.Sprite;
    import flash.text.TextField;
    import net.wg.gui.components.controls.VO.ActionPriceVO;
    import flash.events.MouseEvent;
    import scaleform.clik.events.InputEvent;
    import net.wg.gui.events.UILoaderEvent;
    import scaleform.clik.constants.InvalidationType;
    import net.wg.data.constants.IconsTypes;
    import flash.geom.Point;
    import net.wg.infrastructure.managers.ITooltipMgr;
    import net.wg.data.constants.Tooltips;
    import flash.events.Event;
    import net.wg.data.constants.SoundTypes;
    
    public class CustomizationItemRenderer extends SoundListItemRenderer
    {
        
        public function CustomizationItemRenderer()
        {
            super();
            soundType = SoundTypes.CUSTOMIZATION_ITEM_RENDERER;
        }
        
        public static var DEMO_OFF:String = "off";
        
        public static var DEMO_NEW:String = "new";
        
        public static var DEMO_CURRENT:String = "current";
        
        public var newMarker:MovieClip;
        
        public var uiLoader:UILoaderAlt;
        
        public var actionPrice:ActionPrice;
        
        public var costField:IconText;
        
        public var costFrame:MovieClip;
        
        public var border:RendererBorder;
        
        public var hitMc:Sprite;
        
        public var targetIcon:MovieClip;
        
        public var freeTF:TextField;
        
        public var disabledMc:Sprite;
        
        protected var isNew:Boolean = false;
        
        protected var isGold:Boolean = false;
        
        protected var costVal:String = "";
        
        protected var priceVal:Number = 0;
        
        protected var prefixesVector:Vector.<String> = null;
        
        private var costVisible:Boolean = false;
        
        private var actionPriceVo:ActionPriceVO = null;
        
        private var _current:Boolean = false;
        
        private var _isMouseOver:Boolean = false;
        
        private var _demoMode:String = "off";
        
        private var _useHandCursorForce:Boolean = false;
        
        protected var _costFrameX:int;
        
        protected var _costFrameW:int;
        
        protected var _freeTfX:int;
        
        protected var _freeTfW:int;
        
        override public function setData(param1:Object) : void
        {
            var _loc2_:Boolean = this.isNew;
            data = param1;
            if(data)
            {
                if(data.current != this.current)
                {
                    this.current = data.current;
                }
                this.costVisible = this.demoMode == CustomizationItemRenderer.DEMO_NEW && data.id > 0 && !data.isInHangar || this.demoMode == CustomizationItemRenderer.DEMO_OFF && !((data.current) || (data.isInHangar));
                if(data.price)
                {
                    this.costVal = data.price.isGold?App.utils.locale.gold(data.price.cost):App.utils.locale.integer(data.price.cost);
                    this.priceVal = data.price.cost;
                    this.isGold = data.price.isGold;
                }
                if(data.action)
                {
                    this.actionPriceVo = new ActionPriceVO(data.action);
                }
                _loc2_ = data.isNew;
                if(this.uiLoader)
                {
                    this.loadTexture(data.texturePath);
                }
            }
            if(_loc2_ != this.isNew)
            {
                this.showIsNew(_loc2_);
            }
            invalidateData();
        }
        
        override protected function onDispose() : void
        {
            super.onDispose();
            removeEventListener(MouseEvent.ROLL_OVER,this.showTooltip);
            removeEventListener(MouseEvent.ROLL_OUT,this.hideTooltip);
            removeEventListener(MouseEvent.ROLL_OVER,handleMouseRollOver);
            removeEventListener(MouseEvent.ROLL_OUT,handleMouseRollOut);
            removeEventListener(MouseEvent.MOUSE_DOWN,handleMousePress);
            removeEventListener(MouseEvent.CLICK,handleMouseRelease);
            removeEventListener(MouseEvent.DOUBLE_CLICK,handleMouseRelease);
            removeEventListener(InputEvent.INPUT,handleInput);
            this.uiLoader.dispose();
            this.uiLoader.removeEventListener(UILoaderEvent.COMPLETE,this.onImageLoadComplete);
            this.uiLoader = null;
            if((this.newMarker) && (contains(this.newMarker)))
            {
                removeChild(this.newMarker);
                this.newMarker = null;
            }
            if(this.actionPrice)
            {
                this.actionPrice.dispose();
                this.actionPrice = null;
            }
            if(this.actionPriceVo != null)
            {
                this.actionPriceVo.dispose();
                this.actionPriceVo = null;
            }
            this.costField.dispose();
            this.costField = null;
            this.disabledMc = null;
            this.costFrame = null;
            this.border = null;
            this.hitMc = null;
            this.targetIcon = null;
            this.freeTF = null;
            this.prefixesVector = null;
            data = null;
        }
        
        override public function set enabled(param1:Boolean) : void
        {
            super.enabled = param1;
            mouseChildren = true;
        }
        
        public function get current() : Boolean
        {
            return this._current;
        }
        
        public function set current(param1:Boolean) : void
        {
            if(this._current == param1)
            {
                return;
            }
            this._current = param1;
            setState(state);
        }
        
        public function get demoMode() : String
        {
            return this._demoMode;
        }
        
        public function set demoMode(param1:String) : void
        {
            if(this._demoMode == param1)
            {
                return;
            }
            this._demoMode = param1;
            var _loc2_:Boolean = (this._useHandCursorForce) || this._demoMode == DEMO_OFF;
            super.enabled = _loc2_;
            useHandCursor = _loc2_;
            setState(state);
        }
        
        public function get useHandCursorForce() : Boolean
        {
            return this._useHandCursorForce;
        }
        
        public function set useHandCursorForce(param1:Boolean) : void
        {
            this._useHandCursorForce = param1;
        }
        
        override protected function configUI() : void
        {
            super.configUI();
            this._costFrameX = this.costFrame.x;
            this._costFrameW = this.costFrame.width;
            this._freeTfX = this.freeTF.x;
            this._freeTfW = this.freeTF.width;
            var _loc1_:Boolean = (this._useHandCursorForce) || this._demoMode == DEMO_OFF;
            super.enabled = _loc1_;
            useHandCursor = _loc1_;
            this.uiLoader.addEventListener(UILoaderEvent.COMPLETE,this.onImageLoadComplete);
            addEventListener(MouseEvent.ROLL_OVER,this.showTooltip);
            addEventListener(MouseEvent.ROLL_OUT,this.hideTooltip);
            if(data)
            {
                this.loadTexture(data.texturePath);
            }
            if(this.freeTF)
            {
                this.freeTF.text = VEHICLE_CUSTOMIZATION.IGR_FREE_FULL;
            }
            if(this.hitMc)
            {
                this.hitArea = this.hitMc;
            }
            if(this.actionPrice)
            {
                this.actionPrice.setup(this);
            }
        }
        
        override protected function draw() : void
        {
            var _loc1_:* = false;
            var _loc2_:* = false;
            super.draw();
            if(isInvalid(InvalidationType.DATA))
            {
                this.visible = !(this.data == null);
                if(this.data)
                {
                    visible = true;
                    _loc1_ = (this.freeTF) && data.id > 0 && (data.price) && data.price.cost == 0;
                    _loc2_ = ((data.current) || (data.isInHangar)) && this.demoMode == CustomizationItemRenderer.DEMO_OFF;
                    this.costFrame.visible = (this.costVisible) || (_loc2_);
                    this.updateCostPos();
                    if(this.actionPrice)
                    {
                        if((this.actionPriceVo) && (this.costVisible))
                        {
                            this.actionPriceVo.ico = this.isGold?IconsTypes.GOLD:IconsTypes.CREDITS;
                            this.actionPrice.setData(this.actionPriceVo);
                        }
                        else
                        {
                            this.actionPrice.visible = false;
                        }
                        this.costField.visible = (this.costVisible) && !_loc1_ && !this.actionPrice.visible;
                    }
                    else
                    {
                        this.costField.visible = (this.costVisible) && !_loc1_;
                    }
                    if((_loc1_) || (_loc2_))
                    {
                        this.freeTF.visible = (this.costVisible) || (_loc2_);
                        if(_loc2_)
                        {
                            this.freeTF.x = 0;
                            this.freeTF.width = this._freeTfW + this._freeTfX;
                            if(data.hasOwnProperty("timeLeftStr"))
                            {
                                this.freeTF.text = data.timeLeftStr;
                            }
                            else
                            {
                                this.freeTF.text = this.demoMode == CustomizationItemRenderer.DEMO_OFF?"∞":"";
                            }
                        }
                        else
                        {
                            this.freeTF.x = this._freeTfX;
                            this.freeTF.width = this._freeTfW;
                            this.freeTF.text = VEHICLE_CUSTOMIZATION.IGR_FREE_FULL;
                        }
                        if(this.actionPrice)
                        {
                            this.actionPrice.visible = false;
                        }
                    }
                    else
                    {
                        if(this.freeTF)
                        {
                            this.freeTF.visible = false;
                        }
                        this.costField.text = this.costVal;
                        this.costField.icon = this.isGold?IconsTypes.GOLD:IconsTypes.CREDITS;
                    }
                    if(this.targetIcon)
                    {
                        this.targetIcon.visible = !(this.demoMode == DEMO_CURRENT) && ((data.current) || (data.isInHangar));
                        if(this.targetIcon.visible)
                        {
                            this.targetIcon.gotoAndStop(data.current?"current":"hangar");
                        }
                    }
                    if(this.disabledMc)
                    {
                        if((data.hasOwnProperty("canUse")) && !data.canUse)
                        {
                            this.disabledMc.visible = true;
                            this.uiLoader.alpha = 0.4;
                        }
                        else
                        {
                            this.disabledMc.visible = false;
                            this.uiLoader.alpha = 1;
                        }
                    }
                    this.checkTooltip();
                }
                else
                {
                    visible = false;
                }
            }
        }
        
        protected function updateCostPos() : void
        {
            if((data) && ((data.current) || (data.isInHangar)))
            {
                this.costFrame.x = 0;
                this.costFrame.width = this._costFrameW + this._costFrameX;
            }
            else
            {
                this.costFrame.x = this._costFrameX;
                this.costFrame.width = this._costFrameW;
            }
        }
        
        override protected function getStatePrefixes() : Vector.<String>
        {
            if(this.prefixesVector)
            {
                this.prefixesVector.splice(0,this.prefixesVector.length);
            }
            else
            {
                this.prefixesVector = new Vector.<String>();
            }
            if((enabled) && (this._current))
            {
                this.prefixesVector.push("current_");
            }
            else if((enabled) && (_selected))
            {
                this.prefixesVector.push("selected_");
            }
            else
            {
                this.prefixesVector.push("");
            }
            
            return this.prefixesVector;
        }
        
        protected function checkTooltip() : void
        {
            if(this.demoMode == DEMO_NEW || this.demoMode == DEMO_CURRENT)
            {
                return;
            }
            var _loc1_:Point = new Point(mouseX,mouseY);
            _loc1_ = this.localToGlobal(_loc1_);
            if((this.hitTestPoint(_loc1_.x,_loc1_.y,true)) && (this._isMouseOver))
            {
                this.showTooltip();
            }
        }
        
        protected function showIsNew(param1:Boolean) : void
        {
            this.isNew = param1;
            if((param1) && this.demoMode == DEMO_OFF)
            {
                if(!this.newMarker)
                {
                    this.newMarker = App.utils.classFactory.getObject("NewMarker") as MovieClip;
                    this.newMarker.x = 1;
                    this.newMarker.y = 2;
                    addChild(this.newMarker);
                }
                this.newMarker.visible = param1;
            }
            else if(this.newMarker)
            {
                this.newMarker.visible = param1;
            }
            
        }
        
        private function loadTexture(param1:String) : void
        {
            if(!(param1 == null) && !(param1.length == 0))
            {
                this.uiLoader.source = param1;
            }
            else
            {
                this.uiLoader.unload();
            }
        }
        
        private function get toolTipMgr() : ITooltipMgr
        {
            return App.toolTipMgr;
        }
        
        private function showTooltip(param1:MouseEvent = null) : void
        {
            this._isMouseOver = true;
            if(data)
            {
                if(data.isSpecialTooltip)
                {
                    this.toolTipMgr.showSpecial(Tooltips.CUSTOMIZATION_ITEM,null,data.type,data.id,data.nationId);
                }
                else if(data.description.length > 0)
                {
                    this.toolTipMgr.showComplex(data.description);
                }
                
            }
        }
        
        private function hideTooltip(param1:MouseEvent = null) : void
        {
            this._isMouseOver = false;
            this.toolTipMgr.hide();
        }
        
        protected function onImageLoadComplete(param1:Event) : void
        {
            invalidateSize();
            validateNow();
        }
    }
}
