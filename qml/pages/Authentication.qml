import QtQuick 2.0
import Sailfish.Silica 1.0
import Twitter4QML 1.1

Page {
    id: page

    signal back

    Storage {
        id: storage
        name: "SettingDB"
    }

    PageHeader {
        title: "Authentication"
    }

    Column {
        id: column
        anchors.verticalCenter: page.verticalCenter
        anchors.horizontalCenter: page.horizontalCenter
        spacing: Theme.paddingLarge

        Image {
            id: avater
            width: column.width
            fillMode: Image.PreserveAspectFit
        }
        Text {
            id: name
            width: column.width
            horizontalAlignment: Text.AlignHCenter
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeLarge
        }
        Text {
            id: description
            width: column.width
            wrapMode: Text.WordWrap
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeSmall
        }
        Button {
            id: start
            text: qsTr('1. Start')
            enabled: false
            onClicked: oauth.request_token()
        }
        TextField {
            id: pin
            width: start.width
            placeholderText: qsTr('2. Enter 7 digits pin code')
            enabled: false
            validator: RegExpValidator { regExp: /^\d{7}$/ }
            Keys.onReturnPressed: oauth.access_token(pin.text)
        }
        Button {
            id: authorize
            text: qsTr('3. Authorize')
            enabled: false
            onClicked: oauth.access_token(pin.text)
        }
        Button {
            id: cancel
            text: qsTr('Cancel/Logout')
            enabled: true
            onClicked: {
                pin.text = ''
                oauth.unauthorize()
            }
        }
    }

    Timer {
        running: state == 'RequestTokenReceived'
        interval: 10
        repeat: false
        onTriggered: oauth.authorize()
    }

    states: [
        State {
            name: "Unauthorized"
            when: oauth.state === OAuth.Unauthorized
            PropertyChanges {
                target: start
                enabled: true
            }
            PropertyChanges {
                target: avater
                source: "../images/noImage.jpg"
            }
            PropertyChanges {
                target: name
                text: "Not Authenticated"
            }
            PropertyChanges {
                target: description
                text: ""
            }
            PropertyChanges {
                target: cancel
                enabled: true
            }
        },
        State {
            name: "ObtainUnauthorizedRequestToken"
            when: oauth.state === OAuth.ObtainUnauthorizedRequestToken
            PropertyChanges {
                target: header
                busy: true
            }
        },
        State {
            name: "RequestTokenReceived"
            when: oauth.state === OAuth.RequestTokenReceived
            PropertyChanges {
                target: header
                busy: true
            }
        },
        State {
            name: "InputVerifier"
            when: oauth.state === OAuth.UserAuthorizesRequestToken && pin.text.length != 7
            PropertyChanges {
                target: pin
                enabled: true
            }
            PropertyChanges {
                target: cancel
                enabled: true
            }
            StateChangeScript {
                script: pin.forceActiveFocus()
            }
        },
        State {
            name: "UserAuthorizesRequestToken"
            when: oauth.state === OAuth.UserAuthorizesRequestToken && pin.text.length == 7
            PropertyChanges {
                target: pin
                enabled: true
            }
            PropertyChanges {
                target: authorize
                enabled: true
            }
            PropertyChanges {
                target: cancel
                enabled: true
            }
        },
        State {
            name: "ExchangeRequestTokenForAccessToken"
            when: oauth.state === OAuth.ExchangeRequestTokenForAccessToken
            PropertyChanges {
                target: header
                busy: true
            }
        },
        State {
            name: "Authorized"
            when: oauth.state === OAuth.Authorized
            PropertyChanges {
                target: avater
                source: verifyCredentials.profile_image_url.replace('_normal', '_bigger')
            }
            PropertyChanges {
                target: name
                text: storage.get("screenName")
            }
            PropertyChanges {
                target: description
                text: verifyCredentials.description
            }
            StateChangeScript {
                script: {
//                    console.debug(pageStack.depth)
                    pageStack.pop()
//                    console.debug(pageStack.depth)
                }
            }
        }
    ]
}
