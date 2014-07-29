package net.wg.gui.components.controls.achievements
{
    import flash.display.MovieClip;
    import net.wg.data.constants.SoundTypes;
    import net.wg.data.constants.SoundManagerStates;
    
    public class AchievementDivision extends AchievementCommon
    {
        
        public function AchievementDivision() {
            super();
        }
        
        public var divisionLine:MovieClip = null;
        
        override protected function configUI() : void {
            soundType = SoundTypes.CAROUSEL_BTN;
            soundId = SoundManagerStates.CAROUSEL_CELL_BTN;
            super.configUI();
        }
        
        override public function setData(param1:Object) : void {
            if(param1 == null)
            {
                return;
            }
            super.setData(param1);
        }
        
        override protected function applyData() : void {
            if(data == null)
            {
                return;
            }
            this.divisionLine.visible = data.hasOwnProperty("showSeparator")?data.showSeparator:false;
            super.applyData();
            if(data.value <= 1 && (counter))
            {
                counter.visible = false;
            }
        }
    }
}
