#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QLocale>
#include <QTranslator>
#include <QFontDatabase>
#include <QQuickStyle>
#include "Utils/verificationcode.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    // js读写文件授权
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));
    // qt5启用高分辨率支持
    // QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    //注册验证码组件
    qmlRegisterType<VerificationCode>("Utils.Verify", 1, 0, "VerificationCode");
    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages)
    {
        const QString baseName = "SSIMP_pc_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName))
        {
            app.installTranslator(&translator);
            break;
        }
    }

    int fontId = QFontDatabase::addApplicationFont(QStringLiteral("qrc:/font/fonts/NotoSans-Regular.ttf"));
       QStringList fontFamilies = QFontDatabase::applicationFontFamilies(fontId);
       qDebug()<<"fontfamilies:"<<fontFamilies;
       if (fontFamilies.size() > 0)
       {
           QFont font;
           font.setFamily(fontFamilies[0]);//设置全局字体
           app.setFont(font);
       }

    qDebug() << "Qt version: " << QT_VERSION_STR;
    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/SSIMP_pc/Daemon/daemon.qml"_qs);
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl)
        {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
