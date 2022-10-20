#ifndef NPOST_H
#define NPOST_H

#include <QObject>
#include <QUrl>
#include <QMap>
#include "Utils/netbase.h"

class TcpPost : public QObject
{
    Q_OBJECT
public:
    explicit TcpPost(QObject *parent = nullptr);
    explicit TcpPost(const QString &url, QObject *parent = nullptr);
    explicit TcpPost(const QString &url, const QMap<QString, QString> &headers, const QMap<QString, QString> &params, QObject *parent = nullptr);
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
    QUrl &getUrl();
    // 获取header
    QString &getHeader(const QString &key);
    // 获取headers
    QMap<QString, QString> &getHeaders();
    // 获取请求参数
    QMap<QString, QString> &getParams();
    // 获取请求参数
    QString &getParam(const QString &key);
    // 获取请求体
    QByteArray &getBody();
    // 获取请求超时时间
    int &getTimeout();

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

#endif // NPOST_H
