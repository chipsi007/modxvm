package net.wg.infrastructure.base.meta.impl
{
    import net.wg.infrastructure.base.AbstractWindowView;
    import net.wg.data.constants.Errors;
    
    public class LoginQueueWindowMeta extends AbstractWindowView
    {
        
        public function LoginQueueWindowMeta()
        {
            super();
        }
        
        public var onCancelClick:Function = null;
        
        public var onAutoLoginClick:Function = null;
        
        public function onCancelClickS() : void
        {
            App.utils.asserter.assertNotNull(this.onCancelClick,"onCancelClick" + Errors.CANT_NULL);
            this.onCancelClick();
        }
        
        public function onAutoLoginClickS() : void
        {
            App.utils.asserter.assertNotNull(this.onAutoLoginClick,"onAutoLoginClick" + Errors.CANT_NULL);
            this.onAutoLoginClick();
        }
    }
}
