#ifndef TCPNETUTILS_H
#define TCPNETUTILS_H

#include <QObject>
#include <QTcpSocket>
#include <QDebug>
#include <QTimer>
#include <QJsonObject>
#include <QJsonDocument>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QSslConfiguration>
#include <QEventLoop>
#include "Utils/npost.h"
#include "Utils/nget.h"
/***
 * 网络TCP通信工具类
 * @param parent
 */

class TcpNetUtils : public QObject
{
    Q_OBJECT
public:
    // POST请求模式
    explicit TcpNetUtils(TcpPost *post);
    // GET请求模式
    explicit TcpNetUtils(TcpGet *get);
    ~TcpNetUtils();
    // 发送请求
    void sendRequest();
    // 获取响应
    QByteArray getResponse();
    // 获取响应状态码
    int getStatusCode();
    // 获取响应状态信息
    QString getStatusMsg();
    // 获取响应头
    QList<QNetworkReply::RawHeaderPair> getResponseHeaders();
    // 获取响应内容（响应体）
    QByteArray getResponseBody();
    // 获取响应内容（响应体）字符串
    QString getResponseBodyStr();
    // 获取响应内容（响应体）Json对象
    QJsonObject getResponseBodyJson();
    // 获取响应内容（响应体）Json数组
    QJsonDocument getResponseBodyJsonDoc();

signals:
    // 请求完成信号
    void requestFinished();
    // 请求失败信号
    void requestFailed(QNetworkReply::NetworkError code);
    // 请求超时信号
    void requestTimeout();
    // 请求进度信号
    void requestProgress(qint64 bytesSent, qint64 bytesTotal);
    // 请求重定向信号
    void requestRedirected(const QUrl &url);

private slots:
    void requestProgressSlot(qint64 bytesReceived, qint64 bytesTotal);
    void requestRedirectedSlot(const QUrl &url);
    void requestFailedSlot(QNetworkReply::NetworkError code);
private:
    // 请求模式
    TcpMode mode;
    // 目标地址
    QUrl url;
    // 请求参数
    QMap<QString, QString> params;
    // 请求头
    QMap<QString, QString> headers;
    // 请求体
    QByteArray body;
    // 请求超时时间
    int timeout;
    // 请求响应状态码
    int statusCode;
    // 请求响应状态信息
    QString statusMsg;
    // 请求响应头
    QList<QNetworkReply::RawHeaderPair> responseHeaders;
    // 请求响应内容（响应体）
    QByteArray responseBody;
    // 请求响应内容（响应体）字符串
    QString responseBodyStr;
    // 请求响应内容（响应体）Json对象
    QJsonObject responseBodyJson;
    // 请求响应内容（响应体）Json数组
    QJsonDocument responseBodyJsonDoc;
};

#endif // TCPNETUTILS_H
