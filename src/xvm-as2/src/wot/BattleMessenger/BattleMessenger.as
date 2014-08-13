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
        Logger.add("[AS2][BattleMessenger/BattleMessenger]BattleMessenger()");
        this.wrapper = wrapper;
        this.base = base;
        BattleMessengerCtor();
    }

    function _onPopulateUI() {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]_onPopulateUI()");
        return this._onPopulateUIImpl.apply(this, arguments);
    }
    
    function _onRecieveChannelMessage(cid:Number, message:String, himself:Boolean, targetIsCurrentPlayer:Boolean) {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]_onRecieveChannelMessage()");
        return this._onRecieveChannelMessageImpl.apply(this, arguments);
    }

    // wrapped methods
    /////////////////////////////////////////////////////////////////

    //Ctor
    public function BattleMessengerCtor() {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]BattleMessengerCtor()");
        Utils.TraceXvmModule("BattleMessenger");
        GlobalEventDispatcher.addEventListener(Defines.E_CONFIG_LOADED, this, onConfigLoaded);
    }

    //Impl
    function _onPopulateUIImpl() {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]_onPopulateUIImpl()");
        if(Config.config.battleMessenger.enabled){
            this.wrapper.messageList._stackLength = Config.config.battleMessenger.chatLength;
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

    //Impl
    function _onRecieveChannelMessageImpl(cid:Number, message:String, himself:Boolean, targetIsCurrentPlayer:Boolean)
    {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]_onRecieveChannelMessageImpl()");
        var displayMsg:Boolean = (Config.config.battleMessenger.enabled ? getDisplayStatus(message, himself) : true);
        
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
                Logger.addObject(log, 1, "[BattleMessenger]");
            }
        }

        /** Send message to render */
        if (displayMsg || (Config.config.battleMessenger.enabled && Config.config.battleMessenger.debugMode)) { 
            base._onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer);
        }
    }

    /////////////////////////////////////////////////////////////////
    // own methods

    public static var DEBUG_COLOR:String = "#FF3362";
    private var battleType:String;
    private var self:Player; // Store own identity
    private var antispam:Antispam;
    private var lastReason:String = null;

    /**
     * Perform actions after XVM config load.
     */
    private function onConfigLoaded() {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]onConfigLoaded()");
        if(Config.config.battleMessenger.antispam.enabled)
            this.antispam = new Antispam();
    }

    /**
     * Returns decision about message: show it or hide it.
     * @param message   message text    
     * @param himself   true if message from player, false if message from ally or enemy
     * @return  true if message should be show, false if message should be hide.
     */
    public function getDisplayStatus(message:String, himself:Boolean):Boolean {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]getDisplayStatus()");

        /** ignore own msg (not in debug mode)*/
        if (himself && !Config.config.battleMessenger.debugMode)
            return true;

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

        /** try to block */
        if (blocker(sender, true))
            return false;

        /** check for filtering */
        if (!blocker(sender, false))
            return true;

        /** Block by rating */
        if (Config.config.battleMessenger.ratingFilters.enabled && Config.config.rating.showPlayersStatistics && !isPlayerRatingHigher(sender)) {
            return false;
        }

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
     * Check if we should block/filtet player by block/filter section in config
     * @param   player
     * @param   block true if we decide to block, false if we check to filter
     * @return  true for blocking/filtering situation, false if player is clean
     */
    private function blocker(player:Player, block:Boolean):Boolean {
        var toBlock:Boolean = false;
        //By battle type
        switch(battleType) {
            case StatsDataProxy.BATTLE_RANDOM:
                toBlock = blockerHelper(player, "battleMessenger.BLOCKORFILTER.ALLYORENEMY.randomBattle", "DECISION: ALLYORENEMY in random battle", block)
                break;
            case StatsDataProxy.BATTLE_COMPANY:
            case StatsDataProxy.BATTLE_TEAM_7x7:
                toBlock = blockerHelper(player, "battleMessenger.BLOCKORFILTER.ALLYORENEMY.companyBattle", "DECISION: ALLYORENEMY in company battle", block)
                break;
            case StatsDataProxy.BATTLE_SPECIAL:
                toBlock = blockerHelper(player, "battleMessenger.BLOCKORFILTER.ALLYORENEMY.specialBattle", "DECISION: ALLYORENEMY in special battle", block)
                break;
            case StatsDataProxy.BATTLE_TRAINING:
                toBlock = blockerHelper(player, "battleMessenger.BLOCKORFILTER.ALLYORENEMY.trainingBattle", "DECISION: ALLYORENEMY in training battle", block)
                break;
        }
        
        //By clan
        if (isPlayerInClan(player) && !toBlock) {
            toBlock = blockerHelper(player, "battleMessenger.BLOCKORFILTER.ourClan", "DECISION: In our clan", block);
        }

        //By squad
        if (isPlayerInSquad(player) && !toBlock) {
            toBlock = blockerHelper(player, "battleMessenger.BLOCKORFILTER.ourSquad", "DECISION: In our squad", block);
        }
        
        this.sendDebugMessage("blocker, Block mode:"+block+", Decision:"+toBlock, false)
        return toBlock;
    }
    
    /**
     * Helper function to blocker function
     * @param player
     * @param type name of config section, none/alive/dead/all
     * @param reason reason of blocking
     * @param block true if we decide to block, false if we check to filter
     * @return  true for blocking/filteting situation, false if player is clean
     */
    private function blockerHelper(player:Player, type:String, reason:String, block:Boolean) {
        var dead:Boolean = StatsDataProxy.isPlayerDead(player.uid);
        var toBlock = false;

        if (isPlayerInAllyTeam(player)){
            reason = Utils.strReplace(reason, "ALLYORENEMY", "ally");
            type = Utils.strReplace(type, "ALLYORENEMY", "ally");
        } else {
            reason = Utils.strReplace(reason, "ALLYORENEMY", "enemy");
            type = Utils.strReplace(type, "ALLYORENEMY", "enemy");
        }
        
        if (block){
            reason = Utils.strReplace(reason, "BLOCKORFILTER", "block");
            type = Utils.strReplace(type, "BLOCKORFILTER", "block");
        } else {
            reason = Utils.strReplace(reason, "BLOCKORFILTER", "filter");
            type = Utils.strReplace(type, "BLOCKORFILTER", "filter");
        }

        type = String(Utils.getObjectProperty(Config.config, type));

        if ( type == "none") { toBlock = false; }
        else if (type == "all") { toBlock = true;  }
        else if (type == "alive" && !dead) { toBlock = true;  }
        else if (type == "dead"  && dead) { toBlock = true;  }
        else { toBlock = false; }

        if (toBlock && block)
            reason = Utils.strReplace(reason, "DECISION", "Block");
        else if (toBlock && !block)
            reason = Utils.strReplace(reason, "DECISION", "Apply filters");
        else
            reason = Utils.strReplace(reason, "DECISION", "Clear");
            
        this.lastReason = reason; 
        return toBlock;
    }
        
    /**
     * Returns last block reason.
     * @return  null on empty reason
     */
    public function popReason():String {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]popReason()");
        var ret = this.lastReason;
        this.lastReason = null;
        return ret;
    }

    /**
     * Write debug message to chat and xvm.log
     * @param   text text to write
     * @param   ignoreDebugMode true if we should ignore battleMessenger.debugMode setting.
     */
    public function sendDebugMessage(text:String, ignoreDebugMode:Boolean) {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]sendDebugMessage()");
        if (Config.config.battleMessenger.enabled && (Config.config.battleMessenger.debugMode || ignoreDebugMode) && text.length > 0) {
            Logger.add(text);
            base._onRecieveChannelMessage(null, "<font color='" + DEBUG_COLOR + "'>" + text + "</font>", true, false);
        }
    }

    /**
     * Returns player name from chat message string
     * @param message   chat message with player name
     * @return player name
     */
    private function getPlayerFromMessage(message:String):Player {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]getPlayerFromMessage()");
        var endOfFirtsTag:Number = message.indexOf(">");
        var messageWitOutFirstTag:String = message.substr(endOfFirtsTag + 1, message.length - endOfFirtsTag);
        var endOfUsername:Number = messageWitOutFirstTag.indexOf(" ");

        var userName:String = messageWitOutFirstTag.substr(0, endOfUsername);

        /** remove clan tag - not needed since 0.8.9 */
        userName = Utils.GetPlayerName(userName);

        return StatsDataProxy.getPlayerByName(userName);
    }
    
    /**
     * Check player team and return in what team player ally or enemy
     * @param   player
     * @return  true for ally team, false for enemy team
     */
    private function isPlayerInAllyTeam(player:Player):Boolean {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]isPlayerInAllyTeam()");
        return (self.team == player.team);
    }
    
    /**
     * @param   player
     * @return  true when player is from same clan, always false on own messages
     */
    private function isPlayerInClan(player:Player):Boolean {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]isPlayerInClan()");
        if (Config.config.battleMessenger.ignore.clan && this.self.clanAbbrev.length > 0) {
            return (player.clanAbbrev == this.self.clanAbbrev);
        }
        return false;
    }

    /**
     * @param   player
     * @return  true when player is from same squad, always false on own messages
     */
    private function isPlayerInSquad(player:Player):Boolean {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]isPlayerInSquad()");
        if (Config.config.battleMessenger.ignore.squad && self.squad != 0) {
            return (player.squad == this.self.squad);
        }
        return false;
    }

    /**
     * Check player rating and compare it with minRating in config
     * @param   player
     * @return  true for player.rating > minRating, false for <
     */
    private function isPlayerRatingHigher(player:Player):Boolean {
        Logger.add("[AS2][BattleMessenger/BattleMessenger]isPlayerRatingHigher()");

        var xvmKey:String = com.xvm.Utils.GetPlayerName(player.userName);
        /** check if data are presend */
        if (Stat.s_data[xvmKey]) {
            //this.sendDebugMessage("Player:"+xvmKey+"| Rating:"+Stat.s_data[xvmKey].stat.wn8+"| minRating:"+Config.config.battleMessenger.ratingFilters.minWN8);
            /** stats must be loaded */
            if (Stat.s_data[xvmKey].loadstate == Defines.LOADSTATE_DONE) 
            {
                this.lastReason = "Rating";
                if ((Stat.s_data[xvmKey].stat.r    < Config.config.battleMessenger.ratingFilters.minWinRate) ||
                    (Stat.s_data[xvmKey].stat.e    < Config.config.battleMessenger.ratingFilters.minEFF)     ||
                    (Stat.s_data[xvmKey].stat.xeff < Config.config.battleMessenger.ratingFilters.minXEFF)    ||
                    (Stat.s_data[xvmKey].stat.wn6  < Config.config.battleMessenger.ratingFilters.minWN6)     ||
                    (Stat.s_data[xvmKey].stat.xwn6 < Config.config.battleMessenger.ratingFilters.minXWN6)    ||
                    (Stat.s_data[xvmKey].stat.wn8  < Config.config.battleMessenger.ratingFilters.minWN8)     ||
                    (Stat.s_data[xvmKey].stat.xwn8 < Config.config.battleMessenger.ratingFilters.minXWN8)    ||
                    (Stat.s_data[xvmKey].stat.wgr  < Config.config.battleMessenger.ratingFilters.minWGR)     ||
                    (Stat.s_data[xvmKey].stat.xwgr < Config.config.battleMessenger.ratingFilters.minXWGR))
                    return false;
            } else {
                this.sendDebugMessage("Rating data not loaded");
            }
        } else {
            this.sendDebugMessage("Rating data not found: " + xvmKey);
        }
        return true;
    }
}