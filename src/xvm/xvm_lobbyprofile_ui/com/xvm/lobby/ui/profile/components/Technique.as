/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.lobby.ui.profile.components
{
    import com.xfw.*;
    import com.xfw.events.*;
    import com.xvm.*;
    import com.xvm.lobby.ui.profile.*;
    import com.xvm.types.dossier.*;
    import com.xvm.types.stat.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import net.wg.data.constants.*;
    import net.wg.data.constants.generated.*;
    import net.wg.gui.events.*;
    import net.wg.gui.components.controls.events.*;
    import net.wg.gui.components.advanced.*;
    import net.wg.gui.lobby.profile.pages.technique.*;
    import net.wg.gui.lobby.profile.pages.technique.data.*;
    import scaleform.clik.data.*;
    import scaleform.clik.events.*;
    import scaleform.clik.interfaces.*;

    public class Technique extends Sprite
    {
        // CONSTANTS

        private static const DEFAULT_SORTING_INVALID:String = "default_sorting_invalid";

        public static const EVENT_VEHICLE_DOSSIER_LOADED:String = "vehicle_dossier_loaded";

        // PROPERTIES

        private var _page:ProfileTechnique;
        public function get page():ProfileTechnique
        {
            return _page;
        }

        private var _playerName:String;
        public function get playerName():String
        {
            return _playerName;
        }

        private var _accountDBID:int;
        public function get accountDBID():int
        {
            return _accountDBID;
        }

        public function get accountDossier():AccountDossier
        {
            return Dossier.getAccountDossier(accountDBID);
        }

        public function get currentData():Object
        {
            var p:UI_ProfileTechniquePage = page as UI_ProfileTechniquePage;
            if (p)
                return p.currentDataXvm;
            var w:UI_ProfileTechniqueWindow = page as UI_ProfileTechniqueWindow;
            if (w)
                return w.currentDataXvm;
            return null;
        }

        public function get battlesType():String
        {
            var p:UI_ProfileTechniquePage = page as UI_ProfileTechniquePage;
            if (p)
                return p.battlesTypeXvm;
            var w:UI_ProfileTechniqueWindow = page as UI_ProfileTechniqueWindow;
            if (w)
                return w.battlesTypeXvm;
            return null;
        }

        // PRIVATE FIELDS

        private var _disposed:Boolean = false;
        private var _selectedItemCD:Number = -1;
        //protected var filter:FilterControl;

        // CTOR

        public function Technique(page:ProfileTechnique, playerName:String, accountDBID:int):void
        {
            this.name = "xvm_extension";
            this._page = page;
            this._playerName = playerName;
            this._accountDBID = accountDBID;

            // Change row height: 34 -> 32
            page.listComponent.techniqueList.rowHeight = 32;

            // remove upper/lower shadow
            page.listComponent.upperShadow.visible = false;
            page.listComponent.lowerShadow.visible = false;

            if (Config.networkServicesSettings.statAwards)
            {
                Stat.instance.addEventListener(Stat.COMPLETE_USERDATA, onStatLoaded, false, 0, true);
                Stat.loadUserData(playerName);

                Dossier.requestAccountDossier(null, null, PROFILE_DROPDOWN_KEYS.ALL, accountDBID);

                // override renderers
                page.listComponent.sortableButtonBar.itemRendererName = getQualifiedClassName(UI_ProfileSortingButton);
                page.listComponent.techniqueList.itemRenderer = UI_TechniqueRenderer;
            }
        }

        public function dispose():void
        {
            _disposed = true;
        }

        public function fixInitData(param1:Object):void
        {
            if (Config.networkServicesSettings.statAwards && Config.config.userInfo.showXTEColumn)
            {
                var bi:Object = {
                    id: "xvm_xte",
                    label: "xTE",
                    toolTip: "xvm_xte",
                    buttonWidth: 50,
                    sortOrder: 8,
                    defaultSortDirection: SortingInfo.DESCENDING_SORT,
                    ascendingIconSource: RES_ICONS.MAPS_ICONS_BUTTONS_TAB_SORT_BUTTON_ASCPROFILESORTARROW,
                    descendingIconSource: RES_ICONS.MAPS_ICONS_BUTTONS_TAB_SORT_BUTTON_DESCPROFILESORTARROW,
                    buttonHeight: 40,
                    enabled: true
                };

                var tableHeader:Array = param1.tableHeader;
                tableHeader[4].buttonWidth = 64; // BATTLES_COUNT,74
                tableHeader[5].buttonWidth = 64; // WINS_EFFICIENCY,74
                tableHeader[6].buttonWidth = 75; // AVG_EXPERIENCE,90
                tableHeader.push(tableHeader[7]);
                tableHeader[7] = bi;             // xvm_xte
                tableHeader[8].buttonWidth = 68; // MARK_OF_MASTERY,83
            }
        }

        public function setSelectedVehicleIntCD(itemCD:Number):void
        {
            _selectedItemCD = itemCD;
        }

        // DAAPI

        public function as_responseVehicleDossierXvm(data:VehicleDossier):void
        {
            if (_disposed)
                return;

            //Logger.addObject(data, 1, "as_responseVehicleDossierXvm");
            page.listComponent.techniqueList.invalidateData();
            dispatchEvent(new ObjectEvent(EVENT_VEHICLE_DOSSIER_LOADED, data));
        }

        // Initial sort

        // TODO: save sort order to userprofile
        public function makeInitialSort():void
        {
            var idx:int = Math.abs(Config.config.userInfo.sortColumn) - 1;
            var buttonBar:SortableHeaderButtonBar = page.listComponent.sortableButtonBar;
            if (Config.config.userInfo.showXTEColumn)
            {
                if (buttonBar.dataProvider.length > 8)
                    idx = idx == 7 ? 8 : idx == 8 ? 7 : idx; // swap 8 and 9 positions (mastery and xTE columns)
            }
            if (idx > buttonBar.dataProvider.length - 1)
                idx = 5;

            buttonBar.selectedIndex = idx;

            var button:SortingButton = SortingButton(buttonBar.getButtonAt(idx));
            if (button == null)
                return;
            button.sortDirection = Config.config.userInfo.sortColumn > 0 ? SortingInfo.ASCENDING_SORT : SortingInfo.DESCENDING_SORT;

            page.listComponent.techniqueList.sortByField(button.id, Config.config.userInfo.sortColumn > 0);

            page.listComponent.techniqueList.removeEventListener(SortableScrollingListEvent.SORT_APPLIED, onListSortAppliedHandler);
            page.listComponent.techniqueList.addEventListener(SortableScrollingListEvent.SORT_APPLIED, onListSortAppliedHandler, false, 0, true);
        }

        public function fixStatData():void
        {
            if (_disposed)
                return;

            try
            {
                var stat:StatData = accountDBID == 0 ? Stat.getUserDataByName(playerName) : Stat.getUserDataById(accountDBID);
                if (stat && stat.v)
                {
                    for each (var data:Object in currentData)
                    {
                        if (data == null)
                            continue;
                        var vdata:Object = stat.v[data.id];
                        if (data.xvm_xte < 0)
                        {
                            if (vdata && !isNaN(vdata.xte) && vdata.xte > 0)
                            {
                                data.xvm_xte = vdata.xte;
                                if (vdata.b != data.battlesCount)
                                {
                                    data.xvm_xte_flag |= 0x01;
                                }
                            }
                        }
                    }
                }
                page.invalidate("ddInvalid");
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        // PRIVATE

        // sort

        private function onListSortAppliedHandler(e:SortableScrollingListEvent):void
        {
            try
            {
                page.listComponent.techniqueList.removeEventListener(SortableScrollingListEvent.SORT_APPLIED, onListSortAppliedHandler);
                page.listComponent.selectVehicleById(_selectedItemCD);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        // stat

        private function onStatLoaded(e:ObjectEvent):void
        {
            //Logger.add("onStatLoaded: " + playerName + " " + e.result);

            if (_disposed)
                return;

            if (e.result != playerName)
                return;

            Stat.instance.removeEventListener(Stat.COMPLETE_USERDATA, onStatLoaded);

            fixStatData();
        }
    }
}
