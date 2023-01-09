#ifndef AES_H
#define AES_H

#include <QObject>

// AES加密
QString encrypt(QByteArray data);

// AESbyte加密重载
QByteArray encrypt(QByteArray data, QString key);

// AES解密
QString decrypt(QByteArray Data);

// AESbyte解密重载
QByteArray decrypt(QByteArray Data, QString key);

#endif // AES_H
