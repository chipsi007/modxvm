package net.wg.gui.lobby.customization.renderers
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import net.wg.gui.components.controls.IconText;
   import scaleform.clik.constants.InvalidationType;
   import net.wg.data.constants.SoundTypes;


   public class CamoDemoRenderer extends CamouflageItemRenderer
   {
          
      public function CamoDemoRenderer() {
         super();
         soundId = SoundTypes.CAMOUFLAGE_DEMO_RENDERER;
         useHandCursorForse = true;
      }

      public static const WINTER:String = "winter";

      public static const SUMMER:String = "summer";

      public static const DESERT:String = "desert";

      public static const OFF:String = "off";

      public static const KIND_DIRTY:String = "kindDirty";

      public static var KINDS:Array = [WINTER,SUMMER,DESERT];

      public var kindMc:MovieClip;

      public var timeLeftFld:TextField;

      public var costFieldNew:IconText;

      private var _kind:String;

      private var _kindDirty:Boolean = false;

      override public function setData(param1:Object) : void {
         super.setData(param1);
         this.showKind(!data || !data.id);
      }

      public function get kind() : String {
         return this._kind;
      }

      public function set kind(param1:String) : void {
         this._kind = param1;
         this._kindDirty = true;
      }

      override protected function checkTooltip() : void {
          
      }

      override protected function draw() : void {
         var _loc1_:* = NaN;
         super.draw();
         if(this._kindDirty)
         {
            if(this.kind == OFF)
            {
               this.showKind(false);
            }
            else
            {
               this.showKind(!data || !data.id);
               _loc1_ = 0;
               _loc1_ = 0;
               while(_loc1_ < KINDS.length)
               {
                  if(KINDS[_loc1_] == this.kind)
                  {
                     this.kindMc.gotoAndStop(_loc1_ + 1);
                     break;
                  }
                  _loc1_++;
               }
            }
            this._kindDirty = false;
         }
         if(isInvalid(InvalidationType.DATA))
         {
            if(this.timeLeftFld)
            {
               if((data) && (data.timeLeft) && data.timeLeft.length > 0)
               {
                  this.timeLeftFld.visible = true;
                  this.timeLeftFld.text = data.timeLeft;
               }
               else
               {
                  this.timeLeftFld.visible = false;
               }
               this.timeLeftFld.mouseEnabled = false;
            }
            else
            {
               invalidateData();
            }
            costField.text = "";
         }
      }

      override protected function configUI() : void {
         super.configUI();
         this.timeLeftFld.mouseEnabled = false;
      }

      override protected function setState(param1:String) : void {
         super.setState(param1);
         if(!current && !selected)
         {
            border.state = "up";
         }
      }

      private function showKind(param1:Boolean) : void {
         this.kindMc.visible = !(this.kind == OFF) && (param1);
      }
   }

}