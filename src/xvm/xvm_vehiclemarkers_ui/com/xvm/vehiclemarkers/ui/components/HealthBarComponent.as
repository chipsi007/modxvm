/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.vehiclemarkers.ui.components
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.battle.vo.*;
    import com.xvm.types.cfg.*;
    import com.xvm.vehiclemarkers.ui.*;
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.geom.*;

    public class HealthBarComponent extends VehicleMarkerComponentBase
    {
        public function HealthBarComponent(marker:XvmVehicleMarker)
        {
            super(marker);
            marker.addEventListener(XvmVehicleMarkerEvent.UPDATE_HEALTH, showDamage);
        }

        private var healthBar:Sprite;
        private var border:Sprite;
        private var fill:Sprite;
        private var damage:MovieClip;

        override protected function init(e:XvmVehicleMarkerEvent):void
        {
            try
            {
                healthBar = new Sprite();
                marker.addChild(healthBar);
                border = new Sprite();
                healthBar.addChild(border);
                fill = new Sprite();
                healthBar.addChild(fill);
                damage = new MovieClip();
                healthBar.addChild(damage);
                super.init(e);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        override protected function update(e:XvmVehicleMarkerEvent):void
        {
            try
            {
                super.update(e);
                var cfg:CMarkersHealthBar = e.cfg.healthBar;
                healthBar.visible = Macros.FormatBoolean(cfg.enabled, e.playerState, true);
                if (healthBar.visible)
                {
                    var playerState:VOPlayerState = e.playerState;

                    if (cfg.border.color == null)
                        cfg.border.color = "{{c:system}}";
                    border.graphics.clear();
                    border.graphics.beginFill(
                        Macros.FormatNumber(cfg.border.color, playerState, 0, true),
                        Macros.FormatNumber(cfg.border.alpha, playerState, 100) / 100.0);
                    border.graphics.drawRect(0, 0, cfg.width + cfg.border.size * 2, cfg.height + cfg.border.size * 2);
                    border.graphics.endFill();

                    if (cfg.color == null)
                        cfg.color = "{{c:system}}";
                    if (cfg.lcolor == null)
                        cfg.lcolor = "{{c:system}}";
                    var color:Number = Macros.FormatNumber(cfg.color, playerState, 0, true);
                    var lcolor:Number = Macros.FormatNumber(cfg.lcolor, playerState, color, true);
                    var healthRatio:Number = playerState.curHealth / playerState.maxHealth;
                    if (isNaN(healthRatio))
                        healthRatio = 1;
                    fill.graphics.clear();
                    fill.graphics.beginFill(
                        GraphicsUtil.colorByRatio(healthRatio, lcolor, color),
                        Macros.FormatNumber(cfg.fill.alpha, playerState) / 100.0);
                    fill.graphics.drawRect(cfg.border.size, cfg.border.size, cfg.width * Math.min(healthRatio, 1.0), cfg.height);
                    fill.graphics.endFill();

                    //Logger.add(String(cfg.width * Math.min(healthRatio, 1.0)));

                    damage.graphics.clear();
                    damage.scaleX = 0;
                    damage.graphics.beginFill(0);
                    damage.graphics.drawRect(cfg.border.size, cfg.border.size, cfg.width, cfg.height);
                    damage.graphics.endFill();

                    healthBar.x = cfg.x;
                    healthBar.y = cfg.y;
                    healthBar.alpha = Macros.FormatNumber(cfg.alpha, playerState) / 100.0;
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        // PRIVATE

        /**
         * Show floating damage indicator
         */
        private function showDamage(e:XvmVehicleMarkerEvent):void
        {
            try
            {
                update(e);
                if (healthBar.visible)
                {
                    var cfg:CMarkersHealthBar = e.cfg.healthBar;
                    var playerState:VOPlayerState = e.playerState;
                    TweenLite.killTweensOf(damage);
                    damage.x = cfg.border.size + cfg.width * (playerState.curHealth / playerState.maxHealth) - 1;
                    damage.scaleX += playerState.damageInfo.damageDelta / playerState.maxHealth;
                    if (cfg.damage.color == null)
                        cfg.damage.color = "{{c:system}}";
                    var color:Number = Macros.FormatNumber(cfg.damage.color, playerState, 0, true);
                    GraphicsUtil.setColorTransform(damage, color);
                    damage.alpha = Macros.FormatNumber(cfg.damage.alpha, playerState) / 100.0;
                    TweenLite.to(damage, cfg.damage.fade, { scaleX: 0, ease: Cubic.easeIn } );
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }
    }
}