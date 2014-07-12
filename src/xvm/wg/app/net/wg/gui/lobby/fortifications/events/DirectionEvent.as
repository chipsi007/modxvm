package net.wg.gui.lobby.fortifications.events
{
    import flash.events.Event;
    
    public class DirectionEvent extends Event
    {
        
        public function DirectionEvent(param1:String, param2:int = -1, param3:Boolean = false, param4:Boolean = false) {
            this.id = param2;
            super(param1,param3,param4);
        }
        
        public static var CLOSE_DIRECTION:String = "closeDirection";
        
        public static var OPEN_DIRECTION:String = "openDirection";
        
        public var id:int = -1;
    }
}
