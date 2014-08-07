{
  "battleMessenger": {
    // Enable battleMessenger module.
    // Включение модификации чата.
    "enabled": true,

    // Enable debug mode.
    // Режим отладки.
    "debugMode": false,

    // Enable rating filters
    // Включение фильтра по рейтингу
    "enableRatingFilter": false,

    // Minimum WN8 rating of sender for displaying message.
    // Минимальное значение рейтинга у игрока, при котором отображается его сообщение.
    "minRating": 0,

    // Message display time in seconds.
    // Время отображения сообщения в секундах.
    "messageLifeTime": 10,

    // Number of messages displayed on chat
    // Максимальное число сообщений, которые могут отображаться одновременно
    "chatLength": 10,

    // Background transparency (0-100)
    // Прозрачность фона (от 0 до 100)
    "backgroundAlpha": 100,

    // Mod will hide any messages from allies in next battle types:
    // Мод будет скрывать сообщения от союзников в следующих типах боёв:
    "ignore": {
      "clan": false,
      "squad": false,
      "companyBattle": false,
      "specialBattle": false,
      "trainingBattle": false,
      "randomBattle": false
    },

    // Hide messages from allies. true - hide, false - show.
    // Скрытие сообщений от союзников. true - скрывать, false - показывать.
    "blockAlly": {
      "dead": false,
      "alive": false
    },

    // Hide messages from enemies. true - hide, false - show.
    // Скрытие сообщений от противников. true - скрывать, false - показывать.
    "blockEnemy": {
      "dead": false,
      "alive": false
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
    }
  }
}