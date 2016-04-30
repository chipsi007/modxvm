/**
 * @author ilitvinov87(at)gmail.com
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */

import com.xvm.*;
import wot.Minimap.*;

class wot.Minimap.Minimap
{
    /////////////////////////////////////////////////////////////////
    // wrapped methods

    public var wrapper:net.wargaming.ingame.Minimap;
    public var base:net.wargaming.ingame.Minimap;

    public function Minimap(wrapper:net.wargaming.ingame.Minimap, base:net.wargaming.ingame.Minimap)
    {
        this.wrapper = wrapper;
        this.base = base;
        MinimapProxy.setReferences(base, wrapper);
        wrapper.xvm_worker = this;
        MinimapCtor();
    }

    function scaleMarkers()
    {
        return this.scaleMarkersImpl.apply(this, arguments);
    }

    function correctSizeIndex()
    {
        return this.correctSizeIndexImpl.apply(this, arguments);
    }

    function draw()
    {
        return this.drawImpl.apply(this, arguments);
    }

    // wrapped methods
    /////////////////////////////////////////////////////////////////

    private static var _isAltMode:Boolean = false;
    public static function get config():Object
    {
        return _isAltMode ? Config.config.minimapAlt : Config.config.minimap;
    }

    public function MinimapCtor()
    {
        Utils.TraceXvmModule("Minimap");

        GlobalEventDispatcher.addEventListener(Defines.E_CONFIG_LOADED, this, onConfigLoaded);
        GlobalEventDispatcher.addEventListener(Defines.E_MOVING_STATE_CHANGED, this, onMovingStateChanged);
        GlobalEventDispatcher.addEventListener(Defines.E_STEREOSCOPE_TOGGLED, this, onStereoscopeToggled);
        GlobalEventDispatcher.addEventListener(Defines.XMQP_MINIMAP_CLICK, this, onXmqpMinimapClickEvent);
    }

    function scaleMarkersImpl(factor:Number)
    {
        //Logger.add("scaleMarkers");
        if (Minimap.config.enabled)
        {
            Features.scaleMarkers();
        }
        else
        {
            // Original WG scaling behavior
            base.scaleMarkers(factor);
        }
    }

    function correctSizeIndexImpl(sizeIndex:Number, stageHeight:Number, stageWidth:Number):Number
    {
        if (sizeIndex < MinimapConstants.MAP_MIN_ZOOM_INDEX)
            sizeIndex = MinimapConstants.MAP_MIN_ZOOM_INDEX;
        if (sizeIndex > MinimapConstants.MAP_MAX_ZOOM_INDEX)
            sizeIndex = MinimapConstants.MAP_MAX_ZOOM_INDEX;
        return sizeIndex;
    }

    function drawImpl()
    {
        //Cmd.profMethodStart("Minimap.draw()");

        var sizeIsInvalid:Boolean = wrapper.sizeIsInvalid;
        base.draw();
        if (sizeIsInvalid)
            GlobalEventDispatcher.dispatchEvent( { type: MinimapEvent.REFRESH } );

        //Cmd.profMethodEnd("Minimap.draw()");
    }

    // -- Private

    private function onConfigLoaded()
    {
        if (Config.config.minimap.enabled)
        {
            if (Config.config.minimapAlt.enabled)
                GlobalEventDispatcher.addEventListener(Defines.E_MM_ALT_MODE, this, setAltMode);
            Features.init();
        }
    }

    // Dynamic circles and alt mode

    private var stereoscope_exists:Boolean = false;
    private var stereoscope_enabled:Boolean = false;
    private var is_moving:Boolean = false;

    private function onMovingStateChanged(event)
    {
        is_moving = event.value;
    }

    private function onStereoscopeToggled(event)
    {
        if (stereoscope_exists == false && event.value == true)
            stereoscope_exists = true;
        stereoscope_enabled = event.value;
    }

    private function setAltMode(e:Object):Void
    {
        //Logger.add("setAltMode: " + e.isDown);
        if (Config.config.hotkeys.minimapAltMode.onHold)
            _isAltMode = e.isDown;
        else if (e.isDown)
            _isAltMode = !_isAltMode;
        else
            return;

        GlobalEventDispatcher.dispatchEvent( { type: MinimapEvent.REFRESH } );

        if (stereoscope_exists)
        {
            var en:Boolean = stereoscope_enabled;
            GlobalEventDispatcher.dispatchEvent( { type: Defines.E_STEREOSCOPE_TOGGLED, value: true } );
            if (en == false)
                GlobalEventDispatcher.dispatchEvent( { type: Defines.E_STEREOSCOPE_TOGGLED, value: false } );
        }
        GlobalEventDispatcher.dispatchEvent( { type: Defines.E_MOVING_STATE_CHANGED, value: is_moving } );
    }

    private function onXmqpMinimapClickEvent(e:Object)
    {
        //Logger.addObject(e, 3, "onXmqpMinimapClickEvent");
        var canvas:MovieClip = wrapper.mapHit;
        canvas.lineStyle(3, e.data.color, 80);
        canvas.moveTo(e.data.x, e.data.y);
        canvas.lineTo(e.data.x + 0.1, e.data.y + 0.1);
    }
}
