cmake_minimum_required(VERSION 3.16)

project(FaceIntelSystem VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Find Qt modules
find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Sql Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appFaceIntelSystem
    main.cpp
    Auth/AuthManager.cpp
    resources/qml.qrc
)
target_include_directories(appFaceIntelSystem PRIVATE Auth)

qt_add_qml_module(appFaceIntelSystem
    URI FaceIntelSystem
    VERSION 1.0
    QML_FILES
        Main.qml
        qml/Dashboard.qml
        qml/FaceScan.qml
        qml/LoginPage.qml
        qml/OSINTLookup.qml
)

set_target_properties(appFaceIntelSystem PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appFaceIntelSystem
    PRIVATE Qt6::Core Qt6::Gui Qt6::Quick Qt6::QuickControls2 Qt6::Sql
)


include(GNUInstallDirs)
install(TARGETS appFaceIntelSystem
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
