import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    Favorite {
        id: favorite
    }

    property int listLength: favorite.getLength()

    SilicaListView {
        id: listView
        anchors.fill: parent
        model: favorite.getLength()
        header: PageHeader {
            title: "Favorite Beers"
        }

        delegate: BackgroundItem {
            id: delegate

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingLarge
                Image {
                    id: iconImage
                    width: 64
                    height: 64
                    anchors.verticalCenter: parent.verticalCenter
                    source: favorite.getIcon(favorite.getId(index)) ? favorite.getIcon(favorite.getId(index)) : "../images/noImage.jpg"
                    BusyIndicator {
                        anchors.centerIn: parent
                        running: iconImage.status == Image.Loading
                    }
                }
                Text {
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    text: favorite.getName(favorite.getId(index))
                }
            }
            onClicked: pageStack.push(Qt.resolvedUrl("BeerDescription.qml"), {
                                          beerId: favorite.getId(index),
                                          beerName: favorite.getName(favorite.getId(index)),
                                          beerLabel: favorite.getLabel(favorite.getId(index)),
                                          beerDescription: favorite.getDescription(favorite.getId(index)),
                                          beerAbv: favorite.getAbv(favorite.getId(index)),
                                          beerIbu: favorite.getIbu(favorite.getId(index)),
                                          beerSrm: favorite.getSrm(favorite.getId(index)),
                                          beerOg: favorite.getOg(favorite.getId(index)),
                                          categoryName: favorite.getCategory(favorite.getId(index)),
                                          styleName: favorite.getStyle(favorite.getId(index)),
                                      })
        }
    }

    Timer {
        running: page.status === PageStatus.Active
        interval: 100
        onTriggered: if (listLength !== favorite.getLength()) pageStack.replace(Qt.resolvedUrl("FavoritesList.qml"));
    }

}
