/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package xvm.tcarousel
{
    import com.xfw.*;
    import com.xvm.infrastructure.*;

    public class TCarouselXvmMod extends XvmModBase
    {
        override public function get logPrefix():String
        {
            return "[XVM:TCAROUSEL]";
        }

        private static const _views:Object =
        {
            "hangar": TCarouselXvmView
        }

        override public function entryPoint():void
        {
            //Logger.err(new Error());
            super.entryPoint();

            const _name:String = "xvm_tcarousel";
            const _ui_name:String = _name + "_ui.swf";
            const _preloads:Array = [ "TankCarousel.swf", "filtersPopoverView.swf" ];
            Xfw.try_load_ui_swf(_name, _ui_name, _preloads);
        }

        override public function get views():Object
        {
            return _views;
        }
    }
}
