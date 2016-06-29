/**
 * XVM - company window
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.lobby.company
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.infrastructure.*;
    import flash.utils.*;
    import net.wg.data.constants.generated.*;
    import net.wg.infrastructure.interfaces.*;
    import net.wg.infrastructure.events.*;
    import net.wg.gui.events.*;
    import net.wg.gui.prebattle.company.*;
    import org.idmedia.as3commons.util.StringUtils;

    public class CompanyXvmView extends XvmViewBase
    {
        private var _initialized:Boolean = false;

        public function CompanyXvmView(view:IView)
        {
            super(view);
        }

        public function get page():CompanyMainWindow
        {
            return super.view as CompanyMainWindow;
        }

        public override function onAfterPopulate(e:LifeCycleEvent):void
        {
            //Logger.add("onAfterPopulate: " + view.as_alias);

            _initialized = false;

            if (!Config.networkServicesSettings.statCompany)
                return;

            _initialized = true;

            App.instance.loaderMgr.addEventListener(LibraryLoaderEvent.LOADED, onLibLoaded);

            //if (XfwView.try_load_ui_swf(_name, _ui_name) != XfwConst.SWF_START_LOADING)
                init();
        }

        override public function onBeforeDispose(e:LifeCycleEvent):void
        {
            if (!_initialized)
                return;

            App.instance.loaderMgr.removeEventListener(LibraryLoaderEvent.LOADED, onLibLoaded);
        }

        // PRIVATE

        private function onLibLoaded(e:LibraryLoaderEvent):void
        {
            //if (StringUtils.endsWith(e.url.toLowerCase(), _ui_name))
            {
                init();
                setView(page.stack.currentView as IViewStackContent);
            }
        }

        private function init():void
        {
            page.stack.addEventListener(ViewStackEvent.VIEW_CHANGED, onViewChanged);
        }

        private function onViewChanged(e:ViewStackEvent):void
        {
            setView(e.view);
        }

        private function setView(view:IViewStackContent):void
        {
            switch (getQualifiedClassName(view))
            {
                case PREBATTLE_ALIASES.COMPANY_LIST_VIEW_UI:
                    new CompanyList(view);
                    break;
                case PREBATTLE_ALIASES.COMPANY_ROOM_VIEW_UI:
                    new CompanyRoom(view);
                    break;
                default:
                    //Logger.addObject(e);
                    break;
            }
        }
    }
}
