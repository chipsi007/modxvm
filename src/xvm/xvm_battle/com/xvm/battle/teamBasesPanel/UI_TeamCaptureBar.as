/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.battle.teamBasesPanel
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.types.*;
    import com.xvm.types.cfg.*;
    import flash.events.*;
    import flash.text.*;
    import flash.filters.*;
    import mx.utils.*;

    public dynamic class UI_TeamCaptureBar extends TeamCaptureBarUI
    {
        private static const XVM_BATTLE_COMMAND_CAPTURE_BAR_GET_BASE_NUM_TEXT:String = "xvm_battle.captureBarGetBaseNumText";

        private var cfg:CCaptureBarTeam;
        private var m_captured:Boolean;
        private var m_baseNumText:String = "";

        private var m_points:Number;
        private var m_vehiclesCount:String;
        private var m_timeLeft:String

        public function UI_TeamCaptureBar()
        {
            //Logger.add("UI_TeamCaptureBar()");
            super();

            Xvm.addEventListener(Defines.XVM_EVENT_CONFIG_LOADED, onConfigLoaded);

            initTextFields();
        }

        override public function setData(param1:Number, param2:Number, param3:String, param4:String, param5:Number, param6:String, param7:String):void
        {
            cfg = null;
            super.setData.apply(this, arguments);
            onConfigLoaded(null);
        }

        override public function updateCaptureData(points:Number, param2:Boolean, param3:Boolean, param4:Number, timeLeft:String, vehiclesCount:String):void
        {
            super.updateCaptureData.apply(this, arguments);
            if (!cfg)
                return;
            m_points = points;
            m_timeLeft = timeLeft;
            m_vehiclesCount = vehiclesCount;
            // TODO: convert from AS2
            /*
            if (!Config.config.captureBar.enabled)
            {
                wrapper.m_playersTF.htmlText = "<font size='15' face='xvm'>&#x113;</font>  " + wrapper.m_vehiclesCount;
                wrapper.m_timerTF.htmlText = "<font size='15' face='xvm'>&#x114;</font>  " + wrapper.m_timeLeft;
            }
            */
            updateTextFields();
        }

        override public function updateTitle(param1:String):void
        {
            super.updateTitle(param1);
            if (!cfg)
                return;
            m_captured = true;
            updateTextFields();
        }

        // PRIVATE

        private function get team():String
        {
            return colorType == "green" ? "ally" : "enemy";
        }

        private function onConfigLoaded(e:Event):Object
        {
            try
            {
                cfg = Config.config.captureBar[team];
                setupCaptureBarColor();
                setupTextField(textField, "title");
                setupTextField(tfVehiclesCount, "timer");
                setupTextField(tfTimeLeft, "players");
                setupTextField(pointsTextField, "points");
                setupProgressBar();
                m_baseNumText = Xfw.cmd(XVM_BATTLE_COMMAND_CAPTURE_BAR_GET_BASE_NUM_TEXT, id);
                updateTextFields();
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            return null;
        }

        private function initTextFields():void
        {
            // align: center
            textField.x -= 300;
            textField.width += 600;
            textField.height = 600;
            // align: right
            tfVehiclesCount.x -= 200 - 271;
            tfVehiclesCount.width += 200;
            tfVehiclesCount.height = 600;
            // align: left
            tfTimeLeft.x -= 20 + 265;
            tfTimeLeft.width += 200;
            tfTimeLeft.height = 600;
            // align: center
            pointsTextField.x -= 300;
            pointsTextField.width += 600;
            pointsTextField.height = 600;
        }

        private function setupCaptureBarColor():void
        {
            // TODO: convert from AS2
            /*
            var color:* = cfg.color;

            //Logger.add("c: " + color);

            if (color != null && !isNaN(color))
                color = parseInt(color);

            if (color == null || isNaN(color))
            {
                color = Config.config.markers.useStandardMarkers
                    ? net.wargaming.managers.ColorSchemeManager.instance.getRGB("vm_" + type)
                    : ColorsManager.getSystemColor(type, false);
            }

            GraphicsUtil.colorize(wrapper.m_bgMC, color, 1);
            GraphicsUtil.colorize(wrapper.captureProgress.m_barMC, color, 1);
            */
        }

        private function setupTextField(tf:TextField, name:String):void
        {
            var c:CCaptureBarTextField = cfg[name];
            //tf.border = true; tf.borderColor = 0xFF0000;
            tf.selectable = false;
            tf.x += Macros.FormatGlobalNumberValue(c.x, 0);
            tf.y += Macros.FormatGlobalNumberValue(c.y, 0);
            tf.filters = [new DropShadowFilter(
                0, // distance
                0, // angle
                Macros.FormatGlobalNumberValue(c.shadow.color, 0x000000),
                Macros.FormatGlobalNumberValue(c.shadow.alpha, 100) / 100.0,
                Macros.FormatGlobalNumberValue(c.shadow.blur, 1),
                Macros.FormatGlobalNumberValue(c.shadow.blur, 1),
                Macros.FormatGlobalNumberValue(c.shadow.strength, 1))];
        }

        private function setupProgressBar():void
        {
            var showProgressBar:Boolean = !Macros.FormatGlobalBooleanValue(Config.config.captureBar.hideProgressBar, false);
            bg.visible = showProgressBar;
            //???barColors._visible = showProgressBar;
        }

        private function updateTextFields():void
        {
            if (!cfg)
                return;

            var o:MacrosFormatOptions = new MacrosFormatOptions();
            o.points = m_points;
            o.vehiclesCount = m_vehiclesCount;
            o.timeLeft = m_timeLeft;
            o.timeLeftSec = m_timeLeft ? Utils.timeStrToSec(m_timeLeft) : -1;

            var value:String;
            var name:String = m_captured ? "done" : "format";

            value = Macros.Format(null, cfg.title[name], o);
            value = StringUtil.substitute(value, m_baseNumText);
            textField.htmlText = value;

            value = Macros.Format(null, cfg.players[name], o);
            value = StringUtil.substitute(value, m_baseNumText);
            tfTimeLeft.htmlText = value;

            value = Macros.Format(null, cfg.timer[name], o);
            value = StringUtil.substitute(value, m_baseNumText);
            tfVehiclesCount.htmlText = value;

            value = Macros.Format(null, cfg.points[name], o);
            value = StringUtil.substitute(value, m_baseNumText);
            pointsTextField.htmlText = value;
        }
    }
}
