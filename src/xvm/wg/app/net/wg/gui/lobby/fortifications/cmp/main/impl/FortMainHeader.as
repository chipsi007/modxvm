package net.wg.gui.lobby.fortifications.cmp.main.impl
{
    import net.wg.infrastructure.base.UIComponentEx;
    import net.wg.gui.lobby.fortifications.cmp.main.IMainHeader;
    import net.wg.gui.components.controls.BitmapFill;
    import net.wg.infrastructure.interfaces.IUIComponentEx;
    import flash.text.TextField;
    import net.wg.gui.lobby.fortifications.cmp.main.IFortHeaderClanInfo;
    import net.wg.gui.components.controls.IconTextButton;
    import net.wg.gui.components.advanced.ButtonDnmIcon;
    import net.wg.gui.components.advanced.ToggleSoundButton;
    import net.wg.gui.lobby.fortifications.utils.IFortsControlsAligner;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import flash.display.InteractiveObject;
    import net.wg.gui.lobby.fortifications.utils.impl.FortsControlsAligner;
    
    public class FortMainHeader extends UIComponentEx implements IMainHeader
    {
        
        public function FortMainHeader()
        {
            super();
            this.helper = FortsControlsAligner.instance;
            this._statsBtn.UIID = 1;
            this._clanListBtn.UIID = 2;
            this._transportBtn.UIID = 3;
            this._vignetteYellow.alpha = 0;
        }
        
        private static var TRANSPORT_BTN_RIGHT_OFFSET:Number = 9;
        
        private static var DEPOT_QUANTITY_RIGHT_OFFSET:Number = TRANSPORT_BTN_RIGHT_OFFSET + 8;
        
        private static var SETTING_BTN_LEFT_OFFSET:Number = 15;
        
        public var headerBitmapFill:BitmapFill = null;
        
        private var _tutorialArrow:IUIComponentEx = null;
        
        private var _title:TextField = null;
        
        private var _infoTF:TextField = null;
        
        private var _clanInfo:IFortHeaderClanInfo = null;
        
        private var _totalDepotQuantityText:TextField = null;
        
        private var _vignetteYellow:VignetteYellow = null;
        
        private var _statsBtn:IconTextButton = null;
        
        private var _clanListBtn:IconTextButton = null;
        
        private var _calendarBtn:IconTextButton = null;
        
        private var _settingBtn:ButtonDnmIcon = null;
        
        private var _transportBtn:ToggleSoundButton = null;
        
        private var helper:IFortsControlsAligner = null;
        
        public function updateControls() : void
        {
            this._title.width = App.appWidth;
            this._infoTF.width = App.appWidth;
            this.helper.centerControl(this._vignetteYellow,false);
            this.helper.centerControl(this._clanInfo,true);
            this.helper.rightControl(this._transportBtn,TRANSPORT_BTN_RIGHT_OFFSET);
            this._tutorialArrow.x = this._transportBtn.x + (this._transportBtn.width - this._tutorialArrow.width >> 1);
            this.helper.rightControl(this._totalDepotQuantityText,DEPOT_QUANTITY_RIGHT_OFFSET + this._transportBtn.width);
            var _loc1_:Rectangle = DisplayObject(this.clanInfo).getRect(this);
            this.settingBtn.x = _loc1_.x + _loc1_.width + SETTING_BTN_LEFT_OFFSET;
        }
        
        public function getComponentForFocus() : InteractiveObject
        {
            return this.clanListBtn;
        }
        
        public function set widthFill(param1:Number) : void
        {
            this.headerBitmapFill.widthFill = param1;
        }
        
        public function get heightFill() : Number
        {
            return this.headerBitmapFill.heightFill;
        }
        
        public function get statsBtn() : IconTextButton
        {
            return this._statsBtn;
        }
        
        public function set statsBtn(param1:IconTextButton) : void
        {
            this._statsBtn = param1;
        }
        
        public function get clanListBtn() : IconTextButton
        {
            return this._clanListBtn;
        }
        
        public function set clanListBtn(param1:IconTextButton) : void
        {
            this._clanListBtn = param1;
        }
        
        public function get calendarBtn() : IconTextButton
        {
            return this._calendarBtn;
        }
        
        public function set calendarBtn(param1:IconTextButton) : void
        {
            this._calendarBtn = param1;
        }
        
        public function get transportBtn() : ToggleSoundButton
        {
            return this._transportBtn;
        }
        
        public function set transportBtn(param1:ToggleSoundButton) : void
        {
            this._transportBtn = param1;
        }
        
        public function get settingBtn() : ButtonDnmIcon
        {
            return this._settingBtn;
        }
        
        public function set settingBtn(param1:ButtonDnmIcon) : void
        {
            this._settingBtn = param1;
        }
        
        public function get vignetteYellow() : VignetteYellow
        {
            return this._vignetteYellow;
        }
        
        public function set vignetteYellow(param1:VignetteYellow) : void
        {
            this._vignetteYellow = param1;
        }
        
        public function get totalDepotQuantityText() : TextField
        {
            return this._totalDepotQuantityText;
        }
        
        public function set totalDepotQuantityText(param1:TextField) : void
        {
            this._totalDepotQuantityText = param1;
        }
        
        public function get clanInfo() : IFortHeaderClanInfo
        {
            return this._clanInfo;
        }
        
        public function set clanInfo(param1:IFortHeaderClanInfo) : void
        {
            this._clanInfo = param1;
        }
        
        public function get title() : TextField
        {
            return this._title;
        }
        
        public function set title(param1:TextField) : void
        {
            this._title = param1;
        }
        
        public function get infoTF() : TextField
        {
            return this._infoTF;
        }
        
        public function set infoTF(param1:TextField) : void
        {
            this._infoTF = param1;
        }
        
        public function get tutorialArrow() : IUIComponentEx
        {
            return this._tutorialArrow;
        }
        
        public function set tutorialArrow(param1:IUIComponentEx) : void
        {
            this._tutorialArrow = param1;
        }
        
        override protected function configUI() : void
        {
            super.configUI();
            this.calendarBtn.iconSource = RES_ICONS.MAPS_ICONS_BUTTONS_CALENDAR;
            this._vignetteYellow.mouseEnabled = false;
            this._vignetteYellow.mouseChildren = false;
            mouseEnabled = false;
            this.settingBtn.iconSource = RES_ICONS.MAPS_ICONS_BUTTONS_SETTINGS;
            this.transportBtn.iconSource = RES_ICONS.MAPS_ICONS_BUTTONS_TRANSPORTING;
        }
        
        override protected function onDispose() : void
        {
            this.headerBitmapFill.dispose();
            this.headerBitmapFill = null;
            this._clanInfo.dispose();
            this._clanInfo = null;
            this._statsBtn.dispose();
            this._statsBtn = null;
            this._clanListBtn.dispose();
            this._clanListBtn = null;
            this._calendarBtn.dispose();
            this._calendarBtn = null;
            this._settingBtn.dispose();
            this._settingBtn = null;
            this._vignetteYellow.dispose();
            this._vignetteYellow = null;
            this._transportBtn.dispose();
            this._transportBtn = null;
            this._totalDepotQuantityText = null;
            this._title = null;
            this._infoTF = null;
            this._tutorialArrow.dispose();
            this._tutorialArrow = null;
            this.helper = null;
            super.onDispose();
        }
    }
}
