﻿/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * https://modxvm.com/
 */
package com.xvm
{
    import com.xfw.*;
    import com.xvm.types.*;
    import com.xvm.types.cfg.*;

    public class Config
    {
        private static var s_config:CConfig = null;
        private static var s_networkServicesSettings:NetworkServicesSettings = new NetworkServicesSettings({});

        public static var IS_DEVELOPMENT:Boolean = false;

        public static function get config():CConfig
        {
            return s_config;
        }

        public static function set config(value:CConfig):void
        {
            s_config = value;
        }

        public static function applyGlobalBattleMacros():void
        {
            s_config.applyGlobalBattleMacros();
        }

        public static function get networkServicesSettings():NetworkServicesSettings
        {
            return s_networkServicesSettings;
        }

        public static function set networkServicesSettings(value:NetworkServicesSettings):void
        {
            s_networkServicesSettings = value;
            Macros.RegisterXvmServicesMacrosData();
        }
    }
}
