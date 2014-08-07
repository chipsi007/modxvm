import com.xvm.*;
import wot.BattleMessenger.*;
import wot.BattleMessenger.Antispam.*;
import wot.BattleMessenger.models.*;


/**
 * XVM BattleMessenger module
 * @author Pavel Máca
 * @author Mikhail Paulyshka mixail(at)modxvm.com
 */
class wot.BattleMessenger.BattleMessenger
{   
    /////////////////////////////////////////////////////////////////
    // wrapped methods

    public var wrapper:net.wargaming.messenger.BattleMessenger;
    public var base:net.wargaming.messenger.BattleMessenger;

    public function BattleMessenger(wrapper:net.wargaming.messenger.BattleMessenger, base:net.wargaming.messenger.BattleMessenger) {
        Logger.add("BattleMessenger()");
        this.wrapper = wrapper;
        this.base = base;
        BattleMessengerCtor();
    }

    function _onPopulateUI() {
        Logger.add("_onPopulateUI()");
        return this._onPopulateUIImpl.apply(this, arguments);
    }
    
    function _onRecieveChannelMessage(cid:Number, message:String, himself:Boolean, targetIsCurrentPlayer:Boolean) {
        Logger.add("_onRecieveChannelMessage()");
        return this._onRecieveChannelMessageImpl.apply(this, arguments);
    }

    // wrapped methods
    /////////////////////////////////////////////////////////////////

    public function BattleMessengerCtor() {
        Logger.add("BattleMessengerCtor()");
        Utils.TraceXvmModule("BattleMessenger");
        GlobalEventDispatcher.addEventListener(Defines.E_CONFIG_LOADED, this, onConfigLoaded);
    }

    //Impl
    function _onPopulateUIImpl() {
        Logger.add("_onPopulateUIImpl()");
        this.onGuiInit();
    }

    //Impl
    function _onRecieveChannelMessageImpl(cid:Number, message:String, himself:Boolean, targetIsCurrentPlayer:Boolean)
    {
        Logger.add("_onRecieveChannelMessageImpl()");
        //var timer:Number = getTimer();
        var displayMsg:Boolean = (Config.config.battleMessenger.enabled ? getDisplayStatus(message, himself) : true);
        //Logger.add("timer: " +(getTimer() - timer));
        
        /** Edit message for debug mode */
        if (Config.config.battleMessenger.enabled && Config.config.battleMessenger.debugMode) {
            var log:Object = { 
                msg: message,
                display: displayMsg
            };

            if(!displayMsg){
                message = "<font color='" + DEBUG_COLOR + "'>Hidden: </font>" + message;
            }
            /** add reason, can be also "ignored for xx" */
            var reason:String = popReason();
            if (reason != null) {
                message += "\n<font color='" + DEBUG_COLOR + "'>" + reason + "</font>";

                log.reason = reason;
                Logger.add("[BattleMessenger]");
            }
        base._onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer);
        }

        /** Send message to render */
        if (displayMsg || (Config.config.battleMessenger.enabled && Config.config.battleMessenger.debugMode)) { 
            super._onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer);
        }
    }

    /////////////////////////////////////////////////////////////////
    // own methods

    public static var DEBUG_COLOR:String = "#FF3362";
    private var battleType:String;
    private var self:Player; // Store own identity
    private var antispam:Antispam;
    private var lastReason:String = null;

    private function onConfigLoaded() {
        Logger.add("onConfigLoaded()");
        if(Config.config.battleMessenger.antispam.enabled)
            this.antispam = new Antispam();
    }

    public function onGuiInit() {
        Logger.add("onGuiInit()");
        if(Config.config.battleMessenger.enabled){
            /**
             * this.messageList = child of net.wargaming.notification.FadingMessageList
             * this.messageList.stackLength not working, need _stackLength
             */
            this.base.messageList._stackLength = Config.config.battleMessenger.chatLength;
            this.self = StatsDataProxy.getSelf();
            if (!this.self) {
                this.sendDebugMessage("Error: can't found own identity");
                Logger.add("Error: can't found own identity");
            }

            if(Config.config.battleMessenger.antispam.enabled) {
                /** Ignore player and vehicle names */
                this.antispam.createIgnoreList();
            }

            /** Get battle type */
            battleType = StatsDataProxy.getBattleType();

            /** Debug mode info */
            this.sendDebugMessage("Debug mode active, " + battleType + " battle");

        }
    }

    public function getDisplayStatus(message:String, himself:Boolean):Boolean {
        Logger.add("getDisplayStatus()");
        /** ignore own msg (not in debug mode)*/
        if (!this.self || (himself && !Config.config.battleMessenger.debugMode)) {
            return true;
        }

        /** sender */
        var sender:Player;

        /**
         * split message in two parts
         * [0]: player name, clan, vehicle
         * [1]: content
         */
        var pattern1 = "&nbsp;: </font>";
        var pattern2 = "&nbsp;:&nbsp;</font>";

        var msgParts:Array;
        if (message.indexOf(pattern1) >= 0) {
            msgParts = message.split(pattern1, 2);
        }else if (message.indexOf(pattern2) >= 0) {
            msgParts = message.split(pattern2, 2);
        }else {
            this.sendDebugMessage("Error: unsupported message format");
            return true; //error
        }

        if (msgParts.length == 2) {
            sender = this.getPlayerFromMessage(msgParts[0]);
        }

        if (!sender) {
            this.sendDebugMessage("Error: can't parse sender identity");
            return true; //error
        }
        /** /split */

        /** Ignore */
        if ( ignoreForClan(sender) && !himself ) {
            this.lastReason = "Ignore: own clan";
            return true;
        }
        if ( ignoreForSquad(sender) && !himself) {
            this.lastReason = "Ignore: own squad";
            return true;
        }

        /** Ignore by battle type, skip self */
        if (isSameTeam(sender) && !himself) {
            switch(battleType) {
                case StatsDataProxy.BATTLE_RANDOM:
                    if (Config.config.battleMessenger.ignore.RandomBattle) {
                        this.lastReason = "Ignore: ally in Random battle";
                        return true;
                    } break;
                case StatsDataProxy.BATTLE_COMPANY:
                case StatsDataProxy.BATTLE_TEAM_7x7:
                    if (Config.config.battleMessenger.ignore.CompanyBattle) {
                        this.lastReason = "Ignore: ally in Company battle";
                        return true;
                    } break;
                case StatsDataProxy.BATTLE_SPECIAL:
                    if (Config.config.battleMessenger.ignore.SpecialBattle) {
                        this.lastReason = "Ignore: ally in Special battle";
                        return true;
                    } break;
                case StatsDataProxy.BATTLE_TRAINING:
                    if (Config.config.battleMessenger.ignore.TrainingBattle) {
                        this.lastReason = "Ignore: ally in Training battle";
                        return true;
                    } break;
            }
        }

        /** XVM */
        if (Config.config.battleMessenger.enableRatingFilter && Config.config.ratings.showPlayersStatistics && !isXvmRatingHigher(sender) ) return false;

        /** Dead/Alive */
        if ( isTeamStatusBlock(sender) ) return false;

        /** Antispam */
        if (Config.config.battleMessenger.antispam.enabled) {
            /** Spam */
            if (this.antispam.isSpam(msgParts[1], sender.uid)) {
                lastReason = this.antispam.popLastSpam();
                return false;
            }

            /** Filters */
            if (this.antispam.isFilter(msgParts[1])) {
                lastReason = this.antispam.popLastFilter();
                return false;
            }
        }

        return true;
    }

    /**
     * @return  null on empty reason
     */
    public function popReason():String {
        Logger.add("popReason()");
        var ret = this.lastReason;;
        this.lastReason = null;
        return ret;
    }

    private function sendDebugMessage(text:String, ignoreDebugMode:Boolean) {
        Logger.add("sendDebugMessage()");
        if (Config.config.battleMessenger.enabled && (Config.config.battleMessenger.debugMode || ignoreDebugMode) && text.length > 0) {
            Logger.add("[BattleMessenger] " + text);
            base._onRecieveChannelMessage(null, "<font color='" + DEBUG_COLOR + "'>" + text + "</font>", true, false);
        }
    }

    /** <font color='#FFC697'>UserName[clan] (vehicle) */
    private function getPlayerFromMessage(message:String):Player {
        Logger.add("getPlayerFromMessage()");
        var endOfFirtsTag:Number = message.indexOf(">");
        var messageWitOutFirstTag:String = message.substr(endOfFirtsTag + 1, message.length - endOfFirtsTag);
        var endOfUsername:Number = messageWitOutFirstTag.indexOf(" ");

        var userName:String = messageWitOutFirstTag.substr(0, endOfUsername);

        /** remove clan tag - not needed since 0.8.9 */
        userName = Utils.GetPlayerName(userName);

        return StatsDataProxy.getPlayerByName(userName);
    }

    /**
     * @param   player
     * @return  true when player is from same clan, always false on own messages
     */
    private function ignoreForClan(player:Player):Boolean {
        Logger.add("ignoreForClan()");
        if (Config.config.battleMessenger.ignore.Clan && this.self.clanAbbrev.length > 0) {
            return (player.clanAbbrev == this.self.clanAbbrev);
        }
        return false;
    }

    /**
     * @param   player
     * @return  true when player is from same squad, always false on own messages
     */
    private function ignoreForSquad(player:Player):Boolean {
        Logger.add("ignoreForSquad()");
        if (Config.config.battleMessenger.ignore.Squad && self.squad != 0) {
            return (player.squad == this.self.squad);
        }
        return false;
    }

    private function isXvmRatingHigher(player:Player):Boolean {
        Logger.add("isXvmRatingHigher()");
        if (!com.xvm.Stat) {
            this.sendDebugMessage("Stats off");
            return true;
        }

        var xvmKey:String = com.xvm.Utils.GetPlayerName(player.userName);
        /** check if data are presend */
        if (Config.config.battleMessenger.enableRatingFilter && Config.config.ratings.showPlayersStatistics && com.xvm.Stat.s_data[xvmKey]) 
        {
            /** stats must be loaded */
            if (com.xvm.Stat.s_data[xvmKey].loadstate == com.xvm.Defines.LOADSTATE_DONE) 
            {
                if (com.xvm.Stat.s_data[xvmKey].stat.wn8 < Config.config.battleMessenger.minRating) 
                {
                    this.lastReason = "XVM rating: " + com.xvm.Stat.s_data[xvmKey].stat.wn8;
                    return false;
                }
            }
            else 
            {
                this.sendDebugMessage("XVM data not loaded");
            }
        }
        else if (Config.config.battleMessenger.enableRatingFilter && Config.config.ratings.showPlayersStatistics) 
        {
            this.sendDebugMessage("XVM data not found: " + xvmKey);
        }
        return true;
    }
    
    /**
     * Check player team and alive status against config
     * @param   player
     * @return  true for hide msg, false for display
     */
    private function isTeamStatusBlock(player:Player):Boolean {
        Logger.add("isTeamStatusBlock()");
        var isDead:Boolean = StatsDataProxy.isPlayerDead(player.uid);
        var hide:Boolean;

        if (isSameTeam(player)) 
        {
            hide = (isDead ? Config.config.battleMessenger.blockAlly.Dead : Config.config.battleMessenger.blockAlly.Alive);
        }else 
        {
            hide = (isDead ? Config.config.battleMessenger.blockEnemy.Dead : Config.config.battleMessenger.blockEnemy.Alive);
        }

        if (hide) 
        {
            lastReason = (isSameTeam(player) ? "Ally" : "Enemy") + " - " + (isDead ? "dead" : "alive");
        }
        return hide;
    }

    private function isSameTeam(player:Player):Boolean {
        Logger.add("isSameTeam()");
        return (self.team == player.team);
    }
}