#include "AuthManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QCryptographicHash>
#include <QDebug>

AuthManager::AuthManager(QObject *parent) : QObject(parent) {
    db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("localhost");
    db.setDatabaseName("faceintel");         // Change if needed
    db.setUserName("root");                  // Your MySQL username
    db.setPassword("hawk@2024");         // Your MySQL password

    if (!db.open()) {
        qWarning() << "Database connection failed:" << db.lastError().text();
    } else {
        qDebug() << "Connected to MySQL database.";
    }
}

bool AuthManager::login(const QString &username, const QString &password) {
    if (!db.isOpen()) {
        emit loginFailed("Database not connected.");
        return false;
    }

    QSqlQuery query;
    query.prepare("SELECT password_hash FROM users WHERE username = :username");
    query.bindValue(":username", username);

    if (!query.exec()) {
        emit loginFailed("Query error: " + query.lastError().text());
        return false;
    }

    if (query.next()) {
        QString storedHash = query.value(0).toString();
        //qDebug() <<storedHash;
        QString inputHash = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex();

        if (storedHash == inputHash) {
            emit loginSuccess();
            return true;
        } else {
            emit loginFailed("Incorrect password.");
            return false;
        }
    } else {
        emit loginFailed("User not found.");
        return false;
    }
}
