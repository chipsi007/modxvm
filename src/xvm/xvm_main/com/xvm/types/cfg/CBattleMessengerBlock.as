/**
 * XVM Config - "battleMessenger" section
 * @author Mikhail Paulyshka "mixail(at)modxvm.com"
 */
package com.xvm.types.cfg
{
    public dynamic class CBattleMessengerBlock extends Object
    {
        public var ourClan:String;
        public var ourSquad:String;
        public var ally:CBattleMessengerAlly;
        public var enemy:CBattleMessengerEnemy;
    }
}