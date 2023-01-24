#include "rsa.h"
#include <QString>
#include <QDebug>
#include <openssl/evp.h>
#include <openssl/pem.h>
#include <openssl/rsa.h>
#include <iostream>

QString rsaPubEncrypt(const QString &strPlainData, const QString &strPubKey)
{
  QByteArray plainData = strPlainData.toUtf8();
  char *plainDataChar = plainData.data();

  QByteArray pubKey = strPubKey.toUtf8();
  uchar *pubKeyChar = (uchar *)pubKey.data();

  std::cout << std::endl
            << "原文: " << plainDataChar << std::endl;
  BIO *bioKey = BIO_new_mem_buf(pubKeyChar, -1);
  // 从 BIO 对象中读取公钥
  EVP_PKEY *rsa = PEM_read_bio_PUBKEY(bioKey, NULL, NULL, NULL);
  if (!rsa)
  {
    qDebug() << "公钥读取失败";
    BIO_free(bioKey);
    return QString();
  }
  // 获取公钥的大小
  int keySize = EVP_PKEY_size(rsa);
  // 为加密后的数据分配内存
  unsigned char *ciphertext = (unsigned char *)malloc(keySize);
  // 加密数据( EVP_PKEY_encrypt)
  // 上下文
  EVP_PKEY_CTX *ctx = EVP_PKEY_CTX_new(rsa, NULL);
  if (!ctx)
  {
    qDebug() << "EVP_PKEY_CTX_new failed";
    BIO_free(bioKey);
    EVP_PKEY_free(rsa);
    free(ciphertext);
    return QString();
  }
  // 初始化上下文
  if (1 != EVP_PKEY_encrypt_init(ctx))
  {
    // 失败时应当进行错误处理
    qDebug() << "EVP_PKEY_encrypt_init failed";
    BIO_free(bioKey);
    EVP_PKEY_free(rsa);
    free(ciphertext);
    EVP_PKEY_CTX_free(ctx);
    return QString();
  }
  // 设置填充方式
  if (1 != EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_PADDING))
  {
    // 失败时应当进行错误处理
    qDebug() << "RSA加密失败,填充错误";
    BIO_free(bioKey);
    EVP_PKEY_free(rsa);
    free(ciphertext);
    EVP_PKEY_CTX_free(ctx);
    return QString();
  }
  // 设置加密后的数据长度
  size_t outlen = keySize;
  // 加密后数据存储
  QByteArray *baEncryptData = new QByteArray();
  // 加密数据
  if (1 != EVP_PKEY_encrypt(ctx, ciphertext, &outlen,
                            (unsigned char *)plainDataChar,
                            strlen(plainDataChar)))
  {
    qDebug() << "\033[33mRSA单次加密失败,进入分片加密模式\033[0m";
    int slice = keySize - 11;
    int count = plainData.length() / slice;
    int remainder = plainData.length() % slice;
    remainder > 0 ? count++ : count;
    qDebug() << "RSA分片加密模式: 总数据量" << plainData.length() << "分片大小 : " << slice
             << "分片数量:"
             << count
             << "余数:"
             << remainder;
    // 分段加密
    for (int i = 0; i < count; i++)
    {
      int len = slice;
      i == count - 1 ? len = remainder : len;
      // 获取分片数据
      QByteArray baSliceData = plainData.mid(i * slice, len);
      // 加密分片数据
      if (1 != EVP_PKEY_encrypt(ctx, ciphertext, &outlen,
                                (unsigned char *)baSliceData.data(),
                                baSliceData.length()))
      {
        qDebug() << "RSA分片加密失败";
        BIO_free(bioKey);
        EVP_PKEY_free(rsa);
        free(ciphertext);
        EVP_PKEY_CTX_free(ctx);
        return QString();
      }
      // 追加加密后的数据
      baEncryptData->append(QByteArray((char *)ciphertext, outlen));
    }
  }
  else
  {
    baEncryptData = new QByteArray((char *)ciphertext, outlen);
  }
  EVP_PKEY_CTX_free(ctx);
  BIO_free(bioKey);
  EVP_PKEY_free(rsa);
  // 使用BIO将base64编码后的数据转换为字符串
  BIO *bioBase64 = BIO_new(BIO_s_mem());
  BIO *bioB64 = BIO_new(BIO_f_base64());
  bioBase64 = BIO_push(bioB64, bioBase64);
  BIO_write(bioBase64, baEncryptData->data(), baEncryptData->length());
  BIO_flush(bioBase64);
  char *buf = NULL;
  int len = BIO_get_mem_data(bioBase64, &buf);
  QString strEncryptData = QString::fromUtf8(buf, len);
  // 释放 BIO 对象
  BIO_free_all(bioBase64);
  // 释放内存
  free(ciphertext);
  // 返回加密后的数据
  qDebug().noquote() << "加密后数据：" << strEncryptData;
  return strEncryptData;
}

static QString rsaPriDecrypt(const QString &strDecryptData,
                             const QString &strPriKey)
{
  // 将字符串形式的私钥转换为 BIO 对象
  BIO *bioKey = BIO_new_mem_buf((void *)strPriKey.toStdString().c_str(), -1);
  if (!bioKey)
  {
    return QString();
  }
  // 从 BIO 对象中读取私钥
  EVP_PKEY *rsa = PEM_read_bio_PrivateKey(bioKey, NULL, NULL, NULL);
  if (!rsa)
  {
    BIO_free(bioKey);
    return QString();
  }
  // 获取私钥的大小
  int keySize = EVP_PKEY_size(rsa);
  // 为解密后的数据分配内存
  unsigned char *plaintext = (unsigned char *)malloc(keySize);
  if (!plaintext)
  {
    BIO_free(bioKey);
    EVP_PKEY_free(rsa);
    return QString();
  }
  // 解密数据( EVP_PKEY_decrypt)
  // 上下文
  EVP_PKEY_CTX *ctx = EVP_PKEY_CTX_new(rsa, NULL);
  if (!ctx)
  {
    BIO_free(bioKey);
    EVP_PKEY_free(rsa);
    free(plaintext);
    return QString();
  }
  // 初始化上下文
  if (1 != EVP_PKEY_decrypt_init(ctx))
  {
    BIO_free(bioKey);
    EVP_PKEY_free(rsa);
    free(plaintext);
    EVP_PKEY_CTX_free(ctx);
    return QString();
  }
  // 设置填充方式
  if (1 != EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_PADDING))
  {
    BIO_free(bioKey);
    EVP_PKEY_free(rsa);
    free(plaintext);
    EVP_PKEY_CTX_free(ctx);
    return QString();
  }
  // 设置解密后的数据长度
  size_t outlen = keySize;
  // 解密数据
  if (1 != EVP_PKEY_decrypt(ctx, plaintext, &outlen,
                            (unsigned char *)strDecryptData.toStdString().c_str(),
                            strDecryptData.toStdString().length()))
  {
    BIO_free(bioKey);
    EVP_PKEY_free(rsa);
    free(plaintext);
    EVP_PKEY_CTX_free(ctx);
    return QString();
  }
  // 释放上下文
  EVP_PKEY_CTX_free(ctx);
  // 释放 BIO 对象
  BIO_free(bioKey);
  // 释放私钥
  EVP_PKEY_free(rsa);
  // 将解密后的数据转换为字符串
  QString strPlainData = QString::fromStdString(std::string((char *)plaintext, outlen));
  // 释放内存
  free(plaintext);
  // 返回解密后的数据
  return strPlainData;
}
