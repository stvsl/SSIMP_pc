#include "vctrler.h"
QQmlApplicationEngine *vctrler::m_engine = nullptr;
// 初始化互斥锁，开始时上锁
QMutex *vctrler::m_mutex = nullptr;

void vctrler::setEngine(QQmlApplicationEngine *engine)
{
    m_engine = engine;
    m_mutex = new QMutex();
}

dialogResult vctrler::showDialog(dialogType type, dialogBtnType btntype,
                                 QString title, QString content,
                                 QString customtype)
{
    if (m_engine == nullptr)
    {
        return RESULT_EXCEPTION;
    }
    // 上锁
    // 尝试锁定，如果锁定失败，则等待
    m_mutex->lock();
    qDebug() << "m_engine" << m_engine;
    auto r = m_engine->rootObjects().first();
    qDebug() << "showDialog" << type << btntype << title << content << customtype;
    qDebug() << "showDialog" << r;
    if (type == DIALOG_CUSTOM)
    {
        QMetaObject::invokeMethod(r, "showDialog", Q_ARG(QVariant, title), Q_ARG(QVariant, content), Q_ARG(QVariant, customtype));
    }
    else
    {
        QMetaObject::invokeMethod(r, "showDialog", Q_ARG(QVariant, type), Q_ARG(QVariant, btntype), Q_ARG(QVariant, title), Q_ARG(QVariant, content));
    }
    // 解锁
    m_mutex->unlock();
    return RESULT_OK;
}
