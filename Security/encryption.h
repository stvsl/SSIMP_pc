#ifndef ENCRYPTION_H
#define ENCRYPTION_H
#include "Daemon/global.h"
#include "Plugins/lib/libcrypto.h"
#include <QDebug>
#include <QString>
#include <iostream>

using namespace std;

namespace AES
{
    string encrypt(string str, string key);
    QString encryptQ(QString str, QString key);
    string encrypt(string str);
    QString encryptQ(QString str);

    string decrypt(string ciphertext, string key);
    QString decryptQ(QString ciphertext, QString key);
    string decrypt(string ciphertext);
    QString decryptQ(QString ciphertext);
} // namespace AES

namespace RSA
{
    string encrypt(string str, string pubkey);
    QString encryptQ(QString str, QString pubkey);
    string encrypt(string str);
    QString encryptQ(QString str);

    string decrypt(string str, string prikey);
    QString decryptQ(QString str, QString prikey);
    string decrypt(string str);
    QString decryptQ(QString str);

    string generateRSAKey();
    QString generateRSAKeyQ();
} // namespace RSA

#endif // ENCRYPTION_H
