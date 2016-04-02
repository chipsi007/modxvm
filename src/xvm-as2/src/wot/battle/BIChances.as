﻿/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>, wotunion <http://www.koreanrandom.com/forum/user/27262-wotunion/>
 */
import com.xvm.*;
import wot.battle.BattleMain;

class wot.battle.BIChances
    {      
        public static var _BIChances:Object = {};
        public var chances: TextField; 

        public function BIChances()
            { 
                var debugPanel:MovieClip = _root.debugPanel;
                var fps:MovieClip = debugPanel.fps;
                	if (!Config.config.battle.WinChancesOnBattleInterface.DisableStatic)
                		BIChances._BIChances.__isShowChances = true;
                	else BIChances._BIChances.__isShowChances = false;
                	if (Config.networkServicesSettings.chanceLive && !Config.config.battle.WinChancesOnBattleInterface.DisableLive)
						BIChances._BIChances.__isShowLiveChances = true;
					else BIChances._BIChances.__isShowLiveChances = false;
                    BIChances._BIChances.__formatStaticTextFirst = "<span class='chances'>";
                    BIChances._BIChances.__formatStaticTextSecond = "</span>";
                    BIChances._BIChances.__Count = 0;
					chances = debugPanel.createTextField("chances", debugPanel.getNextHighestDepth(), Config.config.battle.WinChancesOnBattleInterface.x, Config.config.battle.WinChancesOnBattleInterface.y, Config.config.battle.WinChancesOnBattleInterface.width, Config.config.battle.WinChancesOnBattleInterface.height);
                    chances.selectable = false;
                    chances.antiAliasType = "advanced";
                    chances.html = true;
                    var tf: TextFormat = fps.getNewTextFormat();
                    chances.styleSheet = Utils.createStyleSheet(Utils.createCSS("chances",
                    tf.color, tf.font, tf.size, "left", tf.bold, tf.italic));
                    chances.filters = [new flash.filters.DropShadowFilter(1, 90, 0, 100, 5, 5, 1.5)];
                    _BIChances.__intervalID = setInterval(function() {
                        BIChances._BIChances.__Count++;
                        BIChances.UpdateBIChances();
                        }, 2000);
            }
    
        public static function UpdateBIChances() {
            if (BIChances._BIChances.__isShowLiveChances == undefined) {
                return;
            }
                var BIChancesText: String = Chance.GetChanceText(true, false,  BIChances._BIChances.__isShowLiveChances);
                if (((BIChancesText != "") && (BIChances._BIChances.__isClearedInterval != "true")) || (BIChances._BIChances.__Count > 5)) {
                    clearInterval(_BIChances.__intervalID);
                    BIChances._BIChances.__isClearedInterval = "true";
                }
                if BIChancesText == "" {
                    BIChances._BIChances.__instance.chances.htmlText = Utils.fixImgTag(BIChances._BIChances.__formatStaticTextFirst + '' + BIChances._BIChances.__formatStaticTextSecond);
                }
                else {
                    BIChances._BIChances.__instance.chances.htmlText = Utils.fixImgTag(formatChanceText(BIChancesText, BIChances._BIChances.__isShowChances, BIChances._BIChances.__isShowLiveChances));
                }
        }
        
        private static function formatChanceText(ChancesText: String, isShowChance, isShowLiveChance: Boolean) {
           var temp: Array = ChancesText.split('|', 2);
           var tempA: Array =	temp[0].split(':', 2);
           		if (isShowChance && isShowLiveChance) {
            		var tempB: Array = temp[1].split(':', 2);
                		return BIChances._BIChances.__formatStaticTextFirst + tempA[1] + '/' + tempB[1] + BIChances._BIChances.__formatStaticTextSecond;
           		}
            	else { 
            		if (isShowChance && !isShowLiveChance){
            			return BIChances._BIChances.__formatStaticTextFirst + tempA[1] + BIChances._BIChances.__formatStaticTextSecond;
            		}	
            	 	else {
            	 		var tempB: Array = temp[1].split(':', 2);
            			return BIChances._BIChances.__formatStaticTextFirst + tempB[1] + BIChances._BIChances.__formatStaticTextSecond;
            		}
            	}
            	
        }
	}