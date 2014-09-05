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
                    width: 72
                    height: 72
                    anchors.verticalCenter: parent.verticalCenter
                    source: favorite.getIcon(favorite.getId(index)) ? favorite.getIcon(favorite.getId(index)) : "../images/noImage.png"
                    BusyIndicator {
                        anchors.centerIn: parent
                        running: iconImage.status == Image.Loading
                    }
                }
                Column {
                    id: names
                    width: page.width - iconImage.width
                    height: iconImage.height
                    Text {
                        id: beer
                        height: names.height - brewery.height
                        font.pixelSize: Theme.fontSizeLarge
                        textFormat: Text.RichText
                        text: favorite.getName(favorite.getId(index))
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
                    Text {
                        id: brewery
                        font.pixelSize: Theme.fontSizeExtraSmall
                        textFormat: Text.RichText
                        text: favorite.getBrewery(favorite.getId(index))
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
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
                                          breweryName: favorite.getBrewery(favorite.getId(index)),
                                          categoryId: favorite.getCatId(favorite.getId(index)),
                                          styleId: favorite.getStyId(favorite.getId(index)),
                                          breweryId: favorite.getBrewId(favorite.getId(index))
                                      })
        }
    }

    Timer {
        running: page.status === PageStatus.Active
        interval: 100
        onTriggered: if (listLength !== favorite.getLength()) pageStack.replace(Qt.resolvedUrl("FavoritesList.qml"));
    }

}
