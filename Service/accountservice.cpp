#include "accountservice.h"
#include "Security/encryption.h"
#include "Utils/npost.h"
#include "Utils/tcpnetutils.h"

AccountService::AccountService(QObject *parent) : QObject(parent) {}

void AccountService::login(const QString &id, const QString &password)
{
  TcpPost *post = new TcpPost("/api/account/admin/login", this);
  QJsonObject body;
  body.insert("id", AES::encryptQ(id));
  QString hashpasswd = SHA256::hash(password);
  body.insert("passwd", AES::encryptQ(hashpasswd));
  body.insert("feature", globalsecurity::FEATURE);
  post->setBody(body);
  TcpNetUtils *net = new TcpNetUtils(post);
  QObject::connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
                   {
    QJsonDocument resp = net->getResponseBodyJsonDoc();
    if (resp["code"] != "SE200") {
      emit loginFailed();
    } else {
      globalsecurity::TOKEN = resp["token"].toString();
      emit loginSuccess();
      qDebug() << "token" << globalsecurity::TOKEN;
    } });
  net->sendRequest();
  net->deleteLater();
  post->deleteLater();
}

QString AccountService::regist(const QString id, const QString password)
{
  return "Register";
}

//    QString name = obj["name"].toString();
// QString idcard = obj["idcard"].isString() ? obj["idcard"].toString() : QString::number(obj["idcard"].toVariant().toLongLong());
// QString telephone = obj["telephone"].isString() ? obj["telephone"].toString() : QString::number(obj["telephone"].toVariant().toLongLong());
// QString address = obj["address"].toString();
// QString avatar = obj["avatar"].toString();
// QString passwd = obj["passwd"].toString();
// QString establishDay = obj["establishDay"].toString();
// QString birthday = obj["birthday"].toString();
// qDebug() << name << idcard << telephone << address << avatar << passwd << establishDay << birthday;