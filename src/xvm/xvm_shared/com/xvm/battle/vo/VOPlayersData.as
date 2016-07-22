﻿/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.battle.vo
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.vo.*;
    import flash.utils.*;

    public class VOPlayersData
    {
        public var playerStates:Dictionary;

        // DAAPIVehiclesDataVO
        private var _leftCorrelationIDs:Vector.<Number>;
        private var _rightCorrelationIDs:Vector.<Number>;
        private var _leftVehiclesIDs:Vector.<Number>;
        private var _rightVehiclesIDs:Vector.<Number>;

        // DAAPITotalStatsVO
        public var leftScope:int = 0;
        public var rightScope:int = 0;

        public function get leftCorrelationIDs():Vector.<Number>
        {
            return _leftCorrelationIDs;
        }

        public function set leftCorrelationIDs(value:Vector.<Number>):void
        {
            _leftCorrelationIDs = value.concat(); // clone vector
        }

        public function get rightCorrelationIDs():Vector.<Number>
        {
            return _rightCorrelationIDs;
        }

        public function set rightCorrelationIDs(value:Vector.<Number>):void
        {
            _rightCorrelationIDs = value.concat(); // clone vector
        }

        public function get leftVehiclesIDs():Vector.<Number>
        {
            return _leftVehiclesIDs;
        }

        public function set leftVehiclesIDs(value:Vector.<Number>):void
        {
            _leftVehiclesIDs = value.concat(); // clone vector
            updateVehiclesPositionsAndTeam(value, true);
        }

        public function get rightVehiclesIDs():Vector.<Number>
        {
            return _rightVehiclesIDs;
        }

        public function set rightVehiclesIDs(value:Vector.<Number>):void
        {
            _rightVehiclesIDs = value.concat(); // clone vector
            updateVehiclesPositionsAndTeam(value, false);
        }

        // private
        private var playerNameToVehicleIDMap:Dictionary;

        public function VOPlayersData()
        {
            playerStates = new Dictionary();
            playerNameToVehicleIDMap = new Dictionary();
        }

        public function setVehiclesData(data:Object):void
        {
            var value:Object;
            for each (value in data.leftVehicleInfos || data.leftItems)
            {
                addOrUpdatePlayerState(value);
            }
            for each (value in data.rightVehicleInfos || data.rightItems)
            {
                addOrUpdatePlayerState(value);
            }
            leftCorrelationIDs = Vector.<Number>(data.leftCorrelationIDs);
            rightCorrelationIDs = Vector.<Number>(data.rightCorrelationIDs);
            leftVehiclesIDs = Vector.<Number>(data.leftVehiclesIDs || data.leftItemsIDs);
            rightVehiclesIDs = Vector.<Number>(data.rightVehiclesIDs || data.rightItemsIDs);
        }

        public function get(vehicleID:Number):VOPlayerState
        {
            return isNaN(vehicleID) ? null : playerStates[vehicleID];
        }

        public function getVehicleID(playerName:String):Number
        {
            return playerName ? playerNameToVehicleIDMap[playerName] : NaN;
        }

        public function updatePlayerState(vehicleID:Number, data:Object):void
        {
            var playerState:VOPlayerState = get(vehicleID);
            if (playerState)
            {
                playerState.updateNoEvent(data);
            }
        }

        public function updateVehicleInfos(data:*):void
        {
            for each (var value:Object in data)
            {
                addOrUpdatePlayerState(value);
            }
        }

        public function updateVehicleFrags(data:*):void
        {
            for each (var vehicleStats:Object in data)
            {
                var playerState:VOPlayerState = get(vehicleStats.vehicleID);
                if (playerState)
                {
                    playerState.updateNoEvent({
                       frags: vehicleStats.frags
                    });
                }
            }
        }

        public function updateTotalStats(data:Object):void
        {
            leftScope = data.leftScope;
            rightScope = data.rightScope;
        }

        public function dispatchEvents():void
        {
            for each (var playerState:VOPlayerState in playerStates)
            {
                playerState.dispatchEvents();
            }
        }

        // PRIVATE

        private function addOrUpdatePlayerState(value:Object):void
        {
            if (!playerStates.hasOwnProperty(value.vehicleID))
            {
                var playerState:VOPlayerState = new VOPlayerState(value);
                playerStates[value.vehicleID] = playerState;
                playerNameToVehicleIDMap[value.playerName] = value.vehicleID;
            }
            else
            {
                (playerStates[value.vehicleID] as VOPlayerState).updateNoEvent(value);
            }
        }

        private function updateVehiclesPositionsAndTeam(ids:Vector.<Number>, isAlly:Boolean):void
        {
            var playerState:VOPlayerState;
            var len:int = ids.length;
            for (var i:int = 0; i < len; ++i)
            {
                playerState = get(ids[i]);
                if (playerState)
                {
                    playerState.updateNoEvent({
                        isAlly: isAlly,
                        position: i + 1
                    });
                }
            }
        }
    }
}
