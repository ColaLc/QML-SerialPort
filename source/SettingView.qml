import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5

Rectangle {
    id:root
    property bool sendRadionBtnStatus: true
    property bool recRadionBtnStatus: true

    function setModel(s){
        myModel.append({s})
    }
    function getSetting(state){
        var value=portComBox.currentText+'/'+baudCombox.currentText+'/'+databaseCombox.currentText
        return value
    }

    onRecRadionBtnStatusChanged:{
        cpp_obj.recDataModel=recRadionBtnStatus
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 10
        anchors.margins: 2
        RowLayout{
            Text {
                text: qsTr("端口  ")
                height: 100
            }
            ComboBox {
                id:portComBox
                Layout.minimumHeight: 30
                Layout.maximumHeight: 30

                model: ListModel{
                    id:myModel
                }

                delegate: ItemDelegate{
                    id:itmdlg
                    height: 30
                    width: parent.width
                    text: modelData
                    background: Rectangle{
                        id:bacRect
                        anchors.fill: parent
                        color:itmdlg.hovered?"#507BF6":"white";
                    }
                }


            }
        }

        RowLayout{
            Text {
                text: qsTr("波特率")
                //Layout.fillHeight: true
            }
            ComboBox {
                id:baudCombox
                Layout.minimumHeight: 30
                Layout.maximumHeight: 30
                model: ["2400","4800", "9600","19200","38400"]
                delegate: ItemDelegate{
                    id:itmdlg1
                    height: 30
                    width: parent.width
                    text: modelData
                    background: Rectangle{
                        anchors.fill: parent
                        color:itmdlg1.hovered?"#507BF6":"white";
                    }
                }
                onCurrentTextChanged: {
                    cpp_obj.setBaud(Number(currentText))
                }
            }
        }
        RowLayout{
            Text {
                text: qsTr("数据位")
                //Layout.fillHeight: true
            }

            ComboBox {
                id:databaseCombox
                Layout.minimumHeight: 30
                Layout.maximumHeight: 30
                model: [ "5", "6", "7", "8"]
                delegate: ItemDelegate{
                    id:itmdlg2
                    height: 30
                    width: parent.width
                    text: modelData
                    background: Rectangle{
                        anchors.fill: parent
                        color:itmdlg2.hovered?"#507BF6":"white";

                    }
                }
                onCurrentTextChanged: {
                    cpp_obj.setDataBase(Number(currentText))
                }
            }
        }

        ColumnLayout{
            GroupBox {
                Layout.columnSpan:2
                Layout.fillWidth: true
                background: Rectangle {
                    anchors.fill: parent
                    Rectangle{
                        border.color: "gray"
                        border.width: 1
                        anchors.topMargin: 5
                        anchors.fill:  parent
                        radius: 10//圆角
                    }

                    Rectangle{
                        id:titleBackground
                        width: title.width
                        height: title.height
                        anchors.top:parent.top
                        x:20

                        Text{
                            id:title
                            text: "发送设置"
                            font.pixelSize: 15
                        }
                    }
                }

                RowLayout{
                    anchors.fill: parent

                    RadioButton{
                        text: "ASCII"
                        font.pointSize :12;
                        font.family: "Helvetica";
                        font.bold: true
                        checked: sendRadionBtnStatus
                        onClicked: {
                            sendRadionBtnStatus=true
                        }
                    }

                    RadioButton{
                        text: "HEX"
                        font.pointSize :12;
                        font.family: "Helvetica";
                        font.bold: true
                        checked: ~sendRadionBtnStatus
                        onClicked: {
                            sendRadionBtnStatus=false
                        }
                    }

                }
            }

            GroupBox {
                id:groupRec
                Layout.columnSpan:2
                Layout.fillWidth: true

                background: Rectangle {
                    anchors.fill: parent
                    Rectangle{
                        border.color: "gray"
                        border.width: 1
                        anchors.topMargin: 5
                        anchors.fill:  parent
                        radius: 10//圆角
                    }
                    Rectangle{
                        id:titleBackground1
                        width: title1.width
                        height: title1.height
                        anchors.top:parent.top
                        x:20

                        Text{
                            id:title1
                            text: "接受设置"
                            font.pixelSize: 15
                        }
                    }
                }

                RowLayout{
                    //anchors.fill:parent
                    RadioButton{
                        text: "ASCII"
                        font.pointSize :12;
                        font.family: "Helvetica";
                        font.bold: true
                        checked: recRadionBtnStatus
                        onClicked: {
                            recRadionBtnStatus=true
                        }
                    }

                    RadioButton{
                        text: "HEX"
                        font.pointSize :12;
                        font.family: "Helvetica";
                        font.bold: true
                        checked: ~recRadionBtnStatus
                        onClicked: {
                            recRadionBtnStatus=false
                        }
                    }
                }
            }
        }      
    }
}

