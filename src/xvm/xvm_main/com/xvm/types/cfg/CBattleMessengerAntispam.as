/**
 * XVM Config - "battleMessenger" section
 * @author Mikhail Paulyshka "mixail(at)modxvm.com"
 */
package com.xvm.types.cfg
{
    public dynamic class CBattleMessengerAntispam extends Object
    {
        public var enabled:Boolean;
        public var duplicateCount:Number;
        public var duplicateInterval:Number;
        public var playerCount:Number;
        public var playerInterval:Number;
        public var customFilters:Object;
    }
}