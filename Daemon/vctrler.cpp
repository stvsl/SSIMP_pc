#include "vctrler.h"
QQmlApplicationEngine *vctrler::m_engine = nullptr;
void vctrler::setEngine() {}

dialogResult vctrler::showDialog(dialogType type, dialogBtnType btntype,
                                 QString title, QString content,
                                 QString customtype)
{
    if (m_engine == nullptr)
    {
        return RESULT_EXCEPTION;
    }
    auto r = m_engine->rootObjects().constFirst()->findChild<QObject *>("daemon");
    if (type == DIALOG_CUSTOM)
    {
        qDebug() << "custom";
    }
    else
    {
        qDebug() << "not custom";
    }
    return RESULT_OK;
}
