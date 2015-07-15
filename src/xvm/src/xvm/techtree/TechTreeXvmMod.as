/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package xvm.techtree
{
    import com.xfw.*;
    import com.xfw.infrastructure.*;
    import com.xvm.infrastructure.*;
    import net.wg.infrastructure.interfaces.*;

    public class TechTreeXvmMod extends XvmModBase
    {
        public override function get logPrefix():String
        {
            return "[XVM:TECHTREE]";
        }

        private static const _views:Object =
        {
            "techtree": TechTreeXvmView,
            "research": ResearchXvmView
        }

        override protected function processView(view:IView, populated:Boolean):IXfwView
        {
            // TODO: move to views
            if (view.as_alias == "hangar")
            {
                const _name:String = "xvm_techtree";
                const _ui_name:String = _name + "_ui.swf";
                const _preloads:Array = [ "nodesLib.swf" ];
                Xfw.try_load_ui_swf(_name, _ui_name, _preloads);
            }
            return super.processView(view, populated);
        }

        public override function get views():Object
        {
            return _views;
        }
    }
}
