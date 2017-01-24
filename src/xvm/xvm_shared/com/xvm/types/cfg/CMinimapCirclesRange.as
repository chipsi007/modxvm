/**
 * XVM Config
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.types.cfg
{
    import com.xfw.*;
    import com.xvm.*;

    public dynamic class CMinimapCirclesRange extends Object implements ICloneable
    {
        public var enabled:*;
        public var alpha:*;
        public var color:*;
        public var thickness:*;

        public function clone():*
        {
            throw new Error("clone() method is not implemented");
        }

        internal function applyGlobalBattleMacros():void
        {
            enabled = Macros.FormatBooleanGlobal(enabled, true);
            alpha = Macros.FormatNumberGlobal(alpha);
            color = Macros.FormatNumberGlobal(color);
            thickness = Macros.FormatNumberGlobal(thickness);
        }
    }
}
