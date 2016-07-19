﻿/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.extraFields
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.types.*;
    import com.xvm.types.dossier.*;
    import com.xvm.vo.*;
    import com.xvm.types.cfg.*;
    import flash.display.*;
    import flash.filters.*;
    import flash.text.*;
    import flash.geom.*;
    import flash.utils.*;
    import scaleform.gfx.*;
    import scaleform.clik.core.*;

    public class ExtraFields extends UIComponent
    {
        public static const LAYOUT_HORIZONTAL:String = "horizontal";
        public static const LAYOUT_VERTICAL:String = "vertical";
        public static const LAYOUT_ROOT:String = "root";

        private var _bounds:Rectangle;
        private var _layout:String;
        private var _isLeftPanel:Boolean;

        public function ExtraFields(formats:Array, isLeftPanel:Boolean = true, getSchemeNameForText:Function = null, getSchemeNameForImage:Function = null,
            bounds:Rectangle = null, layout:String = null, defaultAlign:String = null, defaultTextFormatConfig:CTextFormat = null):void
        {
            mouseEnabled = false;
            mouseChildren = false;

            _bounds = bounds;
            _layout = layout;
            _isLeftPanel = isLeftPanel;

            var len:int = formats.length;
            for (var i:int = 0; i < len; ++i)
            {
                var format:* = formats[i];
                if (!format)
                    continue;

                if (format is String)
                {
                    format = { format: format };
                    formats[i] = format;
                }

                if (getQualifiedClassName(format) != "com.xvm.types.cfg::CExtraField")
                {
                    if (getQualifiedClassName(format) != "Object")
                    {
                        Logger.add("WARNING: extra field format is not Object class");
                        continue;
                    }
                    var isEmpty:Boolean = true;
                    for (var _tmp:String in format)
                    {
                        isEmpty = false;
                        break;
                    }
                    if (isEmpty)
                        continue;
                    format = ObjectConverter.convertData(format, CExtraField);
                }

                if (Macros.FormatBooleanGlobal(format.enabled, true))
                {
                    addChild(format.src != null
                        ? new (App.utils.classFactory.getClass("com.xvm.extraFields::ImageExtraField"))(format, isLeftPanel, getSchemeNameForImage) // TODO: make ImageExtraField shared
                        : new TextExtraField(format, isLeftPanel, getSchemeNameForText, _bounds, defaultAlign, defaultTextFormatConfig));
                }
            }
        }

        override protected function configUI():void
        {
            super.configUI();
        }

        public function update(options:IVOMacrosOptions, bindToIconOffset:Number = 0, offsetX:Number = 0, offsetY:Number = 0):void
        {
            var len:int = this.numChildren;
            for (var i:int = 0; i < len; ++i)
            {
                var child:IExtraField = this.getChildAt(i) as IExtraField;
                if (child)
                {
                    child.update(options, bindToIconOffset, offsetX, offsetY);
                    if (_bounds && _layout)
                    {
                        var position:Number = options.position;
                        switch (_layout)
                        {
                            case LAYOUT_HORIZONTAL:
                                var vx:Number = _bounds.x + (position - 1) * _bounds.width;
                                x = _isLeftPanel ? vx : App.appWidth - vx;
                                y = _bounds.y;
                                break;
                            case LAYOUT_VERTICAL:
                                x = _isLeftPanel ? _bounds.x : App.appWidth - _bounds.x;
                                y = _bounds.y + (position - 1) * _bounds.height;
                                break;
                            case LAYOUT_ROOT:
                                var align:String = Macros.FormatStringGlobal(child.cfg.screenHAlign, TextFormatAlign.LEFT);
                                child.x = child.xValue + Utils.HAlign(align, child.widthValue, _bounds.width);
                                var valign:String = Macros.FormatStringGlobal(child.cfg.screenVAlign, TextFieldEx.VALIGN_TOP);
                                child.y = child.yValue + Utils.VAlign(valign, child.heightValue, _bounds.height);
                                break;
                        }
                    }
                }
            }
        }

        public function updateBounds(bounds:Rectangle):void
        {
            _bounds = bounds;
        }
    }
}
