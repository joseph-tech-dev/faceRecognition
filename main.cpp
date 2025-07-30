#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "Auth/AuthManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Initialize AuthManager and expose to QML
    AuthManager authManager;
    engine.rootContext()->setContextProperty("authManager", &authManager);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("FaceIntelSystem", "Main");

    return app.exec();
}
