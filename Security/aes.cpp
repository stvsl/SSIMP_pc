#include "aes.h"
#include "Daemon/global.h"

#define AES_BLOCK_SIZE 16

QString encrypt(QByteArray data)
{
    return encrypt(data,global_Security.getAesKey());
}

QByteArray encrypt(QByteArray data, QString key)
{
	std::string password = key.toStdString();
	unsigned char iv[AES_BLOCK_SIZE] = {'C','S','Y','S','T','E','M','A','E','S','J','C','K','E','Y','S'};
	AES_KEY aes_key;
	if (AES_set_encrypt_key((const unsigned char*)password.c_str(), password.length() * 8, &aes_key) < 0)
	{
		//assert(false);
		return QByteArray();
	}
	std::string strRet;
	std::string data_bak = data.toStdString();
	unsigned int data_length = data_bak.length();

	// pkcs7 padding
	int padding_length = AES_BLOCK_SIZE - data_length % AES_BLOCK_SIZE;
	for (int i = 0; i < padding_length; i++)
	{
		data_bak.push_back(padding_length);
	}

	// encrypt
	for (unsigned int i = 0; i < data_length / (AES_BLOCK_SIZE); i++)
	{
		std::string str16 = data_bak.substr(i*AES_BLOCK_SIZE, AES_BLOCK_SIZE);
		unsigned char out[AES_BLOCK_SIZE];
		::memset(out, 0, AES_BLOCK_SIZE);
		AES_cbc_encrypt((const unsigned char*)str16.c_str(), out, AES_BLOCK_SIZE, &aes_key, iv, AES_ENCRYPT);
		strRet += std::string((const char*)out, AES_BLOCK_SIZE);
	}
	return QByteArray::fromStdString(strRet);
}

QString decrypt(QByteArray data)
{
    return decrypt(data,global_Security.getAesKey());
}

QByteArray decrypt(QByteArray data, QString key)
{
	std::string password = key.toStdString();
	std::string strData = data.toStdString();
	unsigned char iv[AES_BLOCK_SIZE] = {'C','S','Y','S','T','E','M','A','E','S','J','C','K','E','Y','S' };

	AES_KEY aes_key;
	if (AES_set_decrypt_key((const unsigned char*)password.c_str(), password.length() * 8, &aes_key) < 0)
	{
		//assert(false);
		return QByteArray();
	}
	std::string strRet;
	// decrypt
		for (unsigned int i = 0; i < strData.length() / AES_BLOCK_SIZE; i++)
	{
		std::string str16 = strData.substr(i*AES_BLOCK_SIZE, AES_BLOCK_SIZE);
		unsigned char out[AES_BLOCK_SIZE];
		::memset(out, 0, AES_BLOCK_SIZE);
		AES_cbc_encrypt((const unsigned char*)str16.c_str(), out, AES_BLOCK_SIZE, &aes_key, iv, AES_DECRYPT);
		strRet += std::string((const char*)out, AES_BLOCK_SIZE);
	}
        // pkcs7 ubpadding
        int padding_length = strRet[strRet.length() - 1];
        strRet = strRet.substr(0, strRet.length() - padding_length);
	return QByteArray::fromStdString(strRet);
}
