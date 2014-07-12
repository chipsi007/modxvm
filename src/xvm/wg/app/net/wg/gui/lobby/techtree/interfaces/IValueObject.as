package net.wg.gui.lobby.techtree.interfaces
{
   import net.wg.utils.ILocale;
   
   public interface IValueObject
   {
      
      function fromArray(param1:Array, param2:ILocale) : void;
      
      function fromObject(param1:Object, param2:ILocale) : void;
   }
}
