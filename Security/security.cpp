#include "Daemon/global.h"
#include "Utils/tcpnetutils.h"
#include "rsa.h"
#include <QCoreApplication>
#include <QHostInfo>
#include <QNetworkInterface>

bool globalsecurity::inited = false;
QString globalsecurity::AES_KEY = "";
QString globalsecurity::LOCAL_RSA_PRIVATE = "";
QString globalsecurity::LOCAL_RSA_PUBLIC = "";
QString globalsecurity::TOKEN = "";
QString globalsecurity::FEATURE = "";
QString globalsecurity::SERVER_RSA_PUBLIC = "";

bool global_Security::Init() {
  // 创建本地RSA密钥对
  RSA *rsa = RSA_new();
  BIGNUM *bn = BN_new();
  BN_set_word(bn, RSA_F4);
  RSA_generate_key_ex(rsa, KEY_LENGTH, bn, NULL);
  // 生成公钥
  BIO *bio_pub = BIO_new(BIO_s_mem());
  PEM_write_bio_RSAPublicKey(bio_pub, rsa);
  char *pub_key = NULL;
  QString pub_key_str = QString(pub_key);
  // 去掉-----END RSA PUBLIC KEY-----后面的信息
  pub_key_str = pub_key_str.mid(
      0, pub_key_str.indexOf("-----END RSA PUBLIC KEY-----") + 29);
  globalsecurity::LOCAL_RSA_PUBLIC = pub_key_str;
  // 生成私钥
  BIO *bio_pri = BIO_new(BIO_s_mem());
  PEM_write_bio_RSAPrivateKey(bio_pri, rsa, NULL, NULL, 0, NULL, NULL);
  char *pri_key = NULL;
  QString pri_key_str = QString(pri_key);
  // 去掉-----END RSA PUBLIC KEY-----后面的信息
  pri_key_str = pri_key_str.mid(
      0, pri_key_str.indexOf("-----END RSA PRIVATE KEY-----") + 30);
  globalsecurity::LOCAL_RSA_PRIVATE = pri_key_str;
  // 获取服务器RSA公钥
  tcpnetutils *tnu = new tcpnetutils();
  tnu->get("/encryption/rsapubkey");
  QJsonParseError jsonError;
  QJsonDocument json = QJsonDocument::fromJson(tnu->exec(), &jsonError);
  if (jsonError.error != QJsonParseError::NoError) {
    qDebug() << "json解析失败";
    return false;
  }
  QJsonObject jsonObj = json.object();
  globalsecurity::SERVER_RSA_PUBLIC = jsonObj.value("pubkey").toString();
  // 发送本地公钥以及特征密码给服务器
  QString hostName = QHostInfo::localHostName();
  QString deviceType = QSysInfo::productType();
  QString deviceName = QSysInfo::machineHostName();
  QString strIpAddress;
  QList<QHostAddress> ipAddressesList = QNetworkInterface::allAddresses();
  // 获取第一个本主机的IPv4地址
  int nListSize = ipAddressesList.size();
  for (int i = 0; i < nListSize; ++i) {
    if (ipAddressesList.at(i) != QHostAddress::LocalHost &&
        ipAddressesList.at(i).toIPv4Address()) {
      strIpAddress = ipAddressesList.at(i).toString();
      break;
    }
  }
  // 如果没有找到，则以本地IP地址为IP
  if (strIpAddress.isEmpty()) {
    strIpAddress = QHostAddress(QHostAddress::LocalHost).toString();
  }
  // 获取设备MAC地址
  QList<QNetworkInterface> nets =
      QNetworkInterface::allInterfaces(); // 获取所有网络接口列表
  int nCnt = nets.count();
  QString strMacAddr = "";
  for (int i = 0; i < nCnt; i++) {
    // 如果此网络接口被激活并且正在运行并且不是回环地址，则就是要找的Mac地址
    if (nets[i].flags().testFlag(QNetworkInterface::IsUp) &&
        nets[i].flags().testFlag(QNetworkInterface::IsRunning) &&
        !nets[i].flags().testFlag(QNetworkInterface::IsLoopBack)) {
      strMacAddr = nets[i].hardwareAddress();
      break;
    }
  }
  QString dbpart256 =
      QString(QCryptographicHash::hash(strIpAddress.toUtf8(),
                                       QCryptographicHash::Sha256)
                  .toHex());
  // 将设备信息整合成字符串
  QString sysstr = hostName + deviceType + deviceName + strIpAddress +
                   strMacAddr + "SSIMP" +
                   QCoreApplication::applicationVersion() + dbpart256;
  // 计算syssstr的md5值
  QByteArray md5 =
      QCryptographicHash::hash(sysstr.toUtf8(), QCryptographicHash::Md5);
  // 将md5值转换为16进制字符串
  QString dbpasswd = md5.toHex();
  // 计算一个系统特征值
  // 获取当前时间
  QDateTime current_date_time = QDateTime::currentDateTime();
  // 随机生成一个20位数的随机数
  QString random_str = QString::number(rand() % 100000000000);
  // 计算特征值
  globalsecurity::FEATURE =
      QCryptographicHash::hash(
          (dbpasswd + current_date_time.toString("yyyyMMddhhmmss") + random_str)
              .toUtf8(),
          QCryptographicHash::Md5)
          .toHex();
  return true;
}

QString global_Security::getAesKey() { return globalsecurity::AES_KEY; }

QString global_Security::getToken() { return globalsecurity::TOKEN; }
