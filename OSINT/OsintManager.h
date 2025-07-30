// OsintManager.h
#pragma once

#include <QObject>
#include <QVariantList>
#include <QProcess>

class OsintManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList osintResults READ osintResults NOTIFY osintResultsChanged)

public:
    explicit OsintManager(QObject* parent = nullptr);

    Q_INVOKABLE void search(const QString& query);
    Q_INVOKABLE void openUrl(const QString& url);
    QVariantList osintResults() const;

signals:
    void osintResultsChanged();

private slots:
    void handleProcessOutput();
    void handleProcessError();

private:
    QProcess m_process;
    QVariantList m_results;
};