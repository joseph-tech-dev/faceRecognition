#include "FaceScanManager.h"

#include <QFile>
#include <QProcess>
#include <QSqlQuery>
#include <QSqlError>
#include <QJsonDocument>
#include <QJsonObject>
#include <QCryptographicHash>
#include <QDebug>

#include <opencv2/opencv.hpp>

// Assume this is defined elsewhere and linked from SFace
extern std::vector<float> getSFaceVector(const cv::Mat &image);
float cosineSimilarity(const std::vector<float> &a, const std::vector<float> &b);

FaceScanManager::FaceScanManager(QObject *parent)
    : QObject(parent)
{
    connectToDatabase();
}

bool FaceScanManager::connectToDatabase()
{
    if (QSqlDatabase::contains("faceintel_db"))
        return true;

    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL", "faceintel_db");
    db.setHostName("localhost");
    db.setDatabaseName("faceintel");
    db.setUserName("your_mysql_username");
    db.setPassword("your_mysql_password");

    if (!db.open()) {
        qWarning() << "❌ Failed to connect to MySQL:" << db.lastError().text();
        return false;
    }

    qDebug() << "✅ Connected to MySQL.";
    return true;
}

void FaceScanManager::scanImage(const QString &imagePath)
{
    qDebug() << "📥 Scanning image:" << imagePath;

    std::vector<float> probeVector;
    if (!extractSFaceVector(imagePath, probeVector)) {
        emit scanFailed("Failed to extract face vector from image.");
        return;
    }

    QString matchedId, matchedName;
    double bestScore = 0.0;

    if (performLocalMatch(probeVector, matchedId, matchedName, bestScore)) {
        emit scanResultReady(matchedName, matchedId, bestScore);
    } else {
        // 🔄 Fallback: Run Python PimEye script
        QProcess process;
        QString scriptPath = "Python/pimeye_runner.py";
        process.start("python3", QStringList() << scriptPath << imagePath);
        process.waitForFinished();

        QByteArray output = process.readAllStandardOutput();
        QJsonDocument doc = QJsonDocument::fromJson(output);
        if (!doc.isNull() && doc.isObject()) {
            QJsonObject obj = doc.object();
            if (obj["match_found"].toBool()) {
                emit scanResultReady(obj["name"].toString(),
                                     obj["id"].toString(),
                                     obj["confidence"].toDouble());
            } else {
                emit scanFailed("No online match found.");
            }
        } else {
            emit scanFailed("Invalid response from PimEye script.");
        }
    }
}

bool FaceScanManager::extractSFaceVector(const QString &path, std::vector<float> &outVector)
{
    cv::Mat img = cv::imread(path.toStdString());
    if (img.empty()) {
        qWarning() << "❌ Failed to load image for SFace.";
        return false;
    }

    try {
        outVector = getSFaceVector(img);
        return (outVector.size() == 512);
    } catch (...) {
        qWarning() << "❌ SFace vector extraction failed with exception.";
        return false;
    }
}

bool FaceScanManager::performLocalMatch(const std::vector<float> &probeVec, QString &id, QString &name, double &confidence)
{
    QSqlDatabase db = QSqlDatabase::database("faceintel_db");
    if (!db.isOpen() && !db.open()) {
        qWarning() << "❌ Database not open:" << db.lastError().text();
        return false;
    }

    QSqlQuery query(db);
    if (!query.exec("SELECT id, name, vector FROM face_vectors")) {
        qWarning() << "❌ Query error:" << query.lastError().text();
        return false;
    }

    double bestSim = -1.0;

    while (query.next()) {
        QString dbVectorStr = query.value("vector").toString();
        std::vector<float> dbVector;

        for (const QString &num : dbVectorStr.split(',')) {
            dbVector.push_back(num.toFloat());
        }

        double sim = cosineSimilarity(probeVec, dbVector);
        if (sim > bestSim) {
            bestSim = sim;
            id = query.value("id").toString();
            name = query.value("name").toString();
        }
    }

    if (bestSim >= 0.6) {  // adjustable threshold
        confidence = bestSim * 100.0;
        return true;
    }

    return false;
}

// Cosine similarity between two vectors
float cosineSimilarity(const std::vector<float> &a, const std::vector<float> &b)
{
    float dot = 0.0, normA = 0.0, normB = 0.0;
    for (size_t i = 0; i < a.size(); ++i) {
        dot += a[i] * b[i];
        normA += a[i] * a[i];
        normB += b[i] * b[i];
    }
    return dot / (std::sqrt(normA) * std::sqrt(normB) + 1e-8);
}
