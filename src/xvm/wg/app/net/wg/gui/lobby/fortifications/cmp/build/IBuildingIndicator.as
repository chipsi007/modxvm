package net.wg.gui.lobby.fortifications.cmp.build
{
   import net.wg.infrastructure.interfaces.IUIComponentEx;
   import net.wg.gui.lobby.fortifications.data.base.BuildingBaseVO;
   import net.wg.gui.lobby.fortifications.cmp.build.impl.IndicatorLabels;
   
   public interface IBuildingIndicator extends IUIComponentEx
   {
      
      function applyVOData(param1:BuildingBaseVO) : void;
      
      function get labels() : IndicatorLabels;
      
      function set labels(param1:IndicatorLabels) : void;
   }
}
