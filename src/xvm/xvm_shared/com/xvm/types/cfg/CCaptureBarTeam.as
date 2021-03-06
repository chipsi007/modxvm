/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * https://modxvm.com/
 */
package com.xvm.types.cfg
{
    import com.xfw.*;

    public dynamic class CCaptureBarTeam implements ICloneable
    {
        public var сolor:*;
        public var title:CCaptureBarTextField;
        public var players:CCaptureBarTextField;
        public var timer:CCaptureBarTextField;
        public var background:CCaptureBarTextField;

        public function clone():*
        {
            throw new Error("clone() method is not implemented");
        }
    }
}
