﻿/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
import com.xvm.*;
import com.xvm.events.*;
import com.greensock.*;
import com.greensock.easing.*;
import net.wargaming.controls.*;
import net.wargaming.managers.*;

class wot.battle.SixthSenseIndicator
{
    private var sixthSenseIndicatorXvm:MovieClip;
    private var icon:UILoaderAlt;
    private var orig_gotoAndPlay:Function;

    public function SixthSenseIndicator()
    {
        // replace _root.sixthSenseIndicator.gotoAndPlay()
        var $this = this;
        orig_gotoAndPlay = _root.sixthSenseIndicator.gotoAndPlay;
        _root.sixthSenseIndicator.gotoAndPlay = function(frame) { $this.gotoAndPlayXvm(frame); };

        var iconPath = Config.config.battle.sixthSenseIcon;
        if (!iconPath || iconPath == "")
            return;
        iconPath = Utils.fixImgTagSrc(Macros.FormatGlobalStringValue(iconPath));

        sixthSenseIndicatorXvm = _root.createEmptyMovieClip("sixthSenseIndicatorXvm", _root.getNextHighestDepth());
        sixthSenseIndicatorXvm._y = 120;
        sixthSenseIndicatorXvm._alpha = 0;
        sixthSenseIndicatorXvm.hitTestDisable = true;

        icon = (UILoaderAlt)(sixthSenseIndicatorXvm.attachMovie("UILoaderAlt", "icon", 0));

        var il:IconLoader = new IconLoader(this, completeLoadSixthSenseIcon);
        il.init(icon, [ iconPath, "" ], false);

        icon.source = il.currentIcon;
        icon.onLoadInit = function(mc:MovieClip) { $this.icon_onLoadInit(mc); }

        GlobalEventDispatcher.addEventListener(Events.E_UPDATE_STAGE, this, onUpdateStage);
    }

    function icon_onLoadInit(mc:MovieClip)
    {
        icon.setSize(mc._width, mc._height);
    }

    private function completeLoadSixthSenseIcon(event)
    {
        //Logger.add("completeLoadSixthSenseIcon");

        var $this = this;
        _global.setTimeout(function() { $this.onUpdateStage(); }, 1);

        // DEBUG
        //var a = "fade"; _global.setInterval(function() { a = a == "fade" ? "active" : "fade"; _root.sixthSenseIndicator.gotoAndPlay(a) }, 3000);
    }

    private function onUpdateStage(e)
    {
        if (icon.content._width != undefined)
            sixthSenseIndicatorXvm._x = BattleState.screenSize.width / 2 - icon.content._width / 2;
    }

    private function gotoAndPlayXvm(frame)
    {
        //Logger.add("gotoAndPlayXvm: " + frame);

        if (icon == null || icon.source == "")
        {
            orig_gotoAndPlay.apply(_root.sixthSenseIndicator, arguments);
            return;
        }

        switch (frame)
        {
            case "active":
                var timeline = new TimelineLite();
                timeline.insert(TweenLite.to(sixthSenseIndicatorXvm, 0.2, { _alpha:100, ease:Linear.easeNone } ), 0);
                timeline.append(TweenLite.from(sixthSenseIndicatorXvm, 0.2, { tint:"0xFFFFFF", ease: Linear.easeNone } ), 0);
                break;
            case "inactive":
 		TweenLite.to(sixthSenseIndicatorXvm, 0.2, {_alpha:70});
                break;
            case "fade":
 		TweenLite.to(sixthSenseIndicatorXvm, 0.5, {_alpha:0});
                break;
        }
    }
}
