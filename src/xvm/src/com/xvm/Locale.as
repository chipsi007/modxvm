﻿/**
 * XVM Localization module
 * @author Maxim Schedriviy "m.schedriviy(at)gmail.com"
 * @author Mikhail Paulyshka "mixail(at)modxvm.com"
 * @author Pavel Máca
 */
package com.xvm
{
    import com.xvm.*;
    import com.xvm.events.*;
    import com.xvm.io.*;
    import com.xvm.misc.*;
    import com.xvm.utils.*;
    import flash.events.*;

    public class Locale extends EventDispatcher
    {
        /////////////////////////////////////////////////////////////////
        // PUBLIC STATIC

        private static var _instance:Locale = null;
        public static function get Instance():Locale
        {
            if (_instance == null)
                _instance = new Locale();
            return _instance;
        }

        public static function LoadLocaleFile():void
        {
            Instance.setupLanguage(JSONxLoader.Load(Defines.XVM_L10N_DIR_NAME + Config.language + ".xc"));
        }

        public static function get(format:String):String
        {
            //Logger.add("Locale[get]: string: " + format + " | string: " + s_lang[format] + " | fallback string: " + s_lang_fallback[format]);
            if (s_lang && s_lang[format] != null)
                format = s_lang[format];
            else if (s_lang_fallback[format] != null)
                format = s_lang_fallback[format];

            /** each item in array begin with macro */
            var formatParts:Vector.<String> = Vector.<String>(format.split("{{" + MACRO_PREFIX + ":"));

            /** begin part until first macro start */
            var res:String = formatParts.shift();
            var len:int = formatParts.length;
            for (var i:int = 0; i < len; ++i)
            {
                /** "macro}} rest of text" */
                var part:String = formatParts[i];

                /** find macro end & make sure it contains at least 1 symbol */
                var macroEnd:Number = part.indexOf("}}", 1);
                if (macroEnd == -1) {
                    /** no end chars => write everythink back */
                    res += "{{" + MACRO_PREFIX + ":" + part;
                    continue;
                }

                var macro:String = part.slice(0, macroEnd);
                var stringParts:Array = macro.split(":");
                macro = stringParts[0];
                stringParts.shift();
                macro = Locale.get(macro);
                if (stringParts.length > 0)
                    macro = Utils.substitute(macro, stringParts);
                res += macro;

                /** write rest of text after macro, without }} */
                res += part.slice(macroEnd + 2, part.length);
            }

            return res;
        }


        /////////////////////////////////////////////////////////////////
        // PRIVATE

        private static const MACRO_PREFIX:String = "l10n";

        /** Hardcoded RU language */
        private static const FALLBACK_RU:Object = {
            // Common
            "Warning": "Предупреждение",
            "Error": "Ошибка",
            "Information": "Информация",
            "OK": "OK",
            "Cancel": "Отмена",
            "Save": "Сохранить",
            "Remove": "Удалить",
            "Yes": "Да",
            "No": "Нет",

            // Ping
            "Initialization": "Инициализация",

            // Win chance
            "Chance error": "Ошибка расчета шансов",
            "Chance to win": "Шансы на победу",
            //"global": "общий",
            //"per-vehicle": "по технике",
            "chanceLive": "Для живых",
            "chanceBattleTier": "Уровень боя",

            /* xvm-as2
            // Hitlog
            "shot": "атака",
            "fire": "пожар",
            "ramming": "таран",
            "world_collision": "падение",
            "death_zone": "death zone",
            "drowning": "drowning",
            "Hits": "Пробитий",
            "Total": "Всего",
            "Last": "Последний",

            // Hp Left
            "hpLeftTitle": "Осталось HP:",

            // Capture
            "enemyBaseCapture": "Захват базы союзниками!",
            "enemyBaseCaptured": "База захвачена союзниками!",
            "allyBaseCapture": "Захват базы врагами!",
            "allyBaseCaptured": "База захвачена врагами!",
            */

            // BattleResults
            "Hit percent": "Процент попаданий",
            "Damage (assisted / own)": "Урон (по разведданным / свой)",
            "BR_xpCrew": "экипажу",

            // TeamRenderers
            "Friend": "Друг",
            "Ignored": "Игнор",
            "unknown": "неизвестно",
            "Fights": "Боёв",
            "Wins": "Побед",
            "Data was updated at": "Данные были обновлены",
            "Load statistics": "Загрузить статистику",

            // Profile
            "General stats": "Общая статистика",
            "Summary": "Общие результаты",
            "Avg level": "Средний уровень",
            //"WN6": "WN6",
            //"WN8": "WN8",
            "EFF": "РЭ",
            "WGR": "ЛРИ",
            "updated": "обновлено",
            " to ": " до ",
            "avg": "ср.",
            "top": "топ",
            "draws": "ничьих",
            "Maximum damage": "Максимальный урон",
            "Specific damage (Avg dmg / HP)": "Уд. урон (ср. урон / прочность)",
            "Capture points": "Очки захвата",
            "Defence points": "Очки защиты",
            "Filter": "Фильтр",

            "Extra data (WoT 0.8.8+)": "Доп. данные (WoT 0.8.8+)",
            "Average battle time": "Среднее время жизни в бою",
            "Average battle time per day": "Среднее время игры в день",
            "Battles after 0.8.8": "Боев после 0.8.8",
            "Average experience": "Средний опыт",
            "Average experience without premium": "Средний опыт без премиума",
            "Average distance driven per battle": "В среднем пройдено км за бой",
            "Average woodcuts per battle": "В среднем повалено деревьев за бой",
            "Average damage assisted": "Средний урон с вашей помощью",
            "    by tracking": "    после сбития гусеницы",
            "    by spotting": "    по разведданным",
            "Average HE shells fired (splash)": "Средний урон фугасами (сплэш)",
            "Average HE shells received (splash)": "Средний полученный урон фугасами",
            "Average penetrations per battle": "В среднем пробитий за бой",
            "Average hits received": "В среднем получено попаданий",
            "Average penetrations received": "В среднем получено пробитий",
            "Average ricochets received": "В среднем получено рикошетов",

            // Crew
            "PutOwnCrew": "Родной экипаж",
            "PutBestCrew": "Лучший экипаж",
            "PutClassCrew": "Экипаж того же класса",
            "PutPreviousCrew": "Предыдущий экипаж",
            "DropAllCrew": "Высадить весь экипаж",

            // Vehicle Params
            "gun_reload_time/actual": "Расчетное время перезарядки орудия",
            "view_range/base": "базовый",
            "view_range/actual": "расчетный",
            "view_range/stereoscope": "со стереотрубой",
            "radio_range/base": "базовая",
            "radio_range/actual": "расчетная",
            "(sec)": "(сек)",
            "(m)": "(м)",

            // Squad
            "Squad battle tiers": "Уровень боев взвода",
            "Vehicle": "Танк",
            "Battle tiers": "Уровень боёв",
            "Type": "Тип",
            "Nation": "Нация",
            "ussr": "СССР",
            "germany": "Германия",
            "usa": "США",
            "france": "Франция",
            "uk": "Великобритания",
            "china": "Китай",
            "japan": "Япония",
            "HT": "ТТ",
            "MT": "СТ",
            "LT": "ЛТ",
            "TD": "ПТ",
            "SPG": "САУ",

            // VehicleMarkersManager
            "blownUp": "Взрыв БК!",

            // Check version
            "ver/currentVersion": "XVM {0} ({1})", // XVM 5.3.4 (4321)
            "ver/newVersion": "Доступно обновление:<tab/><a href='#XVM_SITE_DL#'><font color='#00FF00'>v{0}</font></a>\n{1}",
            "websock/not_connected": "<font color='#FFFF00'>нет подключения к серверу XVM</font>",

            // token
            "token/services_unavailable": "Ошибка сети.\nСервисы XVM недоступны, попробуйте позже.",
            "token/services_inactive": "Сервисы XVM неактивны.\n{{l10n:token/notify_site_activate}}",
            "token/blocked": "Статус: <font color='#FF0000'>Заблокирован</font>\n{{l10n:token/notify_site_activate}}",
            "token/inactive": "Статус: <font color='#FFFF00'>Неактивен</font>\n{{l10n:token/notify_site_activate}}",
            "token/active": "Статус:<tab/><font color='#00FF00'>Активен</font>",
            "token/time_left": "Осталось:<tab/><font color='#EEEEEE'>{0}д. {1}ч. {2}м.</font>",
            "token/time_left_warn": "Осталось:<tab/><font color='#EEEE00'>{0}д. {1}ч. {2}м.</font>",
            "token/cnt": "Количество запросов:<tab/><font color='#EEEEEE'>{0}</font>",
            "token/unknown_status": "Неизвестный статус",
            "token/notify_site_activate": "Пожалуйста, перейдите на <a href='#XVM_SITE#'>сайт XVM</a> и активируйте сервисы XVM в личном кабинете, либо добавьте клиент, если вы уже активировали их ранее.",

            // Carousel
            "NonElite": "Не элитный",
            "Premium": "Премиум",
            "Normal": "Обычный",
            "MultiXP": "Мультиопыт",
            "NoMaster": "Нет мастера",

            // Comments
            "Comments disabled": "Comments disabled",
            "Error loading comments": "Ошибка загрузки комментариев",
            "Error saving comments": "Ошибка сохранения комментариев",
            "Edit data": "Изменить данные",
            "Nick": "Имя",
            "Group": "Группа",
            "Comment": "Комментарий",

            //Vehicle status
            "Destroyed": "Уничтожен",
            "No data": "Нет данных",
            "Not ready": "Не готов"
        };

        /** Hardcoded EN language */
        private static const FALLBACK_EN:Object = {
            // Win chance
            "chanceLive": "For alive",
            "chanceBattleTier": "Battle tier",

            /* xvm-as2
            // Hitlog
            "world_collision": "falling",
            "death_zone": "death zone",
            "drowning": "drowning",

            // Hp Left
            "hpLeftTitle": "Hitpoints left:",

            // Capture
            "enemyBaseCapture": "Base capture by allies!",
            "enemyBaseCaptured": "Base captured by allies!",
            "allyBaseCapture": "Base capture by enemies!",
            "allyBaseCaptured": "Base captured by enemies!",
            */

            // BattleResults
            "BR_xpCrew": "crew",

            // Crew
            "PutOwnCrew": "Put own crew",
            "PutBestCrew": "Put best crew",
            "PutClassCrew": "Put same class crew",
            "PutPreviousCrew": "Put previous crew",
            "DropAllCrew": "Drop all crew",

            // Vehicle Params
            "gun_reload_time/actual": "Actual gun reload time",
            "view_range/base": "base",
            "view_range/actual": "actual",
            "view_range/stereoscope": "with stereoscope",
            "radio_range/base": "base",
            "radio_range/actual": "actual",
            "(sec)": "(sec)",
            "(m)": "(m)",

            // Squad
            "ussr": "USSR",
            "germany": "Germany",
            "usa": "USA",
            "france": "France",
            "uk": "UK",
            "china": "China",
            "japan": "Japan",

            // VehicleMarkersManager
            "blownUp": "Blown-up!",

            // Check version
            "ver/currentVersion": "XVM {0} ({1})", // XVM 5.3.4 (4321)
            "ver/newVersion": "Update available:<tab/><a href='#XVM_SITE_DL#'><font color='#00FF00'>v{0}</font></a>\n{1}",
            "websock/not_connected": "<font color='#FFFF00'>no connection to XVM server</font>",

            // token
            "token/services_unavailable": "Network error. XVM services is unavailable, try again later.",
            "token/services_inactive": "XVM services inactive.\n{{l10n:token/notify_site_activate}}",
            "token/blocked": "Status: <font color='#FF0000'>Blocked</font><br>{{l10n:token/notify_site_activate}}",
            "token/inactive": "Status: <font color='#FFFF00'>Inactive</font><br>{{l10n:token/notify_site_activate}}",
            "token/active": "Status:<tab/><font color='#00FF00'>Active</font>",
            "token/time_left": "Time left:<tab/><font color='#EEEEEE'>{0}d. {1}h. {2}m.</font>",
            "token/time_left_warn": "Time left:<tab/><font color='#EEEE00'>{0}d. {1}h. {2}m.</font>",
            "token/cnt": "Requests count:<tab/><font color='#EEEEEE'>{0}</font>",
            "token/unknown_status": "Unknown status",
            "token/notify_site_activate": "Please go to the <a href='#XVM_SITE#'>XVM site</a> and activate XVM services in the personal cabinet, or add client, if you have already activated it.",

            // Carousel
            "NonElite": "Non elite",
            "Premium": "Premium",
            "Normal": "Normal",
            "MultiXP": "Multi XP",
            "NoMaster": "No master"
        };

        public static var s_lang:Object;
        private static var s_lang_fallback:Object;

        //private var _initialized:Boolean = false;
        //private var _language:String;
        //private var _loaded:Boolean = false;
        //private var timer:Number;

        function Locale()
        {
            s_lang = null;
            // This strings will be used if [langcode].xc not found
            s_lang_fallback = (Config.gameRegion == "RU") ? FALLBACK_RU : FALLBACK_EN;
        }

        private function setupLanguage(res:Object):void
        {
            var e:Error = res as Error;
            if (e != null)
            {
                if (res.type == "NO_FILE")
                {
                    Logger.add("Locale: Can not find language file. " + e.message);
                }
                else
                {
                    var text:String = "[" + res.type + "] " + res.message + ": ";
                    text += ConfigUtils.parseErrorEvent(e);
                    Logger.add(text);
                }
            }
            else
            {
                s_lang = res.locale;
                if (s_lang == null)
                    Logger.add("Locale: \"locale\" section is not found in the file");
            }
        }
    }
}
