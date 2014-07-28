import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.qippis.Twitter4QML 1.1

Dialog {
    id: tweet

    property string beerId
    property string beerName

    Timer {
        running: tweet.status == PageStatus.Active && oauth.state !== OAuth.Authorized
        interval: 100
        onTriggered: pageStack.replace(Qt.resolvedUrl("Authentication.qml"))
    }

    Status {
        id: beerStatus
    }

    Column {
        id: column

        width: tweet.width
        spacing: Theme.paddingLarge
        DialogHeader {
            title: "Tweet"
        }
        Row {
            x: Theme.paddingLarge
            spacing: Theme.paddingLarge
            width: column.width
            Image {
                id: icon
                source: verifyCredentials.profile_image_url.replace('_normal', '_bigger')
            }
            Label {
                id: screenName
                text: storage.get("screenName")
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
        }
        TextArea {
            id: tweetText
            width: tweet.width
            height: 300
            text: "I like %1!! http://www.brewerydb.com/beer/%2 #qippis".arg(beerName).arg(beerId)
        }
    }

    onDone: {
        if (result == DialogResult.Accepted) {
            var parameter = {'status': tweetText.text, 'media': ""};
            beerStatus.statusesUpdate(parameter);
        }
    }

}
