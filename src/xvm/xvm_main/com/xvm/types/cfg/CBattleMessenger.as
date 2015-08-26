/**
 * XVM Config - "battleMessenger" section
 * @author Mikhail Paulyshka "mixail(at)modxvm.com"
 */
package com.xvm.types.cfg
{
    public dynamic class CBattleMessenger extends Object
    {
        public var enabled:Boolean;
        public var messageLifeTime:Number;
        public var chatLength:Number;
        public var backgroundAlpha:Number;
        public var block:CBattleMessengerBlock;
        public var filter:CBattleMessengerFilter;
        public var antispam:CBattleMessengerAntispam;
        public var ratingFilters:CBattleMessengerRatingfilters;
    }
}