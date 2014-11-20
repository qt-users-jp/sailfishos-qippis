import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Page {
    id: page

    property string tookPicture: ""
    property bool imgCaptured: false

    Component.onCompleted: camera.imageCapture.setMetadata("Orientation", 270)

    PageHeader {
        title: "Take Beer's Picture"
    }

    Camera {
        id: camera

        focus {
            focusMode: Camera.FocusContinuous
        }

        imageCapture {
            resolution: "1024x768"
            onImageSaved: {
                page.imgCaptured = true;
                photoPreview.source = camera.imageCapture.capturedImagePath;
            }
        }
    }

    VideoOutput {
        id: videoOutput
        width: 480
        height: 640
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: camera
        focus: visible
        visible: !page.imgCaptured
    }

    Image {
        id: photoPreview
        width: 640
        height: 640
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: page.imgCaptured
        fillMode: Image.PreserveAspectFit
        rotation: 90
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        IconButton {
            visible: !page.imgCaptured
            icon.source: "image://theme/icon-camera-shutter-release"
            onClicked: camera.imageCapture.capture()
        }
        Button {
            visible: page.imgCaptured
            text: "OK"
            onClicked: {
                tookPicture = camera.imageCapture.capturedImagePath;
                pageStack.pop();
            }
        }
        Button {
            visible: page.imgCaptured
            text: "Cancel"
            onClicked: page.imgCaptured = false;
        }
    }

    Connections {
        target: Qt.application
        onActiveChanged: Qt.application.active ? camera.start() : camera.stop()
    }

}
