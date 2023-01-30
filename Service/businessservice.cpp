#include "businessservice.h"
#include "Utils/tcpnetutils.h"
#include "Utils/npost.h"
#include "Security/encryption.h"

AccountService::AccountService(QObject *parent) : QObject(parent)
{
}

QString AccountService::Login(const QString &id, const QString &password)
{
    TcpPost *post = new TcpPost("/api/account/admin/login");
    post->addParam("id", AES::encryptQ(id));
    post->addParam("passwd", AES::encryptQ(SHA256::hash(password)));
    TcpNetUtils *net = new TcpNetUtils(post);
    QObject::connect(net, &TcpNetUtils::requestFinished, [=]()
                     { qDebug() << "11"; });
    return "Login";
}

QString AccountService::Register(QString id, QString password)
{
    return "Register";
}