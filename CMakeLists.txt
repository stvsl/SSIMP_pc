cmake_minimum_required(VERSION 3.5)

project(SSIMP_pc VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.3 COMPONENTS Quick REQUIRED)
find_package(Qt6 REQUIRED COMPONENTS Widgets LinguistTools QuickControls2)
find_package(OpenSSL REQUIRED)

if(OPENSSL_FOUND)
  include_directories(${OPENSSL_INCLUDE_DIRS})
  message(STATUS "OpenSSL Found!")
endif()

ADD_DEFINITIONS(-DTORRENT_LIBRARY)
ADD_DEFINITIONS(-DNO_FREETYPE)
ADD_DEFINITIONS(-DUNICODE -D_UNICODE)
ADD_DEFINITIONS(-DHCPP_LEGACY_API)

qt_add_executable(appSSIMP_pc
    Daemon/main.cpp
    Daemon/global.h
    Utils/verificationcode.h
    Utils/tcpnetutils.h
    Security/aes.h
    Security/rsa.h
    Security/security.cpp
    Utils/verificationcode.cpp
    Utils/tcpnetutils.cpp
    Security/aes.cpp
    Security/rsa.cpp
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
