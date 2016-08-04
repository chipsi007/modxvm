/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.lobby.battleloading
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.battle.*;
    import com.xvm.infrastructure.*;
    import com.xvm.types.*;
    import com.xvm.lobby.battleloading.components.*;
    import flash.utils.*;
    import net.wg.gui.components.controls.ReadOnlyScrollingList;
    import net.wg.gui.lobby.battleloading.BattleLoading;
    import net.wg.gui.lobby.battleloading.BattleLoadingForm;
    import net.wg.infrastructure.events.*;
    import net.wg.infrastructure.interfaces.*;
    import org.idmedia.as3commons.util.StringUtils;

    public class BattleLoadingXvmView extends XvmViewBase
    {
        private var _winChances:WinChances;
        private var _clock:Clock;

        public function BattleLoadingXvmView(view:IView)
        {
            super(view);
        }

        public function get page():BattleLoading
        {
            return super.view as BattleLoading;
        }

        override public function onAfterPopulate(e:LifeCycleEvent):void
        {
            //Logger.add("onAfterPopulate: " + view.as_alias);
            logBriefConfigurationInfo();

            Macros.clear();
            Macros.RegisterXvmServicesMacrosData();

            BattleGlobalData.init();
            Stat.clearBattleStat();
            Stat.loadBattleStat();

            waitInit();
        }

        override public function onBeforeDispose(e:LifeCycleEvent):void
        {
            _winChances = null;
            _clock = null;
            super.onBeforeDispose(e);
        }

        // PRIVATE

        private function logBriefConfigurationInfo():void
        {
            Logger.add(
                "[BattleLoading]\n" +
                "                               XVM_VERSION=" + Config.config.__xvmVersion + " #" + Config.config.__xvmRevision + " for WoT " + Config.config.__wotVersion +"\n" +
                "                               gameRegion=" + Config.config.region + "\n" +
                "                               configVersion=" + Config.config.configVersion + "\n" +
                "                               autoReloadConfig=" + Config.config.autoReloadConfig + "\n" +
                "                               markers.enabled=" + Config.config.markers.enabled + "\n" +
                "                               servicesActive=" + Config.networkServicesSettings.servicesActive + "\n" +
                "                               xmqp=" + Config.networkServicesSettings.xmqp + "\n" +
                "                               statBattle=" + Config.networkServicesSettings.statBattle);
        }

        private function waitInit():void
        {
            if (!page.initialized || App.utils.classFactory.getClass("com.xvm.lobby.ui.battleloading::UI_LeftItemRendererTable") == null)
            {
                var $this:* = this;
                setTimeout(function():void { $this.waitInit(); }, 1);
            }
            else
            {
                init();
            }
        }

        private function init():void
        {
            try
            {
                initRenderers();

                // Components
                _winChances = new WinChances(page); // Winning chance info above players list.
                _clock = new Clock(page);  // Realworld time at right side of TipField.
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        private function initRenderers():void
        {
            var form:BattleLoadingForm = page.form as BattleLoadingForm;
            if (!form)
                return;

            var list1:ReadOnlyScrollingList = form.team1List;
            var list2:ReadOnlyScrollingList = form.team2List;
            list1.validateNow();
            list2.validateNow();

            if (list1.itemRenderer == LeftItemRendererTableUI)
            {
                list1.itemRenderer = App.utils.classFactory.getClass("com.xvm.lobby.ui.battleloading::UI_LeftItemRendererTable");
                list2.itemRenderer = App.utils.classFactory.getClass("com.xvm.lobby.ui.battleloading::UI_RightItemRendererTable");
            }
            else if (list1.itemRenderer == LeftItemRendererTipsUI)
            {
                list1.itemRenderer = App.utils.classFactory.getClass("com.xvm.lobby.ui.battleloading::UI_LeftItemRendererTips");
                list2.itemRenderer = App.utils.classFactory.getClass("com.xvm.lobby.ui.battleloading::UI_RightItemRendererTips");
            }
        }
    }
}
