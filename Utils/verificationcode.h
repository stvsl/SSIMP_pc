#ifndef VERIFICATIONCODE_H
#define VERIFICATIONCODE_H

#include <QQuickPaintedItem>

class VerificationCode : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString verification READ verification WRITE setVerification NOTIFY verificationChanged)

public:
    VerificationCode();
    void paint(QPainter* painter);
    void drawCode(QPainter* painter);
    QString getVerificationCode();

public:
    Q_INVOKABLE void slt_reflushVerification();

    void setVerification(const QString &verification){m_verificationCode = verification;}
    QString verification() const {return m_verificationCode;}
private:
    int letter_number = 4;//字符数
    int noice_point_number ;//干扰点数
    //生成验证码
    void produceVerificationCode() const;
    //产生随机字符
    QChar produceRandomLetter() const;
    //产生随机颜色
    void produceRandomColor() const;

    QChar *verificationCode;
    QColor *colorArray;
    QString m_verificationCode;
    int m_width;
    int m_height;


signals:
    void verificationChanged();
};

#endif // VERIFICATIONCODE_H
