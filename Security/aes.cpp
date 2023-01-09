#include "aes.h"
#include "Daemon/global.h"
#include <openssl/evp.h>

#define AES_BLOCK_SIZE 16

QString encrypt(const QByteArray &data)
{
  return encrypt(data, QString(global_Security::getAesKey()));
}

QByteArray encrypt(const QByteArray data, const QString key)
{
  // 初始化 OpenSSL 库
  OPENSSL_init_crypto(OPENSSL_INIT_LOAD_CONFIG, NULL);

  // 创建 OpenSSL 的加密上下文
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  if (!ctx)
  {
    // 失败时应当返回一个空的 QByteArray 对象
    return QByteArray();
  }

  // 设置加密算法为 AES-256-ECB
  if (1 != EVP_EncryptInit_ex(ctx, EVP_aes_256_ecb(), NULL, NULL, NULL))
  {
    // 失败时应当返回一个空的 QByteArray 对象
    EVP_CIPHER_CTX_free(ctx);
    return QByteArray();
  }

  // 设置加密的密钥，需要将 QString 类型转换为 unsigned char 类型
  unsigned char *keyData = (unsigned char *)key.toUtf8().data();
  if (1 != EVP_EncryptInit_ex(ctx, NULL, NULL, keyData, NULL))
  {
    // 失败时应当返回一个空的 QByteArray 对象
    EVP_CIPHER_CTX_free(ctx);
    return QByteArray();
  }

  // 准备加密的缓冲区
  int outLength = 0;
  int c_len = data.size() + EVP_CIPHER_CTX_block_size(ctx);
  unsigned char *ciphertext = (unsigned char *)malloc(c_len);

  // 进行加密
  if (1 != EVP_EncryptUpdate(ctx, ciphertext, &outLength,
                             (const unsigned char *)data.data(), data.size()))
  {
    // 失败时应当返回一个空的 QByteArray 对象
    EVP_CIPHER_CTX_free(ctx);
    free(ciphertext);
    return QByteArray();
  }
  int tempLen = outLength;

  // 完成加密
  if (1 != EVP_EncryptFinal_ex(ctx, ciphertext + tempLen, &outLength))
  {
    // 失败时应当返回一个空的 QByteArray 对象
    EVP_CIPHER_CTX_free(ctx);
    free(ciphertext);
    return QByteArray();
  }
  tempLen += outLength;
  // 释放加密上下文并返回结果
  EVP_CIPHER_CTX_free(ctx);
  QByteArray result = QByteArray((const char *)ciphertext, tempLen);
  free(ciphertext);
  return result;
}

QString decrypt(const QByteArray &data)
{
  return decrypt(data, global_Security::getAesKey());
}

QByteArray decrypt(const QByteArray data, const QString key)
{
  // 初始化 OpenSSL 库
  OPENSSL_init_crypto(OPENSSL_INIT_LOAD_CONFIG, NULL);

  // 创建 OpenSSL 的解密上下文
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  if (!ctx)
  {
    // 失败时应当返回一个空的 QByteArray 对象
    return QByteArray();
  }

  // 设置解密算法为 AES-128-ECB
  if (1 != EVP_DecryptInit_ex(ctx, EVP_aes_256_ecb(), NULL, NULL, NULL))
  {
    // 失败时应当返回一个空的 QByteArray 对象
    EVP_CIPHER_CTX_free(ctx);
    return QByteArray();
  }

  // 设置解密的密钥，需要将 QString 类型转换为 unsigned char 类型
  unsigned char *keyData = (unsigned char *)key.toUtf8().data();
  if (1 != EVP_DecryptInit_ex(ctx, NULL, NULL, keyData, NULL))
  {
    // 失败时应当返回一个空的 QByteArray 对象
    EVP_CIPHER_CTX_free(ctx);
    return QByteArray();
  }

  // 准备解密的缓冲区
  int outLength = 0;
  int p_len = data.size();
  unsigned char *plaintext = (unsigned char *)malloc(p_len);

  // 进行解密
  if (1 != EVP_DecryptUpdate(ctx, plaintext, &outLength,
                             (const unsigned char *)data.data(), data.size()))
  {
    // 失败时应当返回一个空的 QByteArray 对象
    EVP_CIPHER_CTX_free(ctx);
    free(plaintext);
    return QByteArray();
  }
  int tempLen = outLength;

  // 完成解密
  if (1 != EVP_DecryptFinal_ex(ctx, plaintext + tempLen, &outLength))
  {
    // 失败时应当返回一个空的 QByteArray 对象
    EVP_CIPHER_CTX_free(ctx);
    free(plaintext);
    return QByteArray();
  }
  tempLen += outLength;
  // 释放解密上下文并返回结果
  EVP_CIPHER_CTX_free(ctx);
  QByteArray result = QByteArray((const char *)plaintext, tempLen);
  free(plaintext);
  return result;
}
