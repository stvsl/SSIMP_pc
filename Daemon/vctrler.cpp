#include "vctrler.h"

vctrler::vctrler(QQmlApplicationEngine &engine, QObject *parent)
    : QObject(parent)
{
    m_engine = &engine;
}
