#pragma once

#include <QObject>
#include <QTimer>
#include <QVariant>

#ifdef Q_OS_WINDOWS
#include <wbemidl.h>
#include <comdef.h>
#endif

class SystemMonitor : public QObject {
    Q_OBJECT

    // Live values as properties
    Q_PROPERTY(int cpuUsage READ cpuUsage NOTIFY cpuUsageChanged)
    Q_PROPERTY(int memoryUsage READ memoryUsage NOTIFY memoryUsageChanged)
    Q_PROPERTY(int gpuUsage READ gpuUsage NOTIFY gpuUsageChanged)
    Q_PROPERTY(int temperature READ temperature NOTIFY temperatureChanged)

public:
    explicit SystemMonitor(QObject *parent = nullptr);

    int cpuUsage() const { return m_cpuUsage; }
    int memoryUsage() const { return m_memoryUsage; }
    int gpuUsage() const { return m_gpuUsage; }
    int temperature() const { return m_temperature; }

    // History accessors exposed to QML as invokable methods
    Q_INVOKABLE QVariantList cpuHistory() const { return m_cpuHistory; }
    Q_INVOKABLE QVariantList memoryHistory() const { return m_memoryHistory; }
    Q_INVOKABLE QVariantList gpuHistory() const { return m_gpuHistory; }
    Q_INVOKABLE QVariantList temperatureHistory() const { return m_temperatureHistory; }

    // History control
    Q_INVOKABLE void setHistorySize(int size);
    Q_INVOKABLE void forceUpdate();

signals:
    void cpuUsageChanged();
    void memoryUsageChanged();
    void gpuUsageChanged();
    void temperatureChanged();
    void dataUpdated();

private slots:
    void updateSystemStats();

private:
    int m_cpuUsage = 0;
    int m_memoryUsage = 0;
    int m_gpuUsage = 0;
    int m_temperature = 0;

    QVariantList m_cpuHistory;
    QVariantList m_memoryHistory;
    QVariantList m_gpuHistory;
    QVariantList m_temperatureHistory;

    QTimer m_updateTimer;

    void updateHistory(QVariantList &history, int value, int maxPoints);

    // Platform-specific data collection
    void updateWindowsStats();
    void updateLinuxStats();
    void updateMacStats();
};
