/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package xvm.profile.components
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.types.dossier.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import net.wg.data.constants.*;
    import net.wg.gui.components.controls.SortableScrollingList;
    import net.wg.gui.components.controls.NormalSortingBtnInfo;
    import net.wg.gui.components.advanced.*;
    import net.wg.gui.lobby.profile.pages.technique.*;
    import scaleform.clik.data.*;
    import scaleform.clik.events.*;
    import xvm.profile.UI.*;

    public class Technique extends Sprite
    {
        protected var _page:ProfileTechnique;
        protected var _playerName:String;
        protected var _playerId:int;

        protected var filter:FilterControl;

        //private var techniqueListAdjuster:TechniqueListAdjuster;

        public function Technique(page:ProfileTechnique, playerName:String, playerId:int):void
        {
            try
            {
                this.name = "xvm_extension";
                this._page = page;
                this._playerName = playerName;
                this._playerId = playerId;

                // Change row height: 34 -> 32
                page.listComponent.techniqueList.rowHeight = 32;

                // remove upper/lower shadow
                page.listComponent.upperShadow.visible = false;
                page.listComponent.lowerShadow.visible = false;

                // override renderers
                list.itemRenderer = UI_TechniqueRenderer;

                // Initialize TechniqueStatisticsTab
                list.addEventListener(TechniqueList.SELECTED_DATA_CHANGED, initializeTechniqueStatisticTab);

                Dossier.loadAccountDossier(null, null, PROFILE.PROFILE_DROPDOWN_LABELS_ALL, playerId);

                delayedInit();

                return;

                // Add summary item to the first line of technique list
                //techniqueListAdjuster = new TechniqueListAdjuster(page);

                // TODO
                // create filter controls
                filter = null;
                if (Config.config.userInfo.showFilters)
                    createFilters();

            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        public function get page():ProfileTechnique
        {
            return _page;
        }

        public function get playerName():String
        {
            return _playerName;
        }

        public function get playerId():int
        {
            return _playerId;
        }

        public function get accountDossier():AccountDossier
        {
            return Dossier.getAccountDossier(playerId);
        }

        private function initializeTechniqueStatisticTab():void
        {
            //Logger.add("initializeTechniqueStatisticTab: " + playerName);
            list.removeEventListener(TechniqueList.SELECTED_DATA_CHANGED, initializeTechniqueStatisticTab);
            try
            {
                var data:Array = page.stackComponent.buttonBar.dataProvider as Array;
                if (data == null || data.length == 0 || !(data[0].hasOwnProperty("linkage")))
                {
                    App.utils.scheduler.envokeInNextFrame(initializeTechniqueStatisticTab);
                    return;
                }
                data[0].linkage = getQualifiedClassName(UI_TechniqueStatisticTab);
                page.stackComponent.buttonBar.selectedIndex = -1;
                page.stackComponent.buttonBar.selectedIndex = 0;
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        private function delayedInit():void
        {
            //Logger.add("delayedInit: " + playerName);
            try
            {
                // userInfo.sortColumn
                var bb:SortableHeaderButtonBar = page.listComponent.sortableButtonBar;
                var btnIndex:int = Math.abs(Config.config.userInfo.sortColumn) - 1;
                var b:SortingButton = bb.getButtonAt(btnIndex) as SortingButton;
                if (b == null)
                {
                    App.utils.scheduler.envokeInNextFrame(delayedInit);
                    return;
                }

                // Setup header
                setupHeader();

                bb.selectedIndex = -1;
                bb.selectedIndex = btnIndex;
                b.sortDirection = Config.config.userInfo.sortColumn < 0 ? SortingInfo.DESCENDING_SORT : SortingInfo.ASCENDING_SORT;
                list.selectedIndex = 0;

                // Focus filter
                if (filter != null && filter.visible && Config.config.userInfo.filterFocused == true)
                    filter.setFocus();

                // stat
                if (Config.networkServicesSettings.statAwards)
                    Stat.loadUserData(this, onStatLoaded, playerName, false);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        private function setupHeader():void
        {
            /*var dp:Array = page.listComponent.sortableButtonBar.dataProvider as Array;
            dp[4].buttonWidth = 60; // BATTLES_COUNT,74
            dp[5].buttonWidth = 60; // WINS_EFFICIENCY,74
            dp[6].buttonWidth = 70; // AVG_EXPERIENCE,90
            dp[7].buttonWidth = 60; // MARK_OF_MASTERY,83
            dp[7].showSeparator = true;

            var bi:NormalSortingBtnInfo = new NormalSortingBtnInfo();
            bi.buttonWidth = 60;
            bi.sortOrder = 8;
            bi.toolTip = PROFILE.SECTION_TECHNIQUE_SORT_TOOLTIP_WINS;
            bi.iconId = TechniqueList.WINS_EFFICIENCY;
            bi.defaultSortDirection = SortingInfo.DESCENDING_SORT;
            bi.ascendingIconSource = RES_ICONS.MAPS_ICONS_BUTTONS_TAB_SORT_BUTTON_ASCPROFILESORTARROW;
            bi.descendingIconSource = RES_ICONS.MAPS_ICONS_BUTTONS_TAB_SORT_BUTTON_DESCPROFILESORTARROW;
            bi.buttonHeight = 40;
            bi.enabled = true;
            bi.label = PROFILE.SECTION_TECHNIQUE_BUTTONBAR_TOTALWINS;
            bi.showSeparator = false;
            dp.push(bi);

            page.listComponent.sortableButtonBar.itemRendererName = getQualifiedClassName(UI_ProfileSortingButton);
            page.listComponent.sortableButtonBar.dataProvider = new DataProvider(dp);
            page.listComponent.techniqueList.columnsData = page.listComponent.sortableButtonBar.dataProvider;

            //Logger.addObject(page.listComponent.sortableButtonBar.dataProvider, 2);
            */
        }

        protected function get list():TechniqueList
        {
            return page.listComponent.techniqueList;
        }

        // virtual
        protected function createFilters():void
        {
            //filter = new FilterControl();
            //filter.addEventListener(Event.CHANGE, techniqueListAdjuster.applyFilter);
            //page.addChild(filter);
        }

        // PRIVATE

        // STAT

        private function onStatLoaded():void
        {
            //Logger.add("onStatLoaded: " + playerName);
            if (page != null && page.listComponent != null && page.listComponent.visible)
            {
                if (page is ProfileTechniqueWindow && page.listComponent.selectedItem && page.listComponent.selectedItem.id == 0)
                    page.listComponent.dispatchEvent(new Event(ListEvent.INDEX_CHANGE));
                else
                    page.listComponent.dispatchEvent(new Event(TechniqueListComponent.DATA_CHANGED));
            }
        }
    }
}
