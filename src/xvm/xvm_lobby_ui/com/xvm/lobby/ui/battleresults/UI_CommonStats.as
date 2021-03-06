/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * https://modxvm.com/
 * @author Pavel Máca
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.lobby.ui.battleresults
{
    import com.xfw.*;
    import com.xvm.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import net.wg.data.constants.generated.*;
    import net.wg.gui.lobby.battleResults.components.*;
    import net.wg.gui.lobby.battleResults.data.*;
    import scaleform.clik.events.*;
    import scaleform.gfx.*;

    public dynamic class UI_CommonStats extends CommonStats
    {
        private const FIELD_POS_TITLE:String = "fieldPosTitle";
        private const FIELD_POS_NON_PREM:String = "fieldPosNonPrem";
        private const FIELD_POS_PREM:String = "fieldPosPrem";
        private const CSS_FIELD_CLASS:String = "xvm_bsField";
        private const XP_IMG_TXT:String = " <IMG SRC='img://gui/maps/icons/library/XpIcon-1.png' width='16' height='16' vspace='-2'/>";

        private var _fieldsInitialized:Boolean = false;
        private var _data:BattleResultsVO = null;
        private var xdataList:XvmCommonStatsDataListVO = null;
        private var currentTankIndex:int = 0;

        private var armorNames:Array = null;
        private var damageAssistedNames:Array = null;
        private var damageDealtNames:Array = null;

        private var shotsTitle:TextField;
        private var shotsCount:TextField;
        private var shotsPercent:TextField;
        private var damageAssistedTitle:TextField;
        private var damageAssistedValue:TextField;
        private var damageValue:TextField;

        private var spottedTotalField:EfficiencyIconRenderer;
        private var damageAssistedTotalField:EfficiencyIconRenderer;
        private var armorTotalField:EfficiencyIconRenderer;
        private var critsTotalField:EfficiencyIconRenderer;
        private var damageTotalField:EfficiencyIconRenderer;
        private var killsTotalField:EfficiencyIconRenderer;

        private var tooltips:Object;

        public function UI_CommonStats()
        {
            //Logger.add("UI_CommonStats");
            super();
        }

        override protected function configUI():void
        {
            super.configUI();
            tooltips = { };
            tankSlot.addEventListener(ListEvent.INDEX_CHANGE, onDropDownIndexChangeHandler, false, 0, true);
        }

        override protected function onDispose():void
        {
            tankSlot.removeEventListener(ListEvent.INDEX_CHANGE, onDropDownIndexChangeHandler);

            _data = null;
            xdataList = null;

            try
            {
                // Some error occurs for an unknown reason
                super.onDispose();
            }
            catch (ex:Error)
            {
                if (Config.IS_DEVELOPMENT)
                {
                    //Logger.err(ex);
                }
            }
        }

        override public function update(data:Object):void
        {
            //Logger.add("update");
            try
            {
                // Use data['common']['regionNameStr'] value to transfer XVM data.
                // Cannot add in data object because DAAPIDataClass is not dynamic.
                var xdataStr:String = data.common.regionNameStr;
                if (xdataStr.indexOf("\"__xvm\"") > 0)
                {
                    xdataList = new XvmCommonStatsDataListVO(JSONx.parse(xdataStr));
                    data.common.regionNameStr = xdataList.regionNameStr;
                }
                //Logger.addObject(data, 3);
                //Logger.addObject(data.personal, 5);
                //Logger.addObject(data.personal.details, 2);
                //Logger.addObject(data.common);

                // search localized strings for tooltips and calculate total values
                var personal:PersonalDataVO = data.personal;
                for (var i:String in personal.details)
                {
                    var creditsData:Vector.<DetailedStatsItemVO> = personal.creditsData[i] as Vector.<DetailedStatsItemVO>;
                    xdataList.data[i].creditsNoPremTotalStr = creditsData[creditsData.length - 1]["col1"];
                    xdataList.data[i].creditsPremTotalStr = creditsData[creditsData.length - 1]["col3"];
                    for each (var detail:Object in personal.details[i])
                    {
                        if (armorNames == null)
                        {
                            armorNames = detail.armorNames;
                        }
                        if (damageAssistedNames == null)
                        {
                            damageAssistedNames = detail.damageAssistedNames;
                        }
                        if (damageDealtNames == null)
                        {
                            damageDealtNames = detail.damageDealtNames;
                        }
                    }
                }
                //Logger.addObject(xdataList, 3);

                // original update
                super.update(data);

                // XVM update
                this._data = BattleResultsVO(data);

                detailsMc.validateNow();

                if (!_fieldsInitialized)
                {
                    _fieldsInitialized = true;
                    initializeFields();
                }

                hideQuestsShadows();

                if (Config.config.battleResults.showExtendedInfo)
                {
                    hideUselessButtons();
                }

                efficiencyHeader.summArmorTF.visible =
                    efficiencyHeader.summAssistTF.visible =
                    efficiencyHeader.summCritsTF.visible =
                    efficiencyHeader.summDamageTF.visible =
                    efficiencyHeader.summKillTF.visible =
                    efficiencyHeader.summSpottedTF.visible = !Config.config.battleResults.showTotals;

                updateValues();
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        private function onDropDownIndexChangeHandler(e:ListEvent) : void
        {
            this.currentTankIndex = e.index;
            updateValues();
        }

        // PRIVATE

        private function initializeFields():void
        {
            compactQuests();

            if (Config.config.battleResults.showExtendedInfo)
            {
                initTextFields();
            }

            if (Config.config.battleResults.showTotals)
            {
                initTotals();
            }

            if (Config.config.battleResults.showCrewExperience)
            {
                initCrewExperience();
            }
        }

        private function get xdata():XvmCommonStatsDataVO
        {
            return xdataList.data[this.currentTankIndex];
        }

        private function compactQuests():void
        {
            if (xfw_progressReport)
            {
                xfw_progressReport.linkage = getQualifiedClassName(UI_BR_SubtaskComponent);
            }
        }

        private function hideQuestsShadows():void
        {
            upperShadow.visible = false;
            lowerShadow.visible = false;
        }

        private function hideUselessButtons():void
        {
            detailsMc.detailedReportBtn.visible = false;
            detailsMc.getPremBtn.visible = false;
        }

        private function initTextFields():void
        {
            shotsTitle = createTextField(FIELD_POS_TITLE, 1);

            shotsCount = createTextField(FIELD_POS_NON_PREM, 1);

            shotsPercent = createTextField(FIELD_POS_PREM, 1);

            damageAssistedTitle = createTextField(FIELD_POS_TITLE, 2);

            damageAssistedValue = createTextField(FIELD_POS_NON_PREM, 2);
            damageAssistedValue.name = BATTLE_EFFICIENCY_TYPES.ASSIST;
            damageAssistedValue.addEventListener(MouseEvent.ROLL_OVER, onRollHandler, false, 0, true);
            damageAssistedValue.addEventListener(MouseEvent.ROLL_OUT, onRollHandler, false, 0, true);

            damageValue = createTextField(FIELD_POS_PREM, 2);
            damageValue.name = BATTLE_EFFICIENCY_TYPES.DAMAGE;
            damageValue.addEventListener(MouseEvent.ROLL_OVER, onRollHandler, false, 0, true);
            damageValue.addEventListener(MouseEvent.ROLL_OUT, onRollHandler, false, 0, true);
        }

        private function initTotals():void
        {
            try
            {
                // TODO: Need add 'stun' column
                var x:int = efficiencyTitle.x + 276;
                var y:int = efficiencyTitle.y + 34;
                var w:Number = 33;

                // spotted
                spottedTotalField = addChild(createTotalItem( { x: x, y: y, kind: BATTLE_EFFICIENCY_TYPES.DETECTION })) as EfficiencyIconRenderer;

                // damage assisted (radio/tracks)
                damageAssistedTotalField = addChild(createTotalItem( { x: x + w * 1, y: y, kind: BATTLE_EFFICIENCY_TYPES.ASSIST })) as EfficiencyIconRenderer;

                // armor
                armorTotalField = addChild(createTotalItem( { x: x + w * 2, y: y, kind: BATTLE_EFFICIENCY_TYPES.ARMOR })) as EfficiencyIconRenderer;

                // crits
                critsTotalField = addChild(createTotalItem( { x: x + w * 3, y: y, kind: BATTLE_EFFICIENCY_TYPES.CRITS })) as EfficiencyIconRenderer;

                // piercings
                damageTotalField = addChild(createTotalItem( { x: x + w * 4 + 1, y: y, kind: BATTLE_EFFICIENCY_TYPES.DAMAGE })) as EfficiencyIconRenderer;

                // kills
                killsTotalField = addChild(createTotalItem( { x: x + w * 5 + 1, y: y, kind: BATTLE_EFFICIENCY_TYPES.DESTRUCTION } )) as EfficiencyIconRenderer;
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        private static const CREW_EXP_OFFSET_X:int = 30;
        private function initCrewExperience():void
        {
            if (detailsMc.xpTitleLbl)
                detailsMc.xpTitleLbl.width += 50;
            if (detailsMc.noPremTitleLbl)
                detailsMc.noPremTitleLbl.x += CREW_EXP_OFFSET_X;
            if (detailsMc.creditsLbl)
                detailsMc.creditsLbl.x += CREW_EXP_OFFSET_X;
            if (detailsMc.xpLbl)
                detailsMc.xpLbl.x += CREW_EXP_OFFSET_X;
            if (detailsMc.resLbl)
                detailsMc.resLbl.x += CREW_EXP_OFFSET_X;
            if (shotsCount)
                shotsCount.x += CREW_EXP_OFFSET_X;
            if (damageAssistedValue)
                damageAssistedValue.x += CREW_EXP_OFFSET_X;
        }

        private function updateValues():void
        {
            if (Config.config.battleResults.showExtendedInfo)
            {
                showExtendedInfo();
            }

            if (Config.config.battleResults.showTotals)
            {
                showTotals();
            }

            if (Config.config.battleResults.showTotalExperience)
            {
                showTotalExperience();
            }

            if (Config.config.battleResults.showCrewExperience)
            {
                showCrewExperience();
            }

            if (Config.config.battleResults.showNetIncome)
            {
                showNetIncome();
            }
        }

        private function showExtendedInfo():void
        {
            shotsTitle.htmlText = formatText(Locale.get("Hit percent"), "#C9C9B6");
            shotsCount.htmlText = formatText(xdata.hits + "/" + xdata.shots, "#C9C9B6", TextFormatAlign.RIGHT);

            var hitsRatio:Number = (xdata.shots <= 0) ? 0 : (xdata.hits / xdata.shots) * 100;
            shotsPercent.htmlText = formatText(App.utils.locale.float(hitsRatio) + "%", "#C9C9B6", TextFormatAlign.RIGHT);

            damageAssistedTitle.htmlText = formatText(Locale.get("Damage (assisted / own)"), "#C9C9B6");
            damageAssistedValue.htmlText = formatText(App.utils.locale.integer(xdata.damageAssisted), "#408CCF", TextFormatAlign.RIGHT);
            damageValue.htmlText = formatText(App.utils.locale.integer(xdata.damageDealt), "#FFC133", TextFormatAlign.RIGHT);
        }

        private function showTotals():void
        {
            var tooltipData:IconEfficiencyTooltipData;

            // spotted
            spottedTotalField.value = xdata.spotted;
            spottedTotalField.enabled = xdata.spotted > 0;
            tooltips[BATTLE_EFFICIENCY_TYPES.DETECTION] = new IconEfficiencyTooltipData();

            // kills
            killsTotalField.value = xdata.kills;
            killsTotalField.enabled = xdata.kills > 0;
            tooltips[BATTLE_EFFICIENCY_TYPES.DESTRUCTION] = new IconEfficiencyTooltipData();

            // damage
            damageTotalField.value = xdata.piercings;
            damageTotalField.enabled = xdata.piercings > 0;
            tooltipData = new IconEfficiencyTooltipData();
            tooltipData.setBaseValues(
                [App.utils.locale.integer(xdata.damageDealt), xdata.piercings],
                damageDealtNames,
                2);
            tooltips[BATTLE_EFFICIENCY_TYPES.DAMAGE] = tooltipData;

            // armor
            armorTotalField.value = xdata.nonPenetrationsCount;
            armorTotalField.enabled = xdata.nonPenetrationsCount > 0;
            tooltipData = new IconEfficiencyTooltipData();
            tooltipData.setBaseValues(
                [xdata.ricochetsCount, xdata.nonPenetrationsCount, App.utils.locale.integer(xdata.damageBlockedByArmor)],
                armorNames,
                3);
            tooltips[BATTLE_EFFICIENCY_TYPES.ARMOR] = tooltipData;

            // assist (radio/tracks)
            damageAssistedTotalField.value = xdata.damageAssistedCount;
            damageAssistedTotalField.enabled = xdata.damageAssistedCount > 0;
            tooltipData = new IconEfficiencyTooltipData();
            tooltipData.totalAssistedDamage = xdata.damageAssisted;
            tooltipData.setBaseValues(
                [App.utils.locale.integer(xdata.damageAssistedRadio), App.utils.locale.integer(xdata.damageAssistedTrack), App.utils.locale.integer(xdata.damageAssisted)],
                damageAssistedNames,
                3);
            tooltips[BATTLE_EFFICIENCY_TYPES.ASSIST] = tooltipData;

            // crits
            critsTotalField.value = xdata.critsCount;
            critsTotalField.enabled = xdata.critsCount > 0;
            tooltipData = new IconEfficiencyTooltipData();
            //tooltipData.setCritValues(xdata.criticalDevices, xdata.destroyedTankmen, xdata.destroyedDevices, xdata.critsCount);
            tooltips[BATTLE_EFFICIENCY_TYPES.CRITS] = tooltipData;
        }

        private function showTotalExperience():void
        {
            detailsMc.xpLbl.htmlText = App.utils.locale.integer(xdata.origXP) + XP_IMG_TXT;
            detailsMc.premXpLbl.htmlText = App.utils.locale.integer(xdata.premXP) + XP_IMG_TXT;
        }

        private function showCrewExperience():void
        {
            detailsMc.xpTitleLbl.htmlText += " / " + Locale.get("BR_xpCrew");
            detailsMc.xpLbl.htmlText = detailsMc.xpLbl.htmlText.replace("<IMG SRC",
                "/ " + App.utils.locale.integer(xdata.origCrewXP) + " <IMG SRC");
            detailsMc.premXpLbl.htmlText = detailsMc.premXpLbl.htmlText.replace("<IMG SRC",
                "/ " + App.utils.locale.integer(xdata.premCrewXP) + " <IMG SRC");
        }

        private function showNetIncome():void
        {
            detailsMc.creditsLbl.htmlText = xdata.creditsNoPremTotalStr;
            detailsMc.premCreditsLbl.htmlText = xdata.creditsPremTotalStr;
        }

        // helpers

        private function createTextField(position:String, line:Number):TextField
        {
            var newTf:TextField = new TextField();
            var orig:TextField;
            switch (position)
            {
                case FIELD_POS_TITLE:
                    orig = detailsMc.xpTitleLbl;
                    newTf.autoSize = TextFieldAutoSize.LEFT;
                    break;
                case FIELD_POS_NON_PREM:
                    orig = detailsMc.xpLbl;
                    break;
                case FIELD_POS_PREM:
                    orig = detailsMc.premXpLbl;
                    break;
                default:
                    return null;
            }
            newTf.x = orig.x;
            newTf.height = detailsMc.xpTitleLbl.height;
            newTf.alpha = 1;

            newTf.styleSheet = XfwUtils.createTextStyleSheet(CSS_FIELD_CLASS, detailsMc.xpTitleLbl.defaultTextFormat);
            newTf.mouseEnabled = false;
            newTf.selectable = false;
            TextFieldEx.setNoTranslate(newTf, true);
            newTf.antiAliasType = AntiAliasType.ADVANCED;

            var y_space:Number = detailsMc.xpTitleLbl.height;
            var y_pos:Number = detailsMc.resTitleLbl && detailsMc.resTitleLbl.visible ? detailsMc.resTitleLbl.y : detailsMc.xpTitleLbl.y;

            newTf.y = y_pos + line * y_space;

            detailsMc.addChild(newTf);

            return newTf;
        }

        private function createTotalItem(params:Object = null):EfficiencyIconRenderer
        {
            var icon:EfficiencyIconRenderer = App.utils.classFactory.getComponent("EfficiencyIconRendererGUI", EfficiencyIconRenderer, params);
            icon.addEventListener(MouseEvent.ROLL_OVER, onRollHandler, false, 0, true);
            icon.addEventListener(MouseEvent.ROLL_OUT, onRollHandler, false, 0, true);
            return icon;
        }

        private function formatText(text:String, color:String, align:String = TextFormatAlign.LEFT):String
        {
            return "<p class='" + CSS_FIELD_CLASS + "' align='" + align + "'><font color='" + color + "'>" + text + "</font></p>";
        }

        private function onRollHandler(e:MouseEvent):void
        {
            //Logger.add("onRollHandler: " + e.type);
            if (e.type == MouseEvent.ROLL_OVER)
            {
                var icon:EfficiencyIconRenderer = e.currentTarget as EfficiencyIconRenderer;
                var kind:String = icon != null ? icon.kind : e.currentTarget.name;
                var tooltip:IconEfficiencyTooltipData = tooltips[kind];
                if (tooltip == null)
                    return;
                tooltip.type = kind;
                tooltip.disabled = icon == null ? false : icon.value <= 0;
                tooltip.isGarage = _data.common.playerVehicles.length > 1;
                App.toolTipMgr.showSpecial(TOOLTIPS_CONSTANTS.EFFICIENCY_PARAM, null, tooltip);
            }
            else
            {
                App.toolTipMgr.hide();
            }
        }

        private function merge(obj1:Object, obj2:Object):Object
        {
            var result:Object = new Object();
            for (var param:String in obj1)
                result[param] = obj1[param];
            for (param in obj2)
                result[param] = obj2[param];
            return result;
        }
    }
}
