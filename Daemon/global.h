#ifndef GLOBAL_H
#define GLOBAL_H

#include <QObject>
#include <QUrl>

// 安全加密相关全局变量
namespace globalsecurity
{

  extern bool inited;               // 系统是否已经初始化
  extern QString SERVER_RSA_PUBLIC; // 服务器RSA公钥
  extern QString LOCAL_RSA_PRIVATE; // 本地RSA私钥
  extern QString LOCAL_RSA_PUBLIC;  // 本地RSA公钥
  extern QString AES_KEY;           // AES通信密钥
  extern QString TOKEN;             // 通信使用的token
  extern QString FEATURE;           // 当前系统特征值
};                                  // namespace globalsecurity

class global_Security : QObject
{
  Q_OBJECT
public:
  static QString getServerRsaPublic();
  static QString getLocalRsaPrivate();
  static QString getLocalRsaPublic();
  static QString getAesKey();
  static QString getToken();
  static QString getFeature();
  static bool Update(); // 安全相关参数更新
  static bool Init();   // 安全相关参数初始化
};

// 系统全局变量
namespace global
{
  Q_GLOBAL_STATIC(QUrl, SERVER_URL, ("http://127.0.0.1:6521")); // 服务器地址
};                                                              // namespace global

#endif
