#ifndef GLOBAL_H
#define GLOBAL_H

#include <QObject>

// 安全加密相关全局变量
class global_security : public QObject
{
    Q_OBJECT

public:
    global_security();

private:
    bool inited = false;         // 系统是否已经初始化
    QString SERVER_RSA_PUBLIC;   // 服务器RSA公钥
    QString LOCAL_RSA_PRIVATE;   // 本地RSA私钥
    QString LOCAL_RSA_PUBLIC;    // 本地RSA公钥
    QString AES_KEY;             // AES通信密钥
    QString TOKEN;               // 通信使用的token
    QString FEATURE;             // 当前系统特征值
    bool Update();               // 安全相关参数更新

public:
    QString getServerRsaPublic();
    QString getLocalRsaPrivate();
    QString getLocalRsaPublic();
    QString getAesKey();
    QString getToken();
    QString getFeature();
    bool Init();                 // 安全相关参数初始化
};

global_security global_Security;

#endif //GLOBAL_H
