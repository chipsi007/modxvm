/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package xvm.profile_ui
{
    import com.xfw.*;
    import com.xvm.*;
    import net.wg.data.managers.*;

    public dynamic class UI_StatisticsDashLineTextItemIRenderer extends StatisticsDashLineTextItemIRenderer_UI
    {
        private var _toolTipParams:IToolTipParams;

        public function UI_StatisticsDashLineTextItemIRenderer()
        {
            //Logger.add("UI_StatisticsDashLineTextItemIRenderer");
        }

        override public function set toolTipParams(value:IToolTipParams):void
        {
            super.toolTipParams = value;
            this._toolTipParams = value;
        }

        override protected function showToolTip():void
        {
            try
            {
                if (tooltip == "xvm_xte")
                {
                    var params:Object = _toolTipParams != null ? _toolTipParams.body : null;
                    var t:String = Sprintf.format("{{l10n:profile/xvm_xte_extended_tooltip:%s:%s:%s:%s:%s:%s}}",
                        !params.currentD  ? "--" : App.utils.locale.integer(Math.round(params.currentD)),
                        !params.currentF  ? "--" : App.utils.locale.float(params.currentF),
                        !params.avgD ? "--" : App.utils.locale.integer(Math.round(params.avgD)),
                        !params.avgF ? "--" : App.utils.locale.float(params.avgF),
                        !params.topD ? "--" : App.utils.locale.integer(Math.round(params.topD)),
                        !params.topF ? "--" : App.utils.locale.float(params.topF));
                    App.toolTipMgr.show(Locale.get(t));
                }
                else
                {
                    super.showToolTip();
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }
    }
}
