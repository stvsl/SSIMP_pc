#ifndef VCTRLER_H
#define VCTRLER_H

#include <QObject>
#include <QQmlApplicationEngine>

/***
 * 界面控制器
 */
class vctrler : public QObject
{
    Q_OBJECT
public:
    explicit vctrler(QQmlApplicationEngine &engine, QObject *parent = nullptr);

private:
    QQmlApplicationEngine *m_engine;
};

#endif // VCTRLER_H
