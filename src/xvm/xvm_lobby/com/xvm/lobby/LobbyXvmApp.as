/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * http://www.modxvm.com/
 */
package com.xvm.lobby
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.lobby.online.OnlineServers.OnlineServers;
    import com.xvm.lobby.ping.PingServers.PingServers;

    public class LobbyXvmApp extends Xvm
    {
        public static const AS_UPDATE_BATTLE_TYPE:String = "xvm_hangar.as_update_battle_type";

        private var lobbyXvmMod:LobbyXvmMod;

        public function LobbyXvmApp():void
        {
            lobbyXvmMod = new LobbyXvmMod();
            addChild(lobbyXvmMod);

            Logger.counterPrefix = "L";

            // loading ui mods
            XfwComponent.try_load_ui_swf("xvm_lobby", "xvm_lobby_ui.swf", [ "battleResults.swf", "TankCarousel.swf", "nodesLib.swf", "crew.swf" ]);

            // mod: online
            // init as earlier as possible
            OnlineServers.initFeature((Config.config.login.onlineServers.enabled || Config.config.hangar.onlineServers.enabled) && Config.config.__wgApiAvailable);

            // mod: ping
            // init pinger as earlier as possible
            PingServers.initFeature(Config.config.login.pingServers.enabled || Config.config.hangar.pingServers.enabled);

            Xfw.addCommandListener(LobbyXvmApp.AS_UPDATE_BATTLE_TYPE, onUpdateBattleType);

            LobbyMacros.RegisterVehiclesMacros();
            LobbyMacros.RegisterClockMacros();
        }

        // PRIVATE

        private function onUpdateBattleType(battleType:String):void
        {
            LobbyMacros.RegisterBattleTypeMacros(battleType);
        }
    }
}
