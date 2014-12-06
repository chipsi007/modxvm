import com.xvm.*;
import wot.Minimap.*;
import wot.Minimap.dataTypes.*;
import wot.Minimap.model.*;
import wot.Minimap.model.externalProxy.*;
import wot.Minimap.view.*;

/**
 * MinimapEntry represent individual object on map.
 * One tank icon, base capture point, starting point or player himself.
 *
 * MinimapEntry object at Minimap is called icon.
 *
 * Extended behaviour:
 * ) Append extra text information about unit like level, type, nick etc.
 * ) Rescale child MovieClips to prevent inappropriate scale propagation.
 * ) Colorize icon.
 *
 * @author ilitvinov87@gmail.com
 */

class wot.Minimap.MinimapEntry
{
    /////////////////////////////////////////////////////////////////
    // wrapped methods

    public static var STATIC_ICON_BASE:String = "base"; /** Team colored capture base */
    public static var STATIC_ICON_CONTROL:String = "control"; /** Shared grey capture base */
    public static var STATIC_ICON_SPAWN:String = "spawn"; /** Spawn point. Diamond shaped with number at center. */

    public var wrapper:net.wargaming.ingame.MinimapEntry;
    private var base:net.wargaming.ingame.MinimapEntry;

    public function MinimapEntry(wrapper:net.wargaming.ingame.MinimapEntry, base:net.wargaming.ingame.MinimapEntry)
    {
        this.wrapper = wrapper;
        this.base = base;
        wrapper.xvm_worker = this;
        MinimapEntryCtor();
    }

    function lightPlayer()
    {
        return this.lightPlayerImpl.apply(this, arguments);
    }

    function init()
    {
        return this.initImpl.apply(this, arguments);
    }

    function invalidate()
    {
        return this.invalidateImpl.apply(this, arguments);
    }

    function draw()
    {
        return this.drawImpl.apply(this, arguments);
    }

    // wrapped methods
    /////////////////////////////////////////////////////////////////

    /** Entry type: enemy, ally, squadman, empty possible */
    public static var MINIMAP_ENTRY_NAME_ENEMY:String = "enemy";
    public static var MINIMAP_ENTRY_NAME_ALLY:String = "ally";
    public static var MINIMAP_ENTRY_NAME_SQUAD:String = "squadman";
    public static var MINIMAP_ENTRY_NAME_SELF:String = ""; /** Type of player himself and ? */

    public static var MINIMAP_ENTRY_VEH_CLASS_LIGHT:String = "lightTank";
    public static var MINIMAP_ENTRY_VEH_CLASS_MEDIUM:String = "mediumTank";
    public static var MINIMAP_ENTRY_VEH_CLASS_HEAVY:String = "heavyTank";
    public static var MINIMAP_ENTRY_VEH_CLASS_TD:String = "AT-SPG";
    public static var MINIMAP_ENTRY_VEH_CLASS_SPG:String = "SPG";
    public static var MINIMAP_ENTRY_VEH_CLASS_SUPER:String = "superheavyTank";

    /**
     * Subject of PlayersPanel <-> Minimap syncronization.
     * Syncronized during light delegate event.
     */
    public var uid:Number;

    public var player:Player;

    /** Used only for camera entry to define if entry is processed with Lines class */
    public var cameraExtendedToken:Boolean;

    public var labelMc:MovieClip;

    function MinimapEntryCtor()
    {
        Utils.TraceXvmModule("Minimap");
        var $this = this;
        wrapper["$removeMovieClip"] = wrapper.removeMovieClip;
        wrapper.removeMovieClip = function()
        {
            if ($this.uid != null)
            {
                //Logger.add("remove: " + $this.uid);
                GlobalEventDispatcher.dispatchEvent(new MinimapEvent(MinimapEvent.ENTRY_LOST, $this.uid));
            }
            this["$removeMovieClip"]()
        }
    }

    /**
     * All attachments container: TextFiels(Labels), Shapes.
     */
    public function get attachments():MovieClip
    {
        if (wrapper.xvm_attachments == null)
            wrapper.createEmptyMovieClip("xvm_attachments", wrapper.getNextHighestDepth());
        return wrapper.xvm_attachments;
    }

    /**
     * Minimap resize procedures break attachments scale.
     * Workaround.
     * Reverts parent entry scaling.
     * For example: icon scaling of 62% produces attachment scaling of 159
     * so resulting attachment size becomes as if both icons and attachments scale were 100%.
     * This makes attachments size virtually independent of icon scale.
     */
    public function rescaleAttachments():Void
    {
        var scale = (1 / (wrapper._xscale / 100)) * 100;
        if (attachments._xscale != scale)
            attachments._xscale = attachments._yscale = scale;
    }

    function lightPlayerImpl(visibility)
    {
        /**
         * Behavior of original icon highlighting is altered temporarily
         * while sync flag is raised.
         */
        if (isSyncProcedureInProgress)
        {
            initExtendedBehaviour();
        }
        else
        {
            base.lightPlayer(visibility);
        }
    }

    function initImpl()
    {
        base.init.apply(base, arguments);
        MarkerColor.setColor(wrapper);
    }

    function invalidateImpl()
    {
        //Logger.add('invalidateImpl: ' + wrapper.entryName);
        base.invalidate();
        MarkerColor.setColor(wrapper);
        LabelViewBuilder.updateTextField(labelMc);
    }

    function drawImpl()
    {
        //Logger.add('drawImpl: ' + wrapper.entryName);
        base.draw();
        rescaleAttachments();
    }

    public static function getVehicleClassSymbol(vehicleClass:String):String
    {
        switch (vehicleClass)
        {
            case MINIMAP_ENTRY_VEH_CLASS_LIGHT:
                return MapConfig.lightSymbol;
            case MINIMAP_ENTRY_VEH_CLASS_MEDIUM:
                return MapConfig.mediumSymbol;
            case MINIMAP_ENTRY_VEH_CLASS_HEAVY:
                return MapConfig.heavySymbol;
            case MINIMAP_ENTRY_VEH_CLASS_TD:
                return MapConfig.tdSymbol;
            case MINIMAP_ENTRY_VEH_CLASS_SPG:
                return MapConfig.spgSymbol;
            case MINIMAP_ENTRY_VEH_CLASS_SUPER:
                return MapConfig.superSymbol;
            default:
                return "";
        }
    }

    // -- Private

    private function initExtendedBehaviour():Void
    {
        uid = SyncModel.instance.getTestUid();
        // Inform PlayersPanel
        if (uid != null)
        {
            //Logger.add("add:   " + uid);
            GlobalEventDispatcher.dispatchEvent(new MinimapEvent(MinimapEvent.ENTRY_REVEALED, uid));
        }

        if (MapConfig.revealedEnabled)
        {
            labelMc = LabelsContainer.getLabel(uid);
            if (wrapper.entryName == STATIC_ICON_BASE)
            {
                if (wrapper.orig_entryName == null)
                    wrapper.orig_entryName = wrapper.entryName;
                wrapper.setEntryName(STATIC_ICON_CONTROL);
            }
            setLabelToMimicEntryMoves();
        }
    }

    private function setLabelToMimicEntryMoves():Void
    {
        /**
         * No FPS drop discovered.
         * Okay.
         */
        wrapper.onEnterFrame = function()
        {
            /**
             * Seldom error workaround.
             * Wreck sometimes is placed at map center.
             */
            if (!this._x && !this._y)
            {
                return;
            }

            var entry:wot.Minimap.MinimapEntry = this.xvm_worker;
            entry.labelMc._x = this._x;
            entry.labelMc._y = this._y;
        }
    }

    private function get isSyncProcedureInProgress():Boolean
    {
        var ret:Boolean = SyncModel.instance.isSyncProcedureInProgress;
        if (ret == null)
        {
            Logger.add("## ERROR wot.Minimap.MinimapEntry: SyncModel.instance.isSyncProcedureInProgress == null");
        }

        return ret;
    }
}
