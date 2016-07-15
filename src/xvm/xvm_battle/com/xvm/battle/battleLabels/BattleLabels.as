﻿/**
 * XVM
 * @author wotunion <http://www.koreanrandom.com/forum/user/27262-wotunion/>
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.battle.battleLabels
{
    import com.xfw.*;
    import com.xfw.events.*;
    import com.xvm.*;
    import com.xvm.battle.events.HitLogEvent;

import com.xvm.extraFields.*;
    import com.xvm.types.cfg.*;
    import flash.events.*;
    import scaleform.clik.core.*;

    public class BattleLabels extends UIComponent
    {
        private var _extraFields:ExtraFields = null;
        private var _hitLogExtraFields : ExtraFields;

        public function BattleLabels()
        {
            Xvm.addEventListener(Defines.XVM_EVENT_CONFIG_LOADED, onConfigLoaded);
            Xfw.addCommandListener(XvmCommands.AS_ON_KEY_EVENT, onKeyEvent);
            Stat.instance.addEventListener(Stat.COMPLETE_BATTLE, onStatLoaded);
            Xvm.addEventListener(HitLogEvent.DAMAGE_CAUSED, onDamageCausedHandler);
            onConfigLoaded(null);
        }

        private function onDamageCausedHandler(event:HitLogEvent):void {
            //_hitLogExtraFields.update(BattleState.get(event.hitVehicleID));
        }

        override protected function onDispose():void
        {
            Xvm.removeEventListener(Defines.XVM_EVENT_CONFIG_LOADED, onConfigLoaded);
            Xfw.removeCommandListener(XvmCommands.AS_ON_KEY_EVENT, onKeyEvent);
            Xvm.removeEventListener(HitLogEvent.DAMAGE_CAUSED, onDamageCausedHandler);
            if (_extraFields)
            {
                _extraFields.dispose();
                _extraFields = null;
            }
            if (_hitLogExtraFields)
            {
                removeChild(_hitLogExtraFields);
                _hitLogExtraFields.dispose();
                _hitLogExtraFields = null;
            }

            super.onDispose();
        }

        // PRIVATE

        private function onStatLoaded(e:ObjectEvent):void
        {
            onConfigLoaded(null);
        }

        public function onConfigLoaded(e:Event):void
        {
            try
            {
                // TODO
                //_extraFields = new ExtraFields(...);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        private function onKeyEvent(key:Number, isDown:Boolean):Object
        {
            try
            {
                var cfg:CHotkeys = Config.config.hotkeys;
                if (!cfg.battleLabelsHotKeys)
                    return null;

                // TODO
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
            return null;
        }
    }
}
