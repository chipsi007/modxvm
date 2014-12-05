package net.wg.gui.components.controls
{
    import net.wg.gui.interfaces.IAccordionItemRenderer;
    import flash.display.MovieClip;
    import net.wg.data.constants.SoundTypes;
    import scaleform.clik.constants.InvalidationType;
    import net.wg.data.components.AccordionRendererData;
    import flash.events.MouseEvent;
    import net.wg.gui.events.AccordionRendererEvent;
    
    public class AccordionSoundRenderer extends SoundListItemRenderer implements IAccordionItemRenderer
    {
        
        public function AccordionSoundRenderer()
        {
            super();
            focusable = false;
            toggle = false;
        }
        
        private static var SHOW_NEW_MARKER_FIELD:String = "showNewMarker";
        
        private static var ACCORDION_NEW_MARKER:String = "NewMarkerSmall";
        
        private var _newMarker:MovieClip = null;
        
        private var _enableConstraints:Boolean = false;
        
        public function set enableConstraints(param1:Boolean) : void
        {
            this._enableConstraints = param1;
        }
        
        override protected function configUI() : void
        {
            soundType = SoundTypes.ACCORDION;
            constraintsDisabled = !this._enableConstraints;
            super.configUI();
        }
        
        override protected function draw() : void
        {
            super.draw();
            if((data) && (isInvalid(InvalidationType.DATA)))
            {
                this.showIsNew((data.hasOwnProperty(SHOW_NEW_MARKER_FIELD)) && (data[SHOW_NEW_MARKER_FIELD]));
            }
        }
        
        override public function set data(param1:Object) : void
        {
            var _loc2_:AccordionRendererData = null;
            _loc2_ = param1 as AccordionRendererData;
            if(_loc2_)
            {
                this.enabled = _loc2_.enabled;
                label = _loc2_.label;
            }
            super.data = param1;
            invalidateData();
        }
        
        protected function showIsNew(param1:Boolean) : void
        {
            if(param1)
            {
                if(!this._newMarker)
                {
                    this._newMarker = App.utils.classFactory.getObject(ACCORDION_NEW_MARKER) as MovieClip;
                    this._newMarker.x = this._newMarker.y = 0;
                    addChild(this._newMarker);
                }
                this._newMarker.visible = param1;
            }
            else if(this._newMarker)
            {
                this._newMarker.visible = param1;
            }
            
        }
        
        override public function set enabled(param1:Boolean) : void
        {
            super.enabled = param1;
            this.buttonMode = param1;
            mouseEnabled = true;
        }
        
        override protected function handleMouseRollOver(param1:MouseEvent) : void
        {
            super.handleMouseRollOver(param1);
            dispatchEvent(new AccordionRendererEvent(AccordionRendererEvent.ACCORDION_RENDERER_ROLL_OVER));
        }
        
        override protected function handleMouseRollOut(param1:MouseEvent) : void
        {
            super.handleMouseRollOut(param1);
            dispatchEvent(new AccordionRendererEvent(AccordionRendererEvent.ACCORDION_RENDERER_ROLL_OUT));
        }
    }
}
