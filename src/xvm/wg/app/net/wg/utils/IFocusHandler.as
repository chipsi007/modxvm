package net.wg.utils
{
   import net.wg.infrastructure.interfaces.entity.IDisposable;
   import flash.display.InteractiveObject;
   import net.wg.infrastructure.interfaces.IManagedContent;
   import net.wg.infrastructure.interfaces.IView;
   import scaleform.clik.ui.InputDetails;
   import flash.display.Stage;
   
   public interface IFocusHandler extends IDisposable
   {
      
      function getFocus(param1:uint) : InteractiveObject;
      
      function setFocus(param1:InteractiveObject, param2:uint = 0, param3:Boolean = false) : void;
      
      function setModalFocus(param1:IManagedContent) : void;
      
      function getModalFocus() : IView;
      
      function hasModalFocus(param1:IView) : Boolean;
      
      function input(param1:InputDetails) : void;
      
      function set stage(param1:Stage) : void;
   }
}
