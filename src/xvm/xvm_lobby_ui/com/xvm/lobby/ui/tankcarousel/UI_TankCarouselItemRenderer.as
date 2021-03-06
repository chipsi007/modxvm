/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * https://modxvm.com/
 */
package com.xvm.lobby.ui.tankcarousel
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.extraFields.*;
    import com.xvm.lobby.*;
    import com.xvm.vo.*;
    import flash.display.*;
    import net.wg.gui.components.carousels.data.*;

    public /*dynamic*/ class UI_TankCarouselItemRenderer extends TankCarouselItemRendererUI implements IExtraFieldGroupHolder, ITankCarouselItemRenderer
    {
        public static const DEFAULT_RENDERER_WIDTH:int = 162;
        public static const DEFAULT_RENDERER_HEIGHT:int = 102;
        public static const DEFAULT_RENDERER_VISIBLE_HEIGHT:int = 102;

        private var _helper:TankCarouselItemRendererHelper;

        private var _substrateHolder:Sprite;
        private var _bottomHolder:Sprite;
        private var _normalHolder:Sprite;
        private var _topHolder:Sprite;
        private var _extraFields:ExtraFieldsGroup = null;

        public function UI_TankCarouselItemRenderer()
        {
            //Logger.add(getQualifiedClassName(this));
            super();
            try
            {
                _helper = new TankCarouselItemRendererHelper(this, Config.config.hangar.carousel.normal, DEFAULT_RENDERER_WIDTH, DEFAULT_RENDERER_HEIGHT);
                Xfw.addCommandListener(LobbyXvmApp.AS_UPDATE_BATTLE_TYPE, updateData);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        override protected function onDispose():void
        {
            try
            {
                Xfw.removeCommandListener(LobbyXvmApp.AS_UPDATE_BATTLE_TYPE, updateData);
                _helper.dispose();
                _helper = null;
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            super.onDispose();
        }

        override public function set data(value:Object):void
        {
            if (!value)
            {
                if (extraFields)
                {
                    extraFields.visible = false;
                }
            }
            else
            {
                _helper.fixData(value);
            }
            content.clanLock.validateNow();
            super.data = value;
        }

        override public function set selected(value:Boolean):void
        {
            if (selected != value)
            {
                super.selected = value;
                _helper.updateDataXvm();
            }
        }

        override protected function updateData():void
        {
            super.updateData();
            _helper.updateDataXvm();
        }

        // IExtraFieldGroupHolder

        public function get isLeftPanel():Boolean
        {
            return true;
        }

        public function get substrateHolder():Sprite
        {
            return _substrateHolder;
        }

        public function get bottomHolder():Sprite
        {
            return _bottomHolder;
        }

        public function get normalHolder():Sprite
        {
            return _normalHolder;
        }

        public function get topHolder():Sprite
        {
            return _topHolder;
        }

        public function getSchemeNameForVehicle(options:IVOMacrosOptions):String
        {
            return null;
        }

        public function getSchemeNameForPlayer(options:IVOMacrosOptions):String
        {
            return null;
        }

        // ITankCarouselItemRenderer

        public function set substrateHolder(value:Sprite):void
        {
            _substrateHolder = value;
        }

        public function set bottomHolder(value:Sprite):void
        {
            _bottomHolder = value;
        }

        public function set normalHolder(value:Sprite):void
        {
            _normalHolder = value;
        }

        public function set topHolder(value:Sprite):void
        {
            _topHolder = value;
        }

        public function get extraFields():ExtraFieldsGroup
        {
            return _extraFields;
        }

        public function set extraFields(value:ExtraFieldsGroup):void
        {
            _extraFields = value;
        }

        public function get vehicleCarouselVO():VehicleCarouselVO
        {
            return dataVO;
        }
    }
}
