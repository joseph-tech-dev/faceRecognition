#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "Auth/AuthManager.h"
#include "OSINT/OsintManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Initialize and expose AuthManager
    AuthManager authManager;
    engine.rootContext()->setContextProperty("authManager", &authManager);

    // Initialize and expose OsintManager
    OsintManager osintManager;
    engine.rootContext()->setContextProperty("OsintManager", &osintManager);

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
