import com.xvm.*;
import wot.Minimap.*;
import wot.Minimap.model.externalProxy.*;
import wot.Minimap.model.mapSize.*;

/**
 * Handles circles and lines scaling aspect.
 * Defines icon to attach to.
 */

class wot.Minimap.shapes.ShapeAttach
{
    /**
     * Internal MoviecLip minimap size in points without scaling.
     *
     * scripts/client/gui/Scaleform/Minimap.py
     *   class Minimap(object):
     *     __MINIMAP_SIZE = (210, 210)
     */
    private var MAP_SIZE_IN_POINTS:Number = 210;

    private var scaleFactor:Number;

    private var selfAttachments:MovieClip;

    public function ShapeAttach()
    {
        /**
         * Get oneself icon.
         * Used as a center of circles.
         * Will carry attached circles with itself automatically.
         */
        var self:MinimapEntry = IconsProxy.selfEntry;
        selfAttachments = self.attachments;

        var metersPerPoint:Number = MAP_SIZE_IN_POINTS / mapSizeInMeters;
        scaleFactor = metersPerPoint;

        /** Hide sphapes on players dead event (postmortem mod) */
        GlobalEventDispatcher.addEventListener(Defines.E_SELF_DEAD, this, postmortemMod);

        var ud = BattleState.getSelfUserData();
        if (ud != null && ud.dead == true)
            postmortemMod();
    }

    // -- Private

    private function get mapSizeInMeters():Number
    {
        return MapSizeModel.instance.getFullSide();
    }

    private function postmortemMod(event) {
        selfAttachments._visible = false;
    }
}
