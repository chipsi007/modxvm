/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * https://modxvm.com/
 */
package com.xvm.battle
{
    import com.xfw.*;
    import com.xfw.events.*;
    import com.xvm.*;
    import com.xvm.infrastructure.*;
    import com.xvm.battle.battleClock.*;
    import com.xvm.battle.battleLabels.*;
    import com.xvm.battle.elements.*;
    import com.xvm.battle.events.*;
    import com.xvm.battle.hitlog.*;
    import com.xvm.battle.zoomIndicator.*;
    import com.xvm.types.cfg.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import net.wg.gui.battle.views.*;
    import net.wg.gui.battle.views.debugPanel.*;
    import net.wg.gui.battle.views.ticker.*;
    import net.wg.infrastructure.events.*;
    import net.wg.infrastructure.interfaces.*;
    import scaleform.clik.utils.*;
    import scaleform.gfx.*;

    public class BattleXvmView extends XvmViewBase
    {
        private static var _battlePageRef:WeakReference;

        public static function get battlePage():BaseBattlePage
        {
            return _battlePageRef.value as BaseBattlePage;
        }

        public static function get battlePageDebugPanel():DebugPanel
        {
            try
            {
                return battlePage["debugPanel"];
            }
            catch (ex:Error)
            {
            }
            return null;
        }

        public static function get battlePageBattleTicker():BattleTicker
        {
            try
            {
                return battlePage["battleTicker"];
            }
            catch (ex:Error)
            {
            }
            return null;
        }

        private var _battleController:BattleXvmComponentController = null;
        private var _battleClock:BattleClock = null;
        private var _battleElements:BattleElements = null;
        private var _battleLabels:BattleLabels = null;
        private var _hitlog:Hitlog = null;
        private var _zoomIndicator:ZoomIndicator = null;
        private var _watermark:MovieClip = null;
        private var hotkeys_cfg:CHotkeys;

        public function BattleXvmView(view:IView)
        {
            super(view);
            _battlePageRef = new WeakReference(super.view);

            _battleController = new BattleXvmComponentController();
            battlePage.xfw_battleStatisticDataController.componentControllers.unshift(_battleController);
        }

        public override function onAfterPopulate(e:LifeCycleEvent):void
        {
            //Logger.add("onAfterPopulate: " + view.as_alias);
            super.onAfterPopulate(e);

            //Xvm.swfProfilerBegin("BattleXvmView.onAfterPopulate()");
            try
            {
                logBriefConfigurationInfo();

                Xvm.addEventListener(Defines.XVM_EVENT_CONFIG_LOADED, onConfigLoaded);
                Xfw.addCommandListener(XvmCommands.AS_ON_KEY_EVENT, onKeyEvent);
                Xfw.addCommandListener(XvmCommands.AS_ON_TARGET_CHANGED, onTargetChanged);

                onConfigLoaded(null);

                var behindMinimapIndex:int = battlePage.getChildIndex(battlePage.minimap) - 1;

                if (battlePageDebugPanel != null && Config.config.battle.clockFormat)
                {
                    _battleClock = new BattleClock();
                    battlePageDebugPanel.addChild(_battleClock);
                }

                if (Config.config.battle.elements && Config.config.battle.elements.length)
                {
                    _battleElements = new BattleElements();
                }

                _hitlog = new Hitlog(); // must be initialized before BattleLabels

                _zoomIndicator = new ZoomIndicator();
                _zoomIndicator.visible = battlePageDebugPanel != null && battlePageDebugPanel.visible;
                battlePage.addChildAt(_zoomIndicator, behindMinimapIndex);

                _battleLabels = new BattleLabels(battlePage);
                _battleLabels.visible = battlePageDebugPanel != null && battlePageDebugPanel.visible;
                battlePage.addChildAt(_battleLabels, behindMinimapIndex);

                if (XfwUtils.endsWith(Config.config.__xvmVersion, "-dev"))
                {
                    createWatermark();
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            //Xvm.swfProfilerEnd("BattleXvmView.onAfterPopulate()");
        }

        override public function onBeforeDispose(e:LifeCycleEvent):void
        {
            super.onBeforeDispose(e);
            //Xvm.swfProfilerBegin("BattleXvmView.onBeforeDispose()");
            try
            {
                Xvm.removeEventListener(Defines.XVM_EVENT_CONFIG_LOADED, onConfigLoaded);
                Xfw.removeCommandListener(XvmCommands.AS_ON_KEY_EVENT, onKeyEvent);
                Xfw.removeCommandListener(XvmCommands.AS_ON_TARGET_CHANGED, onTargetChanged);
                if (_battleController)
                {
                    _battleController.dispose();
                    _battleController = null;
                }
                if (_battleClock)
                {
                    _battleClock.dispose();
                    _battleClock = null;
                }
                if (_battleElements)
                {
                    _battleElements.dispose();
                    _battleElements = null;
                }
                if (_battleLabels)
                {
                    _battleLabels.dispose();
                    _battleLabels = null;
                }
                if (_hitlog)
                {
                    _hitlog.dispose();
                    _hitlog = null;
                }
                if (_zoomIndicator)
                {
                    _zoomIndicator.dispose();
                    _zoomIndicator = null;
                }
                if (_watermark)
                {
                    _watermark = null;
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            //Xvm.swfProfilerEnd("BattleXvmView.onBeforeDispose()");
        }

        public override function onConfigLoaded(e:Event):void
        {
            super.onConfigLoaded(e);
            //Logger.add("BattleXvmView.onConfigLoaded()");
            Xvm.swfProfilerBegin("BattleXvmView.onConfigLoaded()");
            try
            {
                super.onConfigLoaded(e);
                hotkeys_cfg = Config.config.hotkeys;
                Xfw.cmd(BattleCommands.BATTLE_CTRL_SET_VEHICLE_DATA);
                Xfw.cmd(BattleCommands.XMQP_INIT);
                battlePage.updateStage(App.appWidth, App.appHeight);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            Xvm.swfProfilerEnd("BattleXvmView.onConfigLoaded()");
        }

        // PRIVATE

        private function logBriefConfigurationInfo():void
        {
            Logger.add(
                "[XVM INFO]\n" +
                "                               XVM_VERSION=" + Config.config.__xvmVersion + " #" + Config.config.__xvmRevision + " for WoT " + Config.config.__wotVersion +"\n" +
                "                               gameRegion=" + Config.config.region + "\n" +
                "                               configVersion=" + Config.config.configVersion + "\n" +
                "                               autoReloadConfig=" + Config.config.autoReloadConfig + "\n" +
                "                               markers.enabled=" + Config.config.markers.enabled + "\n" +
                "                               servicesActive=" + Config.networkServicesSettings.servicesActive + "\n" +
                "                               xmqp=" + Config.networkServicesSettings.xmqp + "\n" +
                "                               statBattle=" + Config.networkServicesSettings.statBattle);
        }

        private function onKeyEvent(key:Number, isDown:Boolean):void
        {
            if (hotkeys_cfg.minimapZoom.enabled && hotkeys_cfg.minimapZoom.keyCode == key)
                Xvm.dispatchEvent(new ObjectEvent(BattleEvents.MINIMAP_ZOOM, { isDown: isDown }));
            if (hotkeys_cfg.minimapAltMode.enabled && hotkeys_cfg.minimapAltMode.keyCode == key)
                Xvm.dispatchEvent(new ObjectEvent(BattleEvents.MINIMAP_ALT_MODE, { isDown: isDown } ));
            if (hotkeys_cfg.playersPanelAltMode.enabled && hotkeys_cfg.playersPanelAltMode.keyCode == key)
                Xvm.dispatchEvent(new ObjectEvent(BattleEvents.PLAYERS_PANEL_ALT_MODE, { isDown: isDown } ));
        }

        private function onTargetChanged(vehicleID:Number):void
        {
            if (vehicleID)
            {
                Xvm.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.ON_TARGET_IN, vehicleID));
            }
            else
            {
                Xvm.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.ON_TARGET_OUT));
            }
        }

        private function createWatermark():void
        {
            _watermark = new MovieClip();
            var textField:TextField = new TextField();
            textField.alpha = 0.2;
            textField.width = 300;
            textField.height = 100;
            textField.mouseEnabled = false;
            textField.selectable = false;
            textField.multiline = true;
            textField.wordWrap = false;
            textField.defaultTextFormat = new TextFormat("$FieldFont", 12, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER, null, null, null, -2);
            textField.text = "XVM Nightly Build #" + Config.config.__xvmRevision + "\nget stable version on\nhttps://modxvm.com";
            _watermark.addChild(textField);
            battlePage.prebattleTimer.background.addChildAt(_watermark, 0);
            _watermark.x = battlePage.prebattleTimer.background.width / 2 + 230;
            _watermark.y = -68;
        }
    }
}
