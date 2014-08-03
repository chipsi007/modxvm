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

    public function BattleMessageRenderer(wrapper:net.wargaming.messenger.controls.BattleMessageRenderer, base:net.wargaming.messenger.controls.BattleMessageRenderer)
    {
        Logger.add("BattleMessageRenderer()");
        this.wrapper = wrapper;
        this.base = base;
        BattleMessageRendererCtor();
    }

    function populateData(initData)
    {
        Logger.add("populateData()");
        return this.populateDataImpl.apply(this, arguments);
    }   

    // wrapped methods
    /////////////////////////////////////////////////////////////////
    
    //Ctor
    public function BattleMessageRendererCtor() {
        Logger.add("BattleMessageRendererCtor()");
        Utils.TraceXvmModule("BattleMessenger");
    }

    //Impl
    function populateDataImpl(initData)
    {   
        Logger.add("populateDataImpl()");

        //FIXME: I don't known what is the right strings
        this.wrapper.background._alpha = Config.config.battleMessenger.backgroundAlpha;
        this.wrapper._lifeTime = Config.config.battleMessenger.messageLifeTime;
        this.base.background._alpha = Config.config.battleMessenger.backgroundAlpha;
        this.base._lifeTime = Config.config.battleMessenger.messageLifeTime;
        base.background._alpha = Config.config.battleMessenger.backgroundAlpha;
        base._lifeTime = Config.config.battleMessenger.messageLifeTime;

        this.base.populateData(initData);
    }
}