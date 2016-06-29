/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.lobby.ui.company
{
    import com.xfw.*;
    import com.xvm.lobby.ui.company.renderers.*;
    import flash.events.*;

    public dynamic class UI_TeamMemberRenderer extends TeamMemberRendererUI
    {
        private var worker:TeamMemberRenderer;

        public function UI_TeamMemberRenderer()
        {
            super();
            worker = new TeamMemberRenderer(this);
        }

        override public function setData(data:Object):void
        {
            super.setData(data);
            worker.setData(data);
        }

        override protected function draw():void
        {
            super.draw();
            worker.draw();
        }

        override protected function handleMouseRollOver(e:MouseEvent):void
        {
            super.handleMouseRollOver(e);
            worker.handleMouseRollOver(e);
        }

        override protected function handleMouseRollOut(e:MouseEvent):void
        {
            super.handleMouseRollOut(e);
            worker.handleMouseRollOut(e);
        }
    }
}
