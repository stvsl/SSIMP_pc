#include "rsa.h"
#include <QString>
#include <openssl/evp.h>
#include <openssl/pem.h>
#include <openssl/rsa.h>

QString rsaPubEncrypt(const QString &strPlainData, const QString &strPubKey)
{
  // 将字符串形式的公钥转换为 BIO 对象
  BIO *bioKey = BIO_new_mem_buf((void *)strPubKey.toStdString().c_str(), -1);
  if (!bioKey)
  {
    // 失败时应当进行错误处理
    // ...
    return QString();
  }

  // 从 BIO 对象中读取公钥
  EVP_PKEY *rsa = PEM_read_bio_PUBKEY(bioKey, NULL, NULL, NULL);
  if (!rsa)
  {
    // 失败时应当进行错误处理
    // ...
    BIO_free(bioKey);
    return QString();
  }
  // 获取公钥的大小
  int keySize = EVP_PKEY_size(rsa);
  // 为加密后的数据分配内存
  unsigned char *ciphertext = (unsigned char *)malloc(keySize);
  if (!ciphertext)
  {
    // 失败时应当进行错误处理
    // ...
    BIO_free(bioKey);
    EVP_PKEY_free(rsa);
    return QString();
  }
  // 加密数据( EVP_PKEY_encrypt)
  // 上下文
  EVP_PKEY_CTX *ctx = EVP_PKEY_CTX_new(rsa, NULL);
  if (!ctx)
  {
    // 失败时应当进行错误处理
    BIO_free(bioKey);
    EVP_PKEY_free(rsa);
    free(ciphertext);
    return QString();
  }
  // 初始化上下文
  if (1 != EVP_PKEY_encrypt_init(ctx))
  {
    // 失败时应当进行错误处理
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
    BIO_free(bioKey);
    EVP_PKEY_free(rsa);
    free(ciphertext);
    EVP_PKEY_CTX_free(ctx);
    return QString();
  }
  // 设置加密后的数据长度
  size_t outlen = keySize;
  // 加密数据
  if (1 != EVP_PKEY_encrypt(ctx, ciphertext, &outlen,
                            (unsigned char *)strPlainData.toStdString().c_str(),
                            strPlainData.toStdString().length()))
  {
    // 失败时应当进行错误处理
    // ...
    BIO_free(bioKey);
    EVP_PKEY_free(rsa);
    free(ciphertext);
    EVP_PKEY_CTX_free(ctx);
    return QString();
  }
  // 释放上下文
  EVP_PKEY_CTX_free(ctx);
  // 释放 BIO 对象
  BIO_free(bioKey);
  // 释放公钥
  EVP_PKEY_free(rsa);
  // 将加密后的数据转换为字符串
  QString strEncryptData = QString::fromStdString(std::string((char *)ciphertext, outlen));
  // 释放内存
  free(ciphertext);
  // 返回加密后的数据
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
