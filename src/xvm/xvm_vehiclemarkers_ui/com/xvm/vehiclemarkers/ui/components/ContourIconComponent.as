/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package com.xvm.vehiclemarkers.ui.components
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.vehiclemarkers.ui.*;
    import flash.display.*;

    public class ContourIconComponent extends VehicleMarkerComponentBase
    {
        //// Fix markers centering
        //private static var MARKER_CENTER_OFFSET_X = -9.5;
        //private static var MARKER_CENTER_OFFSET_Y = {
            //$lightTank: -23.5,
            //$mediumTank: -24.5,
            //$heavyTank: -29.5,
            //$AT_SPG: -20.5,
            //$SPG: -20.5,
            //$dynamic: -22.5
        //}

        //private var m_hunt;
        //private var m_markerLabel;  // [proxy] "green", "gold", "blue", "yellow", "red", "purple"
        //private var m_markerState;  // [proxy.marker] "dead", "immediate_dead", ...
        //private var m_vehicleClass; // [proxy.marker.marker.icon] "lightTank", "mediumTank", ..., "dynamic" (speaker)

        public function ContourIconComponent(marker:XvmVehicleMarker)
        {
            super(marker);
            //m_markerLabel = null;
            //m_markerState = null;
        }

        //public function init(vehicleClass, hunt)
        //{
            //m_vehicleClass = vehicleClass;
            //m_hunt = hunt;
//
            //updateMarkerLabel();
        //}
//
        //private function getFrameName()
        //{
            //return (proxy.isSpeaking && !proxy.isDead) ? "dynamic" : m_vehicleClass;
        //}
//
        //public function setVehicleClass()
        //{
            ////Logger.add("setVehicleClass: " + m_vehicleClass);
//
            //var frameName = getFrameName();
//
            //var icon = getIcon();
            //icon.gotoAndStop(frameName);
//
            //colorizeMarkerIcon(icon, proxy.currentStateConfigRoot.vehicleIcon.color);
        //}
//
        //public function setMarkerState(value)
        //{
            //m_markerState = value;
            //var state = /*m_markerState == "immediate_dead" ? "dead" :*/ m_markerState;
            //proxy.marker.gotoAndPlay(state);
            //if (state != "normal")
            //{
                //var frame = -1;
                //var me = this;
                //proxy.marker.onEnterFrame = function()
                //{
                        //if (frame != this._currentframe)
                        //{
                            //frame = this._currentframe;
                            //return;
                        //}
                        //delete this.onEnterFrame;
                        //this.gotoAndPlay("normal");
                        //me.colorizeMarkerIcon(me.getIcon(), me.proxy.currentStateConfigRoot.vehicleIcon.color);
                        ////this.gotoAndPlay("dead");
                //}
            //}
//
            //if (proxy.isDead && proxy.isSpeaking) // change dynamic to vehicle type marker for dead while speaking
                //this.setVehicleClass();
        //}
//
        //public function setMarkerLabel()
        //{
            ////Logger.add("setMarkerLabel: " + m_markerLabel + " " + m_markerState);
            //m_markerLabel = null;
            //updateMarkerLabel(true);
        //}
//
        //public function updateMarkerLabel(skipSetMarkerLabel:Boolean)
        //{
            ////Logger.add("updateMarkerLabel: " + m_markerLabel + " <=> " + ColorsManager.getMarkerColorAlias(proxy.entityName));
            //var aliasColor = ColorsManager.getMarkerColorAlias(proxy.entityName);
            //if (m_markerLabel == aliasColor)
                //return;
//
            //m_markerLabel = aliasColor;
            //if (!skipSetMarkerLabel)
                //proxy.setMarkerLabel(m_markerLabel);
//
            //if (m_vehicleClass == null)
                //Logger.add("INTERNAL ERROR: m_vehicleClass == null");
//
            //if (m_markerState != null)
            //{
                //if (proxy.isDead)
                    //m_markerState = "immediate_dead";
                //setMarkerState(m_markerState);
            //}
//
            //this.setVehicleClass();
        //}
//
        //public function updateState(state_cfg:Object)
        //{
            //var cfg = state_cfg.vehicleIcon;
//
            //var visible = cfg.enabled || (proxy.isSpeaking && cfg.showSpeaker);
//
            //if (visible)
                //draw(cfg);
//
            //proxy.marker._visible = visible;
        //}
//
        //// PRIVATE FUNCTIONS
//
        //private function draw(cfg:Object)
        //{
            //var x = (cfg.scaleX + MARKER_CENTER_OFFSET_X) * cfg.maxScale / 100;
            //var y = (cfg.scaleY + MARKER_CENTER_OFFSET_Y["$" + getFrameName().split("-").join("_")]) * cfg.maxScale / 100;
//
            //// WARNING: do not touch proxy.marker.marker - marker animation will be broken
//
            //for (var childName in proxy.marker.marker)
            //{
                //var obj = proxy.marker.marker[childName];
                //if (typeof obj != "movieclip")
                    //continue;
//
                //var icon:MovieClip = obj;
                //icon._x = x;
                //icon._y = y;
                //icon._xscale = icon._yscale = cfg.maxScale;
            //}
//
            //proxy.marker._x = cfg.x;
            //proxy.marker._y = cfg.y;
            //proxy.marker._alpha = proxy.formatDynamicAlpha(cfg.alpha);
        //}
//
        //private function getIcon():MovieClip
        //{
            //var icon = null;
            //if (proxy.marker.marker.iconHunt == null)
            //{
                //icon = proxy.marker.marker.icon;
            //}
            //else
            //{
                //proxy.marker.marker.icon._visible = !m_hunt;
                //proxy.marker.marker.iconHunt._visible = m_hunt;
                //icon = m_hunt ? proxy.marker.marker.iconHunt : proxy.marker.marker.icon;
            //}
            //return icon;
        //}
//
        //private function colorizeMarkerIcon(icon:MovieClip, color:String)
        //{
            //if (proxy.isSpeaking)
            //{
                //icon.transform.colorTransform = new flash.geom.ColorTransform();
            //}
            //else
            //{
                //// filters are not applicable to the MovieClip in Scaleform. Only ColorTransform can be used.
                //GraphicsUtil.colorize(icon, proxy.formatDynamicColor(proxy.formatStaticColorText(color)),
                    //proxy.isDead ? Config.config.consts.VM_COEFF_VMM_DEAD : Config.config.consts.VM_COEFF_VMM);
            //}
        //}
    }
}
