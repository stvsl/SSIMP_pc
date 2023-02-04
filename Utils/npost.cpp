#include "npost.h"
#include "Daemon/global.h"
#include <QJsonDocument>

TcpPost::TcpPost(QObject *parent) : QObject(parent)
{
    this->timeout = 5000;
    this->url = QUrl(*global::SERVER_URL_STR());
    this->headers = QMap<QString, QString>();
}

TcpPost::TcpPost(const QString &url, QObject *parent) : QObject(parent)
{
    this->timeout = 5000;
    this->url = QUrl(*global::SERVER_URL_STR() + url);
    this->headers = QMap<QString, QString>();
}

TcpPost::TcpPost(const QString &url, const QMap<QString, QString> &headers, QObject *parent) : QObject(parent)
{
    this->timeout = 5000;
    this->url = QUrl(*global::SERVER_URL_STR() + url);
    this->headers = headers;
}

TcpPost::~TcpPost()
{
}

void TcpPost::setUrl(const QUrl &url)
{
    this->url = url;
}

void TcpPost::setHeader(const QString &key, const QString &value)
{
    this->headers.insert(key, value);
}

void TcpPost::setHeaders(const QMap<QString, QString> &headers)
{
    this->headers = headers;
}

void TcpPost::addHeader(const QString &key, const QString &value)
{
    this->headers.insert(key, value);
}

void TcpPost::setTimeout(int timeout)
{
    this->timeout = timeout;
}

void TcpPost::setBody(const QByteArray &body)
{
    this->body = body;
}

void TcpPost::setBody(const QString &body)
{
    this->body = body.toUtf8();
}

void TcpPost::setBody(const QJsonObject &body)
{
    this->body = QJsonDocument(body).toJson();
    this->headers.insert("Content-Type", "application/json");
}

void TcpPost::setBody(const QJsonDocument &body)
{
    this->body = body.toJson();
}

QUrl &TcpPost::getUrl()
{
    return this->url;
}

QMap<QString, QString> &TcpPost::getHeaders()
{
    return this->headers;
}

QByteArray &TcpPost::getBody()
{
    return this->body;
}

int &TcpPost::getTimeout()
{
    return this->timeout;
}
