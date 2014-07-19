import QtQuick 2.0
import Sailfish.Silica 1.0

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
    property string apiKey

    Favorite {
        id: favorite
    }

    SilicaFlickable {
        id: beerInfromation
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: "Remove from Favorites"
                onClicked: favorite.unset(beerId)
            }
            MenuItem {
                text: "Add to Favorites"
                onClicked: favorite.set(beerId, beerName, beerIcon, beerLabel, beerDescription, beerAbv, beerIbu, beerSrm, beerOg, categoryName, styleName)
            }
            MenuItem {
                text: "Tweet the Beer"
                onClicked: pageStack.push(Qt.resolvedUrl("TweetBeer.qml"), {beerId: beerId, beerName: beerName})
            }
        }

        Column {
            id: column
            x: Theme.paddingLarge
            width: page.width - Theme.paddingLarge

            PageHeader {
                title: qsTr("Beer's Information")
            }
            Row {
                Image {
                    id: labelImage
                    width: column.width / 2
                    height: column.width / 2
                    source: beerLabel ? beerLabel : "../images/noImage.jpg"
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
                Label {
                    height: name.contentHeight
                    width: column.width / 4
                    text: "Name: "
                }
                Text {
                    id: name
                    width: column.width * 3 / 4
                    horizontalAlignment: Text.AlignLeft
                    text: beerName
                    color: Theme.primaryColor
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                }
            }

            Row{
                height: category.contentHeight
                Label {
                    width: column.width / 4
                    text: "Category: "
                }
                Text {
                    id: category
                    width: column.width * 3 / 4
                    horizontalAlignment:  Text.AlignLeft
                    text: categoryName
                    color: Theme.primaryColor
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                }
            }

            Row {
                height: beerSytle.contentHeight
                Label {
                    width: column.width / 4
                    text: "Style: "
                }
                Text {
                    id: beerSytle
                    width: column.width * 3 / 4
                    horizontalAlignment: Text.AlignLeft
                    text: styleName
                    color: Theme.primaryColor
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                }
            }

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
