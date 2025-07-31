#ifndef FACESCANMANAGER_H
#define FACESCANMANAGER_H

#include <QObject>
#include <QString>
#include <vector>

class FaceScanManager : public QObject
{
    Q_OBJECT
public:
    explicit FaceScanManager(QObject *parent = nullptr);

    // Called from QML when a user selects an image
    Q_INVOKABLE void scanImage(const QString &imagePath);

signals:
    // Emitted when a match is found (either locally or online)
    void scanResultReady(const QString &name, const QString &id, double confidence);

    // Emitted if no match is found
    void scanFailed(const QString &reason);

private:
    bool connectToDatabase();

    // Runs SFace on image and extracts a 512D vector
    bool extractSFaceVector(const QString &path, std::vector<float> &outVector);

    // Compares the vector with stored vectors in MySQL
    bool performLocalMatch(const std::vector<float> &probeVec,
                           QString &id, QString &name, double &confidence);
};

#endif // FACESCANMANAGER_H
