package net.wg.gui.lobby.fortifications.data.battleRoom.clanBattle
{
    import net.wg.data.daapi.base.DAAPIDataClass;
    
    public class ClanBattleTimerVO extends DAAPIDataClass
    {
        
        public function ClanBattleTimerVO(param1:Object)
        {
            super(param1);
        }
        
        public var deltaTime:int = -1;
        
        public var htmlFormatter:String = "";
        
        public var alertHtmlFormatter:String = "";
        
        public var glowColor:Number = -1;
        
        public var alertGlowColor:Number = -1;
        
        public var timerDefaultValue:String = "--";
    }
}
