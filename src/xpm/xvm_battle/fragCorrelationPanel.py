""" XVM (c) www.modxvm.com 2013-2016 """

#####################################################################
# imports

import traceback

import BigWorld
import game
from Avatar import PlayerAvatar
from gui import g_guiResetters
from gui.shared import g_eventBus
from gui.Scaleform.daapi.view.battle import score_panel
from gui.Scaleform.daapi.view.battle.markers import MarkersManager
from gui.battle_control import g_sessionProvider
from gui.battle_control.battle_constants import FEEDBACK_EVENT_ID

from xfw import *

from xvm_main.python.constants import *
from xvm_main.python.logger import *
from xvm_main.python.xvm import Xvm as xvm_class
from xvm_main.python import config

#####################################################################
# initialization/finalization

def start():
    g_eventBus.addListener(XVM_EVENT.RELOAD_CONFIG, update_conf_hp)
    update_conf_hp()

BigWorld.callback(0, start)

@registerEvent(game, 'fini')
def fini():
    g_eventBus.removeListener(XVM_EVENT.RELOAD_CONFIG, update_conf_hp)

#####################################################################
# globals
teams_vehicles = [{}, {}]
teams_totalhp = [0, 0]
hp_colors = {}

total_hp_color = None
total_hp_sign = None

#####################################################################
# handlers

# show quantity of alive instead of dead in frags panel
# original idea/code by yaotzinv: http://forum.worldoftanks.ru/index.php?/topic/1339762-
@overrideMethod(score_panel._FragCorrelationPanel, 'updateScore')
def FragCorrelationPanel_updateScore(base, self):
    try:
        if config.get('fragCorrelation/showAliveNotFrags'):
            if len(self._FragCorrelationPanel__teamsDeaths) and len(self._FragCorrelationPanel__teamsShortLists):
                isTeamEnemy = g_sessionProvider.getArenaDP().isEnemyTeam
                ally_frags, enemy_frags, ally_vehicles, enemy_vehicles  = (0, 0, 0, 0)
                for teamIdx, vehs in self._FragCorrelationPanel__teamsShortLists.iteritems():
                    if isTeamEnemy(teamIdx):
                        enemy_vehicles += len(vehs)
                    else:
                        ally_vehicles += len(vehs)
                for teamIdx, score in self._FragCorrelationPanel__teamsDeaths.iteritems():
                    if isTeamEnemy(teamIdx):
                        ally_frags += score
                    else:
                        enemy_frags += score
            team_left = ally_vehicles - enemy_frags
            enemy_left = enemy_vehicles - ally_frags
            self._FragCorrelationPanel__callFlash('updateFrags', [team_left, enemy_left])
            return
    except Exception, ex:
        err(traceback.format_exc())
    base(self)


@registerEvent(score_panel._FragCorrelationPanel, 'populate')
def populate_hp(*args, **kwargs):
    try:
        feedback = g_sessionProvider.getFeedback()
        if feedback is not None:
            feedback.onVehicleFeedbackReceived += onVehicleFeedbackReceived
        g_guiResetters.add(update_conf_hp)
    except Exception, ex:
        err(traceback.format_exc())

@registerEvent(score_panel._FragCorrelationPanel, 'destroy')
def destroy_hp(*args, **kwargs):
    try:
        feedback = g_sessionProvider.getFeedback()
        if feedback is not None:
            feedback.onVehicleFeedbackReceived -= onVehicleFeedbackReceived
        g_guiResetters.discard(update_conf_hp)
        teams_vehicles[:] = [{}, {}]
        teams_totalhp[:] = [0, 0]
    except Exception, ex:
        err(traceback.format_exc())

def update_conf_hp(*args, **kwargs):
    try:
        hp_colors.update({'bad': 'FF0000', 'neutral': 'FFFFFF', 'good': '00FF00'})
        hp_colors.update(config.get('colors/totalHP', {}))
        for type, color in hp_colors.iteritems():
            color = color[-6:]
            hp_colors[type] = {'red': int(color[0:2], 16), 'green' : int(color[2:4], 16), 'blue': int(color[4:6], 16)}
    except Exception, ex:
        err(traceback.format_exc())

@registerEvent(xvm_class, '_onVehicleKilled')
def xvm_onVehicleKilled(self, vID, *args, **kwargs):
    try:
        update_hp(vID, 0)
    except Exception, ex:
        err(traceback.format_exc())

@registerEvent(PlayerAvatar, 'updateVehicleHealth')
def setVehicleNewHealth(self, vehicleID, health, *args, **kwargs):
    try:
        update_hp(vehicleID, health)
    except Exception, ex:
        err(traceback.format_exc())

@registerEvent(xvm_class, 'initBattleSwf')
def initBattleSwf(self, *args, **kwargs):
    try:
        for vID, vData in BigWorld.player().arena.vehicles.iteritems():
            update_hp(vID, vData['vehicleType'].maxHealth)
    except Exception, ex:
        err(traceback.format_exc())

@registerEvent(MarkersManager, 'addVehicleMarker')
def addVehicleMarker(self, vProxy, *args, **kwargs):
    try:
        update_hp(vProxy.id, vProxy.health)
    except Exception, ex:
        err(traceback.format_exc())

def onVehicleFeedbackReceived(eventID, vehicleID, value, *args, **kwargs):
    try:
        if eventID == FEEDBACK_EVENT_ID.VEHICLE_HEALTH:
            update_hp(vehicleID, value[0])
        elif eventID == FEEDBACK_EVENT_ID.VEHICLE_DEAD:
            update_hp(vehicleID, 0)
    except Exception, ex:
        err(traceback.format_exc())

def color_gradient(color1, color2, ratio):
    try:
        ratio_comp = 1.0 - ratio
        return '%0.2X%0.2X%0.2X' % (
                color1['red'] * ratio + color2['red'] * ratio_comp,
                color1['green'] * ratio + color2['green'] * ratio_comp,
                color1['blue'] * ratio + color2['blue'] * ratio_comp,
                )
    except Exception, ex:
        err(traceback.format_exc())
        return 'FFFFFF'

def update_hp(vID, hp, *args, **kwargs):
    try:
        if BigWorld.player().team == BigWorld.player().arena.vehicles[vID]['team']:
            team = 0
        else:
            team = 1

        global teams_vehicles, teams_totalhp, total_hp_color, total_hp_sign

        teams_vehicles[team][vID] = max(hp, 0)
        teams_totalhp[team] = sum(teams_vehicles[team].values())
    
        if teams_totalhp[0] < teams_totalhp[1]:
            ratio = max(min(2.0 * teams_totalhp[0] / teams_totalhp[1] - 0.9, 1), 0)
            total_hp_color = color_gradient(hp_colors['neutral'], hp_colors['bad'], ratio)
            total_hp_sign = '<'
        elif teams_totalhp[0] > teams_totalhp[1]:
            ratio = max(min(2.0 * teams_totalhp[1] / teams_totalhp[0] - 0.9, 1), 0)
            total_hp_color = color_gradient(hp_colors['neutral'], hp_colors['good'], ratio)
            total_hp_sign = '>'
        else:
            total_hp_color = color_gradient(hp_colors['neutral'], hp_colors['neutral'], 1)
            total_hp_sign = '='

        battle = getBattleApp()
        if battle:
            movie = battle.movie
            if movie is not None:
                movie.as_xvm_onPlayersHpChanged()
    except Exception, ex:
        err(traceback.format_exc())
