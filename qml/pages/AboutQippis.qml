import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    PageHeader {
        title: "About Qippis"
    }

    Text {
        id: about
        anchors.centerIn: parent
        width: parent.width
        height: about.contentHeight
        text: "Client of BrewerDB.com for SailfishOS<br>" +
              "Version: 0.0.4 (Alpha)<br>" +
              "<br>" +
              "Please visit <a href=\"http://helicalgear.blogspot.jp/p/qippis.html\">Qippis Info</a> if you need more information about this app.<br>" +
              "<br>" +
              "<br>" +
              "Author:<br>" +
              "@helicalgear<br>" +
              "<br>" +
              "Special Thanks:<br>" +
              "@kenya888<br>" +
              "@task_jp<br>" +
              "@YQK05016<br>"
        horizontalAlignment: Text.AlignHCenter
        color: Theme.primaryColor
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        onLinkActivated: Qt.openUrlExternally(link)
    }

}
