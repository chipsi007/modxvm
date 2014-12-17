package net.wg.gui.cyberSport.views.autoSearch
{
    import scaleform.clik.core.UIComponent;
    import net.wg.gui.cyberSport.interfaces.ICSAutoSearchMainView;
    import net.wg.gui.components.common.waiting.WaitingMc;
    import net.wg.gui.cyberSport.vo.AutoSearchVO;
    import flash.display.InteractiveObject;
    import net.wg.infrastructure.interfaces.entity.IFocusContainer;
    import scaleform.clik.constants.InvalidationType;
    import net.wg.data.constants.generated.CYBER_SPORT_ALIASES;
    import flash.events.Event;
    import scaleform.clik.events.InputEvent;
    
    public class CSAutoSearchMainView extends UIComponent implements ICSAutoSearchMainView
    {
        
        public function CSAutoSearchMainView()
        {
            super();
            this.views = [];
            this.views.push(this.searchCommands,this.searchEnemy,this.waitingPlayer,this.confirmationState,this.errorState);
            this.viewsLength = this.views.length;
            var _loc1_:* = 0;
            while(_loc1_ < this.viewsLength)
            {
                InteractiveObject(this.views[_loc1_]).addEventListener(StateViewBase.UPDATE_TIMER,this.csUpdateTimerHandler);
                _loc1_++;
            }
            this.waitingCmp.play();
        }
        
        private static var FRAME_ANIMATION:uint = 7;
        
        private static var UPDATE_BUTTONS_STATE:String = "updateButtonsState";
        
        public var waitingCmp:WaitingMc;
        
        public var searchCommands:SearchCommands;
        
        public var searchEnemy:SearchEnemy;
        
        public var waitingPlayer:WaitingPlayers;
        
        public var confirmationState:ConfirmationReadinessStatus;
        
        public var errorState:ErrorState;
        
        private var views:Array = null;
        
        private var viewsLength:uint = 0;
        
        private var model:AutoSearchVO;
        
        private var frameCount:Number = 7;
        
        private var enableWaitingPlrBtn:Boolean = false;
        
        private var enableSearchBtn:Boolean = false;
        
        private var buttonsUpdated:Boolean = true;
        
        public function enableButton(param1:Boolean) : void
        {
            var _loc2_:* = 0;
            while(_loc2_ < this.viewsLength)
            {
                ICSAutoSearchMainView(this.views[_loc2_]).enableButton(param1);
                _loc2_++;
            }
        }
        
        public function changeButtonsState(param1:Boolean, param2:Boolean) : void
        {
            this.enableSearchBtn = param2;
            this.enableWaitingPlrBtn = param1;
            this.buttonsUpdated = false;
            invalidate(UPDATE_BUTTONS_STATE);
        }
        
        public function getComponentForFocus() : InteractiveObject
        {
            var _loc1_:InteractiveObject = null;
            var _loc2_:InteractiveObject = null;
            var _loc3_:* = 0;
            while(_loc3_ < this.viewsLength)
            {
                _loc1_ = IFocusContainer(this.views[_loc3_]).getComponentForFocus();
                if(_loc1_ != null)
                {
                    _loc2_ = _loc1_;
                }
                _loc3_++;
            }
            return _loc2_;
        }
        
        public function stopTimer() : void
        {
            var _loc1_:* = 0;
            while(_loc1_ < this.viewsLength)
            {
                ICSAutoSearchMainView(this.views[_loc1_]).stopTimer();
                _loc1_++;
            }
        }
        
        public function set changeState(param1:AutoSearchVO) : void
        {
            if(param1 == null)
            {
                return;
            }
            this.model = param1;
            invalidateData();
            this.initWheelBehaviour();
        }
        
        override protected function onDispose() : void
        {
            var _loc1_:* = 0;
            while(_loc1_ < this.viewsLength)
            {
                ICSAutoSearchMainView(this.views[_loc1_]).dispose();
                InteractiveObject(this.views[_loc1_]).removeEventListener(StateViewBase.UPDATE_TIMER,this.csUpdateTimerHandler);
                _loc1_++;
            }
            super.onDispose();
        }
        
        override protected function draw() : void
        {
            super.draw();
            if(isInvalid(InvalidationType.DATA))
            {
                this.initStates();
            }
            if(!this.buttonsUpdated && (isInvalid(UPDATE_BUTTONS_STATE)))
            {
                this.buttonsUpdated = true;
                this.updateButtons();
            }
        }
        
        private function initWheelBehaviour() : void
        {
            if(this.model.state == CYBER_SPORT_ALIASES.AUTO_SEARCH_CONFIRMATION_STATE)
            {
                this.waitingCmp.stop();
                this.frameCount = FRAME_ANIMATION;
                this.updateWaiting();
            }
            else if(this.model.state == CYBER_SPORT_ALIASES.AUTO_SEARCH_ERROR_STATE)
            {
                this.waitingCmp.stop();
            }
            else
            {
                this.waitingCmp.play();
            }
            
        }
        
        private function updateWaiting() : void
        {
            this.addEventListener(Event.ENTER_FRAME,this.wheelReversHandler);
        }
        
        private function updateButtons() : void
        {
            var _loc1_:uint = 0;
            while(_loc1_ < this.viewsLength)
            {
                StateViewBase(this.views[_loc1_]).changeButtonsState(this.enableWaitingPlrBtn,this.enableSearchBtn);
                _loc1_++;
            }
        }
        
        private function initStates() : void
        {
            var _loc1_:uint = 0;
            while(_loc1_ < this.viewsLength)
            {
                StateViewBase(this.views[_loc1_]).changeState = this.model;
                _loc1_++;
            }
        }
        
        private function csUpdateTimerHandler(param1:Event) : void
        {
            this.initWheelBehaviour();
        }
        
        private function wheelReversHandler(param1:Event) : void
        {
            var _loc2_:* = NaN;
            if(this.frameCount <= 0)
            {
                this.removeEventListener(Event.ENTER_FRAME,this.wheelReversHandler);
            }
            else
            {
                _loc2_ = this.waitingCmp.currentFrame - 1;
                if(_loc2_ <= 0)
                {
                    _loc2_ = this.waitingCmp.totalFrames - 1;
                }
                this.waitingCmp.gotoAndStop(_loc2_);
                this.frameCount--;
            }
        }
        
        override public function handleInput(param1:InputEvent) : void
        {
            var _loc2_:ICSAutoSearchMainView = null;
            var _loc3_:* = 0;
            while(_loc3_ < this.viewsLength)
            {
                _loc2_ = this.views[_loc3_];
                if((_loc2_) && (_loc2_.visible))
                {
                    _loc2_.handleInput(param1);
                }
                _loc3_++;
            }
        }
    }
}
