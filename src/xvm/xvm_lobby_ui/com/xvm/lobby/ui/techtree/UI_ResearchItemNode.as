/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * http://www.modxvm.com/
 */
package com.xvm.lobby.ui.techtree
{
    import com.xfw.*;
    import com.xvm.*;
    import flash.events.*;
    import net.wg.gui.lobby.techtree.data.state.*;

    public dynamic class UI_ResearchItemNode extends ResearchItemNode
    {
        public function UI_ResearchItemNode()
        {
            //Logger.add("UI_ResearchItemNode()");
            super();
        }

        override public function populateUI():void
        {
            if (Config.config.hangar.hidePricesInTechTree)
            {
                if (stateProps && stateProps.visible && stateProps.animation == null)
                {
                    if (stateProps.label == "creditsPriceLabel")
                        stateProps.animation = new AnimationProperties(150, { alpha:0 }, { alpha:1 } );
                }
            }

            super.populateUI();
        }

        override public function showContextMenu():void
        {
            super.showContextMenu();
            if (button)
                button.endAnimation(false);
        }

        override protected function handleClick(value:uint = 0):void
        {
            super.handleClick(value);
            if  (button)
                button.endAnimation(false);
        }

        override protected function handleMouseRollOver(e:MouseEvent):void
        {
            super.handleMouseRollOver(e);
            if (button)
                button.startAnimation();
        }

        override protected function handleMouseRollOut(e:MouseEvent):void
        {
            super.handleMouseRollOut(e);
            if (button)
                button.endAnimation(false);
        }
    }
}
