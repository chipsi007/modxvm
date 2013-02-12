import wot.utils.Logger;
import wot.Minimap.model.mapSize.MapSizeBase;

/**
 * Defines real map side size in meters.
 * Common values are 1km, 600m
 * 
 * Localized map name at _root.statsData.arenaData.mapText is used to define map.
 * "Эль-Халлуф" == "El-Halloof"
 * 
 * Did not find any generalized map name at _root flash resources. Working around locale.
 */

class wot.Minimap.model.mapSize.MapSizeModel
{
    private var cellSide:Number;
    
    public function MapSizeModel() 
    {
        cellSide = MapSizeBase.define(_root.statsData.arenaData.mapText);
        
        /**
         * TODO:
         * imgsource read *
         */
    }
    
    public function getSide():Number
    {
        return cellSide;
    }
}
