cmake_minimum_required(VERSION 3.5)

project(SSIMP_pc VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS Quick REQUIRED)
find_package(Qt6 REQUIRED Widgets LinguistTools QuickControls2)
find_package(OpenSSL REQUIRED) #请确保已安装OpenSSL 3.0

ADD_DEFINITIONS(-DTORRENT_LIBRARY)
ADD_DEFINITIONS(-DNO_FREETYPE)
ADD_DEFINITIONS(-DUNICODE -D_UNICODE)
ADD_DEFINITIONS(-DHCPP_LEGACY_API)

qt_add_executable(appSSIMP_pc
    Daemon/main.cpp
    Daemon/global.h
    Security/security.cpp

    #  工具组件封装
    Utils/verificationcode.h Utils/verificationcode.cpp
    Utils/tcpnetutils.h Utils/tcpnetutils.cpp
    Utils/nget.h Utils/nget.cpp
    Utils/npost.h Utils/npost.cpp
    Utils/netbase.h Utils/netbase.cpp

    # 安全加密组件封装(使用OpenSSL 3.0)
    Security/aes.h Security/aes.cpp
    Security/rsa.h Security/rsa.cpp

    # 界面辅助代理封装
    Daemon/vctrler.h Daemon/vctrler.cpp

    # 资源文件
    resource/resource.qrc
)

qt_add_qml_module(appSSIMP_pc
    URI SSIMP_pc
    VERSION 1.0
    QML_FILES Daemon/daemon.qml
    QML_FILES UIFlame/Menu/Menu.qml
    QML_FILES UIFlame/Menu/MenuDelegate.qml
    QML_FILES UIFlame/Menu/MenuModel.qml
    QML_FILES UIFlame/LoadPage/LoadPage.qml
    QML_FILES UIFlame/MainPage/MainPage.qml
    QML_FILES UIFlame/AboutPage/AboutPage.qml
    QML_FILES UIFlame/AboutPage/AboutQt.qml
    QML_FILES UIFlame/AboutPage/AboutQml.qml
    QML_FILES UIFlame/AboutPage/AboutSoftware.qml
    QML_FILES UIFlame/AboutPage/AboutUS.qml
    QML_FILES UIFlame/AboutPage/OtherOpenSourceProjects.qml
    QML_FILES UIFlame/LoginPage/LoginPage.qml
    QML_FILES UIFlame/MessageBox/MessageBox.qml
    QML_FILES UIFlame/MessageBox/MsgButton.qml
)

file(GLOB TS_FILES "${PROJECT_SOURCE_DIR}/*.ts")

qt_create_translation(appQM_FILES
    ${PROJECT_SOURCE_DIR}
    ${TS_FILES}
    OPTIONS -source-language zh_CN -no-obsolete
    OPTIONS -source-language en_US -no-obsolete

)

set_target_properties(appSSIMP_pc PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER stvsljl.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

set_property(SOURCE file.h PROPERTY SKIP_AUTOGEN ON)

target_compile_definitions(appSSIMP_pc
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(appSSIMP_pc
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Widgets
    PRIVATE Qt6::QuickControls2
    PRIVATE OpenSSL::Crypto OpenSSL::SSL
)
