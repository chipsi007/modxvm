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

    private var c_backgroundAlpha:Number = 0;
    private var c_messageLifeTime:Number = 0;

    public function BattleMessageRenderer(wrapper:net.wargaming.messenger.controls.BattleMessageRenderer, base:net.wargaming.messenger.controls.BattleMessageRenderer) {
        //Logger.add("[AS2][BattleMessenger/BattleMessageRenderer]BattleMessageRenderer()");
        this.wrapper = wrapper;
        this.base = base;
        BattleMessageRendererCtor();
    }

    function populateData(initData) {
        //Logger.add("[AS2][BattleMessenger/BattleMessageRenderer]populateData()");
        return this.populateDataImpl.apply(this, arguments);
    }

    // wrapped methods
    /////////////////////////////////////////////////////////////////

    public function BattleMessageRendererCtor() {
        //Logger.add("[AS2][BattleMessenger/BattleMessageRenderer]BattleMessageRendererCtor()");
        Utils.TraceXvmModule("BattleMessenger");

        c_backgroundAlpha = Config.config.battleMessenger.backgroundAlpha;
        c_messageLifeTime = Config.config.battleMessenger.messageLifeTime;
    }

    //Impl
    function populateDataImpl(initData) {
        //Logger.add("[AS2][BattleMessenger/BattleMessageRenderer]populateDataImpl()");
        wrapper.background._alpha = c_backgroundAlpha;
        wrapper._lifeTime = c_messageLifeTime;

        base.populateData(initData);
    }
}