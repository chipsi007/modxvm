package xvm.hangar.components.BattleLoading
{
    import com.xvm.*;
    import com.xvm.types.MacrosFormatOptions;
    import com.xvm.utils.*;
    import com.xvm.types.cfg.*;
    import com.xvm.types.veh.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    import net.wg.gui.lobby.battleloading.vo.*;
    import scaleform.gfx.*;
    import net.wg.gui.events.*;
    import net.wg.gui.lobby.battleloading.*;
    import xvm.hangar.components.ClanIcon.*;
    import xvm.hangar.UI.battleLoading.*;

    public class BattleLoadingItemRenderer
    {
        private var proxy:PlayerItemRenderer;

        private var fullPlayerName:String = null;

        public function BattleLoadingItemRenderer(proxy:PlayerItemRenderer)
        {
            this.proxy = proxy;

            //setInterval(function():void { proxy.setData(proxy.data) }, 1000); // DEBUG

            proxy.iconLoader.addEventListener(UILoaderEvent.COMPLETE, onVehicleIconLoadComplete);

            // Remove squad icon.
            if (Config.config.battleLoading.removeSquadIcon && proxy.squad != null)
                proxy.squad.visible = false;

            // FIXIT
            //TextFieldEx.setVerticalAlign(proxy.textField,  TextFieldAutoSize.CENTER);
            //TextFieldEx.setVerticalAutoSize(proxy.textField, TextFieldAutoSize.CENTER);

            TextFieldEx.setVerticalAlign(proxy.vehicleField, TextFieldAutoSize.CENTER);
            TextFieldEx.setVerticalAutoSize(proxy.vehicleField, TextFieldAutoSize.CENTER);
            proxy.vehicleField.condenseWhite = true;

            proxy.vehicleField.width += 100;
            proxy.vehicleField.scaleX = 1;
            if (team == Defines.TEAM_ALLY)
                proxy.vehicleField.x -= 103;

            // Add stat loading handler
            Stat.loadBattleStat(this, onStatLoaded);
        }

        public function setData(data:VehicleInfoVO):void
        {
            //Logger.add("setData: " + (data == null ? "(null)" : data.label));
            //Logger.addObject(data);
            try
            {
                if (data == null)
                    return;

                if (fullPlayerName == null)
                {
                    fullPlayerName = App.utils.commons.getFullPlayerName(
                        App.utils.commons.getUserProps(data.playerName, data.clanAbbrev, data.region, data.igrType));
                }

                var vdata:VehicleData = VehicleInfo.getByIcon(data.vehicleIcon);
                Macros.RegisterMinimalMacrosData(data.accountDBID, fullPlayerName, vdata.vid);
                data.playerName = Macros.Format(data.playerName, "{{name}}");
                data.clanAbbrev = Macros.Format(data.playerName, "{{clannb}}");

                // ClanIcon
                attachClanIconToPlayer(data);

                // Alternative icon set
                if (proxy.iconLoader.sourceAlt == Defines.WG_CONTOUR_ICON_NOIMAGE)
                {
                    proxy.iconLoader.sourceAlt = Defines.WG_CONTOUR_ICON_PATH + vdata.sysname + ".png";
                    data.vehicleIcon = data.vehicleIcon.replace(Defines.WG_CONTOUR_ICON_PATH,
                        Defines.XVMRES_ROOT + ((team == Defines.TEAM_ALLY)
                        ? Config.config.iconset.battleLoadingAlly
                        : Config.config.iconset.battleLoadingEnemy));
                }
                else
                {
                    data.vehicleIcon = proxy.iconLoader.source;
                }
            }
            catch (ex:Error)
            {
                Logger.add(ex.getStackTrace());
            }
        }

        private var _savedTextFieldColor:String = null;
        public function draw():void
        {
            try
            {
                var data:VehicleInfoVO = proxy.data as VehicleInfoVO;
                if (data == null)
                    return;

                var isIconHighlighted:Boolean = App.colorSchemeMgr != null && (!Config.config.battleLoading.darkenNotReadyIcon || proxy.enabled);

                proxy.iconLoader.transform.colorTransform =
                        App.colorSchemeMgr.getScheme(isIconHighlighted ? "normal" : "normal_dead").colorTransform;

                var formatOptions:MacrosFormatOptions = new MacrosFormatOptions();
                formatOptions.alive = data.isAlive();
                formatOptions.ready = data.isReady();
                formatOptions.selected = data.isCurrentPlayer;
                formatOptions.isCurrentPlayer = data.isCurrentPlayer;
                formatOptions.isCurrentSquad = data.isCurrentSquad;
                formatOptions.squadIndex = data.squadIndex;
                formatOptions.isTeamKiller = data.isTeamKiller();

                // Set Text Fields
                if (_savedTextFieldColor == null)
                    _savedTextFieldColor = proxy.textField.htmlText.match(/ COLOR="(#[0-9A-F]{6})"/)[1];

                var nickFieldText:String = Macros.Format(WGUtils.GetPlayerName(fullPlayerName), team == Defines.TEAM_ALLY
                    ? Config.config.battleLoading.formatLeftNick : Config.config.battleLoading.formatRightNick, formatOptions);
                proxy.textField.htmlText = "<font color='" + _savedTextFieldColor + "'>" + nickFieldText + "</font>";

                var vehicleFieldText:String = Macros.Format(WGUtils.GetPlayerName(fullPlayerName), team == Defines.TEAM_ALLY
                    ? Config.config.battleLoading.formatLeftVehicle : Config.config.battleLoading.formatRightVehicle, formatOptions);
                proxy.vehicleField.htmlText = "<font color='" + _savedTextFieldColor + "'>" + vehicleFieldText + "</font>";

                //Logger.add(vehicleFieldText);
                //Logger.add(proxy.vehicleField.htmlText);
            }
            catch (ex:Error)
            {
                Logger.add(ex.getStackTrace());
            }
        }

        // PRIVATE

        private function get team():int
        {
            return (proxy is UI_LeftItemRenderer) ? Defines.TEAM_ALLY : Defines.TEAM_ENEMY;
        }

        private var _clanIconLoaded:Boolean = false;
        private function attachClanIconToPlayer(data:VehicleInfoVO):void
        {
            if (_clanIconLoaded)
                return;
            _clanIconLoaded = true;

            var cfg:CClanIcon = Config.config.battleLoading.clanIcon;
            if (!cfg.show)
                return;
            var icon:ClanIcon = new ClanIcon(cfg, proxy.iconLoader.x, proxy.iconLoader.y, team,
                data.accountDBID,
                WGUtils.GetPlayerName(fullPlayerName),
                WGUtils.GetClanNameWithoutBrackets(fullPlayerName));
            icon.addEventListener(Event.COMPLETE, function():void
            {
                // don't add empty icons to the form
                if (icon.source == "")
                    return;

                // unpredictable effects appear when added to the renderer item because of scaleXY.
                // add to the main form, that is not scaled, and adjust XY values.
                proxy.parent.parent.parent.addChild(icon);
                icon.x += proxy.parent.parent.x + proxy.parent.x + proxy.x;
                icon.y += proxy.parent.parent.y + proxy.parent.y + proxy.y;
            });
        }

        private function onVehicleIconLoadComplete(e:UILoaderEvent):void
        {
            //Logger.add("onVehicleIconLoadComplete: " + fullPlayerName);
            // resize icons to avoid invalid resizing of item
            //if (proxy.iconLoader.width > 84 || proxy.iconLoader.height > 24)
            /*if (proxy.iconLoader.height > 24)
            {
                //var c:Number = Math.min(84 / proxy.iconLoader.width, 24 / proxy.iconLoader.height);
                var c:Number = 24 / proxy.iconLoader.height;
                proxy.iconLoader.scaleX = c;
                proxy.iconLoader.scaleY = c;
            }*/

            // crop large icons to avoid invalid resizing of item
            proxy.iconLoader.scrollRect = new Rectangle(0, 0, 84, 24);

            // disable icons mirroring (for alternative icons)
            if (Config.config.battle.mirroredVehicleIcons == false && team == Defines.TEAM_ENEMY)
            {
                proxy.iconLoader.scaleX = -Math.abs(proxy.iconLoader.scaleX);
                proxy.iconLoader.x = 4;
                //Logger.add(proxy.iconLoader.width + "x" + proxy.iconLoader.height);
            }
        }

        private function onStatLoaded():void
        {
            //Logger.add("onStatLoaded: " + fullPlayerName);
            if (Config.networkServicesSettings.servicesActive)
                proxy.vehicleField.condenseWhite = false;
            //draw();
            if (proxy.constraints != null)
                proxy.invalidateData();
        }
    }

}

/*
data: { // net.wg.gui.lobby.battleloading.vo::VehicleInfoVO
  "isPlayerTeam": false,
  "isCurrentSquad": false,
  "isCurrentPlayer": false,
  "region": null,
  "clanAbbrev": "",
  "igrType": 0,
  "playerName": "KKeqpuP4uKK",
  "vehicleName": "Chi-Ni",
  "vehicleIcon": "../../../xvm/res/contour/HARDicons/japan-Chi_Ni.png",
  "vehicleAction": 0,
  "squadIndex": 0,
  "playerStatus": 0,
  "vehicleStatus": 3,
  "prebattleID": 20481354,
  "vehicleID": 23974944,
  "isSpeaking": false,
  "isMuted": false,
  "accountDBID": 5177220
}
*/
