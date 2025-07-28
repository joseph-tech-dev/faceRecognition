
# FACEINTEL Recognition System

## Overview

**FACEINTEL** is an advanced facial recognition system that matches uploaded images against both local and online databases. This dashboard provides a comprehensive interface for monitoring system performance, reviewing matches, and managing recognition operations.

## Features

- **Dual Database Matching**: Searches both local and online databases  
- **Real-time Statistics**: Tracks matches, accuracy, and system status  
- **Recent Matches Display**: Shows detailed results of recent recognitions  
- **Responsive Design**: Adapts to desktop, tablet, and mobile screens  
- **Futuristic UI**: Neon-themed interface with glowing elements  

## System Requirements

- Qt 5.15 or later  
- QML-compatible platform  
- Minimum screen resolution: 800×600  

## Installation

### Clone the repository:
```bash
git clone https://github.com/joseph-tech-dev/faceRecognition.git
```

### Navigate to the project directory:
```bash
cd FACEINTEL
```

### Build and run using qmlscene:
```bash
qmlscene main.qml
```

## Usage

### Navigation

- **Home**: Returns to the main dashboard view  
- **Scan**: Access the image upload and recognition interface  
- **Database**: Manage local facial database entries  
- **Settings**: Configure system parameters  

### Dashboard Components

- **Match Statistics Panel (Top-left)**  
  - Navigation buttons to key system sections  

- **Database Status Panel (Top-right)**  
  - Local database health  
  - Online API connection status  

- **Recent Matches Panel (Bottom)**  
  - Detailed results of recent recognitions  
  - Confidence scores and data sources  

- **System Activity Panel (Desktop only)**  
  - Performance metrics and charts  

## Customization

### Theme Colors

Modify these properties in `main.qml`:
```qml
property color neonBlue: "#00f2ff"  // Primary accent color  
property color neonGreen: "#00ffaa" // Success indicators  
property color bgColor: "#0a0f1c"   // Background color  
property color panelColor: "#111a24" // Panel backgrounds  
```

### Responsive Breakpoints

Adjust screen size thresholds:
```qml
property bool isMobile: width < 900  
property bool isTablet: width >= 900 && width < 1200  
property bool isDesktop: width >= 1200  
```

## Data Sources

The system uses:

- **Local Database**: SQLite database of known faces  
- **Online API**: Cloud-based recognition service (configurable)  

## Troubleshooting

- **Blank panels**: Ensure database connections are properly configured  
- **Layout issues**: Verify Qt Quick Controls 2 are installed  
- **Performance**: Reduce animation complexity on low-end devices  

## License

This project is licensed under the **MIT License**.

## Screenshots

- ![Desktop](https://screenshots/desktop.png)  
- ![Mobile](https://screenshots/mobile.png)  

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss proposed changes.

## Contact

For support or inquiries: [predatormj.v3@gmail.com]
