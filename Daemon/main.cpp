#include "Daemon/global.h"
#include "Utils/verificationcode.h"
#include "vctrler.h"
#include <QFontDatabase>
#include <QGuiApplication>
#include <QLocale>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QTranslator>

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  // js读写文件授权
  qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));
  // qputenv("GODEBUG", QByteArray("cgocheck=0"));
  // qt5启用高分辨率支持
  //  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QCoreApplication::setOrganizationName("stvsljl");
  QCoreApplication::setApplicationName("SSIMP");
  QCoreApplication::setOrganizationDomain("stvsljl.com");
  QCoreApplication::setApplicationVersion("v0.0.4 alpha");
  *global::SERVER_URL_STR() = "http://127.0.0.1:6521";
  qDebug() << "SERVER_URL_STR" << *global::SERVER_URL_STR();
  // 注册验证码组件
  qmlRegisterType<VerificationCode>("Utils.Verify", 1, 0, "VerificationCode");
  // 注册组件
  // TODO
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

  int fontId = QFontDatabase::addApplicationFont(
      QStringLiteral("qrc:/font/fonts/NotoSans-Regular.ttf"));
  QStringList fontFamilies = QFontDatabase::applicationFontFamilies(fontId);
  qDebug() << "fontfamilies:" << fontFamilies;
  if (fontFamilies.size() > 0)
  {
    QFont font;
    font.setFamily(fontFamilies[0]); // 设置全局字体
    app.setFont(font);
  }
  qDebug() << "Qt 版本: " << QT_VERSION_STR;
  QQmlApplicationEngine engine;
  const QUrl url(u"qrc:/SSIMP_pc/Daemon/daemon.qml"_qs);
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreated, &app,
      [url](const QObject *obj, const QUrl &objUrl)
      {
        if (!obj && url == objUrl)
          QCoreApplication::exit(-1);
      },
      Qt::QueuedConnection);
  engine.load(url);
  // 初始化交互控制器
  vctrler::setEngine(&engine);
  // 安全模块初始化
  global_Security::Init();
  return app.exec();
}
