/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.qippis.Twitter4QML 1.1
import "pages"

ApplicationWindow
{
    initialPage: Component { FrontPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    Storage {
        id: storage
        name: "SettingDB"
    }

    AccountVerifyCredentials {
        id: verifyCredentials
    }

    HelpConfiguration {
        id: configuration
    }

    OAuth {
        id: oauth
        consumer_key: consumerKey
        consumer_secret: consumerSecret
        token: storage.get('token')? storage.get('token'):""
        token_secret: storage.get('tokenSecret')? storage.get('tokenSecret'):""
        user_id: storage.get('userId')? storage.get('userId'):""
        screen_name: storage.get('screenName')? storage.get('screenName'):""
        onTokenChanged: storage.set('token', token)
        onToken_secretChanged: storage.set('tokenSecret', token_secret)
        onUser_idChanged: storage.set('userId', user_id)
        onScreen_nameChanged: storage.set('screenName', screen_name)

        property bool completed: false
        onStateChanged: {
            switch (state) {
            case OAuth.Authorized:
                if (completed) {
                    verifyCredentials.exec()
                    configuration.exec()
                }
                break;
            case OAuth.Unauthorized:
                break;
            }
        }
        Component.onCompleted: oauth.completed = true
    }

    Rectangle {
        id: infoBar

        width: parent.width
        height: info.height
        color: Theme.highlightBackgroundColor
        radius: 2

        opacity: 0.0

        visible: opacity > 0.0

        function show(text) {
            info.text = qsTr("Success:\n") + text;
            opacity = 0.9;
            closeTimer.restart();
        }

        Label {
            id: info
            x: Theme.paddingLarge
            width: parent.width - 2 * Theme.paddingLarge
            height: contentHeight
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WrapAnywhere
        }

        Timer {
            id: closeTimer
            interval: 3000
            onTriggered: infoBar.opacity = 0.0
        }
    }
}
