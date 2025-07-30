// OsintManager.cpp
#include "OsintManager.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDesktopServices>
#include <QUrl>
#include <QDebug>
#include <QCoreApplication>
#include <QRegularExpression>
#include <QDir>


OsintManager::OsintManager(QObject* parent) : QObject(parent) {
    connect(&m_process, &QProcess::readyReadStandardOutput, this, &OsintManager::handleProcessOutput);
    connect(&m_process, &QProcess::errorOccurred, this, &OsintManager::handleProcessError);
}

void OsintManager::search(const QString& query) {
    m_results.clear();
    emit osintResultsChanged();

    QString program = "python3";

    // Step up from build folder to reach source
    QDir appDir(QCoreApplication::applicationDirPath());
    QString sourceRoot = appDir.absoluteFilePath("../../"); // go two levels up
    QString scriptPath = QDir::cleanPath(sourceRoot + "/Python/Osint_runner.py");

    if (!QFile::exists(scriptPath)) {
        qWarning() << "OSINT script not found at:" << scriptPath;
        return;
    }

    QStringList args;
    static const QRegularExpression nonDigitRegex("\\D");

    if (query.contains("@"))
        args << scriptPath << "--email" << query;
    else if (query.startsWith("+") || QString(query).remove(nonDigitRegex).length() >= 10)
        args << scriptPath << "--phone" << query;
    else
        args << scriptPath << "--username" << query;

   // qDebug() << "Running:" << program << args;

    m_process.start(program, args);
}




void OsintManager::handleProcessOutput() {
    QByteArray output = m_process.readAllStandardOutput();
    //qDebug() << "Raw output:" << output;

    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(output, &error);

    if (error.error != QJsonParseError::NoError) {
        qWarning() << "Failed to parse JSON output:" << error.errorString();
        return;
    }

    if (!doc.isObject()) {
        qWarning() << "Expected a JSON object from OSINT runner";
        return;
    }

    QJsonObject root = doc.object();
    if (!root.contains("results") || !root["results"].isArray()) {
        qWarning() << "Missing or invalid 'results' array in output";
        return;
    }

    const QJsonArray array = root["results"].toArray();
    m_results.clear();
    for (const QJsonValue& val : array) {
        if (val.isObject())
            m_results.append(val.toObject().toVariantMap());
    }

    emit osintResultsChanged();
}

void OsintManager::handleProcessError() {
    qWarning() << "OSINT subprocess error:" << m_process.errorString();
}

QVariantList OsintManager::osintResults() const {
    return m_results;
}

void OsintManager::openUrl(const QString& url) {
    QDesktopServices::openUrl(QUrl(url));
}
