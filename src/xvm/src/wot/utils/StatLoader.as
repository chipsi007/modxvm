/**
 * ...
 * @author sirmax2
 * @author johnp
 */
import com.xvm.JSON;
import wot.utils.Config;
import wot.utils.Defines;
import wot.utils.GlobalEventDispatcher;
import wot.utils.Logger;
import wot.utils.StatData;
import wot.utils.Utils;
import wot.utils.VehicleInfo;

class wot.utils.StatLoader
{
  public static var s_players_count = 0;
  public static var s_loadDataStarted = false;
  private static var s_loading = false;
  private static var dirty: Boolean = false;
  private static var requestId: Number = -1;

  private static var dummy = Logger.dummy; // avoid import warning

  // so we don't have to create it at function execution:
  // try to retrieve stats after 0.3, 0.8, 1.5, 3 and 5 seconds
  private static var currentTimeoutId = 0;
  private static var timeouts = [ 300, 500, 700, 1500, 2000 ];

  public static function AddPlayerData(playerId: Number, playerName: String, originalText: String, icon: String,
    team: Number, selected: Boolean)
  {
    if (playerId <= 0 || !playerName)
      return;

    var pname = Utils.GetNormalizedPlayerName(playerName);
    var clan = Utils.GetClanName(playerName);

    //Logger.add("AddPlayerData(" + playerName + "): " + pname);

    if (!StatData.s_data[pname])
      s_players_count++;
    StatData.s_data[pname] = {
      playerId: playerId,
      fullPlayerName: playerName,
      name: pname,
      clan: clan,
      originalText: originalText,
      icon: icon,
      vehicleName: VehicleInfo.getShortName(icon),
      team: team,
      selected: selected,
      loaded: StatData.s_data[pname] ? true : false,
      stat: StatData.s_data[pname] ? StatData.s_data[pname].stat : undefined
    };
    if (!StatData.s_data[pname].loaded)
      dirty = true;
  }

  public static function StartLoadData(cmd, isRecursiveCall)
  {
    //if (!isRecursiveCall)
    //  Logger.add("StatLoader.StartLoadData(): cmd=" + cmd);

    if (s_loadDataStarted && !isRecursiveCall)
      return;
    s_loadDataStarted = true;

    var command = (isRecursiveCall ? Defines.COMMAND_ADD : Defines.COMMAND_SET) + " ";

    var players_to_load = [];
    var len = 0;
    for (var pname in StatData.s_data)
    {
      var pdata = StatData.s_data[pname];
      if (!pdata.loaded)
      {
        //Logger.addObject(pdata, pname);
        var str: String = String(pdata.playerId) + "=" + pdata.fullPlayerName +
          "&" + pdata.vehicleName + (pdata.selected ? "&1" : "");
        if (len + str.length > Defines.MAX_PATH - command.length)
          break;
        pdata.loaded = true;
        players_to_load.push(str);
        len += str.length + 1;
      }
    }

    if (players_to_load.length > 0)
    {
      var lv:LoadVars = new LoadVars();
      lv.onData = function(str: String)
      {
        //Logger.add("lv: " + str);
        if (!str)
          return;
        try
        {
          var response = JSON.parse(str);
          StatLoader.requestId = response.resultId;
          StatLoader.StartLoadData(cmd, true);
        }
        catch (ex)
        {
          StatLoader.requestId = -1;
        }
      }
      lv.load(command + players_to_load.join(","));
      return;
    }

    dirty = false;
    currentTimeoutId = 0;
    LoadStatData(cmd);
  }

  public static function LoadLastStat(event)
  {
    if (event)
      GlobalEventDispatcher.removeEventListener("config_loaded", StatLoader.LoadLastStat);
    GlobalEventDispatcher.addEventListener("process_fow", StatLoader.ProcessForFogOfWar);
    if (Config.s_config.rating.showPlayersStatistics && !StatData.s_loaded)
      LoadStatData(Defines.COMMAND_GET_LAST_STAT);
  }

  private static function LoadStatData(command, isRecursiveCall)
  {
    //Logger.add("StatLoader.LoadStatData(): command=" + command);

    if (s_loading && !isRecursiveCall)
      return;
    s_loading = true;

    var lv:LoadVars = new LoadVars();
    lv.onData = function(str: String)
    {
      //Logger.add("lv: " + str);
      if (!str)
        return;

      var done = false;
      var finallyBugWorkaround: Boolean = false; // Workaround: finally block have a bug - it can be called twice. Why? How? F*ck!
      try
      {
        var response = JSON.parse(str);

        if (response.status == "NOT_READY")
        {
          if (StatLoader.currentTimeoutId >= StatLoader.timeouts.length)
            return;
          var timer:Function = _global.setTimeout(function() { StatLoader.LoadStatData(command, true); },
            StatLoader.timeouts[StatLoader.currentTimeoutId]);
          StatLoader.currentTimeoutId++;
          return;
        }

        done = true;

        if (response.info && response.info.xvm)
          GlobalEventDispatcher.dispatchEvent({ type: "set_info", ver: response.info.xvm.ver, message: response.info.xvm.message });

        if (response.players)
        {
          var players_length = response.players.length;
          for (var i = 0; i < players_length; ++i)
          {
            var stat = response.players[i];
            stat = StatLoader.CalculateRating(stat);
            var name = stat.name.toUpperCase();
            if (!StatData.s_data[name])
            {
              StatLoader.s_players_count++;
              StatData.s_data[name] = { loaded: true };
            }
            StatData.s_data[name].stat = stat;
            if (StatData.s_data[name].vehicle.toUpperCase() == "UNKNOWN")
              StatData.s_data[name].loaded = false;
            //Logger.addObject(stat, stat.name);
          }
        }
      }
      catch (ex)
      {
        // do nothing
      }
      finally
      {
        if (finallyBugWorkaround)
          return;
        finallyBugWorkaround = true;

        if (done)
        {
          StatData.s_loaded = true;
          StatLoader.s_loadDataStarted = false;
          StatLoader.s_loading = false;
          //Logger.add("Stat Loaded");
          GlobalEventDispatcher.dispatchEvent( { type: "stat_loaded" } );

          if (StatLoader.dirty)
            var timer = _global.setTimeout(function() { StatLoader.StartLoadData(Defines.COMMAND_RUN_ASYNC); }, 50);
        }
      }
    };
    
    lv.load(command + ((command == Defines.COMMAND_RUN_ASYNC) ? " " + requestId : ""));
  }

  private static function CalculateRating(stat): Object
  {
    stat.r = stat.b > 0 ? Math.round(stat.w / stat.b * 100) : 0;

    if (!stat.tb || stat.tb <= 0 || !stat.tl || stat.tl <= 0)
      stat.tr = stat.r;
    else
    {
      var Or = stat.r;
      var Tr = Math.round(stat.tw / stat.tb * 100);
      var Tb = Math.min(stat.tb, 100);
      var Tl = Math.max(stat.tl, 10) * 10;
      stat.tr = Math.round(Or - (Or - Tr) * Tb / Tl);
    }
    //Logger.addObject(stat);
    return stat;
  }

  // Fog of War

  private static function ProcessForFogOfWar(event)
  {
    if (!event)
      return;
    var data = event.data;
    if (!data.uid)
      return;

    //Logger.add("ProcessForFogOfWar(): " + (data.label || data.name));
    //Logger.addObject(data);

    var fullPlayerName = (data.label || data.name) + (data.clanAbbrev ? "[" + data.clanAbbrev + "]" : "");
    var pname: String = Utils.GetNormalizedPlayerName(fullPlayerName);

    if (StatData.s_data[pname])
      return;

    AddPlayerData(data.uid, fullPlayerName, data.vehicle || data.originalText, data.icon,
      data.team == "team1" ? Defines.TEAM_ALLY : Defines.TEAM_ENEMY);

    var timer = _global.setTimeout(function() { StatLoader.StartLoadData(Defines.COMMAND_RUN_ASYNC); }, 50);
  }
}