﻿/**
 * ...
 * @author sirmax2
 */
class wot.utils.Utils
{
  private static var TRACE_XVM_MODULES = true;

  public static function indexOf(array:Array, value:Object):Number
  {
    var i:Number = 0;
    var len:Number = array.length;
    while(i < len)
    {
      if (array[i] === value)
        return i;
      ++i;
    }
    return -1;
  }

  public static function startsWith(substr: String, str: String): Boolean
  {
    return str.indexOf(substr, 0) == 0;
  }

  public static function endsWith(substr: String, str: String): Boolean
  {
    return str.lastIndexOf(substr) == (str.length - substr.length);
  }

  public static function trim(str: String): String
  {
    var i, j;
    for (i = 0; str.charCodeAt(i) < 33; ++i);
    var len = str.length;
    for (j = len-1; str.charCodeAt(j) < 33; --j);
    return str.substring(i, j+1);
  }

  public static function padLeft(str: String, len: Number, char: String)
  {
    if (!str)
      str = "";
    if (!char)
      char = ' ';
    while (str.length < len)
      str = char + str;
    return str;
  }

  // 0 - equal, -1 - v1<v2, 1 - v1>v2, -2 - error
  public static function compareVersions(v1: String, v2: String): Number
  {
    try
    {
      var a: Array = v1.split(".");
      while (a.length < 4)
        a.push("0");
      var b: Array = v2.split(".");
      while (b.length < 4)
        b.push("0");

      for (var i = 0; i < 4; ++i)
      {
        if (isNaN(parseInt(a[i])) && isNaN(parseInt(b[i])))
          return a[i] == b[i] ? 0 : a[i] < b[i] ? -1 : 1;

        if (isNaN(parseInt(a[i])))
          return -1;

        if (isNaN(parseInt(b[i])))
          return 1;

        if (parseInt(a[i]) < parseInt(b[i]))
          return -1;

        if (parseInt(a[i]) > parseInt(b[i]))
          return 1;
      }

      return 0;
    }
    catch (e)
    {
      return -2;
    }
  }

  public static function GetPlayerName(fullplayername: String): String
  {
    var pos = fullplayername.indexOf("[");
    return (pos < 0) ? fullplayername : fullplayername.slice(0, pos);
  }

  public static function GetNormalizedPlayerName(fullplayername: String): String
  {
    return GetPlayerName(fullplayername).toUpperCase();
  }

  public static function GetClanName(fullplayername: String): String
  {
    var pos = fullplayername.indexOf("[");
    return (pos < 0) ? "" : fullplayername.slice(pos);
  }

  public static function toInt(value: Object, defaultValue: Number): Number
  {
    if (!defaultValue)
      defaultValue = 0;
    if (!value)
      return defaultValue;
    var n: Number = parseInt(value.toString());
    return isNaN(n) ? defaultValue : n;
  }

  public static function toBool(value: Object, defaultValue: Boolean): Boolean
  {
    if ((typeof value) == "boolean")
      return Boolean(value);
    if (!value)
      return defaultValue;
    value = String(value).toLowerCase();
    return defaultValue ? value != "false" : value == "true";
  }

  public static function toString(value: Object, defaultValue: String): String
  {
    return value ? String(value) : defaultValue;
  }

  public static function elapsedMSec(date1, date2): Number
  {
    return date2 - date1;
  }

  public static function fixPath(path: String)
  {
    path = path.split("\\").join("/");
    if (!Utils.endsWith("/", path))
      path += "/";
    return path;
  }


  public static function addRootFor(players: Array, root: String)
  {
    if (root == "/" || root == "")
      return players;
    for (var i in players)
    {
      var ele = players[i];
      if ((ele.clan || ele.nick) && ele.icon)
      {
        ele.icon = root + ele.icon;
      }
    }
    return players;
  }

  public static function removeDuplicatesAndTrim(sourceArray:Array): Array
  {
    for (var i in sourceArray)
    {
      sourceArray[i] = trim(sourceArray[i]);
    }
    for (var i = sourceArray.length - 2; i >= 0; --i)
    {
      for (var j = sourceArray.length - 1; j > i; --j)
      {
        if (sourceArray[j] === sourceArray[i]) sourceArray.splice(j, 1);
      }
    }
    return sourceArray;

  }

  private static var xvmModules: Array = [];
  public static function TraceXvmModule(moduleName: String)
  {
    if (!TRACE_XVM_MODULES)
      return;
    if (wot.utils.Utils.indexOf(xvmModules, moduleName) == -1)
    {
      xvmModules.push(moduleName);
      wot.utils.Logger.add("xvm-> [ \"" + xvmModules.join("\", \"") + "\" ]");
    }
  }
  
  public static function FormatDate(format: String, date: Date)
  {
    var keys = {Y:"getFullYear", M:"getMonth", D:"getDate", H:"getHours", N:"getMinutes", S:"getSeconds"/*, I:"getMilliseconds"*/};
    var str = "";
    if (!date)
      date = new Date();
    var ci, meth;
    var formatArr = format.split(""); // charAt() is slow
    var format_len = formatArr.length;
    for (var i = 0; i < format_len; ++i)
    {
      ci = formatArr[i];
      if (keys[ci] == undefined)
      {
        str += ci;
        continue;
      }
      meth = keys[ci];
      var val = date[meth]() + ((meth == "getMonth") ? 1 : 0);
      str += (val < 10) ? "0" + val : val;
    }
    return str;
  }
}