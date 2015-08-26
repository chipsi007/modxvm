import com.xvm.Wrapper;

class wot.wrapper.BattleMessenger.BattleMessageRenderer extends net.wargaming.messenger.controls.BattleMessageRenderer
{
    function BattleMessageRenderer()
    {
        super();

        var OVERRIDE_FUNCTIONS:Array = [
            "populateData"
        ];
        Wrapper.override(this, new wot.BattleMessenger.BattleMessageRenderer(this, super), OVERRIDE_FUNCTIONS);
    }
}
