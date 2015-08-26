import com.xvm.*;
import wot.BattleMessenger.*;

/**
 * XVM BattleMessenger module
 * @author Pavel Máca
 * @author Mikhail Paulyshka mixail(at)modxvm.com
 */
class wot.BattleMessenger.BattleMessageRenderer
{
    /////////////////////////////////////////////////////////////////
    // wrapped methods
    private var wrapper:net.wargaming.messenger.controls.BattleMessageRenderer;
    private var base:net.wargaming.messenger.controls.BattleMessageRenderer;

    public function BattleMessageRenderer(wrapper:net.wargaming.messenger.controls.BattleMessageRenderer, base:net.wargaming.messenger.controls.BattleMessageRenderer) {
        this.wrapper = wrapper;
        this.base = base;
        BattleMessageRendererCtor();
    }

    function populateData(initData) {
        return this.populateDataImpl.apply(this, arguments);
    }

    // wrapped methods
    /////////////////////////////////////////////////////////////////

    public function BattleMessageRendererCtor() {
        Utils.TraceXvmModule("BattleMessenger");
    }

    //Impl
    function populateDataImpl(initData) {
		if (Config.config.battleMessenger.enabled)
		{
			wrapper._alpha = Config.config.battleMessenger.backgroundAlpha;
			wrapper._lifeTime = Config.config.battleMessenger.messageLifeTime;
		}
        base.populateData(initData);
    }
}