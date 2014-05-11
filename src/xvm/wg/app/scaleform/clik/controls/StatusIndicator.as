package scaleform.clik.controls
{
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.constants.InvalidationType;


   public class StatusIndicator extends UIComponent
   {
          
      public function StatusIndicator() {
         super();
      }

      protected var _maximum:Number = 10;

      protected var _minimum:Number = 0;

      protected var _value:Number = 0;

      override protected function initialize() : void {
         super.initialize();
      }

      public function get maximum() : Number {
         return this._maximum;
      }

      public function set maximum(param1:Number) : void {
         this._maximum = param1;
      }

      public function get minimum() : Number {
         return this._minimum;
      }

      public function set minimum(param1:Number) : void {
         if(this._minimum == param1)
         {
            return;
         }
         this._minimum = param1;
         this.updatePosition();
      }

      public function get value() : Number {
         return this._value;
      }

      public function set value(param1:Number) : void {
         var _loc2_:Number = Math.max(this._minimum,Math.min(this._maximum,param1));
         if(this._value == _loc2_)
         {
            return;
         }
         this._value = _loc2_;
         this.updatePosition();
      }

      public function get position() : Number {
         return this._value;
      }

      public function set position(param1:Number) : void {
         this.value = param1;
      }

      override public function toString() : String {
         return "[CLIK StatusIndicator " + name + "]";
      }

      override protected function configUI() : void {
         super.configUI();
         tabEnabled = focusable = false;
      }

      override protected function draw() : void {
         if(isInvalid(InvalidationType.SIZE))
         {
            setActualSize(_width,_height);
         }
         if(isInvalid(InvalidationType.DATA))
         {
            this.updatePosition();
         }
      }

      protected function updatePosition() : void {
         if(!enabled)
         {
            return;
         }
         var _loc1_:Number = (this._value - this._minimum) / (this._maximum - this._minimum);
         gotoAndStop(Math.max(1,Math.round(_loc1_ * totalFrames)));
      }
   }

}