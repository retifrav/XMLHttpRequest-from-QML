import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Window 2.11
import QtQuick.Layouts 1.11

Window {
    id: root
    visible: true
    width: 800
    minimumWidth: 500
    height: 500
    minimumHeight: 200
    title: qsTr("XMLHttpRequest")

    property int fontSize: 18
    property int rectsRadius: 5

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#eee"

        Rectangle {
            anchors.fill: parent
            anchors.margins: 10
            color: background.color

            ColumnLayout {
                anchors.fill: parent

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    border.width: 1
                    radius: rectsRadius

                    ScrollView {
                        anchors.fill: parent
                        TextArea {
                            id: results
                            //anchors.fill: parent
                            padding: 10
                            font.pixelSize: fontSize
                            font.family: "Courier"
                            textFormat: TextEdit.RichText
                            wrapMode: TextArea.Wrap
                            selectByMouse: true
                            readOnly: true
                        }
                        visible: !progressBar.visible
                    }
                    Rectangle {
                        id: progressBar
                        anchors.fill: parent
                        color: background.color
                        ProgressBar {
                            anchors.fill: parent
                            indeterminate: true
                        }
                        visible: false
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: url.height + 15
                    border.width: 1
                    radius: rectsRadius
                    TextInput {
                        id: url
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        clip: true
                        leftPadding: 10
                        rightPadding: 10
                        text: "http://0.0.0.0:5000/api/values"
                        color: "blue"
                        horizontalAlignment: TextInput.AlignHCenter
                        font.pixelSize: fontSize
                        selectByMouse: true
                    }
                    visible: !progressBar.visible
                }
                Button {
                    id: btn
                    Layout.topMargin: 5
                    Layout.alignment: Qt.AlignCenter
                    text: "Send request"
                    font.pixelSize: fontSize
                    padding: 15
                    background: Rectangle {
                        color: btn.down ? "#bbb" : "#ccc"
                        radius: rectsRadius
                    }
                    visible: !progressBar.visible
                    onClicked: {
                        results.text = "";
                        request(url.text, function (o) {
                            showBusy(false);
                            if (o.status === 200)
                            {
                                //console.log(o.responseText);
                                //results.text = o.responseText;

                                results.text = "[" + dt() + "]<br/><br/>";
                                var jsn = JSON.parse(o.responseText);
                                for(var i in jsn)
                                {
                                    results.text += "<b>" + i + ":</b> "
                                            + jsn[i] + checkTemp(jsn[i])
                                            + "<br/>";
                                }
                            }
                            else
                            {
                                results.text = "Some error has occurred";
                            }
                        });
                    }
                }
            }
        }
    }

    function showBusy(is) {
        if (is === true) {
            progressBar.visible = true;
            //console.log("request has started");
        }
        else {
            progressBar.visible = false;
            //console.log("request has finished");
        }
    }

    // HTTP-request to the URL
    function request(url, callback) {
        showBusy(true);
        var xhr = new XMLHttpRequest();
//        xhr.onerror = (function(myxhr) {
//            xhr.status = 500;
//            //console.log("error");
//            callback(myxhr);
//        })(xhr);
//        xhr.onabort = (function(myxhr) {
//                console.log("aborted");
//        })(xhr);
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
//                console.log(myxhr.readyState);
//                console.log(myxhr.status);
//                console.log(myxhr.statusText);
//                if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED)
//                {
//                    console.log("[Headers]");
//                    console.log(xhr.getAllResponseHeaders ());
//                    console.log("[Last modified]");
//                    console.log(xhr.getResponseHeader("Last-Modified"));
//                    console.log("---");
//                }
                if(myxhr.readyState === 4) { callback(myxhr); }
            }
        })(xhr);

        xhr.open("GET", url);
        xhr.send();
    }

    function dt() {
        return Qt.formatDateTime(new Date(), "dd.MM.yyyy hh:mm:ss");
    }

    function checkTemp(tempValue) {
        if (tempValue >= 18) { return " (<font color='green'>nice</font>)"; }
        else { return " (<font color='red'>not so nice</font>)"; }
    }
}
