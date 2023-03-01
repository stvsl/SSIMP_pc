#ifndef IMGUTILS_H
#define IMGUTILS_H

#include <QObject>
#include <QFile>
#include <QImage>
#include <QBuffer>
#include <QDebug>

class ImgUtils : public QObject
{
    Q_OBJECT
public:
    explicit ImgUtils(QObject *parent = nullptr);
    // 图片转换为base64(自动转换为png格式)
    Q_INVOKABLE static QString imgToBase64(QString imgpath);

signals:
};

#endif // IMGUTILS_H
