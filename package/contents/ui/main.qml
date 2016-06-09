import QtQuick 2.2
import QtQuick.Layouts 1.3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kcoreaddons 1.0 as KCoreAddons
import org.kde.plasma.components 2.0 as PlasmaComponents


Item {
    id: main

    property Component cr: CompactRepresentation {}
    property Component fr: FullRepresentation {}

    property var supportedTranslateLanguages: {}
    property int plasmoidFormFactor
    property string currentSource
    property var preSwapSource: null

    Plasmoid.compactRepresentation: cr
    Plasmoid.fullRepresentation: fr
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
}
