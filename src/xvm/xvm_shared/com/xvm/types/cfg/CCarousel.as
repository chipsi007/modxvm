/**
 * XVM Config
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.types.cfg
{
    import com.xfw.*;

    public dynamic class CCarousel extends Object implements ICloneable
    {
        public var enabled:*;
        public var zoom:*;
        public var rows:*;
        public var padding:CPadding;
        public var backgroundAlpha:*;
        public var scrollingSpeed:*;
        public var hideBuyTank:Boolean;
        public var hideBuySlot:Boolean;
        public var showTotalSlots:Boolean;
        public var showUsedSlots:Boolean;
        public var filters:Object; // TODO
        public var filtersPadding:Object; // TODO
        public var fields:Object; // TODO
        public var extraFields:Array;
        public var nations_order:Array;
        public var types_order:Array;
        public var sorting_criteria:Array;
        public var suppressCarouselTooltips:*;

        public function clone():*
        {
            throw new Error("clone() method is not implemented");
        }
    }
}