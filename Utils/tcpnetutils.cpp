#include "tcpnetutils.h"
#include "netbase.h"
#include <QThread>

TcpNetUtils::TcpNetUtils(TcpPost *post)
{
    this->mode = TcpMode::Post;
    this->timeout = post->getTimeout();
    this->url = post->getUrl();
    this->headers = post->getHeaders();
    this->params = post->getParams();
    this->body = post->getBody();
}

TcpNetUtils::TcpNetUtils(TcpGet *get)
{
    this->mode = TcpMode::Get;
    this->timeout = get->getTimeout();
    this->url = get->getUrl();
    this->headers = get->getHeaders();
    this->params = get->getParams();
}

TcpNetUtils::~TcpNetUtils()
{
}

void TcpNetUtils::sendRequest()
{
    // 创建请求
    QNetworkRequest request;
    request.setUrl(this->url);
    // 设置请求头
    QMapIterator<QString, QString> i(this->headers);
    while (i.hasNext())
    {
        i.next();
        request.setRawHeader(i.key().toUtf8(), i.value().toUtf8());
    }
    // 创建请求管理器
    QNetworkAccessManager *manager = new QNetworkAccessManager();
    // 创建请求
    QNetworkReply *reply = nullptr;
    if (this->mode == TcpMode::Post)
    {
        // POST请求
        reply = manager->post(request, this->body);
    }
    else
    {
        // GET请求
        reply = manager->get(request);
    }
    // 创建事件循环
    QEventLoop loop;
    // 创建定时器
    QTimer timer;
    // 设置定时器超时时间
    timer.setInterval(this->timeout);
    // 定时器超时信号槽
    connect(&timer, &QTimer::timeout, &loop, &QEventLoop::quit);
    // 请求完成信号槽
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    // 请求进度信号槽
    connect(reply, &QNetworkReply::downloadProgress, this, &TcpNetUtils::requestProgress);
    // 请求重定向信号槽
    connect(reply, &QNetworkReply::redirected, this, &TcpNetUtils::requestRedirected);
    // 请求错误信号槽
    connect(reply, &QNetworkReply::errorOccurred, this, &TcpNetUtils::requestErrorHappen);
    // 启动定时器
    timer.start();
    // 启动事件循环
    loop.exec();
    // 获取响应状态码
    this->statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    // 判断响应状态码是否为200
    if (this->statusCode != 200)
    {
        requestErrorHappenSlot(reply->error());
    }
    // 获取响应状态信息
    this->statusMsg = reply->attribute(QNetworkRequest ::HttpReasonPhraseAttribute).toString();
    // 获取响应头
    this->responseHeaders = reply->rawHeaderPairs();
    // 获取响应内容
    this->responseBody = reply->readAll();
    emit requestFinished();
    // 停止定时器
    timer.stop();
    reply->deleteLater();
    manager->deleteLater();
}

void TcpNetUtils::requestProgressSlot(qint64 bytesReceived, qint64 bytesTotal)
{
    // 发送请求进度信号
    emit this->requestProgress(bytesReceived, bytesTotal);
}

void TcpNetUtils::requestRedirectedSlot(const QUrl &url)
{
    // 发送请求重定向信号
    emit this->requestRedirected(url);
}

void TcpNetUtils::requestErrorHappenSlot(QNetworkReply::NetworkError code)
{
    QString msg = "服务器未知错误";
    // 发送请求错误信号
    if (code == 1)
    {
        msg = "远程主机关闭了一个现有的连接,请检查网络";
    }
    // 打印请求信息
    qDebug().noquote() << "\033[31m************请求失败************";
    qDebug().noquote() << "\033[31mMode:" << (this->mode == TcpMode::Post ? "POST" : "GET");
    qDebug().noquote() << "\033[31mRequest:" << this->url.toString();
    qDebug().noquote() << "\033[31mHeaders:" << this->headers;
    qDebug().noquote() << "\033[31mBody:" << this->body
                       << "*******************************\033[0m\n";
    vctrler::showDialog(dialogType::DIALOG_ERROR, dialogBtnType::DIALOG_OK, "网络请求错误", msg + "（错误代码：" + QString::number(code) + ")", NULL);
    emit this->requestErrorHappen(code);
}

int TcpNetUtils::getStatusCode()
{
    return this->statusCode;
}

QString TcpNetUtils::getStatusMsg()
{
    return this->statusMsg;
}

QList<QNetworkReply::RawHeaderPair> TcpNetUtils::getResponseHeaders()
{
    return this->responseHeaders;
}

QByteArray TcpNetUtils::getResponseBody()
{
    return this->responseBody;
}
QString TcpNetUtils::getResponseBodyStr()
{
    return this->responseBody;
}

QJsonObject TcpNetUtils::getResponseBodyJson()
{
    return QJsonDocument::fromJson(this->responseBody).object();
}

QJsonDocument TcpNetUtils::getResponseBodyJsonDoc()
{
    return QJsonDocument::fromJson(this->responseBody);
}
// Path: Utils/tcpnetutils.h
