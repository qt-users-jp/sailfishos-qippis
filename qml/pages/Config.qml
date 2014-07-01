import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: page

    Storage {
        id: storage
        name: "SettingDB"
    }

    Column {
        id: column

        width: page.width
        spacing: Theme.paddingLarge
        DialogHeader {
            title: "Accept"
        }
        Label {
            x: Theme.paddingLarge
            text: qsTr("API Key Setting")
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeExtraLarge
        }
        TextField {
            id: keyStrings
            width: column.width - ( Theme.paddingLarge * 2)
            font.pixelSize: Theme.fontSizeLarge
            placeholderText: "API Key"
            text: storage.get("api_key")
            clip: true
        }
        Text {
            width: column.width
            color: Theme.primaryColor
            font.pixelSize: Theme.fontSizeMedium
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            text: "You must get an API Key to use BreweryDB&apos;s APIs.<br>" +
                  "Please sign up at below URL if you do not have an account of BreweryDB.com" +
                  "<br>" +
                  "<a href=\"https://www.brewerydb.com/auth/signup\"> https://www.brewerydb.com/auth/signup </a><br>" +
                  "<br>" +
                  "You can get an API Key with access limit (400times/day) free.<br>"
        }
    }

    onDone: {
        if (result == DialogResult.Accepted) {
            storage.set("api_key", keyStrings.text)
        }
    }

}
