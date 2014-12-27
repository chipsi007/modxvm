package net.wg.gui.cyberSport.controls
{
    import net.wg.gui.components.controls.ScrollingListEx;
    import net.wg.gui.interfaces.IDropList;
    import flash.display.MovieClip;
    
    public class CSCandidatesScrollingList extends ScrollingListEx implements IDropList
    {
        
        public function CSCandidatesScrollingList()
        {
            super();
        }
        
        public var droppingHit:MovieClip = null;
        
        override public function set selectedIndex(param1:int) : void
        {
        }
        
        override protected function configUI() : void
        {
            super.configUI();
            hitArea = this.droppingHit;
        }
        
        public function get selectable() : Boolean
        {
            return false;
        }
        
        public function set selectable(param1:Boolean) : void
        {
        }
        
        public function highlightList() : void
        {
        }
        
        public function hideHighLight() : void
        {
        }
    }
}
