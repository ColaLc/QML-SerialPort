#include "myserialport.h"
#include <QSerialPortInfo>
#include <QDebug>
#include <QTimer>

int count=0;
MySerialPort::MySerialPort(QObject *parent) : QObject(parent)
{
    myPort=new QSerialPort;
}

MySerialPort::~MySerialPort()
{
    delete myPort;
}

bool MySerialPort::readIsMyPortOpen()
{
    qDebug()<<myPort->isOpen();
    return myPort->isOpen();

}

void MySerialPort::initPort()
{
    foreach (const QSerialPortInfo &info, QSerialPortInfo::availablePorts())
    {
        qDebug() << "Name : " << info.portName();
        emit portNameSignal(info.portName());
//        qDebug() << "Description : " << info.description();
//        qDebug() << "Manufacturer: " << info.manufacturer();
//        qDebug() << "Serial Number: " << info.serialNumber();
//        qDebug() << "System Location: " << info.systemLocation();
    }
}

void MySerialPort::openPort(QString value)
{
    QStringList list=value.split('/');
    int btnState=list[0].toInt();
    QString port=list[1];

    if(btnState==1)   //1 串口打开标志
    {
        //设置串口名字
        myPort->setPortName(port);
        if(myPort->open(QIODevice::ReadWrite))
        {
            connect(myPort,&QSerialPort::readyRead,this,&MySerialPort::readData_slot);
            qDebug()<<myPort->portName()<<myPort->baudRate()<<myPort->dataBits();
        }
        else
        {

        }

    }
    else
        if(btnState==0)
        {
            myPort->close();
        }
    emit returnOpenResultSignal(myPort->isOpen());

}

void MySerialPort::readData_slot()
{
    QByteArray buff;
    buff=myPort->readAll();
    if(recDataModel==ASIIC_TYPE)  //ASIIC
    {
        emit displayRecDataSignal(buff.data());
    }
    else
    {
        QString str=buff.toHex();
        QString str1;
        for(int i = 0; i < str.length()/2;i++)
        {
            str1 += str.mid(i*2,2) + " ";
        }

        emit displayRecDataSignal(str1);
    }
}

void MySerialPort::writeData(QString s,bool dataModel)
{qDebug()<<myPort->portName()<<myPort->baudRate()<<myPort->dataBits();
    QByteArray str;
    if(myPort->isOpen())
    {
        if(dataModel==ASIIC_TYPE)
        {
            str=s.toLatin1();
        }
        else
        {
            str=QByteArray::fromHex(s.toLatin1());
        }
        myPort->write(str);
    }
    else
    {
        //qDebug()<<"not open";
    }
}


void MySerialPort::setPort()
{

}

void MySerialPort::setBaud(int baud)
{
    myPort->setBaudRate(baud);
}

void MySerialPort::setDataBase(int dataBase)
{
    if(dataBase==5)
        myPort->setDataBits(QSerialPort::Data5);
    else if(dataBase==6)
        myPort->setDataBits(QSerialPort::Data6);
    else if(dataBase==7)
        myPort->setDataBits(QSerialPort::Data7);
    else if(dataBase==8)
        myPort->setDataBits(QSerialPort::Data8);

}


