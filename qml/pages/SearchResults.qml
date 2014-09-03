import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0

Page {
    id: page
    property string searchWords
    property int pageNumber
    property string apiKey

    property int currentPage
    property int numberOfPages
    property int totalResults
    property bool statusOfDb: true
    property string errorMessage: ""

    XmlListModel {
        id: dbStatus

        query: "/root"
        XmlRole { name: "currentPage"; query: "currentPage/number()" }
        XmlRole { name: "numberOfPages"; query: "numberOfPages/number()" }
        XmlRole { name: "totalResults"; query: "totalResults/number()" }
        XmlRole { name: "dbStat"; query: "status/string()" }
        XmlRole { name: "errMsg"; query: "errorMessage/string()" }

        onStatusChanged: {
            if ( dbStatus.status === XmlListModel.Ready ) {
                currentPage = dbStatus.get(0).currentPage;
                numberOfPages = dbStatus.get(0).numberOfPages;
                totalResults = dbStatus.get(0).totalResults;
                statusOfDb = (dbStatus.get(0).dbStat === "success");
                errorMessage = dbStatus.get(0).errMsg ? dbStatus.get(0).errMsg:"";
            }
        }
    }

    XmlListModel {
        id: listModel

        xml: dbStatus.xml
        query: "/root/data/item"
        XmlRole { name: "beerId"; query: "id/string()" }
        XmlRole { name: "beerName"; query: "name/string()" }
        XmlRole { name: "beerDescription"; query: "description/string()" }
        XmlRole { name: "beerAbv"; query: "abv/string()" }
        XmlRole { name: "beerIbu"; query: "ibu/string()" }
        XmlRole { name: "beerSrm"; query: "srm/name/string()" }
        XmlRole { name: "beerOg"; query: "og/string()" }
        XmlRole { name: "beerIcon"; query: "labels/icon/string()" }
        XmlRole { name: "beerLabel"; query: "labels/medium/string()" }
        XmlRole { name: "styleId"; query: "style/id/string()" }
        XmlRole { name: "styleName"; query: "style/name/string()" }
        XmlRole { name: "categoryId"; query: "style/category/id/string()" }
        XmlRole { name: "categoryName"; query: "style/category/string()" }
        XmlRole { name: "breweryName"; query: "breweries/item/name/string()" }
    }

    property bool loadingStatus: true

    BusyIndicator {
        anchors.centerIn: parent
        running: loadingStatus
    }

    function search() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "https://api.brewerydb.com/v2/search?q=%1&p=%2&type=beer&withBreweries=Y&key=%3&format=xml".arg(searchWords).arg(pageNumber).arg(apiKey), true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                switch (xhr.status) {
                case 200:
                    dbStatus.xml = xhr.responseText;
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
                loadingStatus = false;
            }
        }
        xhr.send();
    }

    Component.onCompleted: search();

    SilicaListView {
        id: listView
        model: listModel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Page: %1/%2").arg(currentPage).arg(numberOfPages)
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Previous Page")
                onClicked: {
                    if ( currentPage > 1) {
                        pageNumber--;
                        pageStack.replace(Qt.resolvedUrl("SearchResults.qml"), {
                                              searchWords: searchWords,
                                              pageNumber: pageNumber,
                                              apiKey: apiKey
                                          })
                    }
                }
            }
        }

        PushUpMenu {
            MenuItem {
                text: qsTr("Next Page")
                onClicked: {
                    if ( currentPage < numberOfPages) {
                        pageNumber++;
                        pageStack.replace(Qt.resolvedUrl("SearchResults.qml"), {
                                              searchWords: searchWords,
                                              pageNumber: pageNumber,
                                              apiKey: apiKey
                                          })
                    }
                }
            }
        }

        ViewPlaceholder {
            enabled: !statusOfDb
            text: errorMessage
        }

        delegate: BackgroundItem {
            id: delegate

            Row {
                width: page.width
                x: Theme.paddingLarge
                spacing: Theme.paddingLarge
                Image {
                    id: iconImage
                    width: 72
                    height: 72
                    anchors.verticalCenter: parent.verticalCenter
                    source: beerIcon ? beerIcon : "../images/noImage.png"
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
                        text: beerName
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
                    Text {
                        id: brewery
                        font.pixelSize: Theme.fontSizeExtraSmall
                        textFormat: Text.RichText
                        text: breweryName
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
                }
            }
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
                                          breweryName: breweryName,
                                          apiKey: apiKey
                                      })
        }
        VerticalScrollDecorator {}
    }
}
