import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: compactRepresentation
    anchors.fill: parent
    anchors.margins: 5

    Image {
        source: '../images/yatr.svg'
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        hoverEnabled: true

        onClicked: {
            plasmoid.expanded = !plasmoid.expanded
        }

        PlasmaCore.ToolTipArea {
            id: toolTipArea
            anchors.fill: parent
            active: !plasmoid.expanded
            interactive: true
            icon: Qt.resolvedUrl('../images/yandex_eng_logo.svg')
        }
    }
}
