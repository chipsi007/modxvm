package net.wg.utils
{
    import net.wg.utils.animation.ITweenConstruction;
    import flash.display.DisplayObject;
    import net.wg.infrastructure.interfaces.ITweenConstructionHandler;
    import net.wg.infrastructure.interfaces.ITween;
    
    public interface IAnimBuilder
    {
        
        function addFadeIn(param1:DisplayObject, param2:ITweenConstructionHandler, param3:int, param4:String = null) : ITweenConstruction;
        
        function addFadeOut(param1:DisplayObject, param2:ITweenConstructionHandler, param3:int, param4:String = null) : ITweenConstruction;
        
        function addMoveUp(param1:DisplayObject, param2:ITweenConstructionHandler, param3:int, param4:String = null) : ITweenConstruction;
        
        function addMoveDown(param1:DisplayObject, param2:ITweenConstructionHandler, param3:int, param4:String = null) : ITweenConstruction;
        
        function addGlowIn(param1:DisplayObject, param2:ITweenConstructionHandler, param3:int, param4:String = null) : ITweenConstruction;
        
        function addGlowOut(param1:DisplayObject, param2:ITweenConstructionHandler, param3:int, param4:String = null) : ITweenConstruction;
        
        function addShadowIn(param1:DisplayObject, param2:ITweenConstructionHandler, param3:int, param4:String = null) : ITweenConstruction;
        
        function addShadowOut(param1:DisplayObject, param2:ITweenConstructionHandler, param3:int, param4:String = null) : ITweenConstruction;
        
        function addTween(param1:String, param2:int, param3:ITween, param4:DisplayObject, param5:ITweenConstructionHandler) : ITweenConstruction;
        
        function addHalfTurn(param1:DisplayObject, param2:ITweenConstructionHandler, param3:int, param4:String = null) : ITweenConstruction;
    }
}
