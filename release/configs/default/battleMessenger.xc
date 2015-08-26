{
  "battleMessenger": {
    // true - Enable battleMessenger module.
    // true - Включение модификации чата.
    "enabled": true,

    // Message display time, in seconds.
    // Время отображения сообщения, в секундах.
    "messageLifeTime": 10,

    // Maximal number of simultaneously displayed messages in the chat
    // Максимальное число сообщений, которые могут отображаться одновременно
    "chatLength": 10,

    // Background transparency (0-100)
    // Прозрачность фона (от 0 до 100)
    "backgroundAlpha": 100,

    // Mod will hide any messages from players, that satisfy following criteria. 
    // Available values: none, alive, dead, all
    // Мод будет скрывать сообщения от игроков, которые попадают под следующие критерии. 
    // Доступные значения: none(отключено), alive(блокировать живых), dead(блокировать мертвых), all(блокировать всех)
    "block": {
      // Your clanmates
      // Ваши соклановцы
      "ourClan": "none",
      // Players of Your platoon
      // Игроки Вашего взвода
      "ourSquad": "none",

      // Filters by battle types. Nota bene, ourClan and ourSquad have higher priority.
      // Фильтры по типам боев. Обратите внимание, ourClan и ourSquad приоритетнее.

      // Ally team members
      // Члены команды союзников
      "ally": {
        // Filter while playing company battles
        // Фильтр для ротных боёв
        "companyBattle": "none",
        // Filter while playing special (global map) battles
        // Фильтр для спец. боёв (глобальная карта)
        "specialBattle": "none",
        // Filter while playing in training battles
        // Фильтр для тренировочных боёв
        "trainingBattle": "none",
        // Filter while playing random battles
        // Фильтр для случайных боёв
        "randomBattle": "none"
      },
      // Enemy team members
      // Члены команды противников
      "enemy": {
        // Filter while playing company battles
        // Фильтр для ротных боёв
        "companyBattle": "none",
        // Filter while playing special (global map) battles
        // Фильтр для спец. боёв (глобальная карта)
        "specialBattle": "none",
        // Filter while playing in training battles
        // Фильтр для тренировочных боёв
        "trainingBattle": "none",
        // Filter while playing random battles
        // Фильтр для случайных боёв
        "randomBattle": "none"
      }
    },

    // Mod will apply rating filter and antispam to messages from players, that satisfy following criteria.
    // Available values: none, alive, dead, all
    // Мод будет применять фильтр по рейтингу и антиспам к сообщениям игроков, которые попадают под следующие критерии.
    // Доступные значения: none(отключено), alive(блокировать живых), dead(блокировать мертвых), all(блокировать всех)
    "filter": {
      // Your clanmates
      // Ваши соклановцы
      "ourClan": "none",
      // Players of Your platoon
      // Игроки Вашего взвода
      "ourSquad": "none",

      // Filters by battle types. Nota bene, ourClan and ourSquad have higher priority.
      // Фильтры по типам боев. Обратите внимание, ourClan и ourSquad приоритетнее.

      // Ally team members
      // Члены команды союзников
      "ally": {
        // Filter while playing company battles
        // Фильтр для ротных боёв
        "companyBattle": "none",
        // Filter while playing special (global map) battles
        // Фильтр для спец. боёв (глобальная карта)
        "specialBattle": "none",
        // Filter while playing in training battles
        // Фильтр для тренировочных боёв
        "trainingBattle": "none",
        // Filter while playing random battles
        // Фильтр для случайных боёв
        "randomBattle": "none"
      },
      // Enemy team members
      // Члены команды противников
      "enemy": {
        // Filter while playing company battles
        // Фильтр для ротных боёв
        "companyBattle": "none",
        // Filter while playing special (global map) battles
        // Фильтр для спец. боёв (глобальная карта)
        "specialBattle": "none",
        // Filter while playing in training battles
        // Фильтр для тренировочных боёв
        "trainingBattle": "none",
        // Filter while playing random battles
        // Фильтр для случайных боёв
        "randomBattle": "none"
      }
    },

    // Antispam
    // Антиспам
    "antispam": {
      // true - Enable antispam.
      // true - Включение антиспама.
      "enabled": false,

      // Prevent duplicate messages. Limit of duplicateCount identical messages from one player per duplicateInterval.
      // Блокировка дубликатов: не более duplicateCount одинаковых сообщений от одного игрока за duplicateInterval секунд.
      "duplicateCount": 2,
      "duplicateInterval": 7,

      // Prevent spam. Limit of playerCount messages from one player per playerInterval.
      // Блокировка спама: не более playerCount сообщений от одного игрока за playerInterval секунд.
      "playerCount": 3,
      "playerInterval": 7,

      // Custom filters: block all messages containing these masks.
      // Mask "noob.*" will block messages starting from "noob" letter combination.
      // Mask ".*noob.*" will block messages with "noob" combination in any place of message.
      // Mask ".*damn" will block messages with "damn" combination at the end of message.
      // Separator for enumeration is "," (e.g. "customFilters": [".*noob.*", ".*damn"]).
      // ------------------------------------------------------------------------------------------------
      // Пользовательский фильтр: блокировка всех сообщений, которые попадают под эти маски.
      // Маска "нуб.*" заблокирует сообщения, начинающиеся буквосочитанеием "нуб".
      // Маска ".*нуб.*" заблокирует сообщения, содержащие сочетание "нуб" в любой их части.
      // Маска ".*чёрт" заблокирует сообщения, оканчивающиеся сочетанием "чёрт"
      // Разделителем для перечисления является "," (например, "customFilters": [".*нуб.*", ".*чёрт"]).
      "customFilters": []
    },

    // Rating filters
    // Фильтры по рейтингу
    "ratingFilters": {
      // true - Enable rating filters
      // true - Включение фильтров по рейтингу
      "enabled": false,

      // Minimum win rate of sender for display message (from 0 to 100).
      // Минимальный процент побед у игрока, при котором отображается его сообщение. (от 0 до 100)
      "minWinRate": 0,

      // Minimum EFF rating of sender for display message.
      // Минимальное значение рейтинга EFF у игрока, при котором отображается его сообщение.
      "minEFF": 0,

      // Minimum XEFF rating of sender for display message.
      // Минимальное значение рейтинга XEFF у игрока, при котором отображается его сообщение.
      "minXEFF": 0,

      // Minimum WN6 rating of sender for display message.
      // Минимальное значение рейтинга WN6 у игрока, при котором отображается его сообщение.
      "minWN6": 0,

      // Minimum XWN6 rating of sender for display message.
      // Минимальное значение рейтинга XWN6 у игрока, при котором отображается его сообщение.
      "minXWN6": 0,

      // Minimum WN8 rating of sender for display message.
      // Минимальное значение рейтинга WN8 у игрока, при котором отображается его сообщение.
      "minWN8": 0,

      // Minimum XWN8 rating of sender for display message.
      // Минимальное значение рейтинга XWN8 у игрока, при котором отображается его сообщение.
      "minXWN8": 0,

      // Minimum WGR rating of sender for display message.
      // Минимальное значение рейтинга WGR у игрока, при котором отображается его сообщение.
      "minWGR": 0,

      // Minimum XWGR rating of sender for display message.
      // Минимальное значение рейтинга XWGR у игрока, при котором отображается его сообщение.
      "minXWGR": 0
    }
  }
}