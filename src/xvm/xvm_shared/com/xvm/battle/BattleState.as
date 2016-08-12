﻿/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.battle
{
    import com.xfw.*;
    import com.xfw.events.*;
    import com.xvm.*;
    import com.xvm.battle.events.*;
    import com.xvm.battle.vo.*;
    import com.xvm.types.cfg.*;
    import flash.events.Event;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;

    public class BattleState extends UIComponent // implements IBattleComponentDataController
    {
        public static function get(vehicleID:Number):VOPlayerState
        {
            return instance._playersDataVO ? instance._playersDataVO.get(vehicleID) : null;
        }

        public static function getVehicleID(playerName:String):Number
        {
            return instance._playersDataVO ? instance._playersDataVO.getVehicleID(playerName) : NaN;
        }

        public static function get arenaInfoVO():VOArenaInfo
        {
            return instance._arenaInfoVO;
        }

        public static function get playersDataVO():VOPlayersData
        {
            return instance._playersDataVO;
        }

        private var _captureBarData:VOCaptureBarData = new VOCaptureBarData();

        public static function get captureBarDataVO():VOCaptureBarData
        {
            return instance._captureBarDataVO;
        }

        public static function set captureBarDataVO(value:VOCaptureBarData):void
        {
            instance._captureBarDataVO = value;
        }

        public static function get playerFrags():int
        {
            return instance._playerFrags;
        }

        public static function set playerFrags(value:int):void
        {
            instance._playerFrags = value;
        }

        public static function get currentAimZoom():int
        {
            return instance._currentAimZoom;
        }

        public static function set currentAimZoom(value:int):void
        {
            instance._currentAimZoom = value;
        }

        public static function get hitlogHits():Array
        {
            return instance._hitlogHits;
        }

        public static function get hitlogTotalDamage():int
        {
            return instance._hitlogTotalDamage;
        }

        // instance
        private static var _instance:BattleState = null;
        public static function get instance():BattleState
        {
            if (_instance == null)
            {
                _instance = new BattleState();
            }
            return _instance;
        }

        private var _arenaInfoVO:VOArenaInfo = null;
        private var _playersDataVO:VOPlayersData = null;
        private var _captureBarDataVO:VOCaptureBarData = new VOCaptureBarData();
        private var _personalStatus:uint;
        private var _playerFrags:int = 0;
        private var _currentAimZoom:int = 0;

        private var _invalidationStates:Object = {};

        // .ctor should be private for Singleton
        function BattleState()
        {
            focusable = false;
            visible = false;
            Xfw.addCommandListener(BattleCommands.AS_UPDATE_PLAYER_STATE, onUpdatePlayerState);
            Xfw.addCommandListener(BattleCommands.AS_UPDATE_DEVICE_STATE, onUpdateDeviceState);
        }

        override protected function draw():void
        {
            try
            {
                if (isInvalid(InvalidationType.STATE))
                {
                    if (_playersDataVO)
                    {
                        _playersDataVO.dispatchEvents();
                    }
                }
                if (isInvalid(InvalidationType.DATA))
                {
                    for (var key:String in _invalidationStates)
                    {
                        var playerState:VOPlayerState = get(Number(key));
                        if (playerState)
                        {
                            playerState.dispatchEvents();
                        }
                    }
                    _invalidationStates = {};
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        // IBattleComponentDataController implementation

        public function addVehiclesInfo(data:Object):void
        {
            setVehiclesData(data);
        }

        public function setArenaInfo(data:Object):void
        {
            Xvm.swfProfilerBegin("BattleState.setArenaInfo()");
            try
            {
                _arenaInfoVO = new VOArenaInfo(data);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            finally
            {
                Xvm.swfProfilerEnd("BattleState.setArenaInfo()");
            }
        }

        public function setPersonalStatus(param1:uint):void
        {
            //Logger.add("[BattleState] setPersonalStatus: " + param1);
            try
            {
                _personalStatus = param1;

            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        public function setUserTags(data:Object):void
        {
            updateUserTags(data);
        }

        public function setVehiclesData(data:Object):void
        {
            Xvm.swfProfilerBegin("BattleState.setVehiclesData()");
            try
            {
                if (_playersDataVO == null)
                {
                    _playersDataVO = new VOPlayersData();
                }
                _playersDataVO.updateVehiclesData(data);
                invalidate(InvalidationType.STATE);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            finally
            {
                Xvm.swfProfilerEnd("BattleState.setVehiclesData()");
            }
        }

        public function setVehicleStats(data:Object):void
        {
            updateVehiclesStats(data);
        }

        public function updateInvitationsStatuses(data:Object) : void
        {
            //Logger.addObject(data, 1, "[BattleState] updateInvitationsStatuses");
            try
            {
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        public function updatePersonalStatus(param1:uint, param2:uint):void
        {
            Logger.add("[BattleState] updatePersonalStatus: " + param1 + ", " + param2);
            try
            {
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            /*
            {
                this._allyVehicleMarkersList.isVehicleCounterShown = this._enemyVehicleMarkersList.isVehicleCounterShown = true;
            }
            else if(PersonalStatus.IS_VEHICLE_COUNTER_SHOWN == param2)
            {
                this._allyVehicleMarkersList.isVehicleCounterShown = this._enemyVehicleMarkersList.isVehicleCounterShown = false;
            }
            */
        }

        public function updatePlayerStatus(data:Object):void
        {
            Xvm.swfProfilerBegin("BattleState.updatePlayerStatus()");
            //Logger.addObject(data, 1, "[BattleState] updatePlayerStatus");
            try
            {
                _playersDataVO.updatePlayerState(data.vehicleID, { playerStatus: data.status } );
                invalidate(InvalidationType.STATE);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            finally
            {
                Xvm.swfProfilerEnd("BattleState.updatePlayerStatus()");
            }
        }

        public function updateUserTags(data:Object):void
        {
            try
            {
                _playersDataVO.updateUserTags(data);
                invalidate(InvalidationType.STATE);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        public function updateVehiclesInfo(data:Object):void
        {
            setVehiclesData(data);
        }

        public function updateVehiclesStats(data:Object):void
        {
            Xvm.swfProfilerBegin("BattleState.updateVehiclesStats()");
            //Logger.addObject(data, 1, "[BattleState] updateVehiclesStats");
            try
            {
                if (data.leftFrags)
                {
                    _playersDataVO.updateVehicleFrags(data.leftFrags);
                }
                if (data.rightFrags)
                {
                    _playersDataVO.updateVehicleFrags(data.rightFrags);
                }
                if (data.totalStats)
                {
                    _playersDataVO.updateTotalStats(data.totalStats);
                }
                invalidate(InvalidationType.STATE);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            finally
            {
                Xvm.swfProfilerEnd("BattleState.updateVehiclesStats()");
            }
        }

        public function updateVehicleStatus(data:Object):void
        {
            Xvm.swfProfilerBegin("BattleState.updateVehicleStatus()");
            //Logger.addObject(data, 1, "[BattleState] updateVehicleStatus");
            try
            {
                _playersDataVO.updatePlayerState(data.vehicleID, { vehicleStatus: data.status });
                if (data.rightCorrelationIDs)
                    _playersDataVO.rightCorrelationIDs = Vector.<Number>(data.rightCorrelationIDs);
                if (data.rightVehiclesIDs || data.rightItemsIDs)
                    _playersDataVO.rightVehiclesIDs = Vector.<Number>(data.rightVehiclesIDs || data.rightItemsIDs);
                if (data.leftCorrelationIDs)
                    _playersDataVO.leftCorrelationIDs = Vector.<Number>(data.leftCorrelationIDs);
                if (data.leftVehiclesIDs || data.leftItemsIDs)
                    _playersDataVO.leftVehiclesIDs = Vector.<Number>(data.leftVehiclesIDs || data.leftItemsIDs);
                if (data.totalStats)
                    _playersDataVO.updateTotalStats(data.totalStats);
                invalidate(InvalidationType.STATE);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            finally
            {
                Xvm.swfProfilerEnd("BattleState.updateVehicleStatus()");
            }
        }

        // XVM events

        private function onUpdatePlayerState(vehicleID:Number, data:Object):void
        {
            Xvm.swfProfilerBegin("BattleState.onUpdatePlayerState()");
            try
            {
                var playerState:VOPlayerState = get(vehicleID);
                if (playerState)
                {
                    if (data.__hitlogData)
                    {
                        onUpdateHitlogData(playerState, data.curHealth, data.__hitlogData.damageFlag, data.__hitlogData.damageType);
                        delete data.__hitlogData;
                        playerState.update(data);
                        Xvm.dispatchEvent(new ObjectEvent(BattleEvents.HITLOG_UPDATED, playerState));
                    }
                    else
                    {
                        playerState.update(data);
                    }
                    _invalidationStates[playerState.vehicleID] = true;
                    invalidate(InvalidationType.DATA);
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            finally
            {
                Xvm.swfProfilerEnd("BattleState.onUpdatePlayerState()");
            }
        }

        private function onUpdateDeviceState(moduleName:String, state:String, state2:String):void
        {
            try
            {
                switch (state)
                {
                    case "critical":
                        Xvm.dispatchEvent(new StringEvent(PlayerStateEvent.MODULE_CRITICAL, moduleName));
                        break;
                    case "destroyed":
                        Xvm.dispatchEvent(new StringEvent(PlayerStateEvent.MODULE_DESTROYED, moduleName));
                        break;
                    case "repaired":
                        Xvm.dispatchEvent(new StringEvent(PlayerStateEvent.MODULE_REPAIRED, moduleName));
                        break;
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        // hitlog

        private var _hitlogTotalDamage:int = 0;
        private var _hitlogHits:Array = [];

        private function onUpdateHitlogData(playerState:VOPlayerState, newHealth:Number, damageFlag:int, damageType:String):void
        {
            //Logger.add("[BattleState] onUpdateHitlogData: " + arguments);
            var damage:int = playerState.getCurHealthValue() - Math.max(0, newHealth);

            _hitlogTotalDamage += damage;

            playerState.update( {
                hitlogDamage: playerState.hitlogDamage + damage,
                damageInfo: new VODamageInfo({
                    damageDelta: damage,
                    damageType: damageType,
                    damageFlag: damageFlag
                })
            });

            var lastHit:VOHit = _hitlogHits.length ? _hitlogHits[_hitlogHits.length - 1] : new VOHit();
            if ((damageType == "fire" || damageType == "ramming") && lastHit.vehicleID == playerState.vehicleID && lastHit.damageType == damageType)
            {
                damage += lastHit.damage;
                _hitlogHits.pop();
                playerState.hitlogHits.pop();
            }

            var hitIndex:Number = _hitlogHits.push(new VOHit(playerState.vehicleID, damage, damageType)) - 1;
            playerState.hitlogHits.push(hitIndex);
        }
    }
}
