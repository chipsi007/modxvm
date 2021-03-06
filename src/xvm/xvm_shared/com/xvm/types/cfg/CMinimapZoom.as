/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * https://modxvm.com/
 */
package com.xvm.types.cfg
{
    import com.xfw.*;
    import com.xvm.*;

    public dynamic class CMinimapZoom implements ICloneable
    {
        public var index:*;
        public var centered:*;

        public function clone():*
        {
            throw new Error("clone() method is not implemented");
        }

        internal function applyGlobalBattleMacros():void
        {
            index = Macros.FormatNumberGlobal(index);
            centered = Macros.FormatBooleanGlobal(centered, false);
        }
    }
}
