var APIKEY = 'trnsl.1.1.20160609T192322Z.d253de700a4353e9.5cb7d711d929eedae68ac3f521e6d3e27253d0cc'

function getSupportedLanguages(callback) {
    XHR.Send({
        method: 'post',
        url: 'https://translate.yandex.net/api/v1.5/tr.json/getLangs?key=%1&ui=%2'.arg(APIKEY).arg(Qt.locale().uiLanguages[0].split('-')[0]),
        success: function(response) {
            var data = JSON.parse(response)
            callback(data)
        }
    })
}

function detectSourceLanguage(src, callback, hint) {
}

function translate(text, src, dest, callback) {
    XHR.Send({
        method: 'post',
        url: 'https://translate.yandex.net/api/v1.5/tr.json/translate?key=%1'.arg(APIKEY),
        data: {
            lang: '%1-%2'.arg(src).arg(dest),
            text: text
        },
        success: function(response) {
            var data = JSON.parse(response)
            callback(data)
        }
    })
}
