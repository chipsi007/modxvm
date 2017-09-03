/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * http://www.modxvm.com/
 */
package com.xvm.battle.playersPanel
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.battle.*;
    import net.wg.data.constants.generated.*;

    public class UI_EpicRandomPlayersPanel extends epicRandomPlayersPanelUI
    {
        private static const OFFSET:int = 70;

        override public function as_setPanelMode(param1:int):void
        {
            super.as_setPanelMode(param1);
            BattleState.playersPanelMode = state == EPIC_RANDOM_PLAYERS_PANEL_STATE.TOGGLED_HIDDEN ? EPIC_RANDOM_PLAYERS_PANEL_STATE.HIDDEN : state;
            BattleState.playersPanelWidthLeft = listLeft.getRenderersVisibleWidth() - OFFSET;
            BattleState.playersPanelWidthRight = listRight.getRenderersVisibleWidth() - OFFSET;
        }
    }
}
