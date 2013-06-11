import com.xvm.Config;
import com.xvm.GraphicsUtil;
import com.xvm.Logger;
import com.xvm.Utils;

class wot.battle.FragCorrelation
{
    public static function modify():Void
    {
        disableSelection();
        if (Config.s_config.fragCorrelation.hideTeamTextFields == true)
            hideFragCorellationBarTeamTextFields();
        colorizeMarkers();
    }

    /** Disable caret cursor change while mouse cursor is hovering over frag clips */
    private static function disableSelection():Void
    {
        var clipsToDisableSelect:Array = [
            _root.fragCorrelationBar.indicator,
            _root.fragCorrelationBar.m_enemyTeamFragsTF,
            _root.fragCorrelationBar.m_alliedTeamFragsTF,
            _root.fragCorrelationBar.m_enemyTeamTF,
            _root.fragCorrelationBar.m_alliedTeamTF
        ];

        for (var i in clipsToDisableSelect)
            clipsToDisableSelect[i].selectable = false;
    }

    private static function hideFragCorellationBarTeamTextFields():Void
    {
        /** Everything outside of this rectangular mask will be invisible */
        _root.fragCorrelationBar.scrollRect =
            new flash.geom.Rectangle(0, 0, _root.fragCorrelationBar._width, _root.fragCorrelationBar._height / 2);
    }

    private static function colorizeMarkers():Void
    {
        setupMarkers(_root.fragCorrelationBar.alliedMarkers, true);
        setupMarkers(_root.fragCorrelationBar.enemyMarkers, false);
    }            

    private static function setupMarkers(markers, ally)
    {
        if (markers.$createItemRenderer == null)
        {
            markers.$createItemRenderer = markers.createItemRenderer;
            markers.createItemRenderer = function()
            {
                arguments.unshift(ally);
                arguments.unshift(markers);
                return FragCorrelation.wrapper_createItemRenderer.apply(null, arguments);
            }
        }
    }

    // CONTEXT: alliedMarkers, enemyMarkers
    private static function wrapper_createItemRenderer()
    {
        //Logger.addObject(net.wargaming.managers.ColorSchemeManager._colors, "_colors", 3);
        var markers = arguments.shift();
        var ally:Boolean = Boolean(arguments.shift());
        var color = net.wargaming.managers.ColorSchemeManager.instance.getRGB("vm_" + (ally ? "ally" : "enemy"));
        var renderer = markers.$createItemRenderer.apply(markers, arguments);
        GraphicsUtil.colorize(renderer.marker, color, 0.9); // 10% darker to improve appearance
        //Logger.addObject(arguments[0], color, 1);
        return renderer;
    }
}
