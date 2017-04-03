﻿/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.extraFields
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.extraFields.*;
    import com.xvm.types.cfg.*;
    import com.xvm.vo.*;
    import flash.geom.*;
    import flash.text.*;
    import net.wg.infrastructure.interfaces.entity.*;

    public class ExtraFieldsGroup implements IDisposable
    {
        public var substrate:ExtraFields = null;
        public var bottom:ExtraFields = null;
        public var normal:ExtraFields = null;
        public var top:ExtraFields = null;

        private var _isRootLayout:Boolean = false;
        private var _lastUpdateArgs:Array = null;
        private var _x:Number = 0;
        private var _y:Number = 0;

        public function ExtraFieldsGroup(item:IExtraFieldGroupHolder, formats:Array, isRootLayout:Boolean = false, defaultTextFormatConfig:CTextFormat = null)
        {
            const createNewExtraFields:Function = function():ExtraFields
            {
                return new ExtraFields(
                    filteredFormats,
                    item.isLeftPanel,
                    item.getSchemeNameForPlayer,
                    item.getSchemeNameForVehicle,
                    isRootLayout ? new Rectangle(0, 0, App.appWidth, App.appHeight) : null,
                    isRootLayout ? ExtraFields.LAYOUT_ROOT : null,
                    isRootLayout ? TextFormatAlign.LEFT : null,
                    defaultTextFormatConfig);
            }

            _isRootLayout = isRootLayout;

            if (!defaultTextFormatConfig)
            {
                defaultTextFormatConfig = CTextFormat.GetDefaultConfigForBattle(item.isLeftPanel ? TextFormatAlign.LEFT : TextFormatAlign.RIGHT);
            }
            var filteredFormats:Array;
            if (formats && formats.length)
            {
                filteredFormats = filterFormats(formats, Defines.LAYER_SUBSTRATE);
                if (filteredFormats && filteredFormats.length)
                {
                    substrate = createNewExtraFields();
                    item.substrateHolder.addChild(substrate);
                }
                filteredFormats = filterFormats(formats, Defines.LAYER_BOTTOM);
                if (filteredFormats && filteredFormats.length)
                {
                    bottom = createNewExtraFields();
                    item.bottomHolder.addChild(bottom);
                }
                filteredFormats = filterFormats(formats, Defines.LAYER_NORMAL);
                if (filteredFormats && filteredFormats.length)
                {
                    normal = createNewExtraFields();
                    item.normalHolder.addChild(normal);
                }
                filteredFormats = filterFormats(formats, Defines.LAYER_TOP);
                if (filteredFormats && filteredFormats.length)
                {
                    top = createNewExtraFields();
                    item.topHolder.addChild(top);
                }
            }

            if (_isRootLayout)
            {
                Xfw.addCommandListener(XvmCommands.AS_ON_UPDATE_STAGE, onUpdateStage);
            }
        }

        public function dispose():void
        {
            if (_isRootLayout)
            {
                Xfw.removeCommandListener(XvmCommands.AS_ON_UPDATE_STAGE, onUpdateStage);
            }
            if (substrate)
            {
                substrate.dispose();
                substrate = null;
            }
            if (bottom)
            {
                bottom.dispose();
                bottom = null;
            }
            if (normal)
            {
                normal.dispose();
                normal = null;
            }
            if (top)
            {
                top.dispose();
                top = null;
            }
        }

        public function set visible(value:Boolean):void
        {
            if (substrate)
            {
                substrate.visible = value;
            }
            if (bottom)
            {
                bottom.visible = value;
            }
            if (normal)
            {
                normal.visible = value;
            }
            if (top)
            {
                top.visible = value;
            }
        }

        public function set x(value:Number):void
        {
            if (_x == value)
                return;
            _x = value;
            if (substrate)
            {
                substrate.x = _x;
            }
            if (bottom)
            {
                bottom.x = _x;
            }
            if (normal)
            {
                normal.x = _x;
            }
            if (top)
            {
                top.x = _x;
            }
        }

        public function set y(value:Number):void
        {
            if (_y == value)
                return;
            _y = value;
            if (substrate)
            {
                substrate.y = _y;
            }
            if (bottom)
            {
                bottom.y = _y;
            }
            if (normal)
            {
                normal.y = _y;
            }
            if (top)
            {
                top.y = _y;
            }
        }

        public function update(options:IVOMacrosOptions, bindToIconOffset:Number, offsetX:Number = 0, offsetY:Number = 0):void
        {
            _lastUpdateArgs = arguments;
            if (substrate)
            {
                substrate.update(options, bindToIconOffset, offsetX, offsetY);
            }
            if (bottom)
            {
                bottom.update(options, bindToIconOffset, offsetX, offsetY);
            }
            if (normal)
            {
                normal.update(options, bindToIconOffset, offsetX, offsetY);
            }
            if (top)
            {
                top.update(options, bindToIconOffset, offsetX, offsetY);
            }
        }

        // PRIVATE

        private function filterFormats(formats:Array, layer:String):Array
        {
            var res:Array = [];
            var len:int = formats.length;
            for (var i:int = 0; i < len; ++i)
            {
                var format:* = formats[i];
                if (layer == (format.layer ? format.layer.toLowerCase() : "normal"))
                {
                    res.push(format);
                }
            }
            return res;
        }

        private function onUpdateStage():void
        {
            if (_isRootLayout)
            {
                if (substrate)
                {
                    substrate.updateBounds(new Rectangle(0, 0, App.appWidth, App.appHeight));
                }
                if (bottom)
                {
                    bottom.updateBounds(new Rectangle(0, 0, App.appWidth, App.appHeight));
                }
                if (normal)
                {
                    normal.updateBounds(new Rectangle(0, 0, App.appWidth, App.appHeight));
                }
                if (top)
                {
                    top.updateBounds(new Rectangle(0, 0, App.appWidth, App.appHeight));
                }
                if (_lastUpdateArgs != null)
                {
                    update.apply(this, _lastUpdateArgs);
                }
            }
        }
    }
}
