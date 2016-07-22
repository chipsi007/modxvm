/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.vehiclemarkers.ui
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.battle.*;
    import com.xvm.battle.events.*;
    import com.xvm.battle.vo.*;
    import com.xvm.vehiclemarkers.ui.components.*;
    import com.xvm.vo.VOVehicleData;
    import flash.utils.*;
    import flash.events.*;
    import net.wg.gui.battle.components.constants.*;
    import net.wg.gui.battle.views.vehicleMarkers.VehicleMarkersConstants; // * - name conflict
    import net.wg.gui.battle.views.vehicleMarkers.VehicleMarkersManager; // * - name conflict
    import net.wg.gui.battle.views.vehicleMarkers.events.*;
    import net.wg.gui.battle.views.vehicleMarkers.VO.*;

    public dynamic class XvmVehicleMarker extends VehicleMarker
    {
        public var vehicleID:Number = NaN;
        private var playerName:String = null;
        private var curHealth:Number = NaN;
        private var maxHealth:int = 0;

        private var actionMarkerComponent:ActionMarkerComponent = null;
        private var contourIconComponent:ContourIconComponent = null;
        private var damageTextComponent:DamageTextComponent = null;
        private var healthBarComponent:HealthBarComponent = null;
        private var levelIconComponent:LevelIconComponent = null;
        private var textFieldsComponent:TextFieldsComponent = null;
        private var vehicleTypeIconComponent:VehicleTypeIconComponent = null;

        public function XvmVehicleMarker()
        {
            Xvm.swfProfilerBegin("XvmVehicleMarker.ctor()");
            //Logger.add(getQualifiedClassName(this));
            super();
            super.markerSettings = XvmVehicleMarkerConstants.DISABLED_MARKER_SETTINGS;
            Xvm.addEventListener(PlayerStateEvent.CHANGED, onPlayerStateChanged);
            createComponents();
            Xvm.swfProfilerEnd("XvmVehicleMarker.ctor()");
        }

        override protected function configUI():void
        {
            Xvm.swfProfilerBegin("XvmVehicleMarker.configUI()");
            super.configUI();
            VehicleMarkersManager.getInstance().addEventListener(VehicleMarkersManagerEvent.SHOW_EX_INFO, onShowExInfoHandler, false, 0, true);
            // TODO: removeStandardFields();
            Xvm.swfProfilerEnd("XvmVehicleMarker.configUI()");
        }

        override protected function onDispose():void
        {
            Xvm.swfProfilerBegin("XvmVehicleMarker.onDispose()");
            super.onDispose();
            Xvm.removeEventListener(PlayerStateEvent.CHANGED, onPlayerStateChanged);
            VehicleMarkersManager.getInstance().removeEventListener(VehicleMarkersManagerEvent.SHOW_EX_INFO, onShowExInfoHandler);
            deleteComponents();
            Xvm.swfProfilerEnd("XvmVehicleMarker.onDispose()");
        }

        override public function setVehicleInfo(vClass:String, vIconSource:String, vType:String, vLevel:int,
            pFullName:String, pName:String, pClan:String, pRegion:String,
            maxHealth:int, entityName:String, hunt:Boolean, squadIndex:int):void
        {
            // WORKAROUND: possible bug - marker instance not deletes on MarkersManager.destroyMarker() call.
            if (!parent) { dispose(); return; }
            ///

            Xvm.swfProfilerBegin("XvmVehicleMarker.setVehicleInfo()");
            super.setVehicleInfo.apply(this, arguments);
            try
            {
                this.playerName = pName;
                this.maxHealth = maxHealth;
                vehicleID = BattleState.getVehicleID(playerName);
                if (!isNaN(vehicleID))
                {
                    init(vehicleID);
                    //invalidate(InvalidationType.DATA);
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            Xvm.swfProfilerEnd("XvmVehicleMarker.setVehicleInfo()");
        }

        override protected function draw():void
        {
            // WORKAROUND: possible bug - marker instance not deletes on MarkersManager.destroyMarker() call.
            if (!parent) { dispose(); return; }
            ///

            Xvm.swfProfilerBegin("XvmVehicleMarker.super.draw()");
            super.draw();
            Xvm.swfProfilerEnd("XvmVehicleMarker.super.draw()");
            Xvm.swfProfilerBegin("XvmVehicleMarker.draw()");
            try
            {
                if (isInvalid(InvalidationType.DATA))
                {
                    var playerState:VOPlayerState = BattleState.get(vehicleID);
                    if (playerState != null)
                    {
                        dispatchEvent(new XvmVehicleMarkerEvent(XvmVehicleMarkerEvent.UPDATE, playerState, exInfo));
                    }
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            Xvm.swfProfilerEnd("XvmVehicleMarker.draw()");
        }

        override public function updateHealth(newHealth:int, damageFlag:int, damageType:String):void
        {
            // WORKAROUND: possible bug - marker instance not deletes on MarkersManager.destroyMarker() call.
            if (!parent) { dispose(); return; }
            ///

            Xvm.swfProfilerBegin("XvmVehicleMarker.updateHealth()");
            try
            {
                this.curHealth = newHealth;
                var playerState:VOPlayerState = BattleState.get(vehicleID);
                if (playerState != null)
                {
                    playerState.update({
                        damageInfo: new VODamageInfo({
                            damageDelta: playerState.curHealth - Math.max(newHealth, 0),
                            damageType: damageType,
                            damageFlag: damageFlag
                        }),
                        curHealth: newHealth
                    });
                    dispatchEvent(new XvmVehicleMarkerEvent(XvmVehicleMarkerEvent.UPDATE_HEALTH, playerState, exInfo));
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            Xvm.swfProfilerEnd("XvmVehicleMarker.updateHealth()");
        }

        override public function setHealth(curHealth:int):void
        {
            // WORKAROUND: possible bug - marker instance not deletes on MarkersManager.destroyMarker() call.
            if (!parent) { dispose(); return; }
            ///

            Xvm.swfProfilerBegin("XvmVehicleMarker.setHealth()");
            try
            {
                //Logger.add("curHealth=" + curHealth);
                this.curHealth = curHealth;
                var playerState:VOPlayerState = BattleState.get(vehicleID);
                if (playerState != null)
                {
                    playerState.update( { damageInfo:null, curHealth: curHealth } );
                    invalidate(InvalidationType.DATA);
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            Xvm.swfProfilerEnd("XvmVehicleMarker.setHealth()");
        }

        override public function setSpeaking(value:Boolean):void
        {
            // WORKAROUND: possible bug - marker instance not deletes on MarkersManager.destroyMarker() call.
            if (!parent) { dispose(); return; }
            ///

            Xvm.swfProfilerBegin("XvmVehicleMarker.setSpeaking()");
            super.setSpeaking(value);
            try
            {
                var playerState:VOPlayerState = BattleState.get(vehicleID);
                if (playerState != null)
                {
                    dispatchEvent(new XvmVehicleMarkerEvent(XvmVehicleMarkerEvent.SET_SPEAKING, playerState, exInfo));
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            Xvm.swfProfilerEnd("XvmVehicleMarker.setSpeaking()");
        }

        override public function set markerSettings(value:Object):void
        {
            // stub
        }

        override public function layoutParts(param1:Vector.<Boolean>):void
        {
            // stub
        }

        private function onShowExInfoHandler(e:VehicleMarkersManagerEvent):void
        {
            // WORKAROUND: possible bug - marker instance not deletes on MarkersManager.destroyMarker() call.
            if (!parent) { dispose(); return; }
            ///

            //Xvm.swfProfilerBegin("XvmVehicleMarker.onShowExInfoHandler()");
            try
            {
                var playerState:VOPlayerState = BattleState.get(vehicleID);
                if (playerState != null)
                {
                    dispatchEvent(new XvmVehicleMarkerEvent(XvmVehicleMarkerEvent.EX_INFO, playerState, exInfo));
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            //Xvm.swfProfilerEnd("XvmVehicleMarker.onShowExInfoHandler()");
        }

        // PRIVATE

        private function createComponents():void
        {
            try
            {
                vehicleTypeIconComponent = new VehicleTypeIconComponent(this);
                contourIconComponent = new ContourIconComponent(this);
                levelIconComponent = new LevelIconComponent(this);
                actionMarkerComponent = new ActionMarkerComponent(this);
                healthBarComponent = new HealthBarComponent(this);
                textFieldsComponent = new TextFieldsComponent(this);
                damageTextComponent = new DamageTextComponent(this);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        private function deleteComponents():void
        {
            try
            {
                if (vehicleTypeIconComponent != null)
                {
                    vehicleTypeIconComponent.dispose();
                    vehicleTypeIconComponent = null;
                }
                if (contourIconComponent != null)
                {
                    contourIconComponent.dispose();
                    contourIconComponent = null;
                }
                if (levelIconComponent != null)
                {
                    levelIconComponent.dispose();
                    levelIconComponent = null;
                }
                if (actionMarkerComponent != null)
                {
                    actionMarkerComponent.dispose();
                    actionMarkerComponent = null;
                }
                if (healthBarComponent != null)
                {
                    healthBarComponent.dispose();
                    healthBarComponent = null;
                }
                if (textFieldsComponent != null)
                {
                    textFieldsComponent.dispose();
                    textFieldsComponent = null;
                }
                if (damageTextComponent != null)
                {
                    damageTextComponent.dispose();
                    damageTextComponent = null;
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        private function init(vehicleID:Number):void
        {
            this.vehicleID = vehicleID;
            var playerState:VOPlayerState = BattleState.get(vehicleID);
            if (!isNaN(this.curHealth))
            {
                playerState.updateNoEvent({
                    curHealth: this.curHealth
                });
            }
            playerState.updateNoEvent({
                maxHealth: this.maxHealth
            });
            RegisterVehicleMarkerData();
            dispatchEvent(new XvmVehicleMarkerEvent(XvmVehicleMarkerEvent.INIT, playerState, exInfo));
        }

        private function onPlayerStateChanged(e:PlayerStateEvent):void
        {
            if (e.playerName == playerName)
            {
                if (isNaN(vehicleID))
                {
                    init(e.vehicleID);
                }
                invalidate(InvalidationType.DATA);
            }
        }

        private function RegisterVehicleMarkerData():void
        {
            var dict:Object = Macros.Players;
            if (!dict.hasOwnProperty(playerName))
                dict[playerName] = {};
            var pdata:Object = dict[playerName];

            // {{turret}}
            pdata["turret"] = getTurretData();
        }

        private function getTurretData():String
        {
            var turret:int = XvmVehicleMarkerConstants.TURRET_UNKNOWN_VULN_DATABASE_VAL;
            var playerState:VOPlayerState = BattleState.get(vehicleID);
            if (playerState != null)
            {
                var vdata:VOVehicleData = VehicleInfo.get(playerState.vehCD);
                if (vdata != null)
                {
                    if (vdata.hpStock == playerState.maxHealth)
                    {
                        switch (turret)
                        {
                            case XvmVehicleMarkerConstants.TURRET_HIGH_VULN_DATABASE_VAL:
                                return Macros.Format(Config.config.markers.turretMarkers.highVulnerability, playerState);
                            case XvmVehicleMarkerConstants.TURRET_LOW_VULN_DATABASE_VAL:
                                return Macros.Format(Config.config.markers.turretMarkers.lowVulnerability, playerState);
                        }
                    }
                }
            }
            return null;
        }
    }
}
