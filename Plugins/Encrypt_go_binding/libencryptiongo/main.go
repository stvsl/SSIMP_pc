package main

import "C"

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/base64"
	"encoding/pem"
	"fmt"
	"os"
)

func main() {
	fmt.Println("1")
}

// RSA 解密
//
//export GoRSADecrypt
func GoRSADecrypt(ciphertext string, privatekey string) string {
	ciphertextByte, _ := base64.StdEncoding.DecodeString(ciphertext)
	privatekeyByte := []byte(privatekey)
	block, _ := pem.Decode(privatekeyByte)
	if block == nil {
		return "私钥解析失败"
	}
	// 解析私钥
	privateKey, err := x509.ParsePKCS1PrivateKey(block.Bytes)
	if err != nil {
		return "私钥解析失败" + err.Error()
	}
	if len(ciphertextByte) > 256 {
		fmt.Println("切片解密")
		// 切片解密
		var result []byte
		for i := 0; i < len(ciphertextByte); i += 256 {
			// 判断切片是否超出长度
			if i+256 > len(ciphertextByte) {
				// 解密
				decrypted, err := rsa.DecryptPKCS1v15(rand.Reader, privateKey, ciphertextByte[i:])
				if err != nil {
					return "解密失败" + err.Error()
				}
				result = append(result, decrypted...)
			} else {
				// 解密
				decrypted, err := rsa.DecryptPKCS1v15(rand.Reader, privateKey, ciphertextByte[i:i+256])
				if err != nil {
					return "解密失败" + err.Error()
				}
				result = append(result, decrypted...)
			}
		}
		return string(result)
	}
	// 解密
	plaintextByte, err := privateKey.Decrypt(rand.Reader, ciphertextByte, nil)
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
	block, _ := pem.Decode(publickeyByte)
	if block == nil {
		return "公钥解析失败"
	}
	publicKey, err := x509.ParsePKCS1PublicKey(block.Bytes)
	if err != nil {
		return "公钥解析失败" + err.Error()
	}
	ciphertextByte, err := rsa.EncryptPKCS1v15(rand.Reader, publicKey, plaintextByte)
	if err != nil {
		ciphertextByte = make([]byte, 0)
		for i := 0; i < len(plaintextByte); i += 245 {
			var end int
			if i+245 > len(plaintextByte) {
				end = len(plaintextByte)
			} else {
				end = i + 245
			}
			// 加密
			ciphertextByteTemp, err := rsa.EncryptPKCS1v15(rand.Reader, publicKey, plaintextByte[i:end])
			if err != nil {
				return "加密失败" + err.Error()
			}
			ciphertextByte = append(ciphertextByte, ciphertextByteTemp...)
		}
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
	// 生成RSA私钥
	privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		return "密钥对生成失败" + err.Error()
	}
	// 获取公钥
	publicKey := privateKey.PublicKey
	privateKeyPem := pem.EncodeToMemory(&pem.Block{
		Type:  "RSA PRIVATE KEY",
		Bytes: x509.MarshalPKCS1PrivateKey(privateKey),
	})
	publicKeyPem := pem.EncodeToMemory(&pem.Block{
		Type:  "RSA PUBLIC KEY",
		Bytes: x509.MarshalPKCS1PublicKey(&publicKey),
	})
	return fmt.Sprintf("%s|%s", privateKeyPem, publicKeyPem)
}

// 注册环境变量
//
//export CloseCGOWarningEnv
func CloseCGOWarningEnv() {
	os.Setenv("GODEBUG", "cgocheck=0")
}
