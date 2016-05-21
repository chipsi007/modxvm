/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package xvm.profile
{
    import com.xfw.*;
    import com.xvm.infrastructure.*;

    public class ProfileXvmMod extends XvmModBase
    {
        public override function get logPrefix():String
        {
            return "[XVM:PROFILE]";
        }

        private static const _views:Object =
        {
            "profile": ProfileXvmView,
            "profileWindow": ProfileXvmView
        }

        public override function get views():Object
        {
            return _views;
        }
    }
}
