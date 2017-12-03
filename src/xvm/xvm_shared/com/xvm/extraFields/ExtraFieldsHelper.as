﻿/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * https://modxvm.com/
 */
package com.xvm.extraFields
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.battle.events.*;
    import com.xvm.battle.vo.*;
    import com.xvm.vo.*;
    import flash.events.*;
    import flash.utils.*;
    import mx.utils.*;
    import scaleform.gfx.*;

    public class ExtraFieldsHelper
    {
        private static const ALIVE_FLAG_ALIVE:int =         0x01;
        private static const ALIVE_FLAG_DEAD:int =          0x02;
        private static const ALIVE_FLAG_ANY:int =           ALIVE_FLAG_ALIVE | ALIVE_FLAG_DEAD;
        private static const SPOTTED_STATUS_NEVERSEEN:int = 0x10;
        private static const SPOTTED_STATUS_SPOTTED:int =   0x20;
        private static const SPOTTED_STATUS_LOST:int =      0x40;
        private static const SPOTTED_STATUS_ANY:int =       SPOTTED_STATUS_NEVERSEEN | SPOTTED_STATUS_SPOTTED | SPOTTED_STATUS_LOST;

        private static const FLAG_ENTRY_PLAYER:String = "player";
        private static const FLAG_ENTRY_ALLY:String = "ally";
        private static const FLAG_ENTRY_SQUADMAN:String = "squadman";
        private static const FLAG_ENTRY_ENEMY:String = "enemy";
        private static const FLAG_ENTRY_TEAMKILLER:String = "teamKiller";
        private static const FLAG_SPOTTED_NEVERSEEN:String = "neverSeen";
        private static const FLAG_SPOTTED_SPOTTED:String = "spotted";
        private static const FLAG_SPOTTED_LOST:String = "lost";
        private static const FLAG_ALIVE_ALIVE:String = "alive";
        private static const FLAG_ALIVE_DEAD:String = "dead";

        public static function setupEvents(field:IExtraField):void
        {
            if (field.cfg.updateEvent)
            {
                var events:Array = field.cfg.updateEvent.split(",");
                if (events.length)
                {
                    var py_events:Array = [];
                    for each (var event:String in events)
                    {
                        event = StringUtil.trim(event);
                        switch (event.toUpperCase())
                        {
                            case "ON_BATTLE_STATE_CHANGED":
                                Xvm.addEventListener(PlayerStateEvent.CHANGED, field.updateOnEvent);
                                break;
                            case "ON_PLAYERS_HP_CHANGED":
                                Xvm.addEventListener(PlayerStateEvent.PLAYERS_HP_CHANGED, field.updateOnEvent);
                                break;
                            case "ON_MY_HP_CHANGED":
                                Xvm.addEventListener(PlayerStateEvent.MY_HP_CHANGED, field.updateOnEvent);
                                break;
                            case "ON_VEHICLE_DESTROYED":
                                Xvm.addEventListener(PlayerStateEvent.VEHICLE_DESTROYED, field.updateOnEvent);
                                break;
                            case "ON_CURRENT_VEHICLE_DESTROYED":
                                Xvm.addEventListener(PlayerStateEvent.CURRENT_VEHICLE_DESTROYED, field.updateOnEvent);
                                break;
                            case "ON_MODULE_DESTROYED":
                                Xvm.addEventListener(PlayerStateEvent.MODULE_DESTROYED, field.updateOnEvent);
                                break;
                            case "ON_MODULE_REPAIRED":
                                Xvm.addEventListener(PlayerStateEvent.MODULE_REPAIRED, field.updateOnEvent);
                                break;
                            case "ON_DAMAGE_CAUSED":
                                Xvm.addEventListener(PlayerStateEvent.DAMAGE_CAUSED, field.updateOnEvent);
                                break;
                            case "ON_DAMAGE_CAUSED_ALLY":
                                Xvm.addEventListener(PlayerStateEvent.DAMAGE_CAUSED_ALLY, field.updateOnEvent);
                                break;
                            case "ON_TARGET_IN":
                                Xvm.addEventListener(PlayerStateEvent.ON_TARGET_IN, field.updateOnEvent);
                                break;
                            case "ON_TARGET_OUT":
                                Xvm.addEventListener(PlayerStateEvent.ON_TARGET_OUT, field.updateOnEvent);
                                break;
                            case "ON_PANEL_MODE_CHANGED":
                                Xvm.addEventListener(PlayerStateEvent.ON_PANEL_MODE_CHANGED, field.updateOnEvent);
                                break;
                            case "ON_MY_STAT_LOADED":
                                Xvm.addEventListener(PlayerStateEvent.ON_MY_STAT_LOADED, field.updateOnEvent);
                                break;
                            case "ON_EVERY_FRAME":
                                Xvm.addEventListener(PlayerStateEvent.ON_EVERY_FRAME, field.updateOnEvent);
                                if (!timerFrame)
                                {
                                    initTimerFrame();
                                }
                                break;
                            case "ON_EVERY_SECOND":
                                Xvm.addEventListener(PlayerStateEvent.ON_EVERY_SECOND, field.updateOnEvent);
                                if (!timerSec)
                                {
                                    initTimerSec();
                                }
                                break;
                            default:
                                // "PY(event_name)"
                                var pattern:RegExp = /PY\s*\(\s*(\w+)\s*\)/i;
                                var matches:Array = event.match(pattern);
                                //Logger.addObject(matches, 1, event);
                                if (matches && matches.length > 1)
                                {
                                    py_events.push(matches[1]);
                                }
                                break;
                        }
                    }

                    if (py_events.length > 0)
                    {
                        Xfw.addCommandListener(XvmCommands.AS_PY_EVENT, function(eventName:String):void
                        {
                            if (py_events.indexOf(eventName) >= 0)
                            {
                                field.updateOnEvent(new PlayerStateEvent(XvmCommands.AS_PY_EVENT));
                            }
                        });
                    }
                }
            }

            if (field.cfg.hotKeyCode != null)
            {
                Xfw.addCommandListener(XvmCommands.AS_ON_KEY_EVENT, field.onKeyEvent);
                field.visible = !field.cfg.visibleOnHotKey;
            }

            if (field.cfg.mouseEvents)
            {
                registerMouseEvent(field, field.cfg.mouseEvents.click, MouseEvent.CLICK, true);
                registerMouseEvent(field, field.cfg.mouseEvents.mouseDown, MouseEvent.MOUSE_DOWN, true);
                registerMouseEvent(field, field.cfg.mouseEvents.mouseMove, MouseEvent.MOUSE_MOVE, false);
                registerMouseEvent(field, field.cfg.mouseEvents.mouseOut, MouseEvent.MOUSE_OUT, false);
                registerMouseEvent(field, field.cfg.mouseEvents.mouseOver, MouseEvent.MOUSE_OVER, false);
                registerMouseEvent(field, field.cfg.mouseEvents.mouseUp, MouseEvent.MOUSE_UP, true);
                registerMouseEvent(field, field.cfg.mouseEvents.mouseWheel, MouseEvent.MOUSE_WHEEL, false);
            }
        }

        public static function checkVisibilityFlags(flags:Array, options:IVOMacrosOptions):Boolean
        {
            if (!flags)
                return true;

            var entry:String;
            if (options.isCurrentPlayer)
                entry = FLAG_ENTRY_PLAYER;
            else if (options.isSquadPersonal)
                entry = FLAG_ENTRY_SQUADMAN;
            else if (options.isTeamKiller)
                entry = FLAG_ENTRY_TEAMKILLER;
            else if (options.isAlly)
                entry = FLAG_ENTRY_ALLY;
            else
                entry = FLAG_ENTRY_ENEMY;

            var entryPresent:Boolean = false;
            var entryFound:Boolean = false;
            var spottedFlags:int = 0;
            var aliveFlags:int = 0;
            var len:int = flags.length;
            for (var i:int = 0; i < len; ++i)
            {
                var flag:String = flags[i];

                switch (flag)
                {
                    case FLAG_SPOTTED_NEVERSEEN:
                        spottedFlags |= SPOTTED_STATUS_NEVERSEEN;
                        break;
                    case FLAG_SPOTTED_SPOTTED:
                        spottedFlags |= SPOTTED_STATUS_SPOTTED;
                        break;
                    case FLAG_SPOTTED_LOST:
                        spottedFlags |= SPOTTED_STATUS_LOST;
                        break;
                    case FLAG_ALIVE_ALIVE:
                        aliveFlags |= ALIVE_FLAG_ALIVE;
                        break;
                    case FLAG_ALIVE_DEAD:
                        aliveFlags |= ALIVE_FLAG_DEAD;
                        break;
                    case FLAG_ENTRY_PLAYER:
                    case FLAG_ENTRY_SQUADMAN:
                    case FLAG_ENTRY_TEAMKILLER:
                    case FLAG_ENTRY_ALLY:
                    case FLAG_ENTRY_ENEMY:
                        entryPresent = true;
                        if (!entryFound)
                        {
                            if (entry == flag)
                            {
                                entryFound = true;
                                continue;
                            }
                        }
                        break;
                }
            }

            if (entryPresent && !entryFound)
                return false;

            if (!aliveFlags)
                aliveFlags = ALIVE_FLAG_ANY;

            var aliveValue:int = options.isAlive ? ALIVE_FLAG_ALIVE : ALIVE_FLAG_DEAD;
            if ((aliveValue & aliveFlags) == 0)
                return false;

            if (options.isDead)
                return true;

            if (!spottedFlags)
                spottedFlags = SPOTTED_STATUS_ANY;

            var playerState:VOPlayerState = options as VOPlayerState;
            if (!playerState)
                return true;

            var spottedValue:int = 0;
            switch (playerState.spottedStatus)
            {
                case FLAG_SPOTTED_NEVERSEEN:
                    spottedValue = SPOTTED_STATUS_NEVERSEEN;
                    break;
                case FLAG_SPOTTED_SPOTTED:
                    spottedValue = SPOTTED_STATUS_SPOTTED;
                    break;
                case FLAG_SPOTTED_LOST:
                    spottedValue = SPOTTED_STATUS_LOST;
                    break;
            }

            if ((spottedValue & spottedFlags) == 0)
                return false;

            return true;
        }

        // PRIVATE

        private static var timerFrame:Timer = null;
        private static var timerSec:Timer = null;

        private static function initTimerFrame():void
        {
            timerFrame = new Timer(1);
            timerFrame.addEventListener(TimerEvent.TIMER, function():void
            {
                Xvm.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.ON_EVERY_FRAME));
            });
            timerFrame.start();
        }

        private static function initTimerSec():void
        {
            timerSec = new Timer(1000);
            timerSec.addEventListener(TimerEvent.TIMER, function():void
            {
                Xvm.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.ON_EVERY_SECOND));
            });
            timerSec.start();
        }

        private static function registerMouseEvent(field:IExtraField, cfgEventName:String, eventName:String, buttonMode:Boolean):void
        {
            if (cfgEventName != null)
            {
                field.mouseEnabled = true;
                if (buttonMode)
                {
                    field.buttonMode = true;
                }
                field.addEventListener(eventName, handleMouseEvent);
            }
        }

        private static function handleMouseEvent(e:MouseEventEx):void
        {
            if (e.ctrlKey || Xvm.appType == Defines.APP_TYPE_LOBBY)
            {
                //Logger.addObject(e);
                var eventName:String = e.target.cfg.mouseEvents[e.type];
                Xfw.cmd(XfwConst.XFW_COMMAND_CALLBACK,
                    eventName,          // 0
                    e.type,             // 1
                    int(e.localX),      // 2
                    int(e.localY),      // 3
                    int(e.stageX),      // 4
                    int(e.stageY),      // 5
                    int(e.buttonIdx),   // 6
                    int(e.delta),       // 7
                    int(e.ctrlKey),     // 8
                    int(e.altKey),      // 9
                    int(e.shiftKey)     // 10
                );
            }
        }
    }
}
