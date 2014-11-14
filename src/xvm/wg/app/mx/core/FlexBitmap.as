package mx.core
{
    import flash.display.Bitmap;
    import mx.utils.NameUtil;
    import flash.display.BitmapData;
    
    public class FlexBitmap extends Bitmap
    {
        
        public function FlexBitmap(param1:BitmapData = null, param2:String = "auto", param3:Boolean = false)
        {
            super(param1,param2,param3);
            try
            {
                name = NameUtil.createUniqueName(this);
            }
            catch(e:Error)
            {
            }
        }
        
        mx_internal  static var VERSION:String = "4.6.0.23201";
        
        override public function toString() : String
        {
            return NameUtil.displayObjectToString(this);
        }
    }
}
