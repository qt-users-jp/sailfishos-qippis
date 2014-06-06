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
import QtQuick.XmlListModel 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    property string apiKey

    BusyIndicator {
        anchors.centerIn: parent
        running: listModel.status == XmlListModel.Loading
    }

    XmlListModel {
        id: listModel
        source: "https://api.brewerydb.com/v2/styles?key=" + apiKey + "&format=xml"
        query: "/root/data/item"
        XmlRole { name: "styleName"; query: "name/string()" }
        XmlRole { name: "styleId"; query: "id/string()" }
        XmlRole { name: "styleDescription"; query: "description/string()" }
        XmlRole { name: "abvMin"; query: "abvMin/string()" }
        XmlRole { name: "abvMax"; query: "abvMax/string()" }
        XmlRole { name: "ibuMin"; query: "ibuMin/string()" }
        XmlRole { name: "ibuMax"; query: "biuMax/string()" }
        XmlRole { name: "srmMin"; query: "srmMin/string()" }
        XmlRole { name: "srmMax"; query: "srmMax/string()" }
        XmlRole { name: "ogMin"; query: "ogMin/string()" }
        XmlRole { name: "ogMax"; query: "ogMax/string()" }
        XmlRole { name: "fgMin"; query: "fgMin/string()" }
        XmlRole { name: "fgMax"; query: "fgMax/string()" }
    }

    SilicaListView {
        id: listView
        model: listModel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Styles of Beer")
        }
        delegate: BackgroundItem {
            id: delegate

            Label {
                x: Theme.paddingLarge
                text: styleName
                anchors.verticalCenter: parent.verticalCenter
                textFormat: Text.RichText
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: pageStack.push(Qt.resolvedUrl("StyleDescription.qml"), {
                                          styleId: styleId,
                                          styleName: styleName,
                                          styleDescription: styleDescription,
                                          abvMin: abvMin,
                                          abvMax: abvMax,
                                          ibuMin: ibuMin,
                                          ibuMax: ibuMax,
                                          srmMin: srmMin,
                                          srmMax: srmMax,
                                          ogMin: ogMin,
                                          ogMax: ogMax,
                                          fgMin: fgMin,
                                          fgMax: fgMax,
                                          apiKey: apiKey
                                      })
        }
        VerticalScrollDecorator {}
    }
}
