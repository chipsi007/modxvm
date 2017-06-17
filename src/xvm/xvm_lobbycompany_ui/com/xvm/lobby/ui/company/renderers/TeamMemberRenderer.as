/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * http://www.modxvm.com/
 */
package com.xvm.lobby.ui.company.renderers
{
    import com.xfw.*;
    import com.xfw.events.*;
    import com.xvm.*;
    import com.xvm.types.stat.*;
    import flash.events.*;
    import flash.text.*;
    import net.wg.gui.prebattle.controls.*;
    import scaleform.gfx.*;

    public class TeamMemberRenderer
    {
        private var proxy:net.wg.gui.prebattle.controls.TeamMemberRenderer;

        private var vehicleLevelFieldX:Number = 0;
        private var effField:TextField;
        private var playerName:String;

        public function TeamMemberRenderer(proxy:net.wg.gui.prebattle.controls.TeamMemberRenderer)
        {
            try
            {
                this.proxy = proxy;
                proxy.textField.x -= 10;
                proxy.vehicle_type_icon.x -= 8;
                proxy.vehicleNameField.x -= 8;
                vehicleLevelFieldX = proxy.vehicleLevelField.x - 12;
                proxy.vehicleLevelField.x = vehicleLevelFieldX;
                effField = new TextField();
                effField.mouseEnabled = false;
                effField.selectable = false;
                TextFieldEx.setNoTranslate(effField, true);
                effField.antiAliasType = AntiAliasType.ADVANCED;
                var tf:TextFormat = proxy.vehicleLevelField.defaultTextFormat;
                tf.align = TextFormatAlign.RIGHT;
                effField.styleSheet = XfwUtils.createTextStyleSheet("eff", tf);
                effField.x = proxy.width - 15;
                effField.y = proxy.vehicleLevelField.y;
                effField.width = 20;
                effField.height = proxy.vehicleLevelField.height;
                effField.htmlText = "";
                proxy.addChild(effField);

                Stat.instance.addEventListener(Stat.COMPLETE_USERDATA, onStatLoaded, false, 0, true);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }

        }

        public function setData(data:Object):void
        {
            App.toolTipMgr.hide();
            effField.htmlText = "";

            if (!data || !data.fullName)
            {
                playerName = null;
                return;
            }

            playerName = XfwUtils.GetPlayerName(data.fullName);
            App.utils.scheduler.scheduleTask(function():void
            {
                if (!Stat.isUserDataCachedByName(playerName))
                {
                    Stat.loadUserData(playerName);
                }
                else
                {
                    setEffFieldText();
                }
            }, 10);
        }

        public function draw():void
        {
            proxy.vehicleLevelField.x = vehicleLevelFieldX;
        }

        public function handleMouseRollOver(e:MouseEvent):void
        {
            try
            {
                if (proxy.data == null || !proxy.data.fullName)
                    return;
                var sd:StatData = Stat.getUserDataByName(playerName);
                if (sd == null)
                    return;
                var tip:String = TeamRendererHelper.getToolTipData(proxy.data.fullName, proxy.data);
                if (tip == null)
                    return;
                App.toolTipMgr.show(tip);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        public function handleMouseRollOut(e:MouseEvent):void
        {
            App.toolTipMgr.hide();
        }

        // PRIVATE

        private function onStatLoaded(e:ObjectEvent):void
        {
            if (e == null)
                return;
            var s:String = e.result as String;
            if (s == playerName)
            {
                setEffFieldText();
            }
        }

        private function setEffFieldText():void
        {
            effField.htmlText = (proxy.data == null || !proxy.data.fullName) ? "--"
                : "<span class='eff'>" + TeamRendererHelper.formatXVMStatText(proxy.data.fullName) + "</span>";
        }
    }

}
