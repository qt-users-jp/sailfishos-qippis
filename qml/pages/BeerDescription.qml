import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Sailfish.Silica 1.0
import harbour.qippis.Twitter4QML 1.1

Page {
    id: page
    property string beerId
    property string beerName
    property string beerIcon
    property string beerLabel
    property string beerDescription
    property string beerAbv
    property string beerIbu
    property string beerSrm
    property string beerOg
    property string categoryName
    property string styleName
    property string breweryName
    property string breweryId
    property string categoryId
    property string styleId
    property bool statusOfDb: true
    property string errorMessage: ""
    property string apiKey: storage.get("api_key")

    Favorite {
        id: favorite
    }

    Storage {
        id: storage
        name: "SettingDB"
    }

    Status {
        id: beerStatus
        onPlain_textChanged: infoBar.show(plain_text)
//        onId_strChanged: infoBar.show("Tweet Succeeded")
    }

    property bool favorited: favorite.getName(beerId) ? true : false

    function reload() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "https://api.brewerydb.com/v2/beer/%1?withBreweries=Y&key=%2&format=xml".arg(beerId).arg(apiKey), true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                switch (xhr.status) {
                case 200:
                    reloaded.xml = xhr.responseText;
                    break;
                case 401:
                    statusOfDb = false;
                    errorMessage = qsTr("Please check API_Key");
                    break;
                default:
                    statusOfDb = false;
                    errorMessage = qsTr("Something wrong to get the XML data.");
                    break;
                }
            }
        }
        xhr.send();
    }

    XmlListModel {
        id: reloaded
        query: "/root/data"
        XmlRole { name: "_beerName"; query: "name/string()" }
        XmlRole { name: "_beerDescription"; query: "description/string()" }
        XmlRole { name: "_beerAbv"; query: "abv/string()" }
        XmlRole { name: "_beerIbu"; query: "ibu/string()" }
        XmlRole { name: "_beerSrm"; query: "srm/name/string()" }
        XmlRole { name: "_beerOg"; query: "og/string()" }
        XmlRole { name: "_beerIcon"; query: "labels/icon/string()" }
        XmlRole { name: "_beerLabel"; query: "labels/medium/string()" }
        XmlRole { name: "_styleId"; query: "style/id/string()" }
        XmlRole { name: "_styleName"; query: "style/name/string()" }
        XmlRole { name: "_categoryId"; query: "style/category/id/string()" }
        XmlRole { name: "_categoryName"; query: "style/category/name/string()" }
        XmlRole { name: "_breweryId"; query: "breweries/item/id/string()" }
        XmlRole { name: "_breweryName"; query: "breweries/item/name/string()" }
        onStatusChanged: {
            if ( reloaded.status === XmlListModel.Ready ) {
                beerName = reloaded.get(0)._beerName;
                beerDescription = reloaded.get(0)._beerDescription;
                beerAbv = reloaded.get(0)._beerAbv;
                beerIbu = reloaded.get(0)._beerIbu;
                beerSrm = reloaded.get(0)._beerSrm;
                beerOg = reloaded.get(0)._beerOg;
                beerIcon = reloaded.get(0)._beerIcon;
                beerLabel = reloaded.get(0)._beerLabel;
                styleId = reloaded.get(0)._styleId;
                styleName = reloaded.get(0)._styleName;
                categoryId = reloaded.get(0)._categoryId;
                categoryName = reloaded.get(0)._categoryName;
                breweryId = reloaded.get(0)._breweryId;
                breweryName = reloaded.get(0)._breweryName;
                favorite.set(beerId, beerName, beerIcon, beerLabel, beerDescription, beerAbv, beerIbu, beerSrm, beerOg, categoryName, styleName, breweryName, breweryId, categoryId, styleId);
            }
        }
    }

    SilicaFlickable {
        id: beerInfromation
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                visible: !favorited
                text: "Add to Favorite"
                onClicked: {
                    favorite.set(beerId, beerName, beerIcon, beerLabel, beerDescription, beerAbv, beerIbu, beerSrm, beerOg, categoryName, styleName, breweryName, breweryId, categoryId, styleId);
                    page.favorited = true;
                }
            }
            MenuItem {
                visible: favorited
                text: "Remove from Favorite"
                onClicked: {
                    favorite.unset(beerId);
                    page.favorited = false;
                }
            }
            MenuItem {
                visible: favorited
                text: "Reload Beer Info"
                onClicked: {
                    reload();
                }
            }
            MenuItem {
                text: "Tweet the Beer"
                onClicked: {
                    var tweetBeer = pageStack.push(Qt.resolvedUrl("TweetBeer.qml"), {beerId: beerId, beerName: beerName});
                    tweetBeer.parameterChanged.connect(function() {
                        beerStatus.statusesUpdate(tweetBeer.parameter)
                    });
                }
            }
        }

        Column {
            id: column
            x: Theme.paddingLarge
            width: page.width - ( Theme.paddingLarge * 2 )
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Beer's Information")
            }

            Row {
                width: parent.width
                IconButton {
                    id: favStar
                    anchors.verticalCenter: parent.verticalCenter
                    icon.source: favorited ? "image://theme/icon-m-favorite-selected" : "image://theme/icon-m-favorite"
                    onClicked: {
                        if (favorited) {
                            favorite.unset(beerId);
                            favorited = false;
                        } else {
                            favorite.set(beerId, beerName, beerIcon, beerLabel, beerDescription, beerAbv, beerIbu, beerSrm, beerOg, categoryName, styleName, breweryName, breweryId, categoryId, styleId);
                            favorited = true;
                        }
                    }
                }
                Label {
                    width: parent.width - favStar.width
                    anchors.verticalCenter: parent.verticalCenter
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeExtraLarge
                    text: beerName
                }
            }

            Row {
                Image {
                    id: labelImage
                    width: column.width / 2
                    height: column.width / 2
                    source: beerLabel ? beerLabel : "../images/noImage.png"
                    BusyIndicator {
                        anchors.centerIn: parent
                        running: labelImage.status == Image.Loading
                    }
                }
                Column {
                    id: beerParam
                    width: column.width / 2
                    Row {
                        height: beerParam.width / 4
                        Label {
                            width: beerParam.width / 3
                            horizontalAlignment: Text.AlignRight
                            text: "ABV: "
                        }
                        Text {
                            color: Theme.primaryColor
                            width: beerParam.width *  2 / 3
                            horizontalAlignment: Text.AlignHCenter
                            text: beerAbv ? beerAbv : "N/A"
                        }
                    }
                    Row {
                        height: beerParam.width / 4
                        Label {
                            width: beerParam.width / 3
                            horizontalAlignment: Text.AlignRight
                            text: "IBU: "
                        }
                        Text {
                            color: Theme.primaryColor
                            width: beerParam.width * 2 / 3
                            horizontalAlignment: Text.AlignHCenter
                            text: beerIbu ? beerIbu : "N/A"
                        }
                    }
                    Row {
                        height: beerParam.width / 4
                        Label {
                            width: beerParam.width / 3
                            horizontalAlignment: Text.AlignRight
                            text: "SRM: "
                        }
                        Text {
                            color: Theme.primaryColor
                            width: beerParam.width * 2 / 3
                            horizontalAlignment: Text.AlignHCenter
                            text: beerSrm ? beerSrm : "N/A"
                        }
                    }
                    Row {
                        height: beerParam.width / 4
                        Label {
                            width: beerParam.width / 3
                            horizontalAlignment: Text.AlignRight
                            text: "OG: "
                        }
                        Text {
                            color: Theme.primaryColor
                            width: beerParam.width * 2 / 3
                            horizontalAlignment: Text.AlignHCenter
                            text: beerOg ? beerOg : "N/A"
                        }
                    }
                }
            }

            Row {
                width: parent.width
                spacing: Theme.paddingLarge
                Label {
                    width: parent.width / 4
                    text: "Brewery: "
                }
                Text {
                    id: brewery
                    width: parent.width * 3 / 4
                    horizontalAlignment: Text.AlignLeft
                    text: breweryName
                    color: Theme.primaryColor
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                }
            }

            Row{
                width: parent.width
                spacing: Theme.paddingLarge
                Label {
                    width: parent.width / 4
                    text: "Category: "
                }
                Text {
                    id: category
                    width: parent.width * 3 / 4
                    horizontalAlignment:  Text.AlignLeft
                    text: categoryName
                    color: Theme.primaryColor
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                }
            }

            Row {
                width: parent.width
                spacing: Theme.paddingLarge
                Label {
                    width: column.width / 4
                    text: "Style: "
                }
                Text {
                    id: beerStyle
                    width: column.width * 3 / 4
                    horizontalAlignment: Text.AlignLeft
                    text: styleName
                    color: Theme.primaryColor
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                }
            }

            Column {
                Label {
                    width: column.width
                    text: "Description: "
                }
                Text {
                    id: description
                    height: description.contentHeight
                    width: column.width
                    color: Theme.primaryColor
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                    text: beerDescription
                }
            }
        }
    }
}
