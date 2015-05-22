import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.qippis.Twitter4QML 1.1

Dialog {
    id: tweet

    property string beerId
    property string beerName

    property string _image: ""
    property var media: new Array

    property var parameter

    Timer {
        running: tweet.status == PageStatus.Active && oauth.state !== OAuth.Authorized
        interval: 100
        onTriggered: pageStack.replace(Qt.resolvedUrl("Authentication.qml"))
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                visible: tweet._image === ""
                text: "Add Image (Gallery)"
                onClicked: {
                    var imagePicker = pageStack.push("Sailfish.Pickers.ImagePickerPage");
                    imagePicker.selectedContentChanged.connect(function() {
                        tweet._image = imagePicker.selectedContent;
                        tweet.media.push(_image.replace("file://",""));
                    });
                }
            }
            MenuItem {
                visible: tweet._image === ""
                text: "Add Image (Camera)"
                onClicked: {
                    var cameraPicker = pageStack.push(Qt.resolvedUrl("Camera.qml"));
                    cameraPicker.tookPictureChanged.connect(function() {
                        tweet._image = cameraPicker.tookPicture;
                        tweet.media.push(_image);
                    });
                }
            }
            MenuItem {
                visible: tweet._image !== ""
                text: "Remove Image"
                onClicked: {
                    tweet._image = "";
                    tweet.media = [];
                }
            }
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
            Image {
                visible: tweet._image !== ""
                x: Theme.paddingLarge
                width: 160
                height: 160
                fillMode: Image.PreserveAspectCrop
                source: tweet._image
            }
        }
    }

    onDone: {
        if (result == DialogResult.Accepted) {
            parameter = {'status': tweetText.text, 'media': tweet.media};
        }
    }

}
