﻿/**
 * Parameters of the Battle Statistics form.
 * Параметры окна статистики по клавише Tab.
 */
{
  "statisticForm": {
    // true - Enable display of battle tier.
    // true - включить отображение уровня боя.
    "showBattleTier": false,
    // true - Disable Platoon icons.
    // true - убрать отображение иконки взвода.
    "removeSquadIcon": false,
    // Display options for Team/Clan logos (see battleLoading.xc).
    // Параметры отображения иконки игрока/клана (см. battleLoading.xc).
    "clanIcon": {
      "show": true,
      "x": 0,
      "y": 6,
      "xr": 0,
      "yr": 6,
      "w": 16,
      "h": 16,
      "alpha": 90
    },
    // Display format for the left panel (macros allowed, see readme-en.txt).
    // Формат отображения для левой панели (допускаются макроподстановки, см. readme-ru.txt).
    "formatLeftNick": "{{name%.20s~..}}<font alpha='#A0'>{{clan}}</font>",
    // Display format for the right panel (macros allowed, see readme-en.txt).
    // Формат отображения для правой панели (допускаются макроподстановки, см. readme-ru.txt).
    "formatRightNick": "{{name%.20s~..}}<font alpha='#A0'>{{clan}}</font>",
    // Display format for the left panel (macros allowed, see readme-en.txt).
    // Формат отображения для левой панели (допускаются макроподстановки, см. readme-ru.txt).
    "formatLeftVehicle": "{{vehicle}}<font face='Lucida Console' size='12' alpha='{{alive?#FF|#80}}'> <font color='{{c:kb}}'>{{kb%2d~k}}</font> <font color='{{c:xwn8}}'>{{xwn8}}</font> <font color='{{c:rating}}'>{{rating%2d~%}}</font></font>",
    // Display format for the right panel (macros allowed, see readme-en.txt).
    // Формат отображения для правой панели (допускаются макроподстановки, см. readme-ru.txt).
    "formatRightVehicle": "<font face='Lucida Console' size='12' alpha='{{alive?#FF|#80}}'><font color='{{c:rating}}'>{{rating%2d~%}}</font> <font color='{{c:xwn8}}'>{{xwn8}}</font> <font color='{{c:kb}}'>{{kb%2d~k}}</font> </font>{{vehicle}}"
  }
}
