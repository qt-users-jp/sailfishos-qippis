import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string styleId
    property string styleName
    property string styleDescription
    property string abvMin
    property string abvMax
    property string ibuMin
    property string ibuMax
    property string srmMin
    property string srmMax
    property string ogMin
    property string ogMax
    property string fgMin
    property string fgMax
    property string apiKey

    SilicaFlickable {
        id: styleInformation
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            x: Theme.paddingLarge
            width: page.width - (Theme.paddingLarge * 2)

            PageHeader {
                title: qsTr("Style's Information")
            }
            Label {
                id: style
                width: parent.width
                height: style.contentHeight * 3
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                textFormat: Text.RichText
                text: styleName
            }


            Row {
                height: column.width / 4

                Column {
                    width: column.width / 4
                    height: parent.height
                    Label {
                        width: parent.width
                        height: parent.height / 3
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: "ABV"
                    }
                    Text {
                        width: parent.width
                        height: parent.height * 2 / 3
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: abvMin + ( abvMin ? abvMax ? " - " : " <" : "< ") + abvMax
                        color: Theme.primaryColor
                    }
                }
                Column {
                    width: column.width / 4
                    height: parent.height
                    Label {
                        width: parent.width
                        height: parent.height / 3
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                        text: "IBU"
                    }
                    Text {
                        width: parent.width
                        height: parent.height * 2 / 3
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: ibuMin + ( ibuMin ? ibuMax ? " - " : " <" : "< ") + ibuMax
                        color: Theme.primaryColor
                    }
                }

                Column {
                    width: column.width / 4
                    height: parent.height
                    Label {
                        width: parent.width
                        height: parent.height / 3
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                        text: "SRM"
                    }
                    Text {
                        width: parent.width
                        height: parent.height * 2 / 3
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: srmMin + ( srmMin ? srmMax ? " - " : " <" : "< ") + srmMax
                        color: Theme.primaryColor
                    }
                }

                Column {
                    width: column.width / 4
                        height: parent.height
                    Label {
                        width: parent.width
                        height: parent.height / 3
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                        text: "OG"
                    }
                    Text {
                        width: parent.width
                        height: parent.height * 2 / 3
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: ogMin + ( ogMin ? ogMax ? " - " : " <" : "> ") + ogMax
                        color: Theme.primaryColor
                    }
                }
            }

            Text {
                id: description
                width: column.width
                height: description.contentHeight
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                text: styleDescription
            }

        }
    }
}
