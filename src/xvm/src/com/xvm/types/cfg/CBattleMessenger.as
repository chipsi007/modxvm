/**
 * XVM Config - "battleMessenger" section
 * @author Mikhail Paulyshka "mixail(at)modxvm.com"
 */
package com.xvm.types.cfg
{
    public dynamic class CBattleMessenger extends Object
    {
        public var enabled:Boolean;
        public var enableRatingFilter:Boolean;
        public var messageLifeTime:Number;
        public var chatLength:Number;
        public var backgroundAlpha:Number;
        public var minRating:Number;
        public var debugMode:Boolean;
        public var ignore:Object;
        public var blockAlly:Object;
        public var blockEnemy:Object;
        public var antispam:Object;
    }
}