#include "vctrler.h"
QQmlApplicationEngine *vctrler::m_engine = nullptr;
vctrler *vctrler::m_vctrler = nullptr;
// 初始化互斥锁，开始时上锁
QMutex *vctrler::m_mutex = nullptr;

void vctrler::setEngine(QQmlApplicationEngine *engine)
{
    m_engine = engine;
    m_mutex = new QMutex();
    m_vctrler = new vctrler();
    // 连接内部信号槽 dialogClickedBtn(int x);
    auto r = m_engine->rootObjects().first();
    QObject::connect(r, SIGNAL(dialogClickedBtn(int)), vctrler::m_vctrler,
                     SLOT(receiveDialogResult(int)));
}

void vctrler::showDialog(dialogType type, dialogBtnType btntype, QString title,
                         QString content, QString customtype)
{
    if (m_engine == nullptr)
    {
        return;
    }
    // 上锁
    // 尝试锁定，如果锁定失败，则等待
    m_mutex->lock();
    auto r = m_engine->rootObjects().first();
    if (type == DIALOG_CUSTOM)
    {
        QMetaObject::invokeMethod(r, "showDialog", Q_ARG(QVariant, title),
                                  Q_ARG(QVariant, content),
                                  Q_ARG(QVariant, customtype));
    }
    else
    {
        QMetaObject::invokeMethod(r, "showDialog", Q_ARG(QVariant, type),
                                  Q_ARG(QVariant, btntype), Q_ARG(QVariant, title),
                                  Q_ARG(QVariant, content));
    }
    // 解锁
    m_mutex->unlock();
}

void vctrler::receiveDialogResult(int result)
{
    qDebug() << "\033[33m"
             << "receiveDialogResult" << result << "\033[0m";
    switch (result)
    {
    case 1:
        emit dialogResult("RESULT_YES");
        break;
    case 2:
        emit dialogResult("RESULT_NO");
        break;
    case 3:
        emit dialogResult("RESULT_OK");
        break;
    default:
        emit dialogResult("RESULT_CANCEL");
        break;
    }
}

void vctrler::emergencyExit()
{
    if (m_engine == nullptr)
    {
        return;
    }
    auto r = m_engine->rootObjects().first();
    QMetaObject::invokeMethod(r, "emergencyExit");
}
