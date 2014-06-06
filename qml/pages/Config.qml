import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    Storage {
        id: storage
        name: "SettingDB"
    }

    Column {
        id: column

        width: page.width
        spacing: Theme.paddingLarge
        PageHeader {
            title: "Settings"
        }
        Label {
            x: Theme.paddingLarge
            text: qsTr("API Key")
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeExtraLarge
        }
        Rectangle {
            id: inputSpace
            x: Theme.paddingLarge
            width: column.width - ( Theme.paddingLarge * 2)
            height: Theme.fontSizeLarge + 5
            color: "white"
            TextInput {
                id: keyStrings
                anchors.fill: parent
                text: storage.get("api_key")
                width: inputSpace.width
                font.pixelSize: Theme.fontSizeLarge
                clip: true
                selectByMouse: true
                onAccepted: {
                    storage.set("api_key", keyStrings.text)
                    pageStack.pop()
                }
            }
        }
    }

}
