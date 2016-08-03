﻿/**
 * XVM Config
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.types.cfg
{
    import com.xfw.*;

    public dynamic class CExtraField extends Object implements ICloneable
    {
        public var enabled:*;
        public var x:*;
        public var y:*;
        public var width:*;
        public var height:*;
        public var alpha:*;
        public var rotation:*;
        public var scaleX:*;
        public var scaleY:*;
        public var align:String;
        public var valign:String;
        public var borderColor:String;
        public var bgColor:String;
        public var antiAliasType:String;
        public var bindToIcon:*;
        public var src:String;
        public var format:String;
        public var textFormat:CTextFormat;
        public var shadow:CShadow;
        public var highlight:*;

        // for BattleLabels
        public var updateEvent:String;
        public var hotKeyCode:*;
        public var onHold:*;
        public var visibleOnHotKey:*;
        public var screenHAlign:String;
        public var screenVAlign:String;

        // for PlayersPanel
        public var layer:String;

        // legacy configs
        public function set w(value:*):void
        {
            width = value;
        }
        public function set h(value:*):void
        {
            height = value;
        }

        public function clone():*
        {
            var cloned:CExtraField = new CExtraField();
            cloned.enabled = enabled;
            cloned.x = x;
            cloned.y = y;
            cloned.width = width;
            cloned.height = height;
            cloned.alpha = alpha;
            cloned.rotation = rotation;
            cloned.scaleX = scaleX;
            cloned.scaleY = scaleY;
            cloned.align = align;
            cloned.valign = valign;
            cloned.borderColor = borderColor;
            cloned.bgColor = bgColor;
            cloned.antiAliasType = antiAliasType;
            cloned.bindToIcon = bindToIcon;
            cloned.src = src;
            cloned.format = format;
            cloned.textFormat = textFormat ? textFormat.clone() : null;
            cloned.shadow = shadow ? shadow.clone() : null;
            cloned.highlight = highlight;
            cloned.updateEvent = updateEvent;
            cloned.hotKeyCode = hotKeyCode;
            cloned.onHold = onHold;
            cloned.visibleOnHotKey = visibleOnHotKey;
            cloned.screenHAlign = screenHAlign;
            cloned.screenVAlign = screenVAlign;
            cloned.layer = layer;
            return cloned;
        }
    }
}
