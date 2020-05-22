import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5
import "./source"
import MyCppObject 1.0

ApplicationWindow {
    visible: true
    width: 700
    height: 480
    title: qsTr("Hello World")

    function setPortName( str){
        mySettingView.setModel(str)
    }
    function sendSetting(state){
        var value=state+'/'+mySettingView.getSetting()
        cpp_obj.openPort(value)
    }
    function setRecDisplayData(data){
        myDisPlayView.setDisplyText(data)
    }
    function writeData(data){
        cpp_obj.writeData(data,mySettingView.sendRadionBtnStatus)
    }

    Component.onCompleted: {
        cpp_obj.portNameSignal.connect(setPortName)
        cpp_obj.initPort()
        myDisPlayView.sendSettingInfoSignal.connect(sendSetting)
        myDisPlayView.sendDataSignal.connect(writeData)
        cpp_obj.displayRecDataSignal.connect(setRecDisplayData)
    }

    CppObject{  //c++对象
        id:cpp_obj
    }

    VersionPage{  //版本窗口对象
        id:ver
    }

    header:ToolBar{
        font.pixelSize: 20
        font.bold: true
        RowLayout{
            Button{
                text: "说明"
                onClicked: {
                    ver.visible=true
                }
            }

            Button{
                text: "清除"
                onClicked: {
                    myDisPlayView.clearDisplayText()
                }
            }
        }
    }

    GridLayout{
        anchors.fill: parent
        columns: 2
        columnSpacing: 2
        rowSpacing: 2
        anchors.margins: 7

        Rectangle{
            width: 200
            Layout.fillHeight: true
            height: 5
            border.color: "gray"
            border.width: 1
            //anchors.margins: 1
            SettingView{
                id:mySettingView
                anchors.margins: 2
                anchors.fill: parent
                Layout.fillWidth: false

            }
        }
        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            width: 2
            border.color: "gray"
            border.width: 1
            //显示数据界面
            DisplayView{
                id:myDisPlayView
                anchors.fill: parent
            }
        }


    }

}
