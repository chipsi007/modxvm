/**
 * @author ilitvinov87(at)gmail.com
 * @author m.schedriviy(at)gmail.com
 *
 * Handles Enemy Spotted presentation level (View)
 */
import com.xvm.*;
import wot.Minimap.*;
import wot.PlayersPanel.*;
import gfx.core.*;

class wot.PlayersPanel.SpotStatusView extends XvmComponent
{
    private static var SPOT_STATUS_TF_NAME:String = "spotStatusTF";
    private static var formatsCacheAlly:Object = null;
    private static var formatsCacheEnemy:Object = null;

    private var renderer:PlayerListItemRenderer;
    private var cfg:Object;
    private var spotStatusMarker:TextField;

    public function SpotStatusView(renderer:PlayerListItemRenderer, cfg:Object)
    {
        super();

        this.renderer = renderer;
        this.cfg = cfg;

        GlobalEventDispatcher.addEventListener(Defines.E_SPOT_STATUS_UPDATED, this, updateStatus);

        if (isAlly)
        {
            if (formatsCacheAlly == null)
            {
                formatsCacheAlly = { };
                formatsCacheAlly[SpotStatusModel.DEAD] = Utils.fixImgTag(cfg.format.dead);
                formatsCacheAlly[SpotStatusModel.LOST] = Utils.fixImgTag(cfg.format.lost);
                formatsCacheAlly[SpotStatusModel.REVEALED] = Utils.fixImgTag(cfg.format.revealed);
            }
        }
        else
        {
            if (formatsCacheEnemy == null)
            {
                formatsCacheEnemy = { };
                formatsCacheEnemy[SpotStatusModel.DEAD] = [ Utils.fixImgTag(cfg.format.dead), Utils.fixImgTag(cfg.format.artillery.dead) ];
                formatsCacheEnemy[SpotStatusModel.NEVER_SEEN] = [ Utils.fixImgTag(cfg.format.neverSeen), Utils.fixImgTag(cfg.format.artillery.neverSeen) ];
                formatsCacheEnemy[SpotStatusModel.LOST] = [ Utils.fixImgTag(cfg.format.lost), Utils.fixImgTag(cfg.format.artillery.lost) ];
                formatsCacheEnemy[SpotStatusModel.REVEALED] = [ Utils.fixImgTag(cfg.format.revealed), Utils.fixImgTag(cfg.format.artillery.revealed) ];
            }
        }

        spotStatusMarker = createMarker(renderer);

        invalidate();
    }

    public function updateStatus(e):Void
    {
        if (renderer.wrapper.data.uid != e.data)
            return;
        //Logger.addObject(e);
        invalidate();
    }

    // override
    public function draw()
    {
        //Logger.add("draw");
        // Define point relative to which marker is set
        // Set every update for correct position in the fog of war mode.
        spotStatusMarker._x = renderer.wrapper.vehicleLevel._x + cfg.Xoffset; // vehicleLevel._x is 8 for example
        spotStatusMarker._y = renderer.wrapper.vehicleLevel._y + cfg.Yoffset; // vehicleLevel._y is -445.05 for example

        var data = renderer.wrapper.data;
        var uid:Number = data.uid;
        var txt:String;
        var status:Number = SpotStatusModel.defineStatus(uid, data.vehicleState);
        if (isAlly)
        {
            if (status == SpotStatusModel.NEVER_SEEN)
                status = SpotStatusModel.REVEALED;
            txt = formatsCacheAlly[status];
        }
        else
        {
            var isArty:Boolean = SpotStatusModel.isArty(uid);
            txt = formatsCacheEnemy[status][isArty ? 1 : 0];
        }

        var name:String = Utils.GetPlayerName(data.label);

        var obj = Defines.battleStates[name] || { };
        if (status == SpotStatusModel.DEAD && obj.dead == false)
        {
            obj.dead = true;
            if (obj.curHealth > 0)
                obj.curHealth = 0;
        }
        obj.darken = status == SpotStatusModel.DEAD;

        txt = Macros.Format(name, txt, obj);
        //Logger.add(txt);
        spotStatusMarker.htmlText = txt;
    }

    // -- Private

    private function get isAlly():Boolean
    {
        return cfg.format.neverSeen == undefined;
    }

    private static function createMarker(renderer:PlayerListItemRenderer):TextField
    {
        var marker:TextField = renderer.wrapper.createTextField(SPOT_STATUS_TF_NAME, renderer.wrapper.getNextHighestDepth(), 0, 0, 250, 25);
        marker.antiAliasType = "advanced";
        marker.selectable = false;
        marker.html = true;
        return marker;
    }
}
