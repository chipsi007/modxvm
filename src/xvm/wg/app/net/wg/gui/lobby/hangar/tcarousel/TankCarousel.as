package net.wg.gui.lobby.hangar.tcarousel
{
    import net.wg.infrastructure.base.meta.impl.TankCarouselMeta;
    import net.wg.infrastructure.base.meta.ITankCarouselMeta;
    import net.wg.infrastructure.interfaces.IDAAPIModule;
    import net.wg.gui.interfaces.IHelpLayoutComponent;
    import flash.display.MovieClip;
    import net.wg.gui.components.controls.SoundButton;
    import net.wg.gui.components.controls.DropDownImageText;
    import net.wg.gui.components.controls.CheckBox;
    import net.wg.gui.components.controls.VO.ActionPriceVO;
    import scaleform.clik.interfaces.IListItemRenderer;
    import net.wg.gui.lobby.hangar.tcarousel.helper.VehicleCarouselVOManager;
    import flash.display.DisplayObject;
    import scaleform.clik.events.ListEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.DisplayObjectContainer;
    import net.wg.gui.lobby.hangar.tcarousel.data.VehicleCarouselVO;
    import scaleform.clik.constants.InvalidationType;
    import flash.geom.Rectangle;
    import net.wg.utils.IHelpLayout;
    import net.wg.data.constants.Directions;
    import net.wg.gui.events.ListEventEx;
    import net.wg.data.constants.Tooltips;
    import scaleform.clik.events.ButtonEvent;
    import net.wg.gui.lobby.hangar.tcarousel.helper.VehicleCarouselVOBuilder;
    import scaleform.clik.data.DataProvider;
    import net.wg.utils.INations;
    import net.wg.data.daapi.ContextMenuVehicleVo;
    import net.wg.data.components.VehicleContextMenuGenerator;
    import scaleform.clik.data.ListData;
    
    public class TankCarousel extends TankCarouselMeta implements ITankCarouselMeta, IDAAPIModule, IHelpLayoutComponent
    {
        
        public function TankCarousel()
        {
            this.filterData = {};
            super();
            dragHitArea = this.dragHitArea1;
            if(leftArrow)
            {
                leftArrow.dispose();
            }
            leftArrow = this.leftArrow1;
            if(rightArrow)
            {
                rightArrow.dispose();
            }
            rightArrow = this.rightArrow1;
            if(renderersMask)
            {
                renderersMask.dispose();
            }
            renderersMask = this.renderersMask1;
            this.nationFilter = this.vehicleFilters.nationFilter;
            this.tankFilter = this.vehicleFilters.tankFilter;
            this.checkBoxToMain = this.vehicleFilters.checkBoxToMain;
            bg = this.bg1;
            this._currentShowByCompactDescription = [];
        }
        
        public static var FILTERS_CAROUSEL_OFFSET:Number = 15;
        
        public static var VO_VEHICLES_IS_INVALID:String = "vo_vehicles_is_invalid";
        
        public var vehicleFilters:TankCarouselFilters;
        
        public var dragHitArea1:MovieClip;
        
        public var leftArrow1:SoundButton;
        
        public var rightArrow1:SoundButton;
        
        public var renderersMask1:MovieClip;
        
        public var bg1:MovieClip;
        
        private var _isDAAPIInited:Boolean = false;
        
        private var filterData:Object;
        
        private var filterDataInvalid:Boolean = false;
        
        private var nationFilter:net.wg.gui.components.controls.DropDownImageText;
        
        private var tankFilter:net.wg.gui.components.controls.DropDownImageText;
        
        private var checkBoxToMain:CheckBox;
        
        private var _slotPrice:Number = 0;
        
        private var _slotPriceActionData:ActionPriceVO = null;
        
        private var _selectedVehicleCompactID:Number = -1;
        
        private var _availableSlotsForBuyVehicle:Number = 0;
        
        private var _updateShowByCompactDescription:Array = null;
        
        private var _currentShowByCompactDescription:Array = null;
        
        private var _currentShowRendersByIndex:Vector.<IListItemRenderer> = null;
        
        private var _createdRendersListByCompDescr:Object = null;
        
        private var _createdRendersListByCompDescrLength:Number = 0;
        
        private var _vehiclesVOManager:VehicleCarouselVOManager = null;
        
        protected var _slotForBuySlot:IListItemRenderer = null;
        
        protected var _slotForBuyVehicle:IListItemRenderer = null;
        
        private var _updateInProgress:Boolean = false;
        
        private var _rendererHelpLayout:DisplayObject;
        
        private var _filtersHelpLayout:DisplayObject;
        
        private var skipScrollToIndex:Boolean = false;
        
        override public function scrollToIndex(param1:uint) : void
        {
            var _loc2_:uint = 0;
            if((container) && (_renderers))
            {
                _loc2_ = Math.floor(_visibleSlots / 2);
                _loc2_ = _visibleSlots % 2 == 1?_loc2_:_loc2_ - 1;
                currentFirstRenderer = Math.min(_renderers.length - _visibleSlots,Math.max(0,param1 - _loc2_));
                goToFirstRenderer();
            }
        }
        
        public function as_isDAAPIInited() : Boolean
        {
            return this._isDAAPIInited;
        }
        
        public function get isDAAPIInited() : Boolean
        {
            return this._isDAAPIInited;
        }
        
        public function as_populate() : void
        {
            this._isDAAPIInited = true;
        }
        
        public function as_dispose() : void
        {
            var _loc1_:String = null;
            this.tankFilter.removeEventListener(ListEvent.INDEX_CHANGE,this.onVehicleTypeFilterChanged);
            this.checkBoxToMain.removeEventListener(Event.SELECT,this.onFilterCheckBoxChanged);
            this.nationFilter.removeEventListener(ListEvent.INDEX_CHANGE,this.onNationFilterChanged);
            leftArrow.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel);
            rightArrow.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel);
            App.contextMenuMgr.hide();
            this.vehicleFilters.dispose();
            this.vehicleFilters = null;
            this.dragHitArea1 = null;
            this.leftArrow1 = null;
            this.rightArrow1 = null;
            this.renderersMask1 = null;
            this.bg1 = null;
            for(_loc1_ in this.filterData)
            {
                delete this.filterData[_loc1_];
                true;
            }
            this.filterData = null;
            this.nationFilter = null;
            this.tankFilter = null;
            this.checkBoxToMain = null;
            this._rendererHelpLayout = null;
            this._filtersHelpLayout = null;
            this._vehiclesVOManager.clear();
            this._vehiclesVOManager = null;
            this.removeEmptySlots();
            if(this._slotForBuySlot)
            {
                this.cleanUpRenderer(this._slotForBuySlot);
                this._slotForBuySlot = null;
            }
            if(this._slotForBuyVehicle)
            {
                this.cleanUpRenderer(this._slotForBuyVehicle);
                this._slotForBuyVehicle = null;
            }
            this.clearArrays(true);
            var _loc2_:DisplayObjectContainer = container;
            super.onDispose();
            App.utils.asserter.assert(_loc2_.numChildren == 0,"container is not empty after dispose!");
        }
        
        override protected function cleanUpRenderer(param1:IListItemRenderer) : void
        {
            var _loc2_:Number = _renderers.indexOf(param1);
            if(_loc2_ != -1)
            {
                _renderers.splice(_loc2_,1);
            }
            if(container.contains(DisplayObject(param1)))
            {
                container.removeChild(DisplayObject(param1));
            }
            super.cleanUpRenderer(param1);
        }
        
        public function as_setCarouselFilter(param1:Object) : void
        {
            this.filterData = param1;
            this.filterDataInvalid = true;
            this.updateFiltersData();
        }
        
        public function as_setParams(param1:Object) : void
        {
            var _loc5_:IListItemRenderer = null;
            var _loc6_:VehicleCarouselVO = null;
            var _loc7_:DisplayObject = null;
            this._slotPrice = param1.slotPrice is Array?param1.slotPrice[0] > 0?param1.slotPrice[0]:param1.slotPrice[1]:param1.slotPrice;
            var _loc2_:Object = (param1.hasOwnProperty("slotPriceActionData")) && !(param1.slotPriceActionData == undefined)?param1.slotPriceActionData:null;
            if(_loc2_)
            {
                this._slotPriceActionData = new ActionPriceVO(_loc2_);
            }
            this._selectedVehicleCompactID = param1.selectedTankID;
            var _loc3_:Number = param1.freeSlots;
            if(this._slotForBuySlot != null)
            {
                this.updateSlotForBuySlot(true);
            }
            var _loc4_:* = !(_loc3_ == this._availableSlotsForBuyVehicle);
            if(this._slotForBuyVehicle != null)
            {
                this._availableSlotsForBuyVehicle = _loc3_;
                _totalRenderers = this._availableSlotsForBuyVehicle > 0?this._currentShowRendersByIndex.length + 2:this._currentShowRendersByIndex.length + 1;
                if((_loc4_) || this._availableSlotsForBuyVehicle <= 0)
                {
                    this.removeEmptySlots();
                    _loc5_ = getRendererAt(_renderers.length - 1,0);
                    _loc6_ = (_loc5_ as TankCarouselItemRenderer).dataVO;
                    if(_loc6_.buySlot)
                    {
                        _renderers.splice(_renderers.length - 1,1);
                    }
                    _loc5_ = getRendererAt(_renderers.length - 1,0);
                    _loc6_ = (_loc5_ as TankCarouselItemRenderer).dataVO;
                    if(this._availableSlotsForBuyVehicle <= 0)
                    {
                        if(_loc6_.buyTank)
                        {
                            _renderers.splice(_renderers.length - 1,1);
                            _loc5_.x = 0;
                            _loc7_ = _loc5_ as DisplayObject;
                            _loc7_.visible = false;
                        }
                    }
                    else
                    {
                        if(!_loc6_.buyTank)
                        {
                            this._slotForBuyVehicle.x = padding.horizontal + _renderers.length * slotWidth;
                            _renderers.push(this._slotForBuyVehicle);
                        }
                        _loc7_ = this._slotForBuyVehicle as DisplayObject;
                        _loc7_.visible = true;
                        this.updateSlotForBuyVehicle(true);
                    }
                    this._slotForBuySlot.x = padding.horizontal + _renderers.length * slotWidth;
                    _renderers.push(this._slotForBuySlot);
                    this.addEmptySlots();
                    invalidateSize();
                }
                else
                {
                    this.updateSlotForBuyVehicle(this._availableSlotsForBuyVehicle > 0);
                }
            }
            else
            {
                this._availableSlotsForBuyVehicle = _loc3_;
                if(!_renderers)
                {
                    return;
                }
                this.removeEmptySlots();
                this.removeAdvancedSlots();
                this.addAdvancedSlots();
                this.addEmptySlots();
                invalidateSize();
            }
            if(this._currentShowByCompactDescription)
            {
                this.selectedIndex = this._currentShowByCompactDescription.indexOf(this._selectedVehicleCompactID);
                if(!this.skipScrollToIndex)
                {
                    this.scrollToIndex(this.selectedIndex);
                }
                this.skipScrollToIndex = false;
            }
            if(this._createdRendersListByCompDescr)
            {
                _loc5_ = this._createdRendersListByCompDescr[this._selectedVehicleCompactID] as IListItemRenderer;
                if(_loc5_)
                {
                    _loc5_.selected = true;
                    selectedItemRenderer = _loc5_;
                }
            }
        }
        
        public function as_updateVehicles(param1:Object, param2:Boolean) : void
        {
            this._updateInProgress = true;
            if(!this._vehiclesVOManager)
            {
                this._vehiclesVOManager = new VehicleCarouselVOManager();
            }
            if(param2)
            {
                this._vehiclesVOManager.setData(param1);
            }
            else
            {
                this._vehiclesVOManager.updateData(param1);
            }
            invalidate(VO_VEHICLES_IS_INVALID);
        }
        
        public function as_showVehicles(param1:Array) : void
        {
            this._updateShowByCompactDescription = param1;
            if(!this._updateInProgress)
            {
                invalidate(InvalidationType.RENDERERS);
            }
        }
        
        public function showHelpLayout() : void
        {
            var _loc2_:Rectangle = null;
            var _loc3_:Object = null;
            var _loc4_:* = NaN;
            var _loc5_:Rectangle = null;
            var _loc6_:Object = null;
            var _loc1_:IHelpLayout = App.utils.helpLayout;
            if(container)
            {
                _loc2_ = new Rectangle(leftArrow.x,container.y,rightArrow.x - leftArrow.x,slotImageHeight);
                _loc3_ = _loc1_.getProps(_loc2_,LOBBY_HELP.HANGAR_VEHICLE_CAROUSEL,Directions.RIGHT);
                this._rendererHelpLayout = _loc1_.create(root,_loc3_,this);
            }
            if(this.vehicleFilters.visible)
            {
                _loc4_ = 5;
                _loc5_ = new Rectangle(this.vehicleFilters.x - _loc4_,this.vehicleFilters.y,this.vehicleFilters.width + _loc4_ * 2,slotImageHeight);
                _loc6_ = _loc1_.getProps(_loc5_,LOBBY_HELP.HANGAR_VEHFILTERS,Directions.RIGHT);
                this._filtersHelpLayout = _loc1_.create(root,_loc6_,this);
            }
        }
        
        public function closeHelpLayout() : void
        {
            var _loc1_:IHelpLayout = App.utils.helpLayout;
            if(this._rendererHelpLayout)
            {
                _loc1_.destroy(this._rendererHelpLayout);
                this._rendererHelpLayout = null;
            }
            if(this._filtersHelpLayout)
            {
                _loc1_.destroy(this._filtersHelpLayout);
                this._filtersHelpLayout = null;
            }
        }
        
        public function onFilterChanged() : void
        {
            setVehiclesFilterS(this.filterData.nation,this.filterData.tankType,this.filterData.ready);
        }
        
        override public function get selectedIndex() : int
        {
            return _selectedIndex;
        }
        
        override public function set selectedIndex(param1:int) : void
        {
            var _loc2_:IListItemRenderer = null;
            if(selectedItemRenderer)
            {
                selectedItemRenderer.selected = false;
            }
            if(param1 >= 0)
            {
                _loc2_ = this._currentShowRendersByIndex[param1];
                if(_loc2_)
                {
                    _loc2_.selected = true;
                    selectedItemRenderer = _loc2_;
                }
                else
                {
                    selectedItemRenderer = null;
                }
            }
            else
            {
                selectedItemRenderer = null;
            }
            _selectedIndex = param1;
        }
        
        override public function set enabled(param1:Boolean) : void
        {
            var _loc2_:String = null;
            var _loc3_:IListItemRenderer = null;
            super.enabled = param1;
            if(this._createdRendersListByCompDescr != null)
            {
                for(_loc2_ in this._createdRendersListByCompDescr)
                {
                    _loc3_ = this._createdRendersListByCompDescr[_loc2_];
                    if(_loc3_ != null)
                    {
                        _loc3_.enabled = enabled;
                    }
                }
            }
        }
        
        public function get disposed() : Boolean
        {
            return false;
        }
        
        override protected function configUI() : void
        {
            this.initFilters();
            leftArrow.mouseEnabledOnDisabled = rightArrow.mouseEnabledOnDisabled = true;
            leftArrow.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel,false,0,true);
            rightArrow.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel,false,0,true);
            super.configUI();
        }
        
        override protected function draw() : void
        {
            var _loc1_:* = NaN;
            var _loc2_:* = NaN;
            var _loc3_:* = NaN;
            if(isInvalid(VO_VEHICLES_IS_INVALID))
            {
                this.rebuildRenderers();
                this._vehiclesVOManager.clearAndInitDynamicData();
                this._updateInProgress = false;
            }
            if((isInvalid(InvalidationType.RENDERERS)) && !(this._updateShowByCompactDescription == null))
            {
                clearAllAnimIntervals();
                if(isDragging)
                {
                    clearDragProps();
                }
                _loc1_ = 0;
                _loc2_ = 0;
                _loc3_ = 0;
                _loc1_ = 0;
                while(_loc1_ < this._currentShowByCompactDescription.length)
                {
                    _loc3_ = this._currentShowByCompactDescription[_loc1_];
                    _loc2_ = this._updateShowByCompactDescription.indexOf(_loc3_);
                    if(_loc2_ == -1)
                    {
                        this._currentShowByCompactDescription.splice(_loc1_,1);
                        this.removeRendererFromShowByCompactDescr(_loc3_);
                    }
                    else
                    {
                        _loc1_++;
                    }
                }
                if(!this._currentShowByCompactDescription)
                {
                    this._currentShowByCompactDescription = [];
                }
                if(!this._currentShowRendersByIndex)
                {
                    this._currentShowRendersByIndex = new Vector.<IListItemRenderer>();
                }
                if(!_renderers)
                {
                    _renderers = new Vector.<IListItemRenderer>();
                }
                this.removeEmptySlots();
                this.removeAdvancedSlots();
                this.clearArrays(false);
                _loc1_ = 0;
                while(_loc1_ < this._updateShowByCompactDescription.length)
                {
                    _loc3_ = this._updateShowByCompactDescription[_loc1_];
                    this._currentShowByCompactDescription[_loc1_] = _loc3_;
                    this.insertRendererToShowByNum(_loc1_,_loc3_);
                    _loc1_++;
                }
                while(this._updateShowByCompactDescription.length)
                {
                    this._updateShowByCompactDescription.pop();
                }
                this._updateShowByCompactDescription = null;
                this.showHideFilters();
                this.addAdvancedSlots();
                this.addEmptySlots();
                this.repositionRenderers();
                invalidateSize();
            }
            if(isInvalid(InvalidationType.SIZE))
            {
                this.showHideFilters();
                this.updateEmptySlots();
                updateLayout();
            }
            super.draw();
        }
        
        override protected function initUIStartPosition() : void
        {
            this.vehicleFilters.x = contentMargin;
            this.vehicleFilters.y = contentMargin;
            super.initUIStartPosition();
        }
        
        override protected function updateArrowsState() : void
        {
            super.updateArrowsState();
        }
        
        override protected function setupRenderer(param1:IListItemRenderer) : void
        {
            super.setupRenderer(param1);
        }
        
        override protected function handleMouseWheel(param1:MouseEvent) : void
        {
            if((enabled) && (allowDrag) && !isPreDragging && !(param1.target == bg))
            {
                super.handleMouseWheel(param1);
            }
        }
        
        override protected function onItemRollOver(param1:ListEventEx) : void
        {
            super.onItemRollOver(param1);
            if(isSliding)
            {
                return;
            }
            var _loc2_:VehicleCarouselVO = param1.itemData as VehicleCarouselVO;
            if(_loc2_.empty)
            {
                return;
            }
            if(_loc2_.buyTank)
            {
                App.toolTipMgr.showComplex(TOOLTIPS.TANKS_CAROUSEL_BUY_VEHICLE);
                return;
            }
            if(_loc2_.buySlot)
            {
                App.toolTipMgr.showComplex(TOOLTIPS.TANKS_CAROUSEL_BUY_SLOT);
                return;
            }
            App.toolTipMgr.showSpecial(Tooltips.CAROUSEL_VEHICLE,null,_loc2_.inventoryId);
        }
        
        override protected function onItemRollOut(param1:ListEventEx) : void
        {
            super.onItemRollOut(param1);
            App.toolTipMgr.hide();
        }
        
        override protected function onItemStartDrag(param1:ListEventEx) : void
        {
            App.toolTipMgr.hide();
            super.onItemStartDrag(param1);
        }
        
        override protected function handleItemClick(param1:ButtonEvent) : void
        {
            App.toolTipMgr.hide();
            if(isMoving)
            {
                isMoving = false;
                return;
            }
            var _loc2_:TankCarouselItemRenderer = param1.currentTarget as TankCarouselItemRenderer;
            var _loc3_:VehicleCarouselVO = _loc2_.dataVO;
            var _loc4_:Number = _loc2_.index;
            var _loc5_:uint = (param1 as ButtonEvent).buttonIdx;
            if(isNaN(_loc4_))
            {
                return;
            }
            if(dispatchItemEvent(param1))
            {
                if(((useRightButton) && (useRightButtonForSelect) || _loc5_ == 0) && !_loc3_.buyTank && !_loc3_.buySlot)
                {
                    this.selectedIndex = this._currentShowByCompactDescription.indexOf(_loc3_.compactDescr);
                }
            }
        }
        
        override protected function onItemClick(param1:ListEventEx) : void
        {
            var _loc2_:VehicleCarouselVO = param1.itemData as VehicleCarouselVO;
            if(_loc2_.empty)
            {
                return;
            }
            if((_loc2_.buyTank) && param1.buttonIdx == 0)
            {
                (param1.itemRenderer as MovieClip).mouseEnabled = false;
                (param1.itemRenderer as MovieClip).mouseChildren = false;
                this.tryBuyTank(_loc2_);
                this.skipScrollToIndex = true;
                return;
            }
            if((_loc2_.buySlot) && param1.buttonIdx == 0)
            {
                this.skipScrollToIndex = true;
                this.tryBuySlot(_loc2_);
                return;
            }
            if(param1.buttonIdx == 0)
            {
                this.skipScrollToIndex = true;
                this.selectItem(_loc2_.id);
            }
            else if(param1.buttonIdx == 1 && !_loc2_.buyTank && !_loc2_.buySlot)
            {
                this.showContextMenu(_loc2_.inventoryId);
            }
            
        }
        
        private function updateSlotForBuyVehicle(param1:Boolean) : void
        {
            this.populateRendererData(this._currentShowRendersByIndex.length,this._slotForBuyVehicle,VehicleCarouselVOBuilder.instance.getDataVoForBuyVehicle(this._availableSlotsForBuyVehicle),param1,true);
        }
        
        private function updateSlotForBuySlot(param1:Boolean) : void
        {
            this.populateRendererData(this._currentShowRendersByIndex.length,this._slotForBuySlot,VehicleCarouselVOBuilder.instance.getDataVoForBuySlot(this._slotPrice,this._slotPriceActionData),param1,true);
        }
        
        private function tryBuyTank(param1:VehicleCarouselVO) : void
        {
            buyTankClickS();
        }
        
        private function tryBuySlot(param1:VehicleCarouselVO) : void
        {
            buySlotS();
        }
        
        private function selectItem(param1:Number) : void
        {
            vehicleChangeS(param1.toString());
        }
        
        private function clearArrays(param1:Boolean) : void
        {
            var _loc2_:IListItemRenderer = null;
            var _loc3_:Array = null;
            var _loc4_:String = null;
            var _loc5_:* = NaN;
            if(param1)
            {
                if(this._createdRendersListByCompDescr)
                {
                    _loc3_ = [];
                    for(_loc4_ in this._createdRendersListByCompDescr)
                    {
                        _loc3_.push(_loc4_);
                    }
                    for each(_loc4_ in _loc3_)
                    {
                        _loc2_ = IListItemRenderer(this._createdRendersListByCompDescr[_loc4_]);
                        _loc5_ = this._currentShowRendersByIndex.indexOf(_loc2_);
                        if(_loc5_ != -1)
                        {
                            this._currentShowRendersByIndex.splice(_loc5_,1);
                        }
                        this.cleanUpRenderer(_loc2_);
                        delete this._createdRendersListByCompDescr[_loc4_];
                        true;
                    }
                    _loc3_.splice(0,_loc3_.length);
                    this._createdRendersListByCompDescr = null;
                }
                this._createdRendersListByCompDescrLength = 0;
                if(this._currentShowRendersByIndex)
                {
                    for each(_loc2_ in this._currentShowRendersByIndex)
                    {
                        this.cleanUpRenderer(_loc2_);
                    }
                    this._currentShowRendersByIndex.splice(0,this._currentShowRendersByIndex.length);
                    this._currentShowRendersByIndex = null;
                }
                this._currentShowRendersByIndex = null;
            }
            else
            {
                this._currentShowRendersByIndex.splice(0,this._currentShowRendersByIndex.length);
                this._currentShowByCompactDescription.splice(0,this._currentShowByCompactDescription.length);
                if(_renderers)
                {
                    _renderers.splice(0,_renderers.length);
                }
            }
            this._currentShowByCompactDescription.splice(0,this._currentShowByCompactDescription.length);
        }
        
        private function initFilters() : void
        {
            this.tankFilter.dataProvider = new DataProvider(getVehicleTypeProviderS());
            this.tankFilter.menuRowCount = this.tankFilter.dataProvider.length;
            var _loc1_:INations = App.utils.nations;
            var _loc2_:Array = _loc1_.getNationsData();
            var _loc3_:Array = [this.vehicleFilters.createFilterItem(MENU.NATIONS_ALL,TankCarouselFilters.FILTER_ALL_NATION,RES_ICONS.MAPS_ICONS_FILTERS_NATIONS_ALL)];
            if(App.globalVarsMgr.isKoreaS())
            {
                _loc3_.push(this.vehicleFilters.createFilterItem(MENU.CAROUSELFILTER_IGR,TankCarouselFilters.FILTER_IGR_NATION,RES_ICONS.MAPS_ICONS_FILTERS_NATIONS_IGR));
            }
            var _loc4_:uint = 0;
            while(_loc4_ < _loc2_.length)
            {
                _loc2_[_loc4_]["icon"] = "../maps/icons/filters/nations/" + _loc1_.getNationName(_loc2_[_loc4_]["data"]) + ".png";
                _loc3_.push(_loc2_[_loc4_]);
                _loc4_++;
            }
            this.nationFilter.dataProvider = new DataProvider(_loc3_);
            if(!this.filterData.hasOwnProperty("nation"))
            {
                this.filterData.nation = TankCarouselFilters.FILTER_ALL_NATION;
                this.filterData.tankType = TankCarouselFilters.FILTER_ALL_TYPES;
                this.filterData.ready = false;
                this.tankFilter.selectedIndex = 0;
                this.nationFilter.selectedIndex = 0;
            }
            this.updateFiltersData();
            this.tankFilter.addEventListener(ListEvent.INDEX_CHANGE,this.onVehicleTypeFilterChanged);
            this.nationFilter.addEventListener(ListEvent.INDEX_CHANGE,this.onNationFilterChanged);
            this.checkBoxToMain.addEventListener(Event.SELECT,this.onFilterCheckBoxChanged);
        }
        
        protected function showHideFilters() : void
        {
            updateVisibleSlotsCount();
            var _loc1_:Boolean = _visibleSlots < this._createdRendersListByCompDescrLength || !(this._createdRendersListByCompDescrLength == this._currentShowByCompactDescription.length);
            if(!_loc1_)
            {
                leftArrow.x = this.vehicleFilters.x;
                this.vehicleFilters.visible = false;
                this.vehicleFilters.close();
            }
            else if(_loc1_)
            {
                leftArrow.x = this.vehicleFilters.x + this.vehicleFilters.width + FILTERS_CAROUSEL_OFFSET ^ 0;
                this.vehicleFilters.visible = true;
            }
            
            updateDefContainerPos();
            if((container) && (slidingIntervalId == 0) && !isTween)
            {
                container.x = _defContainerPos - currentFirstRenderer * slotWidth;
                renderersMask.x = leftArrow.x + leftArrow.width;
                dragHitArea.x = renderersMask.x;
            }
            updateVisibleSlotsCount();
        }
        
        private function updateFiltersData() : void
        {
            var _loc1_:* = NaN;
            var _loc2_:* = NaN;
            if(!initialized)
            {
                invalidate();
                return;
            }
            if(this.filterDataInvalid)
            {
                this.filterDataInvalid = false;
                _loc1_ = 0;
                while(_loc1_ < this.nationFilter.dataProvider.length)
                {
                    if(this.nationFilter.dataProvider[_loc1_].data == this.filterData.nation)
                    {
                        this.nationFilter.selectedIndex = _loc1_;
                        break;
                    }
                    _loc1_++;
                }
                _loc2_ = 0;
                while(_loc2_ < this.tankFilter.dataProvider.length)
                {
                    if(this.tankFilter.dataProvider[_loc2_].data == this.filterData.tankType)
                    {
                        this.tankFilter.selectedIndex = _loc2_;
                        break;
                    }
                    _loc2_++;
                }
                this.checkBoxToMain.selected = this.filterData.ready;
            }
        }
        
        private function showContextMenu(param1:Number) : void
        {
            var _loc2_:Object = App.contextMenuMgr.getContextMenuVehicleDataByInvCD(param1);
            var _loc3_:ContextMenuVehicleVo = new ContextMenuVehicleVo(_loc2_);
            _loc3_.component = VehicleContextMenuGenerator.COMPONENT_HANGAR;
            App.contextMenuMgr.showVehicleContextMenu(this,_loc3_,new VehicleContextMenuGenerator());
        }
        
        private function rebuildRenderers() : void
        {
            var _loc1_:* = 0;
            var _loc2_:* = 0;
            var _loc3_:IListItemRenderer = null;
            var _loc4_:Vector.<VehicleCarouselVO> = null;
            if(this._createdRendersListByCompDescr == null)
            {
                this._createdRendersListByCompDescr = {};
            }
            _loc4_ = this._vehiclesVOManager.getRemoved();
            _loc2_ = _loc4_.length;
            var _loc5_:VehicleCarouselVO = null;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
                _loc5_ = _loc4_[_loc1_];
                if(this._createdRendersListByCompDescr[_loc5_.compactDescr])
                {
                    _loc3_ = this._createdRendersListByCompDescr[_loc5_.compactDescr];
                    this.cleanUpRenderer(_loc3_);
                    delete this._createdRendersListByCompDescr[_loc5_.compactDescr];
                    true;
                }
                _loc1_++;
            }
            _loc4_ = this._vehiclesVOManager.getAdded();
            _loc2_ = _loc4_.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
                _loc3_ = createRenderer(_loc1_);
                if(_loc3_ == null)
                {
                    break;
                }
                _loc5_ = _loc4_[_loc1_];
                if(!this._createdRendersListByCompDescr[_loc5_.compactDescr])
                {
                    this._createdRendersListByCompDescr[_loc5_.compactDescr] = _loc3_;
                    container.addChild(_loc3_ as DisplayObject);
                    this.populateRendererData(_loc1_,_loc3_,_loc5_);
                }
                _loc1_++;
            }
            _loc4_ = this._vehiclesVOManager.getUpdated();
            _loc2_ = _loc4_.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
                _loc5_ = _loc4_[_loc1_];
                if(this._createdRendersListByCompDescr[_loc5_.compactDescr])
                {
                    _loc3_ = this._createdRendersListByCompDescr[_loc5_.compactDescr];
                    this.populateRendererData(_loc1_,_loc3_,_loc5_,true);
                }
                _loc1_++;
            }
            this.updateCreatedRenderersLength();
            invalidate(InvalidationType.RENDERERS);
        }
        
        private function updateCreatedRenderersLength() : void
        {
            var _loc2_:String = null;
            var _loc1_:Number = 0;
            if(this._createdRendersListByCompDescr)
            {
                for(_loc2_ in this._createdRendersListByCompDescr)
                {
                    _loc1_++;
                }
            }
            this._createdRendersListByCompDescrLength = _loc1_;
        }
        
        private function populateRendererData(param1:Number, param2:IListItemRenderer, param3:VehicleCarouselVO, param4:Boolean = false, param5:Boolean = false) : void
        {
            var _loc8_:ListData = null;
            var _loc6_:DisplayObject = param2 as DisplayObject;
            var _loc7_:TankCarouselItemRenderer = param2 as TankCarouselItemRenderer;
            _loc7_.enabled = enabled;
            _loc7_.dragEnabled = dragEnabled;
            _loc7_.setDataVO(param3);
            if(!param4)
            {
                _loc8_ = new ListData(param1,param3.label,param3.compactDescr == this._selectedVehicleCompactID);
                _loc7_.setListData(_loc8_);
                _loc7_.validateNow();
                _loc6_.visible = false;
                if(param3.compactDescr == this._selectedVehicleCompactID)
                {
                    selectedItemRenderer = param2;
                }
            }
            else if(param5)
            {
                _loc6_.visible = true;
            }
            
        }
        
        private function getRendererByCompactDescr(param1:Number) : IListItemRenderer
        {
            var _loc2_:IListItemRenderer = this._createdRendersListByCompDescr[param1];
            return _loc2_;
        }
        
        private function removeRendererFromShowByCompactDescr(param1:Number) : void
        {
            var _loc3_:DisplayObject = null;
            var _loc2_:IListItemRenderer = this.getRendererByCompactDescr(param1);
            if(_loc2_)
            {
                _loc3_ = _loc2_ as DisplayObject;
                _loc3_.visible = false;
            }
        }
        
        private function insertRendererToShowByNum(param1:Number, param2:Number) : void
        {
            var _loc3_:IListItemRenderer = this.getRendererByCompactDescr(param2);
            if(_loc3_)
            {
                this._currentShowRendersByIndex[param1] = _loc3_;
                _renderers.push(_loc3_);
            }
        }
        
        private function updateEmptySlots() : void
        {
            if(!_renderers)
            {
                return;
            }
            this.removeEmptySlots();
            this.addEmptySlots();
        }
        
        private function removeEmptySlots() : void
        {
            var _loc1_:IListItemRenderer = null;
            var _loc2_:VehicleCarouselVO = null;
            while(_renderers.length)
            {
                _loc1_ = getRendererAt(_renderers.length - 1,0);
                _loc2_ = (_loc1_ as TankCarouselItemRenderer).dataVO;
                if(_loc2_.empty)
                {
                    _renderers.splice(_renderers.length - 1,1);
                    this.cleanUpRenderer(_loc1_);
                    continue;
                }
                break;
            }
        }
        
        private function addEmptySlots() : void
        {
            var _loc1_:DisplayObject = null;
            var _loc2_:IListItemRenderer = null;
            while(_visibleSlots > _renderers.length)
            {
                _loc2_ = createRenderer(_renderers.length);
                if(_loc2_ == null)
                {
                    break;
                }
                this.populateRendererData(_renderers.length,_loc2_,VehicleCarouselVOBuilder.instance.getDataVoForEmptySlot());
                _loc2_.x = padding.horizontal + _renderers.length * slotWidth;
                _renderers.push(_loc2_);
                _loc1_ = _loc2_ as DisplayObject;
                container.addChild(_loc1_);
                _loc1_.visible = true;
            }
        }
        
        private function removeAdvancedSlots() : void
        {
            var _loc1_:IListItemRenderer = null;
            var _loc2_:VehicleCarouselVO = null;
            while(_renderers.length)
            {
                _loc1_ = getRendererAt(_renderers.length - 1,0);
                if(!_loc1_)
                {
                    break;
                }
                _loc2_ = (_loc1_ as TankCarouselItemRenderer).dataVO;
                if((_loc2_.buySlot) || (_loc2_.buyTank))
                {
                    _renderers.splice(_renderers.length - 1,1);
                    if(this._availableSlotsForBuyVehicle <= 0 && (_loc2_.buyTank))
                    {
                        this.cleanUpRenderer(_loc1_);
                        if(this._slotForBuyVehicle)
                        {
                            this._slotForBuyVehicle = null;
                        }
                    }
                    continue;
                }
                break;
            }
        }
        
        private function addAdvancedSlots() : void
        {
            var _loc1_:DisplayObject = null;
            if(this._availableSlotsForBuyVehicle > 0)
            {
                if(!this._slotForBuyVehicle)
                {
                    this._slotForBuyVehicle = createRenderer(_renderers.length);
                    if(this._slotForBuyVehicle != null)
                    {
                        this.updateSlotForBuyVehicle(false);
                        this._slotForBuyVehicle.x = padding.horizontal + _renderers.length * slotWidth;
                        _renderers.push(this._slotForBuyVehicle);
                        _loc1_ = this._slotForBuyVehicle as DisplayObject;
                        container.addChild(_loc1_);
                    }
                }
                else
                {
                    this._slotForBuyVehicle.x = padding.horizontal + _renderers.length * slotWidth;
                    _renderers.push(this._slotForBuyVehicle);
                    _loc1_ = this._slotForBuyVehicle as DisplayObject;
                }
                _loc1_.visible = true;
            }
            if(this._slotForBuySlot == null)
            {
                this._slotForBuySlot = createRenderer(_renderers.length);
                if(this._slotForBuySlot != null)
                {
                    this.updateSlotForBuySlot(false);
                    this._slotForBuySlot.x = padding.horizontal + _renderers.length * slotWidth;
                    _renderers.push(this._slotForBuySlot);
                    _loc1_ = this._slotForBuySlot as DisplayObject;
                    container.addChild(_loc1_);
                }
            }
            else
            {
                this._slotForBuySlot.x = padding.horizontal + _renderers.length * slotWidth;
                _renderers.push(this._slotForBuySlot);
                _loc1_ = this._slotForBuySlot as DisplayObject;
            }
            _loc1_.visible = true;
        }
        
        private function repositionRenderers() : void
        {
            var _loc2_:IListItemRenderer = null;
            var _loc3_:DisplayObject = null;
            var _loc1_:Number = 0;
            var _loc4_:Number = -1;
            _loc1_ = 0;
            while(_loc1_ < this._currentShowRendersByIndex.length)
            {
                _loc2_ = this._currentShowRendersByIndex[_loc1_];
                _loc2_.x = padding.horizontal + _loc1_ * slotWidth;
                _loc3_ = _loc2_ as DisplayObject;
                _loc3_.visible = true;
                if((_loc2_.selected) && _loc4_ == -1)
                {
                    _loc4_ = _loc1_;
                }
                _loc1_++;
            }
            _totalRenderers = this._availableSlotsForBuyVehicle > 0?this._currentShowRendersByIndex.length + 2:this._currentShowRendersByIndex.length + 1;
            _loc4_ = _loc4_ == -1?0:_loc4_;
            this.scrollToIndex(_loc4_);
        }
        
        private function onFilterCheckBoxChanged(param1:Event) : void
        {
            this.filterData.ready = this.checkBoxToMain.selected;
            this.onFilterChanged();
        }
        
        private function onVehicleTypeFilterChanged(param1:ListEvent) : void
        {
            this.filterData.tankType = param1.itemData.data;
            this.onFilterChanged();
        }
        
        private function onNationFilterChanged(param1:ListEvent) : void
        {
            this.filterData.nation = param1.itemData.data;
            this.onFilterChanged();
        }
        
        override protected function onDispose() : void
        {
            super.onDispose();
        }
    }
}
