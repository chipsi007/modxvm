﻿/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * https://modxvm.com/
 */
package com.xvm.lobby.ui.contacts
{
    import com.xfw.*;
    import flash.display.*;
    import net.wg.gui.components.controls.UILoaderAlt; // '*' conflicts with UI classes
    import net.wg.gui.messenger.controls.*;
    import net.wg.gui.messenger.data.*;
    import scaleform.clik.constants.*;

    public class UI_ContactsTreeItemRenderer extends ContactsTreeItemRendererUI
    {
        private var panel:Sprite = null;
        private var nickImg:UILoaderAlt = null;
        private var commentImg:UILoaderAlt = null;

        public function UI_ContactsTreeItemRenderer()
        {
            //Logger.add("UI_ContactsTreeItemRenderer");
            super();
        }

        override protected function configUI():void
        {
            super.configUI();
            createControls();
        }

        override protected function draw():void
        {
            try
            {
                //Logger.addObject(data, 3);

                if (isInvalid(InvalidationType.DATA))
                {
                    var myData:ITreeItemInfo = this.getData() as ITreeItemInfo;
                    if (myData && !myData.isBrunch && myData.data)
                    {
                        if (this.xfw_contactItem == null)
                        {
                            this.xfw_contactItem = new UI_ContactItem();
                        }
                    }
                }

                nickImg.visible = false;
                commentImg.visible = false;

                super.draw();

                if (this.xfw_currentContentItem is ContactItem)
                {
                    var d:ContactsListTreeItemInfo = data as ContactsListTreeItemInfo;
                    if (d && d.data.xvm_contact_data)
                    {
                        nickImg.visible = Boolean(d.data.xvm_contact_data.nick);
                        commentImg.visible = Boolean(d.data.xvm_contact_data.comment);
                    }
                }
            }
            catch (ex:Error)
            {
                Logger.err(ex);
            }
        }

/* using original tooltip form
        override protected function showTooltip():void
        {
            var currentContentItem:UIComponent = this.getCurrentContentItem();
            if (currentContentItem is ContactItem)
            {
                var d:ContactsListTreeItemInfo = data as ContactsListTreeItemInfo;
                if (d && d.data.xvm_contact_data)
                {
                    var comment:String = d.data.xvm_contact_data.comment;
                    if (comment)
                    {
                        App.toolTipMgr.show(d.data.userProps.userName +
                            (d.data.userProps.clanAbbrev ? "[" + d.data.userProps.clanAbbrev + "]" : "") +
                            "\n\n<font color='" + XfwUtils.toHtmlColor(XfwConst.UICOLOR_LABEL) + "'>" + Utils.fixImgTag(comment) + "</font>");
                        return;
                    }
                }
            }
            super.showTooltip();
        }
*/

        // PRIVATE

        private function createControls():void
        {
            panel = this.addChildAt(new Sprite(), 0) as Sprite;
            panel.x = width - 34;

            this.nickImg = panel.addChild(App.utils.classFactory.getComponent("UILoaderAlt", UILoaderAlt, {
                autoSize: true,
                maintainAspectRatio: false,
                x: 6,
                y: 3,
                width: 10,
                height: 20,
                alpha: 0.5,
                source: "../maps/icons/messenger/iconContacts.png",
                visible: false
            })) as UILoaderAlt;

            this.commentImg = panel.addChild(App.utils.classFactory.getComponent("UILoaderAlt", UILoaderAlt, {
                autoSize: true,
                maintainAspectRatio: false,
                x: 14,
                y: 4,
                width: 16,
                height: 16,
                alpha: 0.5,
                source: "../maps/icons/library/pen.png",
                visible: false
            })) as UILoaderAlt;
        }
    }
}
/*
data: { // net.wg.gui.messenger.data::ContactsListTreeItemInfo
  "id": 13494688,
  "isBrunch": false,
  "isOpened": false,
  "data": {
    "isOnline": false,
    "userProps": {
      "rgb": 5263440,
      "userName": "Tracks_Destroyer_RU",
      "tags": [
        "sub/none",
        "friend"
      ],
      "clanAbbrev": null,
      "region": null,
      "suffix": " <IMG SRC='img://gui/maps/icons/messenger/contactConfirmNeeded.png' width='16' height='16' vspace='-6' hspace='0'/>"
    },
    "note": "",
    "xvm_contact_data": {
      "nick": "nick",
      "comment": "comment"
    },
    "dbID": 7027996
  },
  "gui": { "id": 13494688 },
  "parent": {...}, // net.wg.gui.messenger.data::ContactsListTreeItemInfo
  "children": null,
  "parentItemData": null
}
*/

