#include "SystemMonitor.h"
#include <QDebug>
#include <QStorageInfo>
#include <QSysInfo>
#include <QRegularExpression>
#include <QTextStream>

SystemMonitor::SystemMonitor(QObject *parent) : QObject(parent) {
    setHistorySize(60); // default to 60 points (1 minute at 1s intervals)
    connect(&m_updateTimer, &QTimer::timeout, this, &SystemMonitor::updateSystemStats);
    m_updateTimer.start(1000); // Update every second
}

void SystemMonitor::setHistorySize(int size) {
    m_cpuHistory.clear();
    m_memoryHistory.clear();
    m_gpuHistory.clear();
    m_temperatureHistory.clear();
    
    for (int i = 0; i < size; ++i) {
        m_cpuHistory.append(0);
        m_memoryHistory.append(0);
        m_gpuHistory.append(0);
        m_temperatureHistory.append(0);
    }
}

void SystemMonitor::updateSystemStats() {
#ifdef Q_OS_WINDOWS
    updateWindowsStats();
#elif defined(Q_OS_LINUX)
    updateLinuxStats();
#elif defined(Q_OS_MACOS)
    updateMacStats();
#endif

    int historyLimit = m_cpuHistory.size();
    updateHistory(m_cpuHistory, m_cpuUsage, historyLimit);
    updateHistory(m_memoryHistory, m_memoryUsage, historyLimit);
    updateHistory(m_gpuHistory, m_gpuUsage, historyLimit);
    updateHistory(m_temperatureHistory, m_temperature, historyLimit);

    emit dataUpdated();
}

void SystemMonitor::updateHistory(QList<QVariant> &history, int value, int maxPoints) {
    if (history.size() >= maxPoints) {
        history.removeFirst();
    }
    history.append(value);
}


#ifdef Q_OS_WINDOWS
void SystemMonitor::updateWindowsStats() {
    // CPU Usage
    HRESULT hres;
    hres = CoInitializeEx(0, COINIT_MULTITHREADED);
    if (FAILED(hres)) {
        qWarning() << "Failed to initialize COM library";
        return;
    }
    
    hres = CoInitializeSecurity(NULL, -1, NULL, NULL, 
        RPC_C_AUTHN_LEVEL_DEFAULT, RPC_C_IMP_LEVEL_IMPERSONATE, 
        NULL, EOAC_NONE, NULL);
    
    if (FAILED(hres)) {
        qWarning() << "Failed to initialize security";
        CoUninitialize();
        return;
    }
    
    IWbemLocator *pLoc = NULL;
    hres = CoCreateInstance(CLSID_WbemLocator, 0, CLSCTX_INPROC_SERVER, 
        IID_IWbemLocator, (LPVOID *)&pLoc);
    
    if (FAILED(hres)) {
        qWarning() << "Failed to create IWbemLocator object";
        CoUninitialize();
        return;
    }
    
    IWbemServices *pSvc = NULL;
    hres = pLoc->ConnectServer(_bstr_t(L"ROOT\\CIMV2"), NULL, NULL, 0, NULL, 0, 0, &pSvc);
    
    if (FAILED(hres)) {
        qWarning() << "Could not connect to WMI";
        pLoc->Release();
        CoUninitialize();
        return;
    }
    
    hres = CoSetProxyBlanket(pSvc, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE, NULL, 
        RPC_C_AUTHN_LEVEL_CALL, RPC_C_IMP_LEVEL_IMPERSONATE, NULL, EOAC_NONE);
    
    if (FAILED(hres)) {
        qWarning() << "Could not set proxy blanket";
        pSvc->Release();
        pLoc->Release();
        CoUninitialize();
        return;
    }
    
    // Get CPU usage
    IEnumWbemClassObject* pEnumerator = NULL;
    hres = pSvc->ExecQuery(
        bstr_t("WQL"), 
        bstr_t("SELECT LoadPercentage FROM Win32_Processor"), 
        WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY, 
        NULL, &pEnumerator);
    
    if (FAILED(hres)) {
        qWarning() << "Query for CPU load failed";
        pSvc->Release();
        pLoc->Release();
        CoUninitialize();
        return;
    }
    
    IWbemClassObject *pclsObj = NULL;
    ULONG uReturn = 0;
    
    while (pEnumerator) {
        hres = pEnumerator->Next(WBEM_INFINITE, 1, &pclsObj, &uReturn);
        if (uReturn == 0) break;
        
        VARIANT vtProp;
        hres = pclsObj->Get(L"LoadPercentage", 0, &vtProp, 0, 0);
        if (SUCCEEDED(hres)) {
            m_cpuUsage = vtProp.intVal;
            emit cpuUsageChanged();
        }
        VariantClear(&vtProp);
        pclsObj->Release();
    }
    
    // Get Memory usage
    MEMORYSTATUSEX memoryStatus;
    memoryStatus.dwLength = sizeof(memoryStatus);
    GlobalMemoryStatusEx(&memoryStatus);
    m_memoryUsage = memoryStatus.dwMemoryLoad;
    emit memoryUsageChanged();
    
    // Cleanup
    pSvc->Release();
    pLoc->Release();
    pEnumerator->Release();
    CoUninitialize();
    
    // Note: GPU monitoring on Windows typically requires vendor-specific APIs (NVAPI, ADL)
    // For simplicity, we'll leave this at 0 in this example
    m_gpuUsage = 0;
    emit gpuUsageChanged();
    
    // Temperature monitoring also requires hardware-specific APIs
    m_temperature = 0;
    emit temperatureChanged();
}
#endif

#ifdef Q_OS_LINUX
void SystemMonitor::updateLinuxStats() {
    //qDebug() << ">>> updateLinuxStats() called";
    // CPU Usage
    QFile file("/proc/stat");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to open /proc/stat";
        return;
    }

    QTextStream in(&file);
    QString line = in.readLine(); // First line is overall CPU stats
    //qDebug()<< "CPU" << line;
    QStringList values = line.split(' ', Qt::SkipEmptyParts);  // <-- FIXED

    if (values.size() < 5) {
        qWarning() << "Unexpected /proc/stat format";
        file.close();
        return;
    }

    static qint64 prevIdle = 0, prevTotal = 0;

    qint64 idle = values[4].toLongLong();
    qint64 total = 0;
    for (int i = 1; i < values.size(); i++) {
        total += values[i].toLongLong();
    }

    qint64 diffIdle = idle - prevIdle;
    qint64 diffTotal = total - prevTotal;

    if (diffTotal > 0) {
        m_cpuUsage = 100 - ((diffIdle * 100) / diffTotal);
        emit cpuUsageChanged();
    }

    prevIdle = idle;
    prevTotal = total;
    file.close();

    // Memory Usage
    QFile memFile("/proc/meminfo");
    if (!memFile.open(QIODevice::ReadOnly)) {
        qWarning() << "Cannot open /proc/meminfo:" << memFile.errorString();
        return;
    }
    // Parses memory usage statistics from /proc/meminfo.
    // This method avoids QTextStream (which may silently fail) by reading the file
    // as raw bytes and manually extracting relevant fields.
    //
    // Fields extracted:
    //   - MemTotal:        Total system memory (kB)
    //   - MemFree:         Unused memory (kB)
    //   - Buffers:         Temporary buffer storage (kB)
    //   - Cached:          Page cache (kB)
    //   - SReclaimable:    Reclaimable slab memory (kB)
    //
    // The parsed values are stored in a QMap for easy access.
    // These values are then used to compute actual memory usage percentage
    // according to: used = total - free - buffers - cached - SReclaimable
    //
    // This approach ensures compatibility and stability across Linux systems.


    QByteArray content = memFile.readAll();
    memFile.close();

    //qDebug().noquote() << "Raw /proc/meminfo content:\n" << content;

    QMap<QString, qint64> memValues;
    QList<QByteArray> lines = content.split('\n');

    for (const QByteArray &line : std::as_const(lines)) {
        QList<QByteArray> parts = line.split(':');
        if (parts.size() != 2)
            continue;

        QString key = QString(parts[0].trimmed());
        QByteArray valuePart = parts[1].trimmed();

        int numStart = -1;
        for (int i = 0; i < valuePart.size(); ++i) {
            if (valuePart[i] >= '0' && valuePart[i] <= '9') {
                numStart = i;
                break;
            }
        }

        if (numStart != -1) {
            QByteArray numberStr = valuePart.mid(numStart).split(' ').first();
            bool ok = false;
            qint64 value = numberStr.toLongLong(&ok);
            if (ok && (key == "MemTotal" || key == "MemFree" || key == "Buffers" || key == "Cached" || key == "SReclaimable")) {
                memValues[key] = value;
            }
        }
    }

    // Show parsed results
    //qDebug() << "Parsed /proc/meminfo values:";
    for (auto it = memValues.begin(); it != memValues.end(); ++it) {
        //qDebug() << it.key() << ":" << it.value();
    }

    // Compute memory usage
    if (memValues.contains("MemTotal") && memValues["MemTotal"] > 0) {
        qint64 total = memValues["MemTotal"];
        qint64 used = total - memValues.value("MemFree", 0)
                      - memValues.value("Buffers", 0)
                      - memValues.value("Cached", 0)
                      - memValues.value("SReclaimable", 0);

        m_memoryUsage = qBound(0, (used * 100) / total, 100);
        emit memoryUsageChanged();

       // qDebug() << "Memory Usage:" << m_memoryUsage << "%";
    } else {
        qWarning() << "Failed to compute memory usage - MemTotal was 0 or missing.";
    }


}


#endif
void SystemMonitor::forceUpdate() {
    updateSystemStats();
}


#ifdef Q_OS_MACOS
void SystemMonitor::updateMacStats() {
    // CPU Usage
    QProcess process;
    process.start("top", QStringList() << "-l" << "1" << "-n" << "0");
    process.waitForFinished();
    QString output = process.readAllStandardOutput();
    
    QRegularExpression cpuRegex("CPU usage: (\\d+\\.\\d+)% user, (\\d+\\.\\d+)% sys, (\\d+\\.\\d+)% idle");
    QRegularExpressionMatch match = cpuRegex.match(output);
    
    if (match.hasMatch()) {
        float user = match.captured(1).toFloat();
        float sys = match.captured(2).toFloat();
        m_cpuUsage = qRound(user + sys);
        emit cpuUsageChanged();
    }
    
    // Memory Usage
    process.start("vm_stat");
    process.waitForFinished();
    output = process.readAllStandardOutput();
    
    qint64 pagesFree = 0, pagesActive = 0, pagesInactive = 0, pagesWired = 0;
    qint64 pageSize = 0;
    
    QTextStream in(&output);
    while (!in.atEnd()) {
        QString line = in.readLine();
        if (line.startsWith("Pages free:")) {
            pagesFree = line.split(':').last().trimmed().split('.').first().toLongLong();
        } else if (line.startsWith("Pages active:")) {
            pagesActive = line.split(':').last().trimmed().split('.').first().toLongLong();
        } else if (line.startsWith("Pages inactive:")) {
            pagesInactive = line.split(':').last().trimmed().split('.').first().toLongLong();
        } else if (line.startsWith("Pages wired down:")) {
            pagesWired = line.split(':').last().trimmed().split('.').first().toLongLong();
        }
    }
    
    process.start("pagesize");
    process.waitForFinished();
    pageSize = process.readAllStandardOutput().trimmed().toLongLong();
    
    qint64 totalMemory = QSysInfo::vmStatNumber("hw.memsize").toLongLong();
    qint64 usedMemory = (pagesActive + pagesWired + pagesInactive) * pageSize;
    
    if (totalMemory > 0) {
        m_memoryUsage = (usedMemory * 100) / totalMemory;
        emit memoryUsageChanged();
    }
    
    // GPU Usage (requires IOKit)
    m_gpuUsage = 0; // Placeholder
    emit gpuUsageChanged();
    
    // Temperature
    process.start("istats", QStringList() << "cpu" << "--no-graphs" << "--no-labels");
    process.waitForFinished();
    output = process.readAllStandardOutput();
    
    QRegularExpression tempRegex("(\\d+\\.\\d+)°C");
    match = tempRegex.match(output);
    if (match.hasMatch()) {
        m_temperature = qRound(match.captured(1).toFloat());
        emit temperatureChanged();
    }
}
#endif
