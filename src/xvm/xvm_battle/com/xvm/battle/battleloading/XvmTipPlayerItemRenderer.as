﻿/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.battle.battleloading
{
    import com.xfw.*;
    import com.xvm.*;
    import flash.display.*;
    import flash.text.*;
    import net.wg.data.VO.daapi.*;
    import net.wg.gui.battle.battleloading.renderers.*;
    import net.wg.gui.battle.components.*;
    import net.wg.gui.components.icons.*;

    public class XvmTipPlayerItemRenderer extends TipPlayerItemRenderer implements IXvmBattleLoadingItemRenderer
    {
        private var container:RendererContainer = null;
        private var proxy:XvmBattleLoadingItemRendererProxy;

        public function XvmTipPlayerItemRenderer(container:RendererContainer, position:int, isEnemy:Boolean)
        {
            this.container = container;

            //Logger.add("XvmTipPlayerItemRenderer");
            var vehicleField:TextField = container.vehicleFieldsAlly[position];
            if (!isEnemy)
            {
                vehicleField.x = container.vehicleTypeIconsAlly[position].x - vehicleField.width;
            }
            super(container, position, isEnemy);
            proxy = new XvmBattleLoadingItemRendererProxy(this, XvmBattleLoadingItemRendererProxy.UI_TYPE_TIPS, !isEnemy);
        }

        override protected function onDispose():void
        {
            container = null;
            proxy.onDispose();
            super.onDispose();
        }

        override protected function draw():void
        {
            super.draw();
            proxy.draw();
        }

        // IXvmBattleLoadingItemRenderer

        public function get squad():BattleAtlasSprite
        {
            return _squad;
        }

        public function get nameField():TextField
        {
            return _textField;
        }

        public function get vehicleField():TextField
        {
            return _vehicleField;
        }

        public function get vehicleIcon():BattleAtlasSprite
        {
            return _vehicleIcon;
        }

        public function get vehicleLevelIcon():BattleAtlasSprite
        {
            return _vehicleLevelIcon;
        }

        public function get vehicleTypeIcon():BattleAtlasSprite
        {
            return _vehicleTypeIcon;
        }
        public function get playerActionMarker():PlayerActionMarker
        {
            return _playerActionMarker;
        }

        public function get selfBg():BattleAtlasSprite
        {
            return _selfBg;
        }

        public function get icoIGR():BattleAtlasSprite
        {
            return _icoIGR;
        }

		public function invalidate2(id:uint = uint.MAX_VALUE):void
        {
            invalidate(id);
        }

        public function addChild(child:DisplayObject):DisplayObject
        {
            return container.addChild(child);
        }

        public function addChildAt(child:DisplayObject, index:int):DisplayObject
        {
            return container.addChildAt(child, index);
        }

        public function getChildIndex(child:DisplayObject):int
        {
            return container.getChildIndex(child);
        }
    }
}
