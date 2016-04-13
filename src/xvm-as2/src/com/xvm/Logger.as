﻿import com.xvm.*;

class com.xvm.Logger
{
    public static var counter: Number = 0;

    public static function add(str:String)
    {
        try
        {
            DAAPI.xvm_log("[" + Sandbox.GetCurrentSandboxPrefix() + ":" + Strings.padLeft(String(counter++), 3, '0') + "] " + str);
        }
        catch (e)
        {
            // quiet
        }
    }

    public static function addObject(obj:Object, depth:Number, name:String)
    {
        if (isNaN(depth) || depth < 1)
            depth = 1;
        if (depth > 10)
            depth = 10;
        add((name || "[obj]") + ": " + JSONx.stringifyDepth(obj, depth));
    }
}
