cmake_minimum_required(VERSION 3.16)

project(ArcGaugeTest VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QT_QML_GENERATE_QMLLS_INI ON)

# Qt Design Studio の Studio Components を IDE 補完で認識させる
list(APPEND QML_IMPORT_PATH "C:/Qt/Tools/QtDesignStudio/qt6_design_studio_reduced_version/qml")

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

# ユーティリティモジュール (Constants 等)
set_source_files_properties(ArcGaugeTest/Constants.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_library(arcgaugetest_lib STATIC)
qt_add_qml_module(arcgaugetest_lib
    URI ArcGaugeTest
    QML_FILES
        ArcGaugeTest/Constants.qml
)

# メインアプリケーション
qt_add_executable(appArcGaugeTest
    main.cpp
)

qt_add_qml_module(appArcGaugeTest
    URI ArcGaugeTestContent
    QML_FILES
        ArcGaugeTestContent/App.qml
        ArcGaugeTestContent/Screen01.ui.qml
        ArcGaugeTestContent/Screen02.ui.qml
)

set_target_properties(appArcGaugeTest PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appArcGaugeTest
    PRIVATE
        Qt6::Quick
        arcgaugetest_libplugin
)

install(TARGETS appArcGaugeTest
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
