import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import '../code/xhr.js' as XHR
import "../code/yandex-translate.js" as YaTr

Item {
    id: fullRepresentation
    Layout.minimumWidth: Plasmoid.formFactor == PlasmaCore.Types.Vertical ? 200 : 720
    Layout.minimumHeight: Plasmoid.formFactor == PlasmaCore.Types.Vertical ?  640 : 200

    GridLayout {
        id: layout
        anchors.fill: parent
        columns: 7
        rows: 5
        anchors.margins: 10
        rowSpacing: 5
        columnSpacing: 5

        Label {
            text: i18n("Source:")
            Layout.columnSpan: 4
            Layout.fillWidth: true
        }

        Label {
            text: i18n("Translation:")
            Layout.columnSpan: 3
            Layout.fillWidth: true
        }

        ComboBox {
            id: srcLanguageSelect
            textRole: "text"
            Layout.columnSpan: 3
            Layout.fillWidth: true
            model: ListModel {
                id: srcLanguage
            }

            onCurrentIndexChanged: function() {
                if (!model.count) {
                    return
                }

                var newlang = model.get(currentIndex).code
                var olddest = dstLanguage.count ? dstLanguage.get(dstLanguageSelect.currentIndex).code : undefined

                if (olddest == newlang && main.currentSource && !main.preSwapSource) {
                    main.preSwapSource = main.currentSource
                }
                dstLanguage.clear()
                var dst_idx = 0
                Object.keys(main.supportedTranslateLanguages).forEach(function(item) {
                    // NOTE: will skip item == olddest too if olddest == newlang
                    if (item == newlang) {
                        return
                    }

                    dstLanguage.append({text : main.supportedTranslateLanguages[item], code: item})
                    if (item == main.preSwapSource || item == olddest) {
                        dst_idx = dstLanguage.count - 1
                        main.preSwapSource = null
                    }
                })
                dstLanguageSelect.currentIndex = dst_idx
                main.currentSource = newlang
                sourceText.editingFinished()
            }
        }

        Button {
            id: swapLangBtn
            text: "⇔";
            onClicked: swapLanguages()
            Layout.fillWidth: true
        }

        ComboBox {
            id: dstLanguageSelect
            textRole: "text"
            Layout.columnSpan: 3
            Layout.fillWidth: true
            model: ListModel {
                id: dstLanguage
            }
            onCurrentIndexChanged: sourceText.editingFinished()
        }

        TextArea {
            id: sourceText
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan: main.plasmoidFormFactor == PlasmaCore.Types.Vertical ? 7 : 3
            onEditingFinished: doTranslate()
        }

        GroupBox {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan: main.plasmoidFormFactor == PlasmaCore.Types.Vertical ? 7 : 1

            Button {
                id: swapTextBtn
                anchors.centerIn: parent
                Layout.fillWidth: true
                text: "⇐"
                onClicked: function() {
                    if (translatedText.text) {
                        sourceText.text = translatedText.text
                        translatedText.text = ''
                    }
                    swapLanguages()
                }
            }
        }

        TextArea {
            id: translatedText
            Layout.columnSpan: main.plasmoidFormFactor == PlasmaCore.Types.Vertical ? 7 : 3
            readOnly: true
            Layout.fillWidth: true
            Layout.fillHeight: true
        }


        ScrollView {
            id: suggestionBox
            Layout.columnSpan: 7
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: false

            Text {
                id: suggestionText
                wrapMode: Text.Wrap
                width: suggestionBox.width - 10
            }
        }

        Button {
            id: submitBtn
            text: i18n("Translate")
            onClicked: doTranslate()
            Layout.columnSpan: 7
            Layout.fillWidth: true
        }

        Text {
            text: i18n("Powered by <a href='http://translate.yandex.com/'>Yandex.Translate</a>")
            Layout.columnSpan: 6
            Layout.fillWidth: true
            onLinkActivated: Qt.openUrlExternally(link)
        }

        Image {
            source: '../images/yandex_eng_logo.svg'
            Layout.columnSpan: 1
            Layout.maximumHeight: 40
            Layout.maximumWidth: 101
        }
    }

    function doTranslate() {
        var text = sourceText.text
        if (!srcLanguageSelect.count || !dstLanguageSelect.count) {
            return
        }

        if (!text) {
            translatedText.text = ''
            return
        }

        YaTr.translate(text, srcLanguage.get(srcLanguageSelect.currentIndex).code,
                       dstLanguage.get(dstLanguageSelect.currentIndex).code, translationReceived)
    }

    function swapLanguages() {
        var current_dest = dstLanguage.get(dstLanguageSelect.currentIndex).code
        var current_src = srcLanguage.get(srcLanguageSelect.currentIndex).code

        main.preSwapSource = current_src
        srcLanguageSelect.currentIndex = Object.keys(main.supportedTranslateLanguages).indexOf(current_dest)
    }

    function translationReceived(data) {
        data.text.forEach(function(item) {
            if (translatedText.text) {
                translatedText.text += '\n'
            }
            translatedText.text = item
        })
    }

    Component.onCompleted: {
        YaTr.getSupportedLanguages(function(langinfo) {
            main.plasmoidFormFactor = Plasmoid.formFactor

            var sortObject = function(obj) {
                var sortable = []
                for(var key in obj) {
                    if(obj.hasOwnProperty(key)) {
                        sortable.push([key, obj[key]]);
                    }
                }

                sortable.sort(function(a, b) {
                    return a[1].toLowerCase().localeCompare(b[1].toLowerCase())
                });

                var ret = {}
                sortable.forEach(function(kv) {
                    ret[kv[0]] = kv[1]
                })

                return ret
            }
            main.supportedTranslateLanguages = sortObject(langinfo.langs)

            srcLanguage.clear()
            dstLanguage.clear()
            for (var lang in main.supportedTranslateLanguages) {
                srcLanguage.append({text : main.supportedTranslateLanguages[lang], code: lang})
            }

            var cidx = Object.keys(main.supportedTranslateLanguages).indexOf(Qt.locale().uiLanguages[0].split('-')[0]);
            if (cidx !== -1) {
                srcLanguageSelect.currentIndex = cidx
            }
        })
    }
}

