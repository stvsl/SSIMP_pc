#include "businessservice.h"
#include "Utils/tcpnetutils.h"
#include "Utils/npost.h"
#include "Security/encryption.h"

AccountService::AccountService(QObject *parent) : QObject(parent)
{
}

void AccountService::login(const QString &id, const QString &password)
{
    TcpPost *post = new TcpPost("/api/account/admin/login", this);
    QJsonObject body;
    qDebug() << "Login id: " << id << " password: " << password;
    body.insert("id", AES::encryptQ(id));
    QString hashpasswd = SHA256::hash(password);
    body.insert("passwd", AES::encryptQ(hashpasswd));
    body.insert("feature", globalsecurity::FEATURE);
    post->setBody(body);
    TcpNetUtils *net = new TcpNetUtils(post);
    QObject::connect(net, &TcpNetUtils::requestFinished, [=]()
                     {
                         // 获取返回值
                         QJsonDocument resp = net->getResponseBodyJsonDoc();
                         if(resp["code"] != "SE200"){
                            emit loginFailed();
                         } 
                         else {
                            globalsecurity::AES_KEY = resp["token"].toString();
                            emit loginSuccess();
                            qDebug() << "token" << globalsecurity::AES_KEY;
                         } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

QString AccountService::regist(QString id, QString password)
{
    return "Register";
}

EmployeeService::EmployeeService(QObject *parent) : QObject(parent)
{
}

void EmployeeService::addEmployee()
{
    emit addEmployeeSuccess();
}

void EmployeeService::deleteEmployee(QString name)
{
    emit deleteEmployeeSuccess();
}

void EmployeeService::updateEmployee(QString name, QString password)
{
    emit updateEmployeeSuccess();
}

void EmployeeService::queryEmployee(QString name)
{
    emit queryEmployeeSuccess();
}

void EmployeeService::queryEmployStatus()
{
    emit queryEmployeeSuccess();
}

// Path: Service/businessservice.h
