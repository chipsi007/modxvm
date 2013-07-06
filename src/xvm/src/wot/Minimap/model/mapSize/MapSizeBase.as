class wot.Minimap.model.mapSize.MapSizeBase
{
    public static function sizeBySytemMapName(mapName:String):Number
    {
        mapName = mapName.toLowerCase();
        switch(mapName)
        {
            case "31_airfield":    // Аэропорт
                return 100;
            case "38_mannerheim_line": // Заполярье
                return 100;
            case "18_cliff": // Утёс
                return 100;
            case "51_asia":   // Хребет дракона
                return 100;
            case "29_el_hallouf": // Халлуф
                return 100;
            case "06_ensk":       // Энас
                return 60;
            case "13_erlenberg":   // Эрленберг
                return 100;
            case "36_fishing_bay":  // Рыбацкая бхута
                return 100;
            case "33_fjord":        // Фьёрды
                return 100;
            case "45_north_america": // Хайвей
                return 100;
            case "04_himmelsdorf":  // Химмельсдорф
                return 70;
            case "01_karelia":  // Карелия
                return 100;
            case "15_komarin": // Комарин
                return 80;
            case "07_lakeville": // Ласвилль
                return 80;
            case "44_north_america": // Лайвокс
                return 100;
            case "02_malinovka":    // Малиновка
                return 100;
            case "10_hills":       // Рудники
                return 80;
            case "37_caucasus":  // Перевал
                return 100;
            case "19_monastery": // Монастырь
                return 100;
            case "11_murovanka": // Мурованка
                return 80;
            case "42_north_america": // Порт
                return 83;
            case "05_prohorovka": // Прохоровка
                return 100;
            case "03_campania":  // Провинция
                return 60;
            case "34_redshire": // Редшир
                return 100;
            case "08_ruinberg": // Руинберг
                return 80;
            case "28_desert":   // Песчанная река
                return 100;
            case "47_canada_a": // Тихий берег
                return 100;
            case "14_siegfried_line": // Зигфрида
                return 100;
            case "39_crimea": // Южный берег
                return 100;
            case "35_steppes": // Степи
                return 100;
            case "23_westfeld": // Вестфилд
                return 100;
            case "17_munchen": // Вайдпарк
                return 60;
            case "60_asia_miao": // Жемчужная река
                return 100;
            case "73_asia_korea": // Священная долина
                return 100;
            case "85_winter": // Белогорск-19
                return 100;
            default:
                return undefined;
        }
    }

    public static function sizeByLocalizedMapName(localizedMapName:String):Number
    {
        switch(localizedMapName)
        {
            /**
             * Deustch locale by PusteBlumeKuchen
             * http://code.google.com/p/wot-xvm/issues/detail?id=367
             */
            case "Аэродром":
            case "Аэрадром":
            case "Летовище":
            case "Airfield":
            case "Flugplatz":
            case "阿拉曼机场":
                return sizeBySytemMapName("31_airfield");
 
            case "Уайдпарк":
            case "Вайдпарк":
            case "Widepark":
            case "Weitpark":
            case "慕尼黑":
                return sizeBySytemMapName("17_munchen");
 
            case "Вестфилд":
            case "Вестфілд":
            case "Вэстфільд":
            case "Westfield":
            case "韦斯特菲尔德":
                return sizeBySytemMapName("23_westfeld");
 
            case "Заполярье":
            case "Паўночча":
            case "Заполяр'я":
            case "Arctic Region":
            case "Polargebiet":
            case "极地冰原":
                return sizeBySytemMapName("38_mannerheim_line");
 
            case "Карелия":
            case "Карэлія":
            case "Карелія":
            case "Karelia":
            case "Karelien":
            case "卡累利阿":
                return sizeBySytemMapName("01_karelia");
 
            case "Комарин":
            case "Камарын":
            case "Komarin":
            case "科马林":
                return sizeBySytemMapName("15_komarin");
 
            case "Лайв Окс":
            case "Дуброва":
            case "Live Oaks":
            case "里夫奥克斯":
                return sizeBySytemMapName("44_north_america");
 
            case "Ласвилль":
            case "Лаквіль":
            case "Ласвілль":
            case "Lakeville":
            case "拉斯威利":
                return sizeBySytemMapName("07_lakeville");
 
            case "Линия Зигфрида":
            case "Лінія Зігфрыда":
            case "Лінія Зігфріда":
            case "Siegfried Line":
            case "Siegfriedlinie":
            case "齐格菲防线":
                return sizeBySytemMapName("14_siegfried_line");
 
            case "Малиновка":
            case "Малінаўка":
            case "Малинівка":
            case "Malinovka":
            case "Malinowka":
            case "马利诺夫卡":
                return sizeBySytemMapName("02_malinovka");
 
            case "Монастырь":
            case "Кляштар":
            case "Монастир":
            case "Abbey":
            case "Kloster":
            case "小镇争夺战":
                return sizeBySytemMapName("19_monastery");
 
            case "Мурованка":
            case "Мураванка":
            case "Murovanka":
            case "Murowanka":
            case "穆勒万卡":
                return sizeBySytemMapName("11_murovanka");
 
            case "Перевал":
            case "Горны перавал":
            case "Mountain Pass":
            case "Bergpass":
            case "胜利之门":
                return sizeBySytemMapName("37_caucasus");
 
            case "Песчаная река":
            case "Пясчаная рака":
            case "Піщана ріка":
            case "Sand River":
            case "Wadi":
            case "荒漠小镇":
                return sizeBySytemMapName("28_desert");
 
            case "Порт":
            case "Port":
            case "Hafen":
            case "钢铁丛林":
                return sizeBySytemMapName("42_north_america");
 
            case "Провинция":
            case "Правінцыя":
            case "Провінція":
            case "Province":
            case "Provinz":
            case "坎帕尼亚":
                return sizeBySytemMapName("03_campania");
 
            case "Прохоровка":
            case "Прохараўка":
            case "Прохорівка":    
            case "Prokhorovka":
            case "Prokhorowka":
            case "普罗霍洛夫卡":
                return sizeBySytemMapName("05_prohorovka");
 
            case "Редшир":
            case "Рэдшыр":
            case "Redshire":
            case "斯特拉特福":
                return sizeBySytemMapName("34_redshire");
 
            case "Рудники":
            case "Капальні":
            case "Копальні":
            case "Mines":
            case "Minen":
            case "湖边的角逐":
                return sizeBySytemMapName("10_hills");
 
            case "Руинберг":
            case "Руінберг":
            case "Ruinberg":
            case "鲁别克":
                return sizeBySytemMapName("08_ruinberg");
 
            case "Рыбацкая бухта":
            case "Рыбацкая затока":
            case "Рибальська бухта":
            case "Fisherman's Bay":
            case "Fischerbucht":
            case "费舍尔湾":
                return sizeBySytemMapName("36_fishing_bay");
 
            case "Степи":
            case "Стэп":
            case "Steppes":
            case "Steppen":
            case "荒蛮之地":
                return sizeBySytemMapName("35_steppes");
 
            case "Тихий берег":
            case "Ціхі бераг":
            case "Serene Coast":
            case "Küste":
            case "寂静海岸":
                return sizeBySytemMapName("47_canada_a");
 
            case "Утёс":
            case "Стромкі бераг":
            case "Скеля":
            case "Cliff":
            case "Klippe":
            case "海岸争霸":
                return sizeBySytemMapName("18_cliff");
 
            case "Фьорды":
            case "Фіёрды":
            case "Фйорди":
            case "Fjords":
            case "Fjorde":
            case "北欧峡湾":
                return sizeBySytemMapName("33_fjord");
 
            case "Хайвей":
            case "Хуткасная шаша":
            case "Highway":
            case "州际公路":
                return sizeBySytemMapName("45_north_america");
 
            case "Химмельсдорф":
            case "Гімэльсдорф":
            case "Хіммельсдорф":
            case "Himmelsdorf":
            case "锡默尔斯多夫":
                return sizeBySytemMapName("04_himmelsdorf");
 
            case "Хребет Дракона":
            case "Хрыбет Цмока":
            case "Dragon Ridge":
            case "Drachenkamm":
            case "香格里拉":
                return sizeBySytemMapName("51_asia");
 
            case "Эль-Халлуф":
            case "Эль-Халуф":
            case "Ель-Халлуф":
            case "El Halluf":
            case "埃里-哈罗夫":
                return sizeBySytemMapName("29_el_hallouf");
 
            case "Энск":
            case "Енск":
            case "Ensk":
            case "安斯克":
                return sizeBySytemMapName("06_ensk");
 
            case "Эрленберг":
            case "Ерленберг":
            case "Erlenberg":
            case "埃勒斯堡":
                return sizeBySytemMapName("13_erlenberg");
 
            case "Южный берег":
            case "Паўднёвае ўзбярэжжа":
            case "Південний берег":
            case "South Coast":
            case "Südküste":
            case "雅尔塔小镇":
                return sizeBySytemMapName("39_crimea");
 
            case "Жемчужная река":
            case "Перлавая рака":
            case "Перлинна ріка":
            case "Pearl River":
            case "Perlenfluss":
                return sizeBySytemMapName("60_asia_miao");
            
            case "Священная долина":
            case "Священна долина":
            case "Святая даліна":
            case "Sacred Valley":
                return sizeBySytemMapName("73_asia_korea");

            case "Белогорск-19":
            case "Белагорск-19":
            case "Belogorsk-19":
                return sizeBySytemMapName("85_winter");

            default:
                return undefined;
        }

    }
}