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
        text: "Client of BrewerDB.com for SailfishOS\n" +
              "Version: 0.0.1 (very Alpha)\n" +
              "\n" +
              "Author:\n" +
              "@helicalgear\n" +
              "\n" +
              "Special Thanks:\n" +
              "@kenya888\n" +
              "@task_jp\n"
        horizontalAlignment: Text.AlignHCenter
        color: Theme.primaryColor
    }

}
