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
#include <QFile>

OsintManager::OsintManager(QObject* parent) : QObject(parent) {
    connect(&m_process, &QProcess::readyReadStandardOutput, this, &OsintManager::handleProcessOutput);
    connect(&m_process, &QProcess::readyReadStandardError, this, &OsintManager::handleProcessErrorOutput);
    connect(&m_process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &OsintManager::handleProcessFinished);
    connect(&m_process, &QProcess::errorOccurred, this, &OsintManager::handleProcessError);
}

void OsintManager::search(const QString& query) {
    m_results.clear();
    emit osintResultsChanged();
    emit osintStarted();

    QString program = "python3";

    // Navigate to the project root
    QDir appDir(QCoreApplication::applicationDirPath());
    QString sourceRoot = appDir.absoluteFilePath("../../");

    QStringList args;
    args << "-m" << "Python.osint_runner.main";  // use module-style execution

    static const QRegularExpression nonDigitRegex("\\D");
    if (query.contains("@"))
        args << "--email" << query;
    else if (query.startsWith("+") || QString(query).remove(nonDigitRegex).length() >= 10)
        args << "--phone" << query;
    else
        args << "--username" << query;

    m_outputBuffer.clear();

    // Set working directory so module path is correct
    m_process.setWorkingDirectory(sourceRoot);
    m_process.start(program, args);
}

void OsintManager::handleProcessOutput() {
    QByteArray output = m_process.readAllStandardOutput();
    m_outputBuffer.append(output); // accumulate output
}

void OsintManager::handleProcessErrorOutput() {
    QByteArray errorOutput = m_process.readAllStandardError();
    qWarning() << "Python script stderr:" << QString::fromUtf8(errorOutput);
}

void OsintManager::handleProcessFinished(int exitCode, QProcess::ExitStatus exitStatus) {
    Q_UNUSED(exitCode)
    Q_UNUSED(exitStatus)

    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(m_outputBuffer, &error);

    if (error.error != QJsonParseError::NoError) {
        emit osintFailed("Failed to parse OSINT results: " + error.errorString());
        return;
    }

    if (!doc.isObject()) {
        emit osintFailed("Unexpected response format from OSINT runner.");
        return;
    }

    QJsonObject root = doc.object();
    if (!root.contains("results") || !root["results"].isArray()) {
        emit osintFailed("Missing 'results' array in OSINT output.");
        return;
    }

    const QJsonArray array = root["results"].toArray();
    m_results.clear();
    for (const QJsonValue& val : array) {
        if (val.isObject())
            m_results.append(val.toObject().toVariantMap());
    }

    emit osintResultsChanged();
    emit osintFinished();
}

void OsintManager::handleProcessError(QProcess::ProcessError error) {
    qWarning() << "OSINT subprocess error:" << error;
    emit osintFailed("Process error occurred.");
}

QVariantList OsintManager::osintResults() const {
    return m_results;
}

void OsintManager::openUrl(const QString& url) {
    QDesktopServices::openUrl(QUrl(url));
}
