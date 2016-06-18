/**
 * ...
 * @author Maxim Schedriviy
 */
import com.xvm.*;

class com.xvm.ColorsManager
{
    /**
     * Return vehicle marker frame name for current state
     *
     * VehicleMarkerAlly should contain 4 named frames:
     *   - green - normal ally
     *   - gold - squad mate
     *   - blue - teamkiller
     * VehicleMarkerEnemy should contain 2 named frames:
     *   - red - normal enemy
     * @param	entityName EntityName
     * @param	isColorBlindMode CB mode flag
     * @return	name of marker frame
     */
    public static function getMarkerColorAlias(entityName):String
    {
        //if (m_entityName != "ally" && m_entityName != "enemy" && m_entityName != "squadman" && m_entityName != "teamKiller")
        //  Logger.add("m_entityName=" + m_entityName);
        if (entityName == "ally")
            return "green";
        if (entityName == "squadman")
            return "gold";
        if (entityName == "teamKiller")
            return "blue";
        if (entityName == "enemy")
            return "red";

        // if not found (node is not implemented), return inverted enemy color (for debug only)
        // TODO: throw error may be better?
        return "purple";
    }

// AS3:DONE     /**
// AS3:DONE      * Get system color key for current state
// AS3:DONE      */
// AS3:DONE     public static function getSystemColorKey(entityName:String, isDead:Boolean, isBlowedUp:Boolean, isBase:Boolean):String
// AS3:DONE     {
// AS3:DONE         return entityName + "_" + (isBase ? "base" : !isDead ? "alive" : isBlowedUp ? "blowedup" : "dead");
// AS3:DONE     }
// AS3:DONE 
// AS3:DONE     /**
// AS3:DONE      * Get system color value for current state
// AS3:DONE      */
// AS3:DONE     public static function getSystemColor(entityName:String, isDead:Boolean, isBlowedUp:Boolean, isBase:Boolean):Number
// AS3:DONE     {
// AS3:DONE         return parseInt(Config.config.colors.system[getSystemColorKey(entityName, isDead, isBlowedUp, isBase)]);
// AS3:DONE     }

    public static function getDamageSystemColor(damageSource:String, damageDest:String, damageType:String, isDead:Boolean, isBlowedUp:Boolean):Number
    {
        switch (damageType)
        {
            case "world_collision":
            case "death_zone":
            case "drowning":
                return parseInt(Config.config.colors.dmg_kind[damageType]);

            case "shot":
            case "fire":
            case "ramming":
            default:
                var key:String = damageSource + "_" + damageDest + "_";
                key += !isDead ? "hit" : isBlowedUp ? "blowup" : "kill";
                return parseInt(Config.config.colors.damage[key]);
        }
    }
}
