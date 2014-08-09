{
  "battleMessenger": {
    // Enable battleMessenger module.
    // Включение модификации чата.
    "enabled": true,

    // Enable debug mode.
    // Режим отладки.
    "debugMode": false,

    // Message display time in seconds.
    // Время отображения сообщения в секундах.
    "messageLifeTime": 10,

    // Number of messages displayed on chat
    // Максимальное число сообщений, которые могут отображаться одновременно
    "chatLength": 10,

    // Background transparency (0-100)
    // Прозрачность фона (от 0 до 100)
    "backgroundAlpha": 100,

    // Mod will hide any messages from players. Available values: none, alive, dead, both
    // Мод будет скрывать сообщения от игроков, которые попадают под следующие критерии. Доступные значения: none, alive, dead, both
    "block": {
      "ally": {
        "clan": "none",
        "squad": "none",
        "companyBattle": "none",
        "specialBattle": "none",
        "trainingBattle": "none",
        "randomBattle": "none"
      },
      "enemy": {
        "clan": "none",
        "squad": "none",
        "companyBattle": "none",
        "specialBattle": "none",
        "trainingBattle": "none",
        "randomBattle": "none"
      }
    },

    // Mod will apply rating filter and antispam to messages from players. Available values: none, alive, dead, both
    // Мод будет применять фильтр по рейтингу и антиспам к сообщениям игроков, которые попадают под следующие критерии. Доступные значения: none, alive, dead, both
    "filter": {
      "ally": {
        "clan": "none",
        "squad": "none",
        "companyBattle": "none",
        "specialBattle": "none",
        "trainingBattle": "none",
        "randomBattle": "none"
      },
      "enemy": {
        "clan": "none",
        "squad": "none",
        "companyBattle": "none",
        "specialBattle": "none",
        "trainingBattle": "none",
        "randomBattle": "none"
      }
    },

    // Antispam
    // Антиспам
    "antispam": {
      //Enable antispam.
      //Включение антиспама.
      "enabled": false,

      //Prevent duplicate messages. Limit of duplicateCount identical messages from one player per duplicateInterval.
      //Блокировка дубликатов: не более duplicateCount одинаковых сообщений от одного игрока за duplicateInterval секунд.
      "duplicateCount": 2,
      "duplicateInterval": 7,

      //Prevent spam. Limit of duplicateCount messages from one player per duplicateInterval.
      //Блокировка спама: не более duplicateCount сообщений от одного игрока за duplicateInterval секунд.
      "playerCount": 3,
      "playerInterval": 7,

      //Enable/disable set of Wargaming.net filters (from lobby chat rooms), EU only.
      //Включение стоп-фильтра от Wargaming.net, только EU кластер.
      "WG_Filters": false,

      //Custom filters: block all messages containing these mask
      //Пользовательский фильтр: блокировка всех сообщений, которые попадают под эти маски.
      "customFilters": []
    },

    // Rating filters
    // Фильтры по рейтингу
    "ratingFilters": {
      // Enable rating filters
      // Включение фильтров по рейтингу
      "enabled": false,
      
      // Minimum WN8 rating of sender for displaying message.
      // Минимальное значение рейтинга WN8 у игрока, при котором отображается его сообщение.
      "minWN8": 0
    }
  }
}