import com.xvm.Wrapper;

class wot.wrapper.BattleMessenger.BattleMessenger extends net.wargaming.messenger.BattleMessenger
{
    function BattleMessenger()
    {
        super();

        var OVERRIDE_FUNCTIONS:Array = [
            "_onPopulateUI",
            "_onRecieveChannelMessage"
        ];
        Wrapper.override(this, new wot.BattleMessenger.BattleMessenger(this, super), OVERRIDE_FUNCTIONS);
    }
}
