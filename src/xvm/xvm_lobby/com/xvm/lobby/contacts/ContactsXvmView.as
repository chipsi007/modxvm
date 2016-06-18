/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.lobby.contacts
{
    import com.xfw.*;
    import com.xfw.events.*;
    import com.xvm.*;
    import com.xvm.infrastructure.*;
    import flash.utils.*;
    import net.wg.gui.messenger.*;
    import net.wg.gui.messenger.data.*;
    import net.wg.infrastructure.events.*;
    import net.wg.infrastructure.interfaces.*;
    import net.wg.infrastructure.interfaces.entity.*;
    import org.idmedia.as3commons.util.StringUtils;

    public class ContactsXvmView extends XvmViewBase
    {
        private static const CMD_XVM_CONTACTS_AS_EDIT_CONTACT_DATA:String = "xvm_contacts.as_edit_contact_data";

        private static const XVM_EDIT_CONTACT_DATA_ALIAS:String = 'XvmEditContactDataView';

        private static const _name:String = "xvm_lobby";
        private static const _ui_name:String = "xvm_contacts_ui.swf";

        private var _initialized:Boolean = false;

        public function ContactsXvmView(view:IView)
        {
            super(view);
        }

        public function get page():ContactsListPopover
        {
            return super.view as ContactsListPopover;
        }

        override public function onBeforePopulate(e:LifeCycleEvent):void
        {
            //page.borderLip.y += 100;
            //page.treeComponent.setListTopBound(50);
        }

        override public function onAfterPopulate(e:LifeCycleEvent):void
        {
            _initialized = false;

            if (!Config.networkServicesSettings.comments)
                return;

            _initialized = true;

            App.instance.loaderMgr.addEventListener(LibraryLoaderEvent.LOADED, onLibLoaded);

            if (Xfw.try_load_ui_swf(_name, _ui_name) != XfwConst.SWF_START_LOADING)
                init();
        }

        override public function onBeforeDispose(e:LifeCycleEvent):void
        {
            if (!_initialized)
                return;

            App.instance.loaderMgr.removeEventListener(LibraryLoaderEvent.LOADED, onLibLoaded);
            Xfw.removeCommandListener(CMD_XVM_CONTACTS_AS_EDIT_CONTACT_DATA, editContactData);
        }

        // PRIVATE

        private function onLibLoaded(e:LibraryLoaderEvent):void
        {
            if (StringUtils.endsWith(e.url.toLowerCase(), _ui_name))
            {
                init();
                App.utils.scheduler.scheduleOnNextFrame(function():void
                {
                    page.treeComponent.list.invalidate();
                });
            }
        }

        private function init():void
        {
            page.treeComponent.list.itemRendererName =  "xvm.contacts_ui::UI_ContactsTreeItemRenderer";
            Xfw.addCommandListener(CMD_XVM_CONTACTS_AS_EDIT_CONTACT_DATA, editContactData);
            page.xfw_linkageUtils.addEntity(XVM_EDIT_CONTACT_DATA_ALIAS, "xvm.contacts_ui::UI_EditContactDataView");
        }

        private function editContactData(name:String, dbID:Number):Object
        {
            var data:ContactListMainInfo = new ContactListMainInfo(name, dbID);
            IUpdatable(page.viewStack.show("xvm.contacts_ui::UI_EditContactDataView")).update(data);
            return null;
        }
    }
}
