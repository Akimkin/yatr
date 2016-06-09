/*
 * Copyright (C) 2016 Denis Akimkin
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 * associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

function Send(config) {
    var noopHandler = function() {}

    var myconfig = {
        method: 'get',
        url: '',
        success: noopHandler,
        error: noopHandler,
        data: {},
        contentType: 'application/x-www-form-urlencoded',
    }

    if (config !== null && typeof config === 'object') {
        for (var k in config) {
            if (myconfig.hasOwnProperty(k)) {
                myconfig[k] = config[k]
            }
        }
    }


    var request = new XMLHttpRequest()
    var datastr = '';
    for (var k in myconfig.data) {
        if (datastr) {
            datastr += '&'
        }

        datastr += k.toString() + '=' + myconfig.data[k].toString()
    }

    var requestUrl = myconfig.url;
    if (myconfig.method == 'get') {
        requestUrl = '%1%2'.arg(requestUrl).arg(datastr ? "?%1".arg(datastr) : "")
    }

    request.open(myconfig.method, requestUrl)
    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            if (request.status && request.status === 200) {
                if (myconfig.success) {
                    myconfig.success(request.responseText)
                }
            } else {
                if (myconfig.error) {
                    myconfig.error(request.status, request)
                }
            }
        }
    }


    if (myconfig.method == 'post') {
        request.setRequestHeader('Content-Type', myconfig.contentType ? myconfig.contentType
                                                             : 'application/x-www-form-urlencoded')
        request.setRequestHeader('Content-Length', datastr ? datastr.length : 0)
        request.send(datastr)
    } else {
        request.send()
    }

}
