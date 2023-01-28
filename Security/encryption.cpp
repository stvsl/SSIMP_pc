#include "encryption.h"
#include "Daemon/global.h"
namespace AES
{
  string encrypt(string str, string key)
  {
    GoString str_ = {str.c_str(), (long int)str.length()};
    GoString key_ = {key.c_str(), (long int)key.length()};
    GoString ret_ = GoAESEncrypt(str_, key_);
    string ret = string(ret_.p, ret_.n);
#if ENCRYPT_ERR_DEBUG == 1
    cout << endl
         << "\033[1;33m"
         << "**************RSA加密**************" << endl;
    cout << "原文： " << str << endl;
    cout << "密钥： " << key << endl;
    cout << "密文： " << ret << endl;
    cout << "**********************************" << endl
         << "\033[0m" << endl;
#endif
    return Base64::encodeStd(ret);
  }

  QString encryptQ(QString str, QString key)
  {
    QByteArray strbyte = str.toUtf8();
    QByteArray keybyte = key.toUtf8();
    string str_ = strbyte.toStdString();
    string key_ = keybyte.toStdString();
    string ret_ = encrypt(str_, key_);
    QString ret = QString::fromStdString(ret_);
    return ret;
  }

  string encrypt(string str)
  {
    QByteArray _key_ = global_Security::getAesKey().toUtf8();
    string key_ = _key_.toStdString();
    return encrypt(str, key_);
  }

  QString encryptQ(QString str)
  {
    return encryptQ(str, global_Security::getAesKey());
  }

  string decrypt(string ciphertext, string key)
  {
    GoString ciphertext_ = {ciphertext.c_str(), (long int)ciphertext.length()};
    GoString key_ = {key.c_str(), (long int)key.length()};
    GoString ret_ = GoAESDecrypt(ciphertext_, key_);
    string ret = string(ret_.p, ret_.n);
#if ENCRYPT_ERR_DEBUG == 1
    cout << endl
         << "\033[1;33m"
         << "**************RSA解密**************" << endl;
    cout << "密文： " << ciphertext << endl;
    cout << "密钥： " << key << endl;
    cout << "原文： " << ret << endl;
    cout << "**********************************" << endl
         << "\033[0m << endl";
#endif
    return ret;
  }

  QString decryptQ(QString ciphertext, QString key)
  {
    QByteArray ciphertextbyte = ciphertext.toUtf8();
    QByteArray keybyte = key.toUtf8();
    string ciphertext_ = ciphertextbyte.toStdString();
    string key_ = keybyte.toStdString();
    string ret_ = decrypt(ciphertext_, key_);
    QString ret = QString::fromStdString(ret_);
    return ret;
  }

  string decrypt(string ciphertext)
  {
    QByteArray _key_ = globalsecurity::AES_KEY.toUtf8();
    string key_ = _key_.toStdString();
    return decrypt(ciphertext, key_);
  }

  QString decryptQ(QString ciphertext)
  {
    return decryptQ(ciphertext, globalsecurity::AES_KEY);
  }

} // namespace AES

namespace RSA
{
  string encrypt(string str, string pubkey)
  {
    GoString str_ = {str.c_str(), (long int)str.length()};
    GoString pubkey_ = {pubkey.c_str(), (long int)pubkey.length()};
    GoString ret_ = GoRSAEncrypt(str_, pubkey_);
    string ret = string(ret_.p, ret_.n);
#if ENCRYPT_ERR_DEBUG == 1
    cout << endl
         << "\033[1;33m"
         << "**************RSA加密**************" << endl;
    cout << "原文： " << str << endl;
    cout << "密钥： " << pubkey << endl;
    cout << "密文： " << ret << endl;
    cout << "**********************************" << endl
         << "\033[0m";
#endif
    return Base64::encodeStd(ret);
  }

  QString encryptQ(QString str, QString pubkey)
  {
    QByteArray strbyte = str.toUtf8();
    QByteArray pubkeybyte = pubkey.toUtf8();
    string str_ = strbyte.toStdString();
    string pubkey_ = pubkeybyte.toStdString();
    string ret_ = encrypt(str_, pubkey_);
    QString ret = QString::fromStdString(ret_);
    return ret;
  }

  string encrypt(string str)
  {
    QByteArray _key_ = globalsecurity::LOCAL_RSA_PUBLIC.toUtf8();
    string key_ = _key_.toStdString();
    return encrypt(str, key_);
  }
  QString encryptQ(QString str)
  {
    return encryptQ(str, globalsecurity::LOCAL_RSA_PUBLIC);
  }

  string decrypt(string str, string prikey)
  {
    GoString str_ = {str.c_str(), (long int)str.length()};
    GoString prikey_ = {prikey.c_str(), (long int)prikey.length()};
    GoString ret_ = GoRSADecrypt(str_, prikey_);
    string ret = string(ret_.p, ret_.n);
#if ENCRYPT_ERR_DEBUG == 1
    cout << endl
         << "\033[1;33m"
         << "**************RSA解密**************" << endl;
    cout << "密文： " << str << endl;
    cout << "密钥： " << prikey << endl;
    cout << "原文： " << ret << endl;
    cout << "**********************************" << endl
         << "\033[0m" << endl;
#endif
    return ret;
  }

  QString decryptQ(QString str, QString prikey)
  {
    QByteArray strbyte = str.toUtf8();
    QByteArray prikeybyte = prikey.toUtf8();
    string str_ = strbyte.toStdString();
    string prikey_ = prikeybyte.toStdString();
    string ret_ = decrypt(str_, prikey_);
    QString ret = QString::fromStdString(ret_);
    return ret;
  }

  string decrypt(string str)
  {
    QByteArray _key_ = globalsecurity::LOCAL_RSA_PRIVATE.toUtf8();
    string key_ = _key_.toStdString();
    return decrypt(str, key_);
  }

  QString decryptQ(QString str) { return decryptQ(str, globalsecurity::LOCAL_RSA_PRIVATE); }

  string generateRSAKey()
  {
    GoString ret_ = GoRSAKey();
    string ret = string(ret_.p, ret_.n);
    return ret;
  }

  QString generateRSAKeyQ()
  {
    GoString ret_ = GoRSAKey();
    string stdret = string(ret_.p, ret_.n);
    QString qret = QString::fromStdString(stdret);
    return qret;
  }
} // namespace RSA

namespace Base64
{
  string encodeStd(string str)
  {
    QByteArray strbyte = QByteArray::fromStdString(str);
    QByteArray strbase64 = strbyte.toBase64();
    string strbase64Std = strbase64.toStdString();
    return strbase64Std;
  }

  QString encodeQ(QString str)
  {
    QByteArray strbyte = str.toUtf8();
    QByteArray strbytebase64 = strbyte.toBase64();
    return QString(strbytebase64);
  }

  QByteArray decodeQ(QString str)
  {
    QByteArray strbyte = str.toUtf8();
    strbyte = QByteArray::fromBase64(strbyte);
    return strbyte;
  }
} // namespace Base64

namespace CGOSET
{
  void DisableCgoCheck()
  {
    CloseCGOWarningEnv();
  }
}