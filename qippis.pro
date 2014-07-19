# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# Twitter4QML
include(./twitter4qml/twitter4qml.pri)

# The name of your application
TARGET = harbour-qippis

CONFIG += sailfishapp

SOURCES += src/qippis.cpp \
    src/twitter4qml.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    translations/*.ts \
    qml/pages/BeerDescription.qml \
    qml/pages/Config.qml \
    qml/pages/FrontPage.qml \
    qml/pages/SearchResults.qml \
    qml/pages/Storage.qml \
    qml/pages/StyleDescription.qml \
    qml/images/noImage.jpg \
    rpm/harbour-qippis.changes.in \
    rpm/harbour-qippis.yaml \
    harbour-qippis.desktop \
    qml/harbour-qippis.qml \
    qml/pages/AboutQippis.qml \
    qml/pages/Favorite.qml \
    qml/pages/FavoritesList.qml \
    qml/pages/Authentication.qml \
    qml/pages/TweetBeer.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

HEADERS += \
    src/twitter4qml.h

