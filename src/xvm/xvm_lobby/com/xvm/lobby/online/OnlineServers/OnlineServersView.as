/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.lobby.online.OnlineServers
{
    import com.xfw.*;
    import com.xfw.events.*;
    import com.xvm.*;
    import com.xvm.types.cfg.*;
    import flash.text.*;
    import flash.events.*;
    import scaleform.clik.core.*;
    import org.idmedia.as3commons.util.*;

    public class OnlineServersView extends UIComponent
    {

        private static const QUALITY_BAD:String = "bad";
        private static const QUALITY_POOR:String = "poor";
        private static const QUALITY_GOOD:String = "good";
        private static const QUALITY_GREAT:String = "great";
        private static const CURRENT_SERVER:String = "current";
        private static const SERVER_COLOR:String = "server"; // actually it's server + delimiter
        private static const STYLE_NAME_PREFIX:String = "xvm_online_";
        private static const COMMAND_GETCURRENTSERVER:String = "xvm_online.getcurrentserver";
        private static const COMMAND_AS_CURRENTSERVER:String = "xvm_online.as.currentserver";

        private var cfg:COnlineServers;
        private var fields:Vector.<TextField>;
        private var currentServer:String;
        private var serverColor:Number;

        public function OnlineServersView(cfg:COnlineServers)
        {
            mouseEnabled = false;
            this.cfg = cfg;
            this.currentServer = currentServer;
            this.serverColor = parseInt(cfg.fontStyle.serverColor, 16);
            fields = new Vector.<TextField>();
            var f:TextField = createNewField();
            f.htmlText = makeStyledRow( { cluster: Locale.get("Initialization"), people_online: "..." } );
            updatePositions();
            OnlineServers.addEventListener(update);
            this.addEventListener(Event.RESIZE, updatePositions);
            Xfw.addCommandListener(COMMAND_AS_CURRENTSERVER, currentServerCallback);
            Xfw.cmd(COMMAND_GETCURRENTSERVER);
        }

        override protected function onDispose():void
        {
            OnlineServers.removeEventListener(update);
            this.removeEventListener(Event.RESIZE, updatePositions);
            super.onDispose();
        }

        // -- Private

        private function currentServerCallback(name:String):void
        {
            currentServer = StringUtils.startsWith(name, "WOT ") ? name.substring(4) : name;
        }

        private function get_x_offset():int
        {
            switch (cfg.hAlign)
            {
                case "center":
                    return (App.appWidth - this.actualWidth) / 2;
                case "right":
                    return App.appWidth - this.actualWidth;
            }
            return 0;
        }

        private function get_y_offset():int
        {
            switch (cfg.vAlign)
            {
                case "center":
                    return (App.appHeight - this.actualHeight) / 2;
                case "bottom":
                    return App.appHeight - this.actualHeight;
            }
            return 0;
        }

        private function updatePositions():void
        {
            if (fields.length == 0)
                return
            for (var i:int = 1; i < fields.length; i++) // make full width
            {
                var currentField:TextField = fields[i];
                var prevField:TextField = fields[i - 1];
                currentField.x = prevField.x + prevField.width + cfg.columnGap;
            }
            // align using new width
            var y_offset:int = get_y_offset();
            fields[0].x = cfg.x + get_x_offset();
            fields[0].y = cfg.y + y_offset;
            for (i = 1; i < fields.length; i++)
            {
                currentField = fields[i];
                prevField = fields[i - 1];
                currentField.x = prevField.x + prevField.width + cfg.columnGap;
                currentField.y = cfg.y + y_offset;
            }
        }

        private function update(e:ObjectEvent):void
        {
            try
            {
                var responseTimeList:Array = e.result as Array;
                if (responseTimeList.length == 0)
                    return;
                clearAllFields();
                for (var i:int = 0; i < responseTimeList.length; ++i)
                    appendRowToFields(makeStyledRow(responseTimeList[i]));
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        /**
         * Each update data is obsolete.
         * Content is erased, but empty fields remain.
         */
        private function clearAllFields():void
        {
            for each (var tf:TextField in fields)
                tf.htmlText = "";
        }

        private function appendRowToFields(row:String):void
        {
            var tf:TextField = getReceiverField();
            tf.htmlText += row;
            updatePositions();
        }

        private function makeStyledRow(onlineObj:Object):String
        {
            var cluster:String = onlineObj.cluster;
            var people_online:String = onlineObj.people_online;
            var raw:String = "";
            var isTitle:Boolean = (cluster == "###best_online###");
            //deal with title and values
            if (isTitle)
                cluster = Locale.get("Online")
            else
            {
                if (isNaN(parseInt(people_online))) //not number
                    raw = people_online;
                else
                    raw = String(Math.round(parseInt(people_online) / 1000)) + "k";
                if (raw != "...")
                    while (raw.length < cfg.minimalValueLength) //left pad the value for minimal length
                        raw = " " + raw;
            }
            while (cluster.length < cfg.minimalNameLength) //left pad the value for minimal length
                cluster = cluster + " ";
            //put everything together: server + delimiter + padded value
            if ((cfg.showServerName && !isTitle) || people_online == "..." || (cfg.showTitle && isTitle))
                if (!isNaN(serverColor) && people_online != "...")
                    raw = "<span class='" + STYLE_NAME_PREFIX + SERVER_COLOR + "'>" + cluster + cfg.delimiter + "</span>" + raw;
                else
                    raw = cluster + cfg.delimiter + raw;
            //mark current server
            if (onlineObj.cluster == currentServer && cfg.fontStyle.markCurrentServer != "none")
                raw = "<span class='" + STYLE_NAME_PREFIX + CURRENT_SERVER + "'>" + raw + "</span>";
            return "<textformat leading='" + cfg.leading + "'><span class='" + STYLE_NAME_PREFIX + defineQuality(people_online) + "'>" + raw + "</span></textformat>";
        }

        private function defineQuality(people_online_str:String):String
        {
            var people_online:Number = parseInt(people_online_str);
            if (isNaN(people_online))
                return QUALITY_BAD;
            if (people_online < cfg.threshold[QUALITY_POOR])
                return QUALITY_BAD;
            if (people_online < cfg.threshold[QUALITY_GOOD])
                return QUALITY_POOR;
            if (people_online < cfg.threshold[QUALITY_GREAT])
                return QUALITY_GOOD;
            return QUALITY_GREAT;
        }

        /**
         * Defines which field is appropriate for data apeend.
         * If there is no such field then create one.
         */
        private function getReceiverField():TextField
        {
            var firstNotFullField:TextField = getFirstNotFullField();
            return  firstNotFullField || createNewField();
        }

        /**
         * Align colums so they do not overlap each other.
        public function alignFields():void
        {
            for (var i:int = 1; i < fields.length; i++)
            {
                var currentField:TextField = fields[i];
                var prevField:TextField = fields[i - 1];
                currentField.x = prevField.x + prevField.width + cfg.columnGap;
            }
        }
         */

        // -- Private

        private function getFirstNotFullField():TextField
        {
            for (var i:int = 0; i < fields.length; i++)
            {
                var field:TextField = fields[i];
                if (field.htmlText == "" || field.numLines < cfg.maxRows)
                {
                    return field;
                }
            }

            return null;
        }

        private function createNewField():TextField
        {
            //Logger.add("createNewField()");
            var newFieldNum:int = fields.length + 1;
            var newField:TextField = createField(newFieldNum);
            fields.push(newField);
            return fields[fields.length - 1];
        }

        public function createField(num:int):TextField
        {
            var tf:TextField = new TextField();
            tf.name = "tfOnline" + num;
            tf.x = cfg.x + get_x_offset();
            tf.y = cfg.y + get_y_offset();
            tf.width = 200;
            tf.height = 200;
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.multiline = true;
            tf.wordWrap = false;
            tf.selectable = false;
            tf.mouseEnabled = false;
            tf.styleSheet = WGUtils.createStyleSheet(createCss());
            tf.alpha = cfg.alpha / 100.0;
            tf.htmlText =  "";
            tf.filters = Utils.createShadowFiltersFromConfig(cfg.shadow);
            addChild(tf);
            return tf;
        }

        // -- Private

        private function createCss():String
        {
            var css:String = "";
            css += createQualityCss(OnlineServersView.QUALITY_GREAT);
            css += createQualityCss(OnlineServersView.QUALITY_GOOD);
            css += createQualityCss(OnlineServersView.QUALITY_POOR);
            css += createQualityCss(OnlineServersView.QUALITY_BAD);
            css += createCurrentServerCss();
            if (!isNaN(serverColor))
                css += createServerColorCss();

            return css;
        }

        private function createQualityCss(quality:String):String
        {
            var size:Number = cfg.fontStyle.size;
            var bold:Boolean = cfg.fontStyle.bold;
            var italic:Boolean = cfg.fontStyle.italic;
            var name:String = cfg.fontStyle.name;
            var color:Number = parseInt(cfg.fontStyle.color[quality], 16);

            return WGUtils.createCSS(OnlineServersView.STYLE_NAME_PREFIX + quality, color, name, size, "left", bold, italic);
        }

        private function createCurrentServerCss():String
        {
            var css_string:String = "." + STYLE_NAME_PREFIX + CURRENT_SERVER + " {";
            if(cfg.fontStyle.markCurrentServer == "bold" || cfg.fontStyle.markCurrentServer == "normal")
                css_string += "font-weight: " + cfg.fontStyle.markCurrentServer + ";"
            if(cfg.fontStyle.markCurrentServer == "italic" || cfg.fontStyle.markCurrentServer == "normal")
                css_string += "font-style: " + cfg.fontStyle.markCurrentServer + ";"
            if (cfg.fontStyle.markCurrentServer == "underline")
                css_string += "text-decoration: underline;"
            css_string += "}";
            return css_string;
        }

        private function createServerColorCss():String
        {
            return "." + STYLE_NAME_PREFIX + SERVER_COLOR + " {color:" + XfwUtils.toHtmlColor(serverColor) + "};"
        }
    }
}