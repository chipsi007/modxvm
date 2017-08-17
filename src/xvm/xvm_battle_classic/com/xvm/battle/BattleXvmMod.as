/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * http://www.modxvm.com/
 */
package com.xvm.battle
{
    import com.xfw.*;
    import com.xvm.infrastructure.*;
    import com.xvm.battle.battleloading.BattleLoadingXvmView;
    import com.xvm.battle.fullStats.FullStatsXvmView;
    import com.xvm.battle.minimap.MinimapXvmView;
    import com.xvm.battle.playersPanel.PlayersPanelXvmView;
    import com.xvm.battle.sixthSense.SixthSenseXvmView;
    import com.xvm.battle.teamBasesPanel.TeamBasesPanelXvmView;

    public class BattleXvmMod extends XvmModBase
    {
        public override function get logPrefix():String
        {
            return "[XVM:BATTLE]";
        }

        private static const _views:Object =
        {
            "classicBattlePage": [
                BattleLoadingXvmView,
                FullStatsXvmView,
                PlayersPanelXvmView,
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
