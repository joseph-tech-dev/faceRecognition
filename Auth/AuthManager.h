#ifndef AUTHMANAGER_H
#define AUTHMANAGER_H

#include <QObject>
#include <QSqlDatabase>

class AuthManager : public QObject {
    Q_OBJECT
public:
    explicit AuthManager(QObject *parent = nullptr);
    Q_INVOKABLE bool login(const QString &username, const QString &password);

signals:
    void loginSuccess();
    void loginFailed(const QString &reason);

private:
    QSqlDatabase db;
};

#endif // AUTHMANAGER_H
