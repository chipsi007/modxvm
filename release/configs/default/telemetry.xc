/**
 * Telemetry.
 * Телеметрия.
 */
{
  "telemetry": {
    // set true to enable telemetry
    // установите в "true" для включения
    "enabled": true,
    
    // connection/logfile settings.
    // настройки подключения и логгирования.
    "connection": {
      
      //sink:
      //  Baical : deliver to Baical server over network
      //  FileBin: log into binary file, use Baical to open it
      //  FileTxt: log into a text file
      //  Console: log into console
      //  Syslog : log into syslog
      //  Auto   : deliver to Baical if connection is established, otherwise to file (timeout is 250ms)
      //  Null   : all data will be dropped
      "sink": "Auto",

      //Telemetry client instance name. Max length is 96 chars.
      //Имя клиента телеметрии. Максимальная длинна - 96 символов.
      "name": "WoT_XVM",

      //Maximum available memory for buffers (KiB)
      //Размер буфера в памяти в КиБ
      "memoryPool": 4096,

      //Server address. Can be IPv4, IPv6 or NetBIOS name.
      //Only for "Auto" or "Baical" sinks.
      //Адрес сервера. Допустимо использование IPv4, IPv6 или NetBIOS имени.
      //Только если "sink" установлено в "Auto" или "Baical".
      "serverAddress": "127.0.0.1",

      //Server port.
      //Only for "Auto" or "Baical" sinks.
      //Порт сервера.
      //Только если "sink" установлено в "Auto" или "Baical".
      "serverPort": 9009,
      
      //Packet size. From 512 to 65535.
      //Only for "Auto" or "Baical" sinks.
      //Размер пакета для передачи. Допустимые значения: от 512 до 65535.
      //Только если "sink" установлено в "Auto" или "Baical".
      "packetSize": 512,

      //Packet transmission window. From 1 to memoryPool/packetSize/2
      //Only for "Auto" or "Baical" sinks.
      //Размер окна передачи. Допустимые значения: от 1 до memoryPool/packetSize/2
      //Только если "sink" установлено в "Auto" или "Baical".
      "packetWindow": 1,

      //Log format.
      //  %cn – channel name
      //  %id – message ID 
      //  %ix – message index 
      //  %tf – full time: YY.MM.DD HH.MM.SS.mils.mics.nans 
      //  %tm – medium time: HH.MM.SS.mils.mics.nans 
      //  %ts – time short MM.SS.mils.mics.nans o
      //  %td – time difference between current and prev. one +SS.mils.mics.nans 
      //  %tc – time stamp in 100 nanoseconds intervals 
      //  %lv – log level 
      //  %ti – thread ID 
      //  %tn – thread name (if it was registered) 
      //  %cc – CPU core index 
      //  %mi – module ID
      //  %mn – module name 
      //  %ff – file name + path 
      //  %fs – file name 
      //  %fl – file line 
      //  %fn – function name 
      //  %ms – text user message
      //Only for "FileTxt" and "Console" sinks
      //Формат для текстового лога.
      //Только если "sink" установлено в "FileTxt" или "Console"
      "format": "{%cn} [%tf] %lv %ms",

      //Directory for log files
      //Only for "Auto" or "File"
      //Каталог для логов
      //Только если "sink" установлено в "Auto" или "File".
      "logDirectory": "XVM_logs",

      //Log rolling value and type 
      // 10mb - roll by file size
      // 10hr - roll by time
      //Only for "Auto" or "File"
      //Политика роллинга логов
      // 10mb - роллинг по размеру файла
      // 10hr - роллинг по времени
      //Только если "sink" установлено в "Auto" или "File".
      "logRolling": "24hr",

      //Maximum log files number. Max value is 4096. Set in 0 to stop deleting old logs.
      //Only for "Auto" or "File"
      //Максимальное число логов. Максмальное значение - 4096. Устновите в 0, чтобы прекратить удаление старых логов
      //Только если "sink" установлено в "Auto" или "File".
      "logMaxFiles": 100

    },
    "features": {
    	"d3d9": true,
    	"d3d11": true
    }
  }
}