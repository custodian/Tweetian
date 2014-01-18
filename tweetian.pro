TEMPLATE = app
TARGET = tweetian

# Application version
VERSION = 1.8.3
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

win32 {
    # Define QMLJSDEBUGGER to allow debugging of QML in debug builds
    # (This might significantly increase build time)
    QMLJSDEBUGGER_PATH = C:\QtSDK\QtCreator\share\qtcreator\qml\qmljsdebugger
    DEFINES += QMLJSDEBUGGER
}


# Qt Library
QT += network

# Qt Mobility Library
maemo5 {
    CONFIG += mobility12 qdbus
    MOBILITY += location
} else {
    CONFIG += mobility
    MOBILITY += feedback location gallery
}


HEADERS += \
    src/qmlutils.h \
    src/thumbnailcacher.h \
    src/userstream.h \
    src/networkmonitor.h \
    src/imageuploader.h

SOURCES += main.cpp \
    src/qmlutils.cpp \
    src/thumbnailcacher.cpp \
    src/userstream.cpp \
    src/networkmonitor.cpp \
    src/imageuploader.cpp

simulator{
    qml_harmattan.source = qml/tweetian-harmattan
    qml_harmattan.target = qml
    qml_symbian.source = qml/tweetian-symbian
    qml_symbian.target = qml
    DEPLOYMENTFOLDERS = qml_harmattan qml_symbian

    RESOURCES += qml-harmattan.qrc qml-symbian.qrc

    HEADERS += src/harmattanutils.h src/symbianutils.h
    SOURCES += src/harmattanutils.cpp src/symbianutils.cpp
}

contains(MEEGO_EDITION,harmattan){
    QT += dbus
    CONFIG += qdeclarative-boostable shareuiinterface-maemo-meegotouch share-ui-plugin share-ui-common mdatauri
    DEFINES += Q_OS_HARMATTAN
    RESOURCES += qml-harmattan.qrc

    include(notifications/notifications.pri)
    splash.files = splash/tweetian-splash-portrait.jpg splash/tweetian-splash-landscape.jpg
    splash.path = /opt/tweetian/splash
    INSTALLS += splash

    HEADERS += src/tweetianif.h src/harmattanutils.h
    SOURCES += src/tweetianif.cpp src/harmattanutils.cpp
}

maemo5 {
    qml_harmattan.source = qml/tweetian-harmattan
    qml_harmattan.target = qml

    DEPLOYMENTFOLDERS += qml_harmattan

    DEFINES += Q_OS_MAEMO

    RESOURCES += qml-harmattan.qrc

    HEADERS += src/harmattanutils.h
    SOURCES += src/harmattanutils.cpp

    HEADERS += src/tweetianif.h
    SOURCES += src/tweetianif.cpp
}

symbian{
    TARGET = tweetian_0xA00158E5
    TARGET.UID3 = 0xA00158E5
    TARGET.CAPABILITY += NetworkServices Location LocalServices ReadUserData WriteUserData
    TARGET.EPOCHEAPSIZE = 0x40000 0x4000000

    CONFIG += qt-components
    vendorinfo += "%{\"Dickson\"}" ":\"Dickson\""
    my_deployment.pkg_prerules = vendorinfo
    DEPLOYMENT += my_deployment
    DEPLOYMENT.display_name = Tweetian
    ICON = Tweetian.svg
    RESOURCES += qml-symbian.qrc

    # Symbian have a different syntax
    DEFINES -= APP_VERSION=\\\"$$VERSION\\\"
    DEFINES += APP_VERSION=\"$$VERSION\"

    HEADERS += src/symbianutils.h
    SOURCES += src/symbianutils.cpp

    LIBS += -lavkon -lapgrfx -leikcore -lcone -lapmime
}

OTHER_FILES += qtc_packaging/debian_harmattan/* \
    i18n/tweetian_*.ts \
    tweetian.desktop \
    tweetian_harmattan.desktop \
    README.md \
    qtc_packaging/debian_fremantle/rules \
    qtc_packaging/debian_fremantle/README \
    qtc_packaging/debian_fremantle/copyright \
    qtc_packaging/debian_fremantle/control \
    qtc_packaging/debian_fremantle/compat \
    qtc_packaging/debian_fremantle/changelog

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
