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
/***
 * 网络TCP通信工具类
 * @param parent
 */
// 定义枚举类型
enum class TcpMode
{
    Get,
    Post,
};
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

class TcpPost : public QObject
{
    Q_OBJECT
public:
    explicit TcpPost(QObject *parent = nullptr);
    ~TcpPost();
    // 设置请求URL
    void setUrl(const QUrl &url);
    // 设置header
    void setHeader(const QString &key, const QString &value);
    // 设置headers
    void setHeaders(const QMap<QString, QString> &headers);
    // 追加header
    void addHeader(const QString &key, const QString &value);
    // 设置请求参数
    void setParams(const QMap<QString, QString> &params);
    // 追加请求参数
    void addParam(const QString &key, const QString &value);
    // 设置请求参数
    void setParam(const QString &key, const QString &value);
    // 设置请求体
    void setBody(const QByteArray &body);
    // 设置请求体
    void setBody(const QString &body);
    // 设置请求体
    void setBody(const QJsonObject &body);
    // 设置请求体
    void setBody(const QJsonDocument &body);
    // 设置请求超时时间
    void setTimeout(int timeout);
    // 获取请求URL
    QUrl getUrl();
    // 获取header
    QString getHeader(const QString &key);
    // 获取headers
    QMap<QString, QString> getHeaders();
    // 获取请求参数
    QMap<QString, QString> getParams();
    // 获取请求参数
    QString getParam(const QString &key);
    // 获取请求体
    QByteArray getBody();
    // 获取请求超时时间
    int getTimeout();

private:
    // 请求URL
    QUrl url;
    // 请求头
    QMap<QString, QString> headers;
    // 请求参数
    QMap<QString, QString> params;
    // 请求体
    QByteArray body;
    // 请求超时时间
    int timeout;
    // 模式
    TcpMode mode = TcpMode::Post;
};

class TcpGet : public QObject
{
    Q_OBJECT
public:
    explicit TcpGet(QObject *parent = nullptr);
    explicit TcpGet(const QString &url, QObject *parent = nullptr);
    ~TcpGet();
    // 设置请求URL
    void setUrl(const QUrl &url);
    // 设置header
    void setHeader(const QString &key, const QString &value);
    // 设置headers
    void setHeaders(const QMap<QString, QString> &headers);
    // 追加header
    void addHeader(const QString &key, const QString &value);
    // 设置请求参数
    void setParams(const QMap<QString, QString> &params);
    // 追加请求参数
    void addParam(const QString &key, const QString &value);
    // 设置请求参数
    void setParam(const QString &key, const QString &value);
    // 设置请求超时时间
    void setTimeout(int timeout);
    // 获取请求URL
    QUrl getUrl();
    // 获取header
    QString getHeader(const QString &key);
    // 获取headers
    QMap<QString, QString> getHeaders();
    // 获取请求参数
    QMap<QString, QString> getParams();
    // 获取请求参数
    QString getParam(const QString &key);
    // 获取请求超时时间
    int getTimeout();

private:
    // 请求URL
    QUrl url;
    // 请求头
    QMap<QString, QString> headers;
    // 请求参数
    QMap<QString, QString> params;
    // 请求超时时间
    int timeout;
    // 模式
    TcpMode mode = TcpMode::Get;
};

#endif // TCPNETUTILS_H#endif // TCPNETUTILS_H#endif // TCPNETUTILS_H#endif // TCPNETUTILS_H#endif // TCPNETUTILS_H#endif // TCPNETUTILS_H

#endif // TCPNETUTILS_H