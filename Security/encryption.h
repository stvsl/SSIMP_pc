#ifndef ENCRYPTION_H
#define ENCRYPTION_H
#include "Plugins/lib/libcrypto.h"
#include <QCryptographicHash>
#include <QDebug>
#include <QString>
#include <iostream>

using namespace std;

string Xor(string a, string b);
QString XorQ(QString a, QString b);

namespace AES {
string encrypt(string str, string key);
QString encryptQ(QString str, QString key);
string encrypt(string str);
QString encryptQ(QString str);

string decrypt(string ciphertext, string key);
QString decryptQ(QString ciphertext, QString key);
string decrypt(string ciphertext);
QString decryptQ(QString ciphertext);
} // namespace AES

namespace RSA {
string encrypt(string str, string pubkey);
QString encryptQ(QString str, QString pubkey);
string encrypt(string str);
QString encryptQ(QString str);

string decrypt(string Base64str, string prikey);
QString decryptQ(QString Base64str, QString prikey);
string decrypt(string Base64str);
QString decryptQ(QString Base64str);

string generateRSAKey();
QString generateRSAKeyQ();
} // namespace RSA

namespace Base64 {
string encodeStd(string str);
QString encodeQ(QString str);
QByteArray decodeQ(QString str);
} // namespace Base64

namespace SHA256 {
QString hash(QString str);
} // namespace SHA256

#endif // ENCRYPTION_H

namespace CGOSET {
void DisableCgoCheck();
}
