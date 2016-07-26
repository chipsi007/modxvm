﻿/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.battle.fullStats
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.battle.*;
    import com.xvm.battle.events.*;
    import com.xvm.battle.vo.*;
    import com.xvm.types.cfg.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import net.wg.data.constants.*;
    import net.wg.gui.battle.components.*;
    import net.wg.gui.battle.random.views.stats.components.fullStats.constants.*;
    import net.wg.gui.battle.random.views.stats.components.fullStats.tableItem.*;
    import net.wg.gui.battle.views.stats.*;
    import net.wg.gui.battle.views.stats.constants.*;
    import net.wg.infrastructure.interfaces.*;
    import scaleform.gfx.*;

    public class StatsTableItemXvm extends StatsTableItem
    {
        private static const FIELD_HEIGHT:int = 26;
        private static const ICONS_AREA_WIDTH:int = 80;

        private static const INVALIDATE_PLAYER_STATE:uint = 1 << 15;

        private var DEFAULT_PLAYER_NAME_X:Number;
        private var DEFAULT_PLAYER_NAME_WIDTH:Number;
        private var DEFAULT_VEHICLE_NAME_X:Number;
        private var DEFAULT_VEHICLE_NAME_WIDTH:Number;
        private var DEFAULT_FRAGS_X:Number;
        private var DEFAULT_FRAGS_WIDTH:Number;
        private var DEFAULT_VEHICLE_ICON_X:Number;
        private var DEFAULT_VEHICLE_TYPE_ICON_X:Number;

        private var cfg:CStatisticForm;

        private var _isLeftPanel:Boolean;
        private var _playerNameTF:TextField;
        private var _vehicleNameTF:TextField;
        private var _fragsTF:TextField;
        private var _vehicleIcon:BattleAtlasSprite;
        private var _vehicleLevelIcon:BattleAtlasSprite;
        private var _vehicleTypeIcon:BattleAtlasSprite;
        private var _icoIGR:BattleAtlasSprite;
        private var _isIGR:Boolean = false;

        private var _vehicleID:Number = NaN;
        private var _vehicleIconName:String = null;

        public function StatsTableItemXvm(isLeftPanel:Boolean, playerNameTF:TextField, vehicleNameTF:TextField, fragsTF:TextField, deadBg:BattleAtlasSprite,
            vehicleTypeIcon:BattleAtlasSprite, icoIGR:BattleAtlasSprite, vehicleIcon:BattleAtlasSprite, vehicleLevelIcon:BattleAtlasSprite,
            muteIcon:BattleAtlasSprite, speakAnimation:SpeakAnimation, vehicleActionIcon:BattleAtlasSprite, playerStatus:PlayerStatusView)
        {
            //Logger.add("StatsTableItemXvm");
            super(playerNameTF, vehicleNameTF, fragsTF, deadBg, vehicleTypeIcon, icoIGR, vehicleIcon, vehicleLevelIcon, muteIcon, speakAnimation, vehicleActionIcon, playerStatus);

            _isLeftPanel = isLeftPanel;
            _playerNameTF = playerNameTF;
            _vehicleNameTF = vehicleNameTF;
            _icoIGR = icoIGR;
            _fragsTF = fragsTF;
            _vehicleIcon = vehicleIcon;
            _vehicleLevelIcon = vehicleLevelIcon;
            _vehicleTypeIcon = vehicleTypeIcon;

            DEFAULT_PLAYER_NAME_X = playerNameTF.x;
            DEFAULT_PLAYER_NAME_WIDTH = playerNameTF.width;
            DEFAULT_VEHICLE_NAME_X = vehicleNameTF.x;
            DEFAULT_VEHICLE_NAME_WIDTH = vehicleNameTF.width;
            DEFAULT_FRAGS_X = fragsTF.x;
            DEFAULT_FRAGS_WIDTH = fragsTF.width;
            DEFAULT_VEHICLE_ICON_X = vehicleIcon.x;
            DEFAULT_VEHICLE_TYPE_ICON_X = vehicleTypeIcon.x;

            // align fields
            fragsTF.y -= 1;
            fragsTF.scaleX = fragsTF.scaleY = 1;
            fragsTF.height = FIELD_HEIGHT;
            TextFieldEx.setVerticalAlign(fragsTF, TextFieldEx.VALIGN_CENTER);

            playerNameTF.y = fragsTF.y;
            playerNameTF.scaleX = playerNameTF.scaleY = 1;
            playerNameTF.height = FIELD_HEIGHT;
            TextFieldEx.setVerticalAlign(playerNameTF, TextFieldEx.VALIGN_CENTER);

            vehicleNameTF.y = fragsTF.y;
            vehicleNameTF.scaleX = vehicleNameTF.scaleY = 1;
            vehicleNameTF.height = FIELD_HEIGHT;
            TextFieldEx.setVerticalAlign(vehicleNameTF, TextFieldEx.VALIGN_CENTER);

            Xvm.addEventListener(Defines.XVM_EVENT_CONFIG_LOADED, setup);
            Xvm.addEventListener(PlayerStateEvent.CHANGED, onPlayerStateChanged);
            Xvm.addEventListener(Defines.XVM_EVENT_ATLAS_LOADED, onAtlasLoaded);
            Xfw.addCommandListener(XvmCommands.AS_ON_CLAN_ICON_LOADED, onClanIconLoaded);
            Stat.instance.addEventListener(Stat.COMPLETE_BATTLE, onStatLoaded)

            setup();
        }

        override protected function onDispose():void
        {
            Xvm.removeEventListener(Defines.XVM_EVENT_CONFIG_LOADED, setup);
            Xvm.removeEventListener(PlayerStateEvent.CHANGED, onPlayerStateChanged);
            Xvm.removeEventListener(Defines.XVM_EVENT_ATLAS_LOADED, onAtlasLoaded);
            Xfw.removeCommandListener(XvmCommands.AS_ON_CLAN_ICON_LOADED, onClanIconLoaded);
            Stat.instance.removeEventListener(Stat.COMPLETE_BATTLE, onStatLoaded)
            super.onDispose();
        }

        override public function setPlayerName(userProps:IUserProps):void
        {
            super.setPlayerName(userProps);
            _vehicleID = BattleState.getVehicleID(userProps.userName);
        }

        override public function setIsIGR(isIGR:Boolean):void
        {
            _isIGR = isIGR;
        }

        override public function setVehicleIcon(vehicleIconName:String):void
        {
            super.setVehicleIcon(vehicleIconName);
            if (_vehicleIconName != vehicleIconName)
            {
                _vehicleIconName = vehicleIconName;
            }
        }

        override protected function draw():void
        {
            super.draw();

            var updatePlayerNameField:Boolean = false;
            var updateVehicleNameField:Boolean = false;
            var updateFragsField:Boolean = false;
            var updateVehicleIcon:Boolean = false;
            var updateIgr:Boolean = false;
            var needAlign:Boolean = false;

            if (isInvalid(FullStatsValidationType.USER_PROPS))
            {
                updatePlayerNameField = true;
            }
            if (isInvalid(FullStatsValidationType.VEHICLE_NAME))
            {
                updateVehicleNameField = true;
                updateIgr = true;
            }
            if(isInvalid(RandomFullStatsValidationType.VEHICLE_ICON))
            {
                if (this._vehicleIconName)
                {
                    updateVehicleIcon = true;
                }
            }
            if (isInvalid(FullStatsValidationType.FRAGS))
            {
                updateFragsField = true;
            }
            if (isInvalid(FullStatsValidationType.IS_IGR))
            {
                updateIgr = true;
                needAlign = true;
            }
            if (isInvalid(INVALIDATE_PLAYER_STATE) || isInvalid(FullStatsValidationType.COLORS))
            {
                updatePlayerNameField = true;
                updateVehicleNameField = true;
                updateFragsField = true;
            }

            if (updatePlayerNameField || updateVehicleNameField || updateFragsField)
            {
                var playerState:VOPlayerState = BattleState.get(_vehicleID);
                if (playerState)
                {
                    if (updatePlayerNameField)
                    {
                        _playerNameTF.visible = true;
                        _playerNameTF.htmlText = Macros.FormatString(_isLeftPanel ? cfg.formatLeftNick : cfg.formatRightNick, playerState);
                    }
                    if (updateVehicleNameField)
                    {
                        _vehicleNameTF.visible = true;
                        _vehicleNameTF.htmlText = Macros.FormatString(_isLeftPanel ? cfg.formatLeftVehicle : cfg.formatRightVehicle, playerState);
                    }
                    if (updateFragsField)
                    {
                        _fragsTF.visible = true;
                        _fragsTF.htmlText = Macros.FormatString(_isLeftPanel ? cfg.formatLeftFrags : cfg.formatRightFrags, playerState);
                    }
                }
            }
            if (updateVehicleIcon)
            {
                var atlasName:String = _isLeftPanel ? UI_FullStats.leftAtlas : UI_FullStats.rightAtlas;
                if (!App.atlasMgr.isAtlasInitialized(atlasName))
                {
                    atlasName = AtlasConstants.BATTLE_ATLAS;
                }
                _vehicleIcon.graphics.clear();
                App.atlasMgr.drawGraphics(atlasName, BattleAtlasItem.getVehicleIconName(_vehicleIconName), _vehicleIcon.graphics, BattleAtlasItem.VEHICLE_TYPE_UNKNOWN);
            }
            if (updateIgr)
            {
                if (_isIGR)
                {
                    if (_isLeftPanel)
                    {
                        var bounds:Rectangle = _vehicleNameTF.getCharBoundaries(0);
                        _icoIGR.x = _vehicleNameTF.x + (bounds ? bounds.x : 0) - this._icoIGR.width >> 0;
                    }
                    else
                    {
                        _icoIGR.x = this._vehicleNameTF.x - this._icoIGR.width >> 0;
                    }
                }
            }
        }

        // XVM events handlers

        private function setup():void
        {
            cfg = Config.config.statisticForm;

            if (cfg.removeVehicleLevel)
            {
                _vehicleLevelIcon.alpha = 0;
            }

            if (cfg.removeVehicleTypeIcon)
            {
                _vehicleTypeIcon.alpha = 0;
            }

            if (cfg.nameFieldShowBorder)
            {
                _playerNameTF.border = true;
                _playerNameTF.borderColor = 0x00FF00;
            }

            if (cfg.vehicleFieldShowBorder)
            {
                _vehicleNameTF.border = true;
                _vehicleNameTF.borderColor = 0xFFFF00;
            }

            if (cfg.fragsFieldShowBorder)
            {
                _fragsTF.border = true;
                _fragsTF.borderColor = 0xFF0000;
            }

            if (!_isLeftPanel)
            {
                if (Config.config.battle.mirroredVehicleIcons)
                {
                    _vehicleIcon.scaleX = 1;
                }
                else
                {
                    _vehicleIcon.scaleX = -1;
                }
            }

            alignTextFields();
        }

        private function onPlayerStateChanged(e:PlayerStateEvent):void
        {
            invalidate(INVALIDATE_PLAYER_STATE);
        }

        private function onAtlasLoaded(e:Event):void
        {
            invalidate(RandomFullStatsValidationType.VEHICLE_ICON);
        }

        private function onClanIconLoaded(vehicleID:Number, playerName:String):void
        {
            invalidate(INVALIDATE_PLAYER_STATE);
        }

        private function onStatLoaded():void
        {
            // TODO if (_vehicleID in updatedPlayers)
            invalidate(INVALIDATE_PLAYER_STATE);
        }

        // PRIVATE

        private function alignTextFields():void
        {
            if (_isLeftPanel)
            {
                _playerNameTF.x = DEFAULT_PLAYER_NAME_X + cfg.nameFieldOffsetXLeft;
                _playerNameTF.width = cfg.nameFieldWidthLeft;
                _vehicleNameTF.x = DEFAULT_VEHICLE_NAME_X + cfg.vehicleFieldOffsetXLeft + (DEFAULT_VEHICLE_NAME_WIDTH - cfg.vehicleFieldWidthLeft);
                _vehicleNameTF.width = cfg.vehicleFieldWidthLeft;
                _fragsTF.x = DEFAULT_FRAGS_X + cfg.fragsFieldOffsetXLeft + (DEFAULT_FRAGS_WIDTH - cfg.fragsFieldWidthLeft) / 2;
                _fragsTF.width = cfg.fragsFieldWidthLeft;
                _vehicleIcon.x = DEFAULT_VEHICLE_ICON_X + cfg.vehicleIconOffsetXLeft;
                _vehicleTypeIcon.x = DEFAULT_VEHICLE_TYPE_ICON_X + cfg.vehicleIconOffsetXLeft;
            }
            else
            {
                _playerNameTF.x = DEFAULT_PLAYER_NAME_X - cfg.nameFieldOffsetXRight + (DEFAULT_PLAYER_NAME_WIDTH - cfg.nameFieldWidthRight);
                _playerNameTF.width = cfg.nameFieldWidthRight;
                _vehicleNameTF.x = DEFAULT_VEHICLE_NAME_X - cfg.vehicleFieldOffsetXRight;
                _vehicleNameTF.width = cfg.vehicleFieldWidthRight;
                _fragsTF.x = DEFAULT_FRAGS_X - cfg.fragsFieldOffsetXRight + (DEFAULT_FRAGS_WIDTH - cfg.fragsFieldWidthRight) / 2;
                _fragsTF.width = cfg.fragsFieldWidthRight;
                if (Config.config.battle.mirroredVehicleIcons)
                {
                    _vehicleIcon.x = DEFAULT_VEHICLE_ICON_X - cfg.vehicleIconOffsetXRight;
                }
                else
                {
                    _vehicleIcon.x = DEFAULT_VEHICLE_ICON_X - cfg.vehicleIconOffsetXRight - ICONS_AREA_WIDTH;
                }
                _vehicleTypeIcon.x = DEFAULT_VEHICLE_TYPE_ICON_X - cfg.vehicleIconOffsetXRight;
            }
        }
    }
}