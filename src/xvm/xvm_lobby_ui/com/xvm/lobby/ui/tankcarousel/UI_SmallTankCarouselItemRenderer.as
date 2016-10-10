/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.lobby.ui.tankcarousel
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.extraFields.*;
    import com.xvm.lobby.vo.*;
    import com.xvm.types.cfg.*;
    import com.xvm.types.dossier.*;
    import com.xvm.vo.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    import net.wg.gui.lobby.hangar.tcarousel.*;
    import net.wg.gui.lobby.hangar.tcarousel.data.*;
    import scaleform.gfx.*;

    public /*dynamic*/ class UI_SmallTankCarouselItemRenderer extends SmallTankCarouselItemRendererUI implements IExtraFieldGroupHolder, ITankCarouselItemRenderer
    {
        public static const DEFAULT_WIDTH:int = 162;
        public static const DEFAULT_HEIGHT:int = 37;

        private var _helper:TankCarouselItemRendererHelper;

        private var _substrateHolder:Sprite;
        private var _bottomHolder:Sprite;
        private var _normalHolder:Sprite;
        private var _topHolder:Sprite;
        private var _extraFields:ExtraFieldsGroup = null;

        public function UI_SmallTankCarouselItemRenderer()
        {
            //Logger.add(getQualifiedClassName(this));
            super();
            try
            {
                _helper = new TankCarouselItemRendererHelper(this, Config.config.hangar.carousel.small, DEFAULT_WIDTH, DEFAULT_HEIGHT);
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
                extraFields.visible = false;
            }
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