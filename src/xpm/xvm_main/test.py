""" XVM (c) https://modxvm.com 2013-2018 """

#############################
# Command

def onHangarInit():
    # debug
    if IS_DEVELOPMENT:

        import glob
        files = glob.glob("[0-9]*.dat")
        if files:
            for fn in files:
                log('[TEST]  battle result: {}'.format(fn))
                runTest(('battleResults', fn))

        #import gui.awards.event_dispatcher as shared_events
        #from helpers import dependency
        #from skeletons.gui.goodies import IGoodiesCache
        #goodiesCache = dependency.instance(IGoodiesCache)
        #shared_events.showBoosterAward(goodiesCache.getBooster(5022))


def runTest(args):
    if args is not None:
        cmd = args[0]
        if cmd == 'battleResults':
            _showBattleResults(int(args[1][:-4]))


#############################
# imports

import os
import cPickle
import traceback

import AccountCommands
from account_helpers import BattleResultsCache
from helpers import dependency
from gui.shared.utils import decorators
from gui.battle_results import RequestResultsContext
from skeletons.gui.battle_results import IBattleResultsService

from xfw import *

from logger import *


#############################
# BattleResults

@decorators.process('loadStats')
def _showBattleResults(arenaUniqueID):
    battleResults = dependency.instance(IBattleResultsService)
    ctx = RequestResultsContext(arenaUniqueID, showImmediately=False, showIfPosted=True, resetCache=False)
    yield battleResults.requestResults(ctx)

#@decorators.process('loadStats')
#def _showWindow(self, notification, arenaUniqueID):
#    uniqueID = long(arenaUniqueID)
#    result = yield self.battleResults.requestResults(RequestResultsContext(uniqueID, showImmediately=False, showIfPosted=True, resetCache=False))
#    if not result:
#        self._updateNotification(notification)

@overrideMethod(BattleResultsCache.BattleResultsCache, 'get')
def BattleResultsCache_get(base, self, arenaUniqueID, callback):
    fileHandler = None
    try:
        #log('get: ' + str(callback))
        filename = '{0}.dat'.format(arenaUniqueID)
        if not os.path.exists(filename):
            base(self, arenaUniqueID, callback)
        else:
            fileHandler = open(filename, 'rb')
            version, battleResults = cPickle.load(fileHandler)
            if battleResults is not None:
                if callback is not None:
                    #log('callback: ' + str(callback))
                    callback(AccountCommands.RES_CACHE, BattleResultsCache.convertToFullForm(battleResults))
    except Exception, ex:
        err(traceback.format_exc())
        base(self, arenaUniqueID, callback)

    if fileHandler is not None:
        fileHandler.close()
