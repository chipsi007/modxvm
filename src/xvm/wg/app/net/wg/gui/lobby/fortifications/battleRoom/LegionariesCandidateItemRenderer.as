package net.wg.gui.lobby.fortifications.battleRoom
{
    import net.wg.gui.components.controls.SoundListItemRenderer;
    import net.wg.infrastructure.interfaces.entity.IDropItem;
    import net.wg.infrastructure.interfaces.entity.IUpdatable;
    import net.wg.gui.cyberSport.controls.CandidateHeaderItemRender;
    import net.wg.gui.cyberSport.controls.CandidateItemRenderer;
    import net.wg.data.constants.Cursors;
    import scaleform.clik.utils.Constraints;
    import scaleform.clik.constants.ConstrainMode;
    import scaleform.clik.constants.InvalidationType;
    import net.wg.gui.lobby.fortifications.data.battleRoom.LegionariesCandidateVO;
    import net.wg.data.constants.Values;
    
    public class LegionariesCandidateItemRenderer extends SoundListItemRenderer implements IDropItem, IUpdatable
    {
        
        public function LegionariesCandidateItemRenderer()
        {
            super();
            this.candidateItemRender.visible = false;
            this.headerRender.visible = false;
            this.candidateItemRender.useRightButton = true;
        }
        
        public var headerRender:CandidateHeaderItemRender;
        
        public var candidateItemRender:CandidateItemRenderer;
        
        override public function setData(param1:Object) : void
        {
            this.data = param1;
            invalidateData();
        }
        
        public function update(param1:Object) : void
        {
            this.setData(param1);
        }
        
        public function get getCursorType() : String
        {
            return (this.candidateItemRender) && (this.candidateItemRender.visible)?Cursors.DRAG_OPEN:Cursors.ARROW;
        }
        
        override protected function configUI() : void
        {
            super.configUI();
            if(this.headerRender)
            {
                this.headerRender.buttonMode = false;
                constraints = new Constraints(this,ConstrainMode.COUNTER_SCALE);
                constraints.addElement(this.headerRender.name,this.headerRender,Constraints.ALL);
            }
            this.candidateItemRender.visible = false;
        }
        
        override protected function setState(param1:String) : void
        {
            super.setState(param1);
            if((this.candidateItemRender) && (this.candidateItemRender.visible))
            {
                this.candidateItemRender.gotoAndPlay(param1);
            }
        }
        
        override protected function draw() : void
        {
            super.draw();
            if(isInvalid(InvalidationType.DATA))
            {
                this.updateElements(data);
                invalidateSize();
            }
            if(isInvalid(InvalidationType.SIZE))
            {
                if((this.headerRender) && (this.headerRender.visible))
                {
                    this.headerRender.invalidateSize();
                }
                if(this.candidateItemRender.visible)
                {
                    this.candidateItemRender.invalidateSize();
                }
            }
            if(constraints)
            {
                constraints.update(this._width,this._height);
            }
        }
        
        override protected function onDispose() : void
        {
            if(this.headerRender)
            {
                this.headerRender.dispose();
                this.headerRender = null;
            }
            if(this.candidateItemRender)
            {
                this.candidateItemRender.dispose();
                this.candidateItemRender = null;
            }
            super.onDispose();
        }
        
        protected function updateElements(param1:Object) : void
        {
            var _loc2_:LegionariesCandidateVO = null;
            _loc2_ = LegionariesCandidateVO(param1);
            visible = !(_loc2_ == null);
            if(!_loc2_)
            {
                return;
            }
            if(_loc2_.headerText != Values.EMPTY_STR)
            {
                this.headerRender.visible = true;
                this.headerRender.setData(_loc2_.headerText,_loc2_.headerToolTip);
                this.enabled = false;
                this.mouseChildren = true;
                this.updateCandidateItemRender(false);
                this.candidateItemRender.update(null);
            }
            else if(_loc2_.emptyRender)
            {
                this.visible = this.enabled = false;
                this.mouseChildren = false;
                this.candidateItemRender.update(null);
                this.updateCandidateItemRender(false);
            }
            else
            {
                this.headerRender.visible = false;
                this.enabled = false;
                this.mouseChildren = true;
                this.updateCandidateItemRender(true);
                this.candidateItemRender.update(param1);
                this.candidateItemRender.visible = true;
            }
            
        }
        
        private function updateCandidateItemRender(param1:Boolean) : void
        {
            this.candidateItemRender.enabled = param1;
            this.candidateItemRender.mouseChildren = false;
        }
    }
}
