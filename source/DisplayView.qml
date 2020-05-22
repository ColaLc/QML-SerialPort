import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5

Item {
    id:root
    signal sendSettingInfoSignal(int state)
    signal sendDataSignal(string data)

    function clearDisplayText(){
        displaText.clear()
    }

    function setDisplyText(data){
        displaText.insert(displaText.length,data)
    }
    function setOpenBtnText(station){
        openBtn.btnStation=station
        console.log("get result:"+openBtn.btnStation)
    }
    Component.onCompleted: {
        cpp_obj.returnOpenResultSignal.connect(setOpenBtnText)
    }

    GridLayout{
        columns: 2
        anchors.fill: parent
        anchors.margins: 1

        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan:2
            border.width: 1
            border.color: "gray"
            height: 4

            ScrollView {
                anchors.fill:parent
                clip: true
                background: Rectangle {
                    anchors.fill: parent
                    border.color: "gray"
                    radius: 5
                }

                TextArea {
                    id: displaText
                    wrapMode:TextArea.Wrap
                    font.family: "Courier New"
                    font.pointSize: 14

                }
            }

        }

        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.width: 1
            border.color: "gray"
            width: 4

            ScrollView {
                anchors.fill:parent
                clip: true
                TextArea {
                    id:sendView
                    font.pointSize: 15
                    wrapMode:TextArea.Wrap
                    focus: true
                    selectByMouse: true
                }
            }
        }

        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true

            Button{
                id:openBtn
                height: parent.height/2-5
                width: parent.width
                text: btnStation==false?"打开串口":"关闭串口"
                property bool btnStation: false
                font.pointSize :12;
                font.family: "Helvetica";
                font.bold: true
                onClicked: {
                    btnStation=!btnStation
                    if(cpp_obj.readIsMyPortOpen()){
                        emit: sendSettingInfoSignal(0)
                    }
                    else{
                        emit: sendSettingInfoSignal(1)   //1打开  0关闭
                    }
                }
            }

            Button{
                //anchors.bottom: parent
                anchors.bottom: parent.bottom
                height: parent.height/2-5
                width: parent.width
                text: "发送"
                font.pointSize :12;
                font.family: "Helvetica";
                font.bold: true
                enabled: openBtn.btnStation?true:false
                onClicked: {
                    emit: sendDataSignal(sendView.text)
                }

            }
        }
    }
}
