/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * https://modxvm.com/
 */
package com.xvm.battle
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.infrastructure.*;
    import com.xvm.battle.battleloading.EpicRandomBattleLoadingXvmView;
    import com.xvm.battle.fullStats.EpicRandomFullStatsXvmView;
    import com.xvm.battle.minimap.MinimapXvmView;
    import com.xvm.battle.playersPanel.EpicRandomPlayersPanelXvmView;
    import com.xvm.battle.sixthSense.SixthSenseXvmView;
    import com.xvm.battle.teamBasesPanel.TeamBasesPanelXvmView;

    public class BattleXvmMod extends XvmModBase
    {
        public function BattleXvmMod():void
        {
            Xvm.appType = Defines.APP_TYPE_BATTLE_EPIC;
            super();
        }

        public override function get logPrefix():String
        {
            return "[XVM:BATTLE]";
        }

        private static const _views:Object =
        {
            "epicRandomPage": [
                EpicRandomBattleLoadingXvmView, // TODO:EPIC
                //EpicRandomFullStatsXvmView, // TODO:EPIC
                EpicRandomPlayersPanelXvmView,
                TeamBasesPanelXvmView,
                MinimapXvmView,
                SixthSenseXvmView,
                BattleXvmView                   // BattleXvmView should be loaded last (implements invalidation methods)
            ]
        }

        public override function get views():Object
        {
            return _views;
        }
    }
}