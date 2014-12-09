package net.wg.gui.events
{
    import flash.events.Event;
    
    public class HeaderButtonBarEvent extends Event
    {
        
        public function HeaderButtonBarEvent(param1:String, param2:int = 0)
        {
            super(param1,true,true);
            this.width = param2;
        }
        
        public static var RESIZE:String = "resizeHB";
        
        public var width:int;
        
        override public function clone() : Event
        {
            return new HeaderButtonBarEvent(type,this.width);
        }
    }
}
