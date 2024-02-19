#include "imgutils.h"

ImgUtils::ImgUtils(QObject *parent)
    : QObject{parent}
{
}

QString ImgUtils::imgToBase64(QString imgpath)
{
    qDebug() << "imgToBase64" << imgpath;
    // file:///home/stvsl/Pictures/波奇.png
    //  路径转换
    imgpath = imgpath.mid(7);
    qDebug() << "imgToBase64" << imgpath;
    // 读取文件内容
    QFile file(imgpath);
    if (!file.open(QIODevice::ReadOnly))
    {
        return "读取文件失败";
    }
    QByteArray imageData = file.readAll();

    // 将文件内容转换为图像对象
    QImage image;
    if (!image.loadFromData(imageData))
    {
        return "转换为图像对象失败";
    }

    // 将图像对象转换为base64编码的字符串
    QByteArray base64Data;
    QBuffer buffer(&base64Data);
    buffer.open(QIODevice::WriteOnly);
    image.save(&buffer, "PNG");
    return QString::fromLatin1(base64Data.toBase64().data());
}
