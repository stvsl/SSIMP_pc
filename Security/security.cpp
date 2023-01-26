/*
 * @Author: stvsl
 * @Date: 2023-01-17 17:08:17
 * @Last Modified by: stvsl
 * @Last Modified time: 2023-01-17 17:08:41
 * @Description: 安全模块
 */

#include "Daemon/global.h"
#include "Utils/tcpnetutils.h"
#include <QCoreApplication>
#include <QHostInfo>
#include <QNetworkInterface>
#include <Utils/npost.h>
#include <QObject>

bool globalsecurity::inited = false;
QString globalsecurity::AES_KEY = "";
QString globalsecurity::LOCAL_RSA_PRIVATE = "";
QString globalsecurity::LOCAL_RSA_PUBLIC = "";
QString globalsecurity::TOKEN = "";
QString globalsecurity::FEATURE = "";
QString globalsecurity::SERVER_RSA_PUBLIC = "";

bool Init_State_2();
bool Init_State_3();
/***
 *  计算本地RSA公钥和私钥，获取服务器的RSA公钥
 */
bool global_Security::Init()
{

  qDebug() << "RSA密钥对生成成功";
  qDebug().noquote() << "本地RSA私钥：" << globalsecurity::LOCAL_RSA_PRIVATE;
  qDebug().noquote() << "本地RSA公钥：" << globalsecurity::LOCAL_RSA_PUBLIC;

  // 获取服务器RSA公钥
  TcpNetUtils *net = new TcpNetUtils(new TcpGet("/api/encryption/rsapubkey"));
  connect(net, &TcpNetUtils::requestErrorHappen, [=]()
          { globalsecurity::inited = false; 
            qDebug() << "服务器RSA公钥获取失败"; });
  connect(net, &TcpNetUtils::requestFinished, [=]()
          {
    globalsecurity::SERVER_RSA_PUBLIC =
        net->getResponseBodyJsonDoc()["pubkey"].toString();
    globalsecurity::inited = Init_State_2(); });

  net->sendRequest();
  return globalsecurity::inited;
}

/***
 * 计算自身特征值的相关操作
 */
bool Init_State_2()
{
  QString hostName = QHostInfo::localHostName();
  QString deviceType = QSysInfo::productType();
  QString deviceName = QSysInfo::machineHostName();
  QString strIpAddress;
  QList<QHostAddress> ipAddressesList = QNetworkInterface::allAddresses();
  // 获取第一个本主机的IPv4地址
  int nListSize = ipAddressesList.size();
  for (int i = 0; i < nListSize; ++i)
  {
    if (ipAddressesList.at(i) != QHostAddress::LocalHost &&
        ipAddressesList.at(i).toIPv4Address())
    {
      strIpAddress = ipAddressesList.at(i).toString();
      break;
    }
  }
  // 如果没有找到，则以本地IP地址为IP
  if (strIpAddress.isEmpty())
  {
    strIpAddress = QHostAddress(QHostAddress::LocalHost).toString();
  }
  // 获取设备MAC地址
  QList<QNetworkInterface> nets =
      QNetworkInterface::allInterfaces(); // 获取所有网络接口列表
  int nCnt = nets.count();
  QString strMacAddr = "";
  for (int i = 0; i < nCnt; i++)
  {
    // 如果此网络接口被激活并且正在运行并且不是回环地址，则就是要找的Mac地址
    if (nets[i].flags().testFlag(QNetworkInterface::IsUp) &&
        nets[i].flags().testFlag(QNetworkInterface::IsRunning) &&
        !nets[i].flags().testFlag(QNetworkInterface::IsLoopBack))
    {
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
  // 计算本地AES密钥片段1
  globalsecurity::AES_KEY =
      QCryptographicHash::hash((dbpasswd +
                                current_date_time.toString("yyyyMMddhhmmss") +
                                random_str + globalsecurity::FEATURE)
                                   .toUtf8(),
                               QCryptographicHash::Sha256)
          .toHex();
  return Init_State_3();
}

bool Init_State_3()
{
  // 向服务器发送POST请求，获取AES密钥
  QJsonObject json;
  qDebug().noquote() << "服务器RSA公钥:\n"
                     << globalsecurity::SERVER_RSA_PUBLIC;
  // json.insert("feature", rsaPubEncrypt(globalsecurity::FEATURE,
  //                                      globalsecurity::SERVER_RSA_PUBLIC));
  // json.insert("pubkey", rsaPubEncrypt(globalsecurity::LOCAL_RSA_PUBLIC,
  //                                     globalsecurity::SERVER_RSA_PUBLIC));
  // json.insert("aesp", rsaPubEncrypt(globalsecurity::AES_KEY,
  //                                   globalsecurity::SERVER_RSA_PUBLIC));
  TcpPost *post = new TcpPost("/api/encryption/rsatoaes");
  post->setHeader("Content-Type", "application/json");
  post->setBody(json);
  TcpNetUtils *net = new TcpNetUtils(post);
  QObject::connect(net, &TcpNetUtils::requestFinished, [=]()
                   { globalsecurity::AES_KEY =
                         net->getResponseBodyJsonDoc()["aesp2"].toString();
                        //  globalsecurity::AES_KEY =
                        //      rsaPriDecryptWithBase64(globalsecurity::AES_KEY,
                        //                    globalsecurity::LOCAL_RSA_PRIVATE);
                         qDebug().noquote() << "AES协议密钥:\n"
                                            << globalsecurity::AES_KEY; });
  QObject::connect(net, &TcpNetUtils::requestErrorHappen, [=]()
                   {
                     // 连接vctrl静态类的信号
                     QObject::connect(vctrler::m_vctrler,&vctrler::dialogResult,
                                      [=]()
                                      {
                                        vctrler::emergencyExit();
                                      }); });
  net->sendRequest();
  return true;
}

QString global_Security::getAesKey() { return globalsecurity::AES_KEY; }

QString global_Security::getToken() { return globalsecurity::TOKEN; }
