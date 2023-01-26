package main

import "C"
import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rsa"
	"crypto/x509"
)

// RSA 解密
//
//export GoRSADecrypt
func GoRSADecrypt(ciphertext string, privatekey string) string {
	ciphertextByte := []byte(ciphertext)
	privatekeyByte := []byte(privatekey)
	// 解析私钥
	privateKey, err := x509.ParsePKCS1PrivateKey(privatekeyByte)
	if err != nil {
		return "私钥解析失败" + err.Error()
	}
	// 解密
	plaintextByte, err := privateKey.Decrypt(nil, ciphertextByte, nil)
	if err != nil {
		return "解密失败" + err.Error()
	}
	return string(plaintextByte)
}

// RSA 加密
//
//export GoRSAEncrypt
func GoRSAEncrypt(plaintext string, publickey string) string {
	plaintextByte := []byte(plaintext)
	publickeyByte := []byte(publickey)
	// 解析公钥
	publicKey, err := x509.ParsePKIXPublicKey(publickeyByte)
	if err != nil {
		return "公钥解析失败" + err.Error()
	}
	// 加密
	ciphertextByte, err := rsa.EncryptPKCS1v15(nil, publicKey.(*rsa.PublicKey), plaintextByte)
	if err != nil {
		return "加密失败" + err.Error()
	}
	return string(ciphertextByte)
}

func PKCS7Padding(ciphertext []byte, blockSize int) []byte {
	padding := blockSize - len(ciphertext)%blockSize
	padtext := bytes.Repeat([]byte{byte(padding)}, padding)
	return append(ciphertext, padtext...)
}

func PKCS7UnPadding(origData []byte) []byte {
	length := len(origData)
	unpadding := int(origData[length-1])
	return origData[:(length - unpadding)]
}

// AES 解密
//
//export GoAESDecrypt
func GoAESDecrypt(ciphertext string, key string) string {
	ciphertextByte := []byte(ciphertext)
	keyByte := []byte(key)
	// 解密
	block, err := aes.NewCipher(keyByte)
	if err != nil {
		return "解密失败" + err.Error()
	}
	blockSize := block.BlockSize()
	blockMode := cipher.NewCBCDecrypter(block, keyByte[:blockSize])
	origData := make([]byte, len(ciphertextByte))
	blockMode.CryptBlocks(origData, ciphertextByte)
	origData = PKCS7UnPadding(origData)
	return string(origData)
}

// AES 加密
//
//export GoAESEncrypt
func GoAESEncrypt(plaintext string, key string) string {
	ciphertextByte := []byte(plaintext)
	keyByte := []byte(key)
	// 加密
	block, err := aes.NewCipher(keyByte)
	if err != nil {
		return "加密失败" + err.Error()
	}
	blockSize := block.BlockSize()
	ciphertextByte = PKCS7Padding(ciphertextByte, blockSize)
	blockMode := cipher.NewCBCEncrypter(block, keyByte[:blockSize])
	crypted := make([]byte, len(ciphertextByte))
	blockMode.CryptBlocks(crypted, ciphertextByte)
	return string(crypted)
}

// 生成RSA密钥对
//
//export GoRSAKey
func GoRSAKey() string {
	// 生成RSA密钥对
	privateKey, err := rsa.GenerateKey(nil, 2048)
	if err != nil {
		return "密钥对生成失败" + err.Error()
	}
	privateKeyBytes := x509.MarshalPKCS1PrivateKey(privateKey)
	publicKeyBytes, err := x509.MarshalPKIXPublicKey(&privateKey.PublicKey)
	if err != nil {
		return "密钥对生成失败" + err.Error()
	}
	return string(privateKeyBytes) + string(publicKeyBytes)
}

func main() {}
