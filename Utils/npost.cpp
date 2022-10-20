#include "npost.h"
#include "Daemon/global.h"

TcpPost::TcpPost(QObject *parent) : QObject(parent)
{
    this->timeout = 5000;
    this->url = *global::SERVER_URL;
    this->headers = QMap<QString, QString>();
    this->params = QMap<QString, QString>();
}

TcpPost::TcpPost(const QString &url, QObject *parent) : QObject(parent)
{
    this->timeout = 5000;
    this->url = QUrl(global::SERVER_URL->toString() + url);
    this->headers = QMap<QString, QString>();
    this->params = QMap<QString, QString>();
}

TcpPost::TcpPost(const QString &url, const QMap<QString, QString> &headers, const QMap<QString, QString> &params, QObject *parent) : QObject(parent)
{
    this->timeout = 5000;
    this->url = QUrl(global::SERVER_URL->toString() + url);
    this->headers = headers;
    this->params = params;
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

void TcpPost::setParams(const QMap<QString, QString> &params)
{
    this->params = params;
}

void TcpPost::addParam(const QString &key, const QString &value)
{
    this->params.insert(key, value);
}

void TcpPost::setTimeout(int timeout)
{
    this->timeout = timeout;
}

QUrl &TcpPost::getUrl()
{
    return this->url;
}

QMap<QString, QString> &TcpPost::getHeaders()
{
    return this->headers;
}

QMap<QString, QString> &TcpPost::getParams()
{
    return this->params;
}

QByteArray &TcpPost::getBody(){
    return this->body;
}

int &TcpPost::getTimeout()
{
    return this->timeout;
}
