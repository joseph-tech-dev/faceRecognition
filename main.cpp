#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>

#include "Auth/AuthManager.h"
#include "OSINT/OsintManager.h"
#include "SystemMonitor/SystemMonitor.h"
//#include "FaceScan/FaceScanManager.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":assets/icons/zephix_32.png"));  // Note the ':' for Qt Resource System
    QQmlApplicationEngine engine;

    // Register SystemMonitor as a QML type
    qmlRegisterType<SystemMonitor>("SystemMonitor", 1, 0, "SystemMonitor");

    // Initialize and expose AuthManager
    AuthManager authManager;
    engine.rootContext()->setContextProperty("authManager", &authManager);

    // Initialize and expose OsintManager
    OsintManager osintManager;
    engine.rootContext()->setContextProperty("OsintManager", &osintManager);

    //Face Scanning
    //FaceScanManager faceScanManager;
    //engine.rootContext()->setContextProperty("faceScanManager", &faceScanManager);

    // Handle QML loading failure
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("FaceIntelSystem", "Main");

    return app.exec();
}
