/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package xvm.battleloading_ui.components
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xfw.events.*;
    import com.xvm.vo.*;
    import com.xvm.lobby.vo.*;
    import com.xvm.types.stat.*;
    import com.xvm.types.cfg.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import net.wg.gui.events.*;
    import net.wg.gui.lobby.battleloading.*;
    import net.wg.gui.lobby.battleloading.vo.*;
    import scaleform.gfx.*;
    import xvm.battleloading_ui.*;

    public class BattleLoadingItemRenderer
    {
        public static const PROXY_TYPE_TABLE:String = "table";
        public static const PROXY_TYPE_TIPS:String = "tips";

        private static const NAME_FIELD_WIDTH_DELTA_TABLE:int = 100;
        private static const NAME_FIELD_WIDTH_DELTA_TIPS:int = 40;
        private static const VEHICLE_FIELD_WIDTH_TABLE:int = 250;
        private static const VEHICLE_FIELD_WIDTH_TIPS:int = 100;
        private static const VEHICLE_TYPE_ICON_WIDTH:Number = 25;
        private static const MAXIMUM_VEHICLE_ICON_WIDTH:int = 80;

        private var proxy:PlayerItemRenderer;
        private var proxyType:String;

        private var _model:VehicleInfoVO;

        private var _vehicleIconLoaded:Boolean = false;

        private var squad_x:Number;
        private var textField_x:Number;
        private var textField_width:Number;
        private var vehicleIconLoader_x:Number;
        private var vehicleLevelIcon_x:Number;
        private var vehicleTypeIcon_x:Number;


        // for debug
        public function _debug():void
        {
            setInterval(function():void {
                _model.vehicleStatus = 3;
                proxy.setData(_model);
            }, 1000);
        }

        public function BattleLoadingItemRenderer(proxy:PlayerItemRenderer, proxyType:String)
        {
            this.proxy = proxy;
            this.proxyType = proxyType;

            if (Macros.GlobalBoolean(cfg.nameFieldShowBorder, false))
            {
                proxy.textField.border = true;
                proxy.textField.borderColor = 0x00FF00;
            }

            if (Macros.GlobalBoolean(cfg.vehicleFieldShowBorder, false))
            {
                proxy.vehicleField.border = true;
                proxy.vehicleField.borderColor = 0xFFFF00;
            }

            //_debug();
        }

        public function configUI():void
        {
            proxy.vehicleIconLoader.addEventListener(UILoaderEvent.COMPLETE, onVehicleIconLoadComplete);

            // Load battle stat
            Stat.instance.addEventListener(Stat.COMPLETE_BATTLE, onStatLoaded)
            if (Stat.battleStatLoaded)
            {
                onStatLoaded(null);
            }

            // fix bad align in 0.9.9, 0.9.10
            var dx:int = team == XfwConst.TEAM_ALLY ? 23 : -20;
            proxy.vehicleIconLoader.x += dx;
            proxy.vehicleLevelIcon.x += dx;
            proxy.vehicleTypeIcon.x += dx;

            // Setup controls

            // setup vehicle field
            TextFieldEx.setVerticalAlign(proxy.vehicleField, TextFieldAutoSize.CENTER);
            TextFieldEx.setVerticalAutoSize(proxy.vehicleField, TextFieldAutoSize.CENTER);
            proxy.vehicleField.condenseWhite = true;
            proxy.vehicleField.scaleX = 1;
            proxy.vehicleField.width = getVehicleFieldWidth();

            proxy.vehicleIconLoader.autoSize = false;

            var textFieldWidthDelta:int = getNameFieldWidthDelta();

            textField_width = proxy.textField.width + textFieldWidthDelta;

            if (team == XfwConst.TEAM_ALLY)
            {
                squad_x = proxy.squad.x + Macros.GlobalNumber(cfg.squadIconOffsetXLeft, 0);
                textField_x = proxy.textField.x + Macros.GlobalNumber(cfg.nameFieldOffsetXLeft, 0);
                var vehicleIconOffsetXLeft:Number = Macros.GlobalNumber(cfg.vehicleIconOffsetXLeft, 0);
                vehicleIconLoader_x = proxy.vehicleIconLoader.x + vehicleIconOffsetXLeft;
                vehicleLevelIcon_x = proxy.vehicleLevelIcon.x + vehicleIconOffsetXLeft;
                vehicleTypeIcon_x = proxy.vehicleTypeIcon.x + vehicleIconOffsetXLeft;
            }
            else
            {
                squad_x = proxy.squad.x - Macros.GlobalNumber(cfg.squadIconOffsetXRight, 0);
                textField_x = proxy.textField.x - Macros.GlobalNumber(cfg.nameFieldOffsetXRight, 0) - textFieldWidthDelta;
                var vehicleIconOffsetXRight:Number = Macros.GlobalNumber(cfg.vehicleIconOffsetXRight, 0);
                vehicleIconLoader_x = proxy.vehicleIconLoader.x - vehicleIconOffsetXRight;
                vehicleLevelIcon_x = proxy.vehicleLevelIcon.x - vehicleIconOffsetXRight;
                vehicleTypeIcon_x = proxy.vehicleTypeIcon.x - vehicleIconOffsetXRight;
            }
        }

        public function onDispose():void
        {
            proxy.vehicleIconLoader.removeEventListener(UILoaderEvent.COMPLETE, onVehicleIconLoadComplete);
        }

        public function fixData(data:VehicleInfoVO):Object
        {
            if (data != null)
            {
                try
                {
                    _model = data;

                    var fullPlayerName:String = App.utils.commons.getFullPlayerName(
                        App.utils.commons.getUserProps(_model.playerName, _model.clanAbbrev, _model.region, _model.igrType));
                    var vdata:VOVehicleData = VehicleInfo.getByIcon(_model.vehicleIcon);
                    Macros.RegisterMinimalMacrosData(_model.accountDBID, fullPlayerName, vdata.vehCD, team == XfwConst.TEAM_ALLY);

                    // Alternative icon set
                    if (!proxy.vehicleIconLoader.sourceAlt || proxy.vehicleIconLoader.sourceAlt == Defines.WG_CONTOUR_ICON_NOIMAGE)
                    {
                        proxy.vehicleIconLoader.sourceAlt = Defines.WG_CONTOUR_ICON_PATH + vdata.sysname + ".png";
                        _model.vehicleIcon = _model.vehicleIcon.replace(Defines.WG_CONTOUR_ICON_PATH,
                            Defines.XVMRES_ROOT + ((team == XfwConst.TEAM_ALLY)
                            ? Config.config.iconset.battleLoadingAlly
                            : Config.config.iconset.battleLoadingEnemy));
                    }
                    else
                    {
                        _model.vehicleIcon = proxy.vehicleIconLoader.source;
                    }
                }
                catch (ex:Error)
                {
                    Logger.err(ex);
                }
            }
            else
            {
                _model = null;
            }

            return _model;
        }

        public function draw():void
        {
            try
            {
                if (_model != null && proxy.initialized)
                {
                    var options:VOLobbyMacrosOptions = new VOLobbyMacrosOptions();
                    options.vehicleStatus = _model.vehicleStatus;
                    options.playerStatus = _model.playerStatus;
                    options._isSelected = _model.isCurrentPlayer;
                    options._isCurrentPlayer = _model.isCurrentPlayer;
                    options._isSquadPersonal = _model.isCurrentSquad;
                    options._squadIndex = _model.squadIndex;
                    options._position = proxy.index + 1;

                    // ClanIcon
                    attachClanIconToPlayer();

                    var isIconHighlighted:Boolean = App.colorSchemeMgr != null && (!Macros.GlobalBoolean(cfg.darkenNotReadyIcon) || proxy.enabled) && options.isAlive;

                    proxy.vehicleIconLoader.transform.colorTransform =
                        App.colorSchemeMgr.getScheme(isIconHighlighted ? "normal" : "normal_dead").colorTransform;

                    // controls visibility
                    if (Macros.GlobalBoolean(cfg.removeSquadIcon))
                        proxy.squad.visible = false;
                    if (Macros.GlobalBoolean(cfg.removeVehicleLevel))
                        proxy.vehicleLevelIcon.visible = false;
                    if (Macros.GlobalBoolean(cfg.removeVehicleTypeIcon))
                        proxy.vehicleTypeIcon.visible = false;

                    // fields x positions
                    proxy.squad.x = squad_x;
                    proxy.textField.x = textField_x;
                    proxy.textField.width = textField_width;
                    proxy.vehicleIconLoader.x = vehicleIconLoader_x;
                    proxy.vehicleLevelIcon.x = vehicleLevelIcon_x;
                    proxy.vehicleTypeIcon.x = vehicleTypeIcon_x;

                    // vehicleField
                    if (team == XfwConst.TEAM_ALLY)
                    {
                        proxy.vehicleField.x = proxy.vehicleIconLoader.x - getVehicleFieldWidth();
                        if (Macros.GlobalBoolean(cfg.removeVehicleTypeIcon))
                        {
                            if (proxyType == PROXY_TYPE_TIPS)
                            {
                                proxy.vehicleField.width = getVehicleFieldWidth() + VEHICLE_TYPE_ICON_WIDTH - 5;
                                proxy.vehicleField.x += 5 - VEHICLE_TYPE_ICON_WIDTH;
                            }
                        }
                        else
                        {
                            if (proxyType == PROXY_TYPE_TIPS)
                            {
                                proxy.vehicleField.x += 5 - VEHICLE_TYPE_ICON_WIDTH;
                            }
                            else
                            {
                                proxy.vehicleField.x += -2 - VEHICLE_TYPE_ICON_WIDTH;
                            }
                        }
                        proxy.vehicleField.x += Macros.GlobalNumber(cfg.vehicleFieldOffsetXLeft, 0);
                    }
                    else
                    {
                        proxy.vehicleField.x = proxy.vehicleIconLoader.x + (proxy.vehicleIconLoader.scaleX < 0 ? MAXIMUM_VEHICLE_ICON_WIDTH : 0);
                        if (Macros.GlobalBoolean(cfg.removeVehicleTypeIcon))
                        {
                            if (proxyType == PROXY_TYPE_TIPS)
                            {
                                proxy.vehicleField.width = getVehicleFieldWidth() + VEHICLE_TYPE_ICON_WIDTH - 7;
                            }
                        }
                        else
                        {
                            if (proxyType == PROXY_TYPE_TIPS)
                            {
                                proxy.vehicleField.x += VEHICLE_TYPE_ICON_WIDTH - 7;
                            }
                            else
                            {
                                proxy.vehicleField.x += VEHICLE_TYPE_ICON_WIDTH + 2;
                            }
                        }
                        proxy.vehicleField.x -= Macros.GlobalNumber(cfg.vehicleFieldOffsetXRight, 0);
                    }

                    // Set Text Fields
                    var textFieldColorString:String = proxy.textField.htmlText.match(/ COLOR="(#[0-9A-F]{6})"/)[1];

                    var nickFieldText:String = Macros.Format(_model.playerName, team == XfwConst.TEAM_ALLY
                        ? cfg.formatLeftNick : cfg.formatRightNick, options);
                    proxy.textField.htmlText = "<font color='" + textFieldColorString + "'>" + nickFieldText + "</font>";

                    var vehicleFieldText:String = Macros.Format(_model.playerName, team == XfwConst.TEAM_ALLY
                        ? cfg.formatLeftVehicle : cfg.formatRightVehicle, options);
                    proxy.vehicleField.htmlText = "<font color='" + textFieldColorString + "'>" + vehicleFieldText + "</font>";
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        // PRIVATE

        private function get team():int
        {
            return (proxy is UI_LeftItemRendererTable || proxy is UI_LeftItemRendererTips) ? XfwConst.TEAM_ALLY : XfwConst.TEAM_ENEMY;
        }

        private function getNameFieldWidthDelta():int
        {
            var w:Number =  (proxyType == PROXY_TYPE_TABLE) ? NAME_FIELD_WIDTH_DELTA_TABLE : NAME_FIELD_WIDTH_DELTA_TIPS;
            if (team == XfwConst.TEAM_ALLY)
            {
                w += Macros.GlobalNumber(cfg.nameFieldWidthDeltaLeft, 0);
            }
            else
            {
                w += Macros.GlobalNumber(cfg.nameFieldWidthDeltaRight, 0);
            }
            return w;
        }

        private function getVehicleFieldWidth():int
        {
            var w:Number = (proxyType == PROXY_TYPE_TABLE) ? VEHICLE_FIELD_WIDTH_TABLE : VEHICLE_FIELD_WIDTH_TIPS;
            if (team == XfwConst.TEAM_ALLY)
            {
                w += Macros.GlobalNumber(cfg.vehicleFieldWidthDeltaLeft, 0);
            }
            else
            {
                w += Macros.GlobalNumber(cfg.vehicleFieldWidthDeltaRight, 0);
            }
            return w;
        }

        private function get cfg():CBattleLoading
        {
            return proxyType == PROXY_TYPE_TABLE ? Config.config.battleLoading : Config.config.battleLoadingTips;
        }

        private function onVehicleIconLoadComplete(e:UILoaderEvent):void
        {
            //Logger.add("onVehicleIconLoadComplete: " + _model.playerName);

            try
            {
                // disable icons mirroring (for alternative icons)
                if (!_vehicleIconLoaded)
                {
                    if (Config.config.battle.mirroredVehicleIcons == false && team == XfwConst.TEAM_ENEMY)
                    {
                        vehicleIconLoader_x -= MAXIMUM_VEHICLE_ICON_WIDTH;
                        vehicleLevelIcon_x -= 40;
                    }
                }

                _vehicleIconLoaded = true;

                if (Config.config.battle.mirroredVehicleIcons == false && team == XfwConst.TEAM_ENEMY)
                {
                    proxy.vehicleIconLoader.scaleX = -Math.abs(proxy.vehicleIconLoader.scaleX);
                    proxy.vehicleIconLoader.x = vehicleIconLoader_x;
                    proxy.vehicleLevelIcon.x = vehicleLevelIcon_x;
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        private function onStatLoaded(e:ObjectEvent):void
        {
            //Logger.add("onStatLoaded: " + _model.playerName);
            proxy.vehicleField.condenseWhite = false;
            if (_model != null && proxy.initialized)
                proxy.invalidate();
        }

        private var _clanIconLoaded:Boolean = false;
        private function attachClanIconToPlayer():void
        {
            if (_clanIconLoaded)
                return;

            if (!Macros.GlobalBoolean(cfg.clanIcon.show))
                return;

            var statData:StatData = Stat.battleStat[_model.playerName];
            if (statData == null)
                return;

            _clanIconLoaded = true;

            var icon:ClanIcon = new ClanIcon(cfg.clanIcon, proxy.vehicleIconLoader.x, proxy.vehicleIconLoader.y, team,
                _model.accountDBID,
                _model.playerName,
                _model.clanAbbrev,
                statData.x_emblem);
            icon.addEventListener(Event.COMPLETE, function():void
            {
                // don't add empty icons to the form
                if (icon.source == "")
                    return;

                // unpredictable effects appear when added to the renderer item because of scaleXY.
                // add to the main form, that is not scaled, and adjust XY values.
                proxy.parent.parent.parent.addChild(icon);
                var offset:int = 0;
                if (_vehicleIconLoaded && Config.config.battle.mirroredVehicleIcons == false && team == XfwConst.TEAM_ENEMY)
                    offset = MAXIMUM_VEHICLE_ICON_WIDTH;
                icon.x += proxy.parent.parent.x + proxy.parent.x + proxy.x + offset;
                icon.y += proxy.parent.parent.y + proxy.parent.y + proxy.y;
            });
        }
    }

}

/*
_model: { // net.wg.gui.lobby.battleloading.vo::VehicleInfoVO
  "isFallout": false,
  "vLevel": 10,
  "teamColor": "red",
  "vehicleType": "SPG",
  "points": 0,
  "isPlayerTeam": false,
  "isCurrentSquad": false,
  "isCurrentPlayer": false,
  "region": null,
  "clanAbbrev": "OTMK",
  "igrType": 0,
  "playerName": "Chaoticpie_US",
  "vehicleGuiName": "ConquerorGC",
  "vehicleName": "ConquerorGC",
  "vehicleIcon": "../maps/icons/vehicle/contour/uk-GB31_Conqueror_Gun.png",
  "vehicleAction": 0,
  "squadIndex": 0,
  "playerStatus": 0,
  "vehicleStatus": 3,
  "prebattleID": 0,
  "vehicleID": 4633566,
  "isSpeaking": false,
  "isMuted": false,
  "accountDBID": 1011569697
}
*/
