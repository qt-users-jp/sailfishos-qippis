import QtQuick 2.0
import Sailfish.Silica 1.0


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

    ListModel {
        id: listModel
    }

    property bool loadingStatus: true

    BusyIndicator {
        anchors.centerIn: parent
        running: loadingStatus
    }

    function search() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "https://api.brewerydb.com/v2/search?q="+ searchWords + "&p=" + pageNumber + "&type=beer&key=" + apiKey + "&format=xml", true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    var results = xhr.responseXML.documentElement.childNodes;
                    for (var i=0; i<results.length; i++) {
                        switch (results[i].nodeName) {
                        case "currentPage": currentPage = results[i].firstChild.nodeValue; break;
                        case "numberOfPages": numberOfPages = results[i].firstChild.nodeValue; break;
                        case "totalResults": totalResults = results[i].firstChild.nodeValue; break;
                        case "data": makeList(results[i].childNodes); break;
                        case "status": statusOfDb = (results[i].firstChild.nodeValue === "success"); break;
                        case "errorMesage": errorMessage = results[i].firstChild.nodeValue; break;
                        default:
                        }
                    }
                } else if (xhr.status === 401) {
                    statusOfDb = false;
                    errorMessage = "Please check API_Key";
                } else {
                    statusOfDb = false;
                    errorMessage = "Something wrong to get the XML data.";
                }
                loadingStatus = false;
            }
        }
        xhr.send();
    }

    function makeList(xmldata) {
        for (var i=0; i<xmldata.length; i++) {
            if (xmldata[i].nodeName === "item") {
                var _beerId = ""; var _beerName = ""; var _beerDescription = "";
                var _beerAbv = ""; var _beerIbu = ""; var _beerSrm = ""; var _beerOg = "";
                var _beerIcon = ""; var _beerLabel = "";
                var _styleId = ""; var _styleName = "";
                var _categoryId = ""; var _categoryName = "";
                var beerItem = xmldata[i].childNodes;
                for (var j=0; j<beerItem.length; j++) {
                    switch (beerItem[j].nodeName) {
                    case "id": _beerId = beerItem[j].firstChild.nodeValue; break;
                    case "name": _beerName = beerItem[j].firstChild.nodeValue; break;
                    case "description": _beerDescription = beerItem[j].firstChild.nodeValue; break;
                    case "abv": _beerAbv = beerItem[j].firstChild.nodeValue; break;
                    case "ibu": _beerIbu = beerItem[j].firstChild.nodeValue; break;
                    case "srm": var srmValue = beerItem[j].childNodes;
                        for (var k=0; k<srmValue.length; k++) {
                            if (srmValue[k].nodeName === "name") _beerSrm = srmValue[k].firstChild.nodeValue;
                        }
                        break;
                    case "og": _beerOg = beerItem[j].firstChild.nodeValue; break;
                    case "labels": var labels = beerItem[j].childNodes;
                        for (var l=0; l<labels.length; l++) {
                            switch (labels[l].nodeName) {
                            case "icon": _beerIcon = labels[l].firstChild.nodeValue; break;
                            case "medium": _beerLabel = labels[l].firstChild.nodeValue; break;
                            default:
                            }
                        }
                        break;
                    case "style": var beerStyle =beerItem[j].childNodes;
                        for (var m=0; m<beerStyle.length; m++) {
                            switch (beerStyle[m].nodeName) {
                            case "id": _styleId = beerStyle[m].firstChild.nodeValue; break;
                            case "name": _styleName = beerStyle[m].firstChild.nodeValue; break;
                            case "category": var beerCategory = beerStyle[m].childNodes;
                                for (var n=0; n<beerCategory.length; n++) {
                                    switch (beerCategory[n].nodeName) {
                                    case "id": _categoryId = beerCategory[n].firstChild.nodeValue; break;
                                    case "name": _categoryName = beerCategory[n].firstChild.nodeValue; break;
                                    default:
                                    }
                                }
                                break;
                            default:
                            }
                        }
                        break;
                    default:
                    }
                }
                listModel.append({
                                     "beerId": _beerId,
                                     "beerName": _beerName,
                                     "beerDescription": _beerDescription,
                                     "beerAbv": _beerAbv,
                                     "beerIbu": _beerIbu,
                                     "beerSrm": _beerSrm,
                                     "beerOg": _beerOg,
                                     "beerIcon": _beerIcon,
                                     "beerLabel": _beerLabel,
                                     "styleId": _styleId,
                                     "styleName": _styleName,
                                     "categoryId": _categoryId,
                                     "categoryName": _categoryName
                                 });
            }
        }
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
                x: Theme.paddingLarge
                spacing: Theme.paddingLarge
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
                    text: beerName
                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
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
                                          apiKey: apiKey
                                      })
        }
        VerticalScrollDecorator {}
    }
}
