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
    QMap<QString, QString> getResponseHeaders();
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
    void requestFailed();
    // 请求超时信号
    void requestTimeout();
    // 请求进度信号
    void requestProgress(qint64 bytesSent, qint64 bytesTotal);
    // 请求重定向信号
    void requestRedirected(const QUrl &url);
    // 请求中断信号
    void requestAborted();
    // 请求错误信号
    void requestError(QNetworkReply::NetworkError code);
    // 请求SSL错误信号
    void requestSslErrors(const QList<QSslError> &errors);

private slots:
    // 请求完成槽
    void requestFinishedSlot();
    // 请求失败槽
    void requestFailedSlot();
    // 请求超时槽
    void requestTimeoutSlot();
    // 请求进度槽
    void requestProgressSlot(qint64 bytesSent, qint64 bytesTotal);
    // 请求重定向槽
    void requestRedirectedSlot(const QUrl &url);
    // 请求中断槽
    void requestAbortedSlot();
    // 请求错误槽
    void requestErrorSlot(QNetworkReply::NetworkError code);
    // 请求SSL错误槽
    void requestSslErrorsSlot(const QList<QSslError> &errors);

private:
    // 请求模式
    TcpMode mode;
    // 请求对象
    QNetworkAccessManager *manager;
    // 请求
    QNetworkRequest *request;
    // 响应
    QNetworkReply *reply;
    // 请求超时定时器
    QTimer *timer;
    // 请求超时时间
    int timeout;
    // 请求响应
    QByteArray response;
    // 请求响应状态码
    int statusCode;
    // 请求响应状态信息
    QString statusMsg;
    // 请求响应头
    QMap<QString, QString> responseHeaders;
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
