import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    property string searchWords
    property string apiKey

    BusyIndicator {
        anchors.centerIn: parent
        running: listModel.status == XmlListModel.Loading
    }

    XmlListModel {
        id: listModel
        source: "https://api.brewerydb.com/v2/search?q="+ searchWords + "&type=beer&key=" + apiKey + "&format=xml"
        query: "/root/data/item"
        XmlRole { name: "beerName"; query: "name/string()" }
        XmlRole { name: "beerIcon"; query: "labels/icon/string()" }
        XmlRole { name: "beerId"; query: "id/string()" }
        XmlRole { name: "beerDescription"; query: "description/string()" }
        XmlRole { name: "styleName"; query: "style/name/string()" }
        XmlRole { name: "sytleId"; query: "style/id/string()" }
        XmlRole { name: "categoryName"; query: "style/category/name/string()" }
        XmlRole { name: "categoryId"; query: "style/category/id/string()" }
        XmlRole { name: "beerLabel"; query: "labels/medium/string()" }
        XmlRole { name: "beerAbv"; query: "abv/string()" }
        XmlRole { name: "beerIbu"; query: "ibu/string()" }
        XmlRole { name: "beerSrm"; query: "srm/name/string()" }
        XmlRole { name: "beerOg"; query: "og/string()" }
    }

    SilicaListView {
        id: listView
        model: listModel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Search Results")
        }
        delegate: BackgroundItem {
            id: delegate

            Row {
                x: Theme.paddingLarge
                Image {
                    id: iconImage
                    width: 64
                    height: 64
                    anchors.verticalCenter: parent.verticalCenter
                    source: beerIcon ? beerIcon : "../images/noImage.jpg"
                    BusyIndicator {
                        anchors.centerIn: parent
                        running: iconImage.status == Image.Loading
                    }
                }
                Text {
                    font.pixelSize: Theme.fontSizeLarge
                    textFormat: Text.RichText
                    text: "  " + beerName
                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
            }
//            onClicked: console.log("Clicked " + beerId)
            onClicked: pageStack.push(Qt.resolvedUrl("BeerDescription.qml"), {
                                          beerId: beerId,
                                          beerName: beerName,
                                          beerIcon: beerIcon,
                                          beerLabel: beerLabel,
                                          beerDescription: beerDescription,
                                          beerAbv: beerAbv,
                                          beerIbu: beerIbu,
                                          beerSrm: beerSrm,
                                          beerOg: beerOg,
                                          categoryName: categoryName,
                                          styleName: styleName,
                                          apiKey: apiKey
                                      })
        }
        VerticalScrollDecorator {}
    }
}
