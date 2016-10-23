/**
 * XVM - companies list window
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.lobby.company
{
    import com.xfw.*;
    import com.xvm.*;
    import net.wg.gui.components.controls.CheckBox;
    import net.wg.infrastructure.interfaces.*;
    import net.wg.gui.prebattle.company.*;

    public class CompanyList
    {
        private var updateCheckBox:CheckBox;

        private var view:CompanyListView;

        public function CompanyList(view:IViewStackContent)
        {
            try
            {
                this.view = view as CompanyListView;
                init();
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
       }

        // PRIVATE

        private function init():void
        {
            //Logger.add("init: " + view.as_getPyAlias());

            view.division.menuRowCount = 7; // fix WG issue

            if (Config.networkServicesSettings.statCompany != true)
                return;

            view.cmpList.itemRendererName = "com.xvm.lobby.ui.company::UI_CompanyListItemRenderer";

            updateCheckBox = App.utils.classFactory.getComponent("CheckBox", CheckBox);
            updateCheckBox.name = "updateStatCheckBox";
            updateCheckBox.autoSize = "left";
            updateCheckBox.label = Locale.get("Load statistics");
            updateCheckBox.x = view.createButton.x + view.createButton.width + 5;
            updateCheckBox.y = 7;
            view.addChild(updateCheckBox);
            App.utils.scheduler.scheduleTask(function():void
            {
                //TODO:0.9.14
                /*
                var dx:Number = updateCheckBox.x + updateCheckBox.width - view.filterTextField.x;
                if (dx > 0)
                {
                    view.filterTextField.x += dx;
                    view.filterTextField.width += 50 - dx;

                    view.filterButton.x += 50;
                    view.filterButton.y += 1;

                    view.refreshButton.x += 50;
                    view.refreshButton.y += 1;

                    view.filterInBattleCheckbox.x += 50;
                    view.filterInBattleCheckbox.width -= 50;

                    view.division.x += 30;
                    view.division.width -= 30;
                }*/
            }, 100);
        }
    }
}
