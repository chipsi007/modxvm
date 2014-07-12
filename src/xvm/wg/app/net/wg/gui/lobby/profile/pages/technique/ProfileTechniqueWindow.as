package net.wg.gui.lobby.profile.pages.technique
{
    import net.wg.gui.components.common.waiting.Waiting;
    import net.wg.gui.utils.ExcludeTweenManager;
    import net.wg.infrastructure.constants.WindowViewInvalidationType;
    import fl.transitions.easing.Strong;
    import scaleform.clik.motion.Tween;
    
    public class ProfileTechniqueWindow extends ProfileTechnique
    {
        
        public function ProfileTechniqueWindow() {
            this.tweenManager = new ExcludeTweenManager();
            super();
        }
        
        public static var WAITING_SIDES_PADDING:uint = 1;
        
        private static var ANIM_SPEED:uint = 500;
        
        private var _showWaiting:Boolean;
        
        private var _waiting:Waiting;
        
        private var tweenManager:ExcludeTweenManager;
        
        override protected function draw() : void {
            super.draw();
            if(isInvalid(WindowViewInvalidationType.WAITING_INVALID))
            {
                if(this._showWaiting)
                {
                    if(!this._waiting)
                    {
                        this._waiting = new Waiting();
                        addChild(this._waiting);
                        this._waiting.x = stackComponent.x + stackComponent.viewStack.x + WAITING_SIDES_PADDING;
                        this._waiting.y = stackComponent.y + WAITING_SIDES_PADDING;
                        this._waiting.setSize(currentDimension.x - this._waiting.x - 2 * WAITING_SIDES_PADDING,currentDimension.y - this._waiting.y - 2 * WAITING_SIDES_PADDING);
                        this._waiting.validateNow();
                        this._waiting.backgroundAlpha = 0;
                    }
                    this._waiting.setMessage("");
                }
                if(this._waiting)
                {
                    if(this._showWaiting)
                    {
                        this._waiting.show();
                        this.tweenManager.registerAndLaunch(ANIM_SPEED,stackComponent.viewStack,{"alpha":0},{
                            "ease":Strong.easeOut,
                            "onComplete":this.onTweenComplete
                        });
                }
                else
                {
                    this._waiting.hide();
                    this.tweenManager.registerAndLaunch(ANIM_SPEED,stackComponent.viewStack,{"alpha":1},{
                        "ease":Strong.easeOut,
                        "onComplete":this.onTweenComplete
                    });
            }
        }
    }
}

private function onTweenComplete(param1:Tween) : void {
    this.tweenManager.unregister(param1);
}

public function set showWaiting(param1:Boolean) : void {
    if(this._showWaiting != param1)
    {
        this._showWaiting = param1;
        invalidate(WindowViewInvalidationType.WAITING_INVALID);
    }
}

override protected function onDispose() : void {
    this.tweenManager.dispose();
    this.tweenManager = null;
    if(this._waiting)
    {
        this._waiting.dispose();
        this._waiting = null;
    }
    super.onDispose();
}

override public function as_responseVehicleDossier(param1:Object) : void {
    this.showWaiting = param1 == null;
    super.as_responseVehicleDossier(param1);
}
}
}
