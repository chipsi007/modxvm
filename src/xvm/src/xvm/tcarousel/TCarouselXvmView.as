/**
 * XVM - hangar
 * @author Maxim Schedriviy <m.schedriviy@gmail.com>
 */
package xvm.tcarousel
{
    import com.xvm.*;
    import com.xvm.infrastructure.*;
    import com.xvm.misc.*;
    import net.wg.gui.lobby.hangar.*;
    import net.wg.infrastructure.events.*;
    import net.wg.infrastructure.interfaces.*;

    public class TCarouselXvmView extends XvmViewBase
    {
        public function TCarouselXvmView(view:IView)
        {
            super(view);
        }

        public function get page():net.wg.gui.lobby.hangar.Hangar
        {
            return super.view as net.wg.gui.lobby.hangar.Hangar;
        }

        public override function onAfterPopulate(e:LifeCycleEvent):void
        {
            //Logger.addObject("onAfterPopulate: " + view.as_alias);
            init();
        }

        private function init():void
        {
            AccountData.init();
            page.carousel.itemRenderer = UI_TankCarouselItemRenderer;
        }
    }
}
