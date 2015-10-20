import com.xvm.*;
import wot.Minimap.model.mapSize.*;

/**
 * Defines real map side size in meters.
 * Common values are 1km, 800m
 */

class wot.Minimap.model.mapSize.MapSizeModel
{
    private static var _instance:MapSizeModel;

    private var cellSide:Number;

    public static function get instance():MapSizeModel
    {
        if (!_instance)
        {
            _instance = new MapSizeModel();
        }

        return _instance;
    }

    public function getCellSide():Number
    {
        return cellSide;
    }

    public function getFullSide():Number
    {
        return cellSide * 10;
    }

    // -- Private

    private function MapSizeModel()
    {
        /**
         * Translate localized map name back to system name.
         * Map must be added in MapInfoData.
         */
        var mapText:String = _root.statsData.arenaData.mapText;
        Logger.add("Minimap: localized map name: " + mapText);

        cellSide = MapInfoData.SizeByLocalizedMapName(mapText);
        if (!cellSide)
        {
            /** This can be seen only when map isn't set in MapInfoData */
            Logger.add("Minimap ERROR: map not recognized");
        }
    }
}
