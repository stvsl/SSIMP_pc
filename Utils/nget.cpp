#include "nget.h"
#include "Daemon/global.h"

TcpGet::TcpGet(QObject *parent) : QObject(parent)
{
    this->timeout = 5000;
    this->url = global::SERVER_URL;
    this->headers = QMap<QString, QString>();
    this->params = QMap<QString, QString>();
}

TcpGet::TcpGet(const QString &url, QObject *parent) : QObject(parent)
{
    this->timeout = 5000;
    this->url = QUrl(url);
    this->headers = QMap<QString, QString>();
    this->params = QMap<QString, QString>();
}

TcpGet::TcpGet(const QString &url, const QMap<QString, QString> &headers, const QMap<QString, QString> &params, QObject *parent) : QObject(parent)
{
    this->timeout = 5000;
    this->url = QUrl(url);
    this->headers = headers;
    this->params = params;
}

TcpGet::~TcpGet()
{
}

void TcpGet::setUrl(const QUrl &url)
{
    this->url = url;
}

void TcpGet::setHeader(const QString &key, const QString &value)
{
    this->headers.insert(key, value);
}

void TcpGet::setHeaders(const QMap<QString, QString> &headers)
{
    this->headers = headers;
}

void TcpGet::addHeader(const QString &key, const QString &value)
{
    this->headers.insert(key, value);
}

void TcpGet::setParams(const QMap<QString, QString> &params)
{
    this->params = params;
}

void TcpGet::addParam(const QString &key, const QString &value)
{
    this->params.insert(key, value);
}

void TcpGet::setParam(const QString &key, const QString &value)
{
    this->params.insert(key, value);
}

void TcpGet::setTimeout(int timeout)
{
    this->timeout = timeout;
}

QUrl TcpGet::getUrl()
{
    return this->url;
}

QString TcpGet::getHeader(const QString &key)
{
    return this->headers.value(key);
}

QMap<QString, QString> TcpGet::getHeaders()
{
    return this->headers;
}

QMap<QString, QString> TcpGet::getParams()
{
    return this->params;
}

QString TcpGet::getParam(const QString &key)
{
    return this->params.value(key);
}

int TcpGet::getTimeout()
{
    return this->timeout;
}
