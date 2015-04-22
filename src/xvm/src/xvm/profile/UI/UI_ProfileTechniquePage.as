/**
 * XVM
 * @author Maxim Schedriviy <max(at)modxvm.com>
 */
package xvm.profile.UI
{
    import com.xfw.*;
    import com.xvm.*;
    import com.xvm.types.dossier.*;
    import xvm.profile.components.*;

    public dynamic class UI_ProfileTechniquePage extends ProfileTechniquePage_UI
    {
        private var technique:Technique;

        public function UI_ProfileTechniquePage()
        {
            super();
        }

        override protected function onPopulate():void
        {
            super.onPopulate();
            technique = new TechniquePage(this, XvmGlobals[XvmGlobals.CURRENT_USER_NAME]);
            addChild(technique);
        }

        // PUBLIC

        public function get currentDataXvm():Object
        {
            return currentData;
        }

        public function get battlesTypeXvm():String
        {
            return battlesType;
        }

        public function get baseDisposed():Boolean
        {
            return _baseDisposed;
        }

        public function as_responseDossierXvm(battlesType:String, vehicles:Object):void
        {
            if (_baseDisposed)
                return;

            try
            {
                if (technique)
                    technique.as_responseDossierXvm(battlesType, vehicles);
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

        public function as_responseVehicleDossierXvm(data:Object):void
        {
            if (_baseDisposed)
                return;

            try
            {
                var vdossier:VehicleDossier = new VehicleDossier(data);
                if (vdossier != null)
                {
                    Dossier.setVehicleDossier(vdossier);
                    if (technique)
                        technique.as_responseVehicleDossierXvm(vdossier);
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }
    }
}
