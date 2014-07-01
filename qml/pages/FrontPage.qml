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


Page {
    id: page

    Storage {
        id: storage
        name: "SettingDB"
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: "About Qippis"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutQippis.qml"))
            }

            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Config.qml"))
            }
//            MenuItem {
//                text: qsTr("Categories of Beer")
//                onClicked: pageStack.push(Qt.resolvedUrl("CategoryList.qml"))
//            }
            MenuItem {
                text: qsTr("Styles of Beer")
                onClicked: pageStack.push(Qt.resolvedUrl("StyleList.qml"), {apiKey: storage.get("api_key")})
            }
            MenuItem {
                text: "Favorites"
                onClicked: pageStack.push(Qt.resolvedUrl("FavoritesList.qml"), {apiKey: storage.get("api_key")})
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "Qippis"
            }
            Label {
                x: Theme.paddingLarge
                text: qsTr("Search the Beer")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
            TextField {
                x: Theme.paddingLarge
                width: column.width - ( Theme.paddingLarge * 2)
                id: searchWords
                placeholderText: "Name of Beer"
                font.pixelSize: Theme.fontSizeLarge
                clip: true
            }
            Button {
                id: searchButton
                x: page.width - ( searchButton.width + 20 )
                text: "Search!"
                onClicked: if (storage.get("api_key") === "") {
                               pageStack.push(Qt.resolvedUrl("Config.qml"));
                           } else {
                               pageStack.push(Qt.resolvedUrl("SearchResults.qml"), {
                                                  searchWords: searchWords.text.replace(/^\s+|\s+$/g, "").replace(/\s+/g, " AND "),
                                                  pageNumber: 1,
                                                  apiKey: storage.get("api_key")
                                              })
                           }
            }
        }
    }
}


