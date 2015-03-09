""" XVM (c) www.modxvm.com 2013-2015 """

# PUBLIC

def initialize():
    return _contacts.initialize()

def isAvailable():
    return _contacts.is_available

def getXvmContactData(uid):
    return _contacts.getXvmContactData(uid)

# PRIVATE

from random import randint
import traceback

from gui import SystemMessages

import simplejson

from xfw import *
from xvm_main.python.constants import *
from xvm_main.python.loadurl import loadUrl
from xvm_main.python.logger import *
import xvm_main.python.token as token
import xvm_main.python.utils as utils

_CONTACTS_DATA_VERSION = '1.0'
_SYSTEM_MESSAGE_TPL = '''<textformat tabstops="[130]"><img src="img://../xvm/res/icons/xvm/16x16t.png"
 vspace="-5">&nbsp;<a href="#XVM_SITE#"><font color="#E2D2A2">www.modxvm.com</font></a>\n\n%VALUE%</textformat>'''

class _Contacts:

    def __init__(self):
        self.cached_data = None
        self.cached_token = None
        self.is_available = False
        self.contacts_disabled = False

    def initialize(self):
        try:
            if self.contacts_disabled:
                return

            if not token.networkServicesSettings['comments']:
                return

            if token.isOnline:
                t = token.getToken()
                if t is None:
                    raise Exception('[TOKEN_NOT_INITIALIZED] {0}'.format(l10n('Network services unavailable')))
                if t == '':
                    raise Exception('[NO_TOKEN] {0}'.format(l10n('Network services unavailable')))

                if self.cached_data is None or self.cached_token != t:
                    self.cached_token = t
                    json_data = self._doRequest('getComments')
                    data = {'ver':_CONTACTS_DATA_VERSION} if json_data is None else simplejson.loads(json_data)
                    if data['ver'] != _CONTACTS_DATA_VERSION:
                        pass # TODO: data = convertOldVersion(data)
                    self.cached_data = data
                    self.is_available = True

        except Exception as ex:
            self.contacts_disabled = True
            self.is_available = False
            self.cached_token = None
            self.cached_data = None

            errstr = _SYSTEM_MESSAGE_TPL.replace('%VALUE%', '<b>{0}</b>\n\n{1}\n\n{2}'.format(
                l10n('Error loading comments'),
                str(ex),
                l10n('Comments disabled')))
            SystemMessages.pushMessage(errstr, type=SystemMessages.SM_TYPE.Warning)
            warn(traceback.format_exc())

        log(self.cached_data)

    def getXvmContactData(self, uid):
        nick = None
        comment = None
        if self.cached_data is not None and 'players' in self.cached_data:
            data = self.cached_data['players'].get(str(uid), None)
            if data is not None:
                nick = data.get('nick', None)
                comment = data.get('comment', None)
        return {'nick':nick,'comment':comment}

    # PRIVATE

    def _doRequest(self, cmd, body=None):
        req = '{0}/{1}'.format(cmd, self.cached_token)
        server = XVM_SERVERS[randint(0, len(XVM_SERVERS) - 1)]
        (response, duration, errStr) = loadUrl(server, req, body=body)

        if not response:
            raise Exception(errStr)

        response = response.strip()
        if response in ('', '[]', '{}'):
            response = None

        # log(utils.hide_guid(response))

        return response

_contacts = _Contacts()
