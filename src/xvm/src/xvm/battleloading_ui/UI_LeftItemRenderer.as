/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package xvm.battleloading_ui
{
    import net.wg.gui.lobby.battleloading.vo.*;
    import xvm.battleloading_ui.components.*;

    public dynamic class UI_LeftItemRenderer extends LeftItemRendererUI
    {
        private var worker:BattleLoadingItemRenderer;

        public function UI_LeftItemRenderer()
        {
            super();
            worker = new BattleLoadingItemRenderer(this);
        }

        override protected function configUI():void
        {
            super.configUI();
            x = 5; // fix bad align in 0.9.9
        }

        override public function setData(data:Object):void
        {
            super.setData(data);
            worker.setData(data as VehicleInfoVO);
        }

        override protected function draw():void
        {
            super.draw();
            worker.draw();
        }
    }
}
