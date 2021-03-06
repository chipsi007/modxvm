﻿/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * https://modxvm.com/
 */
package com.xvm.battle.fullStats
{
    import com.xfw.*;
    import net.wg.gui.battle.ranked.stats.components.fullStats.*;
    import net.wg.gui.battle.ranked.stats.components.fullStats.tableItem.*;

    public class FullStatsTableCtrlXvm extends FullStatsTableCtrl
    {
        public function FullStatsTableCtrlXvm(table:FullStatsTable)
        {
            super(table);
        }

        override public function createPlayerStatsItem(col:int, row:int):StatsTableItem
        {
            return new StatsTableItemXvm(xfw_table, col, row);
        }
    }
}
