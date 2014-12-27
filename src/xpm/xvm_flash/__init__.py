""" XVM (c) www.modxvm.com 2013-2014 """

#####################################################################
# MOD INFO (mandatory)

XPM_MOD_VERSION    = "1.6.1"
XPM_MOD_URL        = "http://www.modxvm.com/"
XPM_MOD_UPDATE_URL = "http://www.modxvm.com/en/download-xvm/"
XPM_GAME_VERSIONS  = ["0.9.5"]

#####################################################################
# SWF mods initializer

import ResMgr
from xpm import *
from gui.shared import events
from gui import SystemMessages

XPM_CMD = 'xpm.cmd'

g_xvmView = None

# FIXME: code duplication from xpm/__init__.py#14
wd = None
sec = ResMgr.openSection('../paths.xml')
subsec = sec['Paths']
vals = subsec.values()
for val in vals:
    path = val.asString + '/scripts/client/gui/mods'
    if os.path.isdir(path) and os.path.isfile(path + '/lib/xpm.pyc'):
        wd = path
        break

_xvm_swf_file_name = os.path.join(wd, '../../../../../xvm/mods/xvm.swf')
_xvm_config_dir_name = os.path.join(wd, '../../../../../xvm/configs')

if os.path.isfile(_xvm_swf_file_name):

    _XVM_MODS_DIR = "res_mods/xvm/mods"
    _XVM_VIEW_ALIAS = 'xvm'
    _XVM_SWF_URL = '../../../xvm/mods/xvm.swf'

    _XPM_COMMAND_GETMODS = "xpm.getMods"
    _XPM_COMMAND_INITIALIZED = "xpm.initialized"
    _XPM_COMMAND_LOADFILE = "xpm.loadFile"
    _XPM_COMMAND_GETGAMEREGION = "xpm.gameRegion"
    _XPM_COMMAND_GETGAMELANGUAGE = "xpm.gameLanguage"
    _XPM_COMMAND_MESSAGEBOX = 'xpm.messageBox'
    _XPM_COMMAND_SYSMESSAGE = 'xpm.systemMessage'

    _XPM_AS_COMMAND_RELOAD_CONFIG = "xpm.as.reload_config"

    _xvmInitialized = False

    def _start():
        #debug('start')

        from gui.shared import g_eventBus, EVENT_BUS_SCOPE
        from gui.Scaleform.framework import g_entitiesFactories, ViewSettings, ViewTypes, ScopeTemplates
        from gui.Scaleform.framework.entities.View import View

        class XvmView(View):
            def xvm_cmd(self, cmd, *args):
                debug('[XPM] # ' + str(cmd) + str(args))
                if cmd == _XPM_COMMAND_GETMODS:
                    return _xpm_getMods()
                elif cmd == _XPM_COMMAND_INITIALIZED:
                    global _xvmInitialized
                    _xvmInitialized = True
                    _startConfigWatchdog()
                elif cmd == _XPM_COMMAND_LOADFILE:
                    return load_file(args[0])
                elif cmd == _XPM_COMMAND_GETGAMEREGION:
                    global gameRegion
                    return gameRegion
                elif cmd == _XPM_COMMAND_GETGAMELANGUAGE:
                    global gameLanguage
                    return gameLanguage
                elif cmd == _XPM_COMMAND_MESSAGEBOX:
                    # title, message
                    from gui import DialogsInterface
                    from gui.Scaleform.daapi.view import dialogs
                    DialogsInterface.showDialog(dialogs.SimpleDialogMeta(
                        args[0],
                        args[1],
                        dialogs.I18nInfoDialogButtons('common/error')),
                        (lambda x: None))
                elif cmd == _XPM_COMMAND_SYSMESSAGE:
                    # message, type
                    # Types: gui.SystemMessages.SM_TYPE:
                    #   'Error', 'Warning', 'Information', 'GameGreeting', ...
                    SystemMessages.pushMessage(
                        args[0],
                        type=SystemMessages.SM_TYPE.of(args[1]))
                else:
                    handlers = g_eventBus._EventBus__scopes[EVENT_BUS_SCOPE.DEFAULT][XPM_CMD]
                    for handler in handlers.copy():
                        try:
                            (result, status) = handler(cmd, *args)
                            if status:
                                return result
                        except TypeError:
                            err(traceback.format_exc())
                    log('WARNING: unknown command: %s' % cmd)

            def as_xvm_cmdS(self, cmd, *args):
                return self.flashObject.as_xvm_cmd(cmd, *args) if self.flashObject is not None else None

        g_entitiesFactories.addSettings(ViewSettings(
            _XVM_VIEW_ALIAS,
            XvmView,
            _XVM_SWF_URL,
            ViewTypes.SERVICE_LAYOUT,
            None,
            ScopeTemplates.GLOBAL_SCOPE))

        g_eventBus.addListener(events.GUICommonEvent.APP_STARTED, _appStarted)

    def _fini():
        #debug('fini')
        from gui.shared import g_eventBus
        g_eventBus.removeListener(events.GUICommonEvent.APP_STARTED, _appStarted)
        _stopConfigWatchdog()

    def _appStarted(event):
        #debug('AppStarted')
        try:
            from gui.WindowsManager import g_windowsManager
            app = g_windowsManager.window
            if app is not None:
                global g_xvmView
                g_xvmView = None
                global _xvmInitialized
                _xvmInitialized = False
                app.loaderManager.onViewLoaded += _onViewLoaded
                BigWorld.callback(0, lambda:app.loadView(_XVM_VIEW_ALIAS))
                #app.loadView(_XVM_VIEW_ALIAS)
        except Exception, ex:
            err(traceback.format_exc())

    def _AppLoadView(base, self, newViewAlias, name = None, *args, **kwargs):
        #log('loadView: ' + newViewAlias)
        if newViewAlias == 'hangar':
            global _xvmInitialized
            if _xvmInitialized == False:
                BigWorld.callback(0, lambda:_AppLoadView(base, self, newViewAlias, name, *args, **kwargs))
                return
        base(self, newViewAlias, name, *args, **kwargs)

    def _onViewLoaded(view):
        try:
            debug('onViewLoaded: ' + view.alias)
            if view.alias == _XVM_VIEW_ALIAS:
                from gui.WindowsManager import g_windowsManager
                app = g_windowsManager.window
                #if app is not None:
                #    app.loaderManager.onViewLoaded -= _onViewLoaded
                global g_xvmView
                g_xvmView = view
                #log(g_xvmView)
        except Exception, ex:
            err(traceback.format_exc())

    # commands handlers

    def _xpm_getMods():
        try:
            mods_dir = _XVM_MODS_DIR
            if not os.path.isdir(mods_dir):
                return None
            mods = []
            for m in glob.iglob(mods_dir + "/*.swf"):
                m = m.replace('\\', '/')
                if not m.lower().endswith("/xvm.swf"):
                    mods.append(m)
            return mods
        except Exception, ex:
            err(traceback.format_exc())
        return None

    # config watchdog
    _configWatchdogTimerId = None
    _lastConfigDirState = None

    def _startConfigWatchdog():
        _stopConfigWatchdog()
        if _isConfigReloadingEnabled():
            _configWatchdog()

    def _configWatchdog():
        #log('_configWatchdog')

        global _xvm_config_dir_name
        global _lastConfigDirState
        global _configWatchdogTimerId

        try:
            x = [(nm, os.path.getmtime(nm)) for nm in [os.path.join(p, f) for p, n, fn in os.walk(_xvm_config_dir_name) for f in fn]]
            if _lastConfigDirState is None:
                _lastConfigDirState = x
            elif _lastConfigDirState != x:
                _lastConfigDirState = x
                global g_xvmView
                if g_xvmView is not None and g_xvmView.flashObject is not None:
                    _stopConfigWatchdog()
                    g_xvmView.as_xvm_cmdS(_XPM_AS_COMMAND_RELOAD_CONFIG)

                    from gui.WindowsManager import g_windowsManager
                    from gui.Scaleform.framework import ViewTypes
                    from gui.Scaleform.daapi.settings.views import VIEW_ALIAS
                    from gui.prb_control.events_dispatcher import g_eventDispatcher
                    app = g_windowsManager.window
                    if app:
                        container = app.containerManager.getContainer(ViewTypes.LOBBY_SUB)
                        if container:
                            view = container.getView()
                            if view and view.alias == VIEW_ALIAS.LOBBY_HANGAR:
                                container.remove(view)
                            g_eventDispatcher.loadHangar()
                    return

        except Exception, ex:
            err(traceback.format_exc())

        if _isConfigReloadingEnabled():
            _configWatchdogTimerId = BigWorld.callback(1, _configWatchdog)
        else:
            _stopConfigWatchdog()

    def _stopConfigWatchdog():
        global _configWatchdogTimerId
        if _configWatchdogTimerId:
            BigWorld.cancelCallback(_configWatchdogTimerId)
            _configWatchdogTimerId = None

    def _isConfigReloadingEnabled():
        try:
            from gui.mods.xvmstat.config import config
            return config['autoReloadConfig'] == True
        except:
            return False

    # register events

    def _RegisterEvents():
        _start()
        import game
        RegisterEvent(game, 'fini', _fini)
        from gui.Scaleform.framework.application import App
        OverrideMethod(App, 'loadView', _AppLoadView)
    BigWorld.callback(0, _RegisterEvents)