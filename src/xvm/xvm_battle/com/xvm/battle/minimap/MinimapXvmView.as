package com.xvm.battle.minimap
{
	import com.xfw.*;
	import com.xvm.*;
	import com.xvm.infrastructure.*;
	import com.xvm.battle.BattleState;
	import com.xvm.battle.vo.VOPlayerState;
	import com.xvm.types.cfg.CMinimap;
	import flash.events.Event;
	import net.wg.infrastructure.events.*;
	import net.wg.infrastructure.interfaces.*;
	import net.wg.data.constants.generated.*;
	import net.wg.gui.battle.random.views.*;
	
	public class MinimapXvmView extends XvmViewBase
	{
		
		public function MinimapXvmView(view:IView)
		{
			super(view);
		}
		
		public function get page():BattlePage
		{
			return super.view as BattlePage;
		}
		
		public override function onAfterPopulate(e:LifeCycleEvent):void
		{
			super.onAfterPopulate(e);
			init();
		}
		
		override public function onBeforeDispose(e:LifeCycleEvent):void 
		{
			Xvm.removeEventListener(Defines.XVM_EVENT_CONFIG_LOADED, xvmEventConfigLoaded);
			super.onBeforeDispose(e);
		}
		private function init():void
		{	
			try
			{
				tryToCreateMoMinimap(Config.config.minimap)
			}
			catch (e:Error)
			{
				Xvm.addEventListener(Defines.XVM_EVENT_CONFIG_LOADED, xvmEventConfigLoaded);
			}

			
		}
		
		private function xvmEventConfigLoaded(e:Event):void 
		{
			try
			{
				tryToCreateMoMinimap(Config.config.minimap)
			}
			catch (e:Error)
			{
				Logger.err(e);
			}
			
		}
	
		private function tryToCreateMoMinimap(cfg:CMinimap): void {
			var xvm_enabled:Boolean = Macros.FormatBooleanGlobal(cfg.enabled, true);
			if (xvm_enabled)
			{
				page.unregisterComponent(BATTLE_VIEW_ALIASES.MINIMAP);
				var idx:int = page.getChildIndex(page.minimap);
				page.removeChild(page.minimap);
				var component:UI_Minimap = new UI_Minimap(cfg);
				component.x = page.minimap.x;
				component.y = page.minimap.y;
				page.minimap = component;
				page.addChildAt(page.minimap, idx);
				component.validateNow();
				page.xfw_registerComponent(page.minimap, BATTLE_VIEW_ALIASES.MINIMAP);
			}
		}
	}

}