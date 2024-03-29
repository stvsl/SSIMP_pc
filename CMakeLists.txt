cmake_minimum_required(VERSION 3.5)

project(SSIMP_pc VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_compile_definitions(
    #加密组件调试模式开关 0:关闭 1:开启
    ENCRYPT_ERR_DEBUG=0
    #调试模式开关 0:关闭 1:开启
    ARTICLE_DEBUG=0
    TASKSET_DEBUG=0
    ATTENDANCE_DEBUG=0
)

find_package(Qt6 COMPONENTS Quick Qml REQUIRED WebEngineQuick WebEngineCore WebChannel)
find_package(Qt6 REQUIRED Widgets LinguistTools QuickControls2)

ADD_DEFINITIONS(-DTORRENT_LIBRARY)
ADD_DEFINITIONS(-DNO_FREETYPE)
ADD_DEFINITIONS(-DUNICODE -D_UNICODE)
ADD_DEFINITIONS(-DHCPP_LEGACY_API)


add_custom_command(
    OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/Plugins/lib/libcrypto.so
    COMMAND go build -o Plugins/lib/libcrypto.so -buildmode=c-shared ./Plugins/Encrypt_go_binding/libencryptiongo/main.go
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "******************************编译Go组件******************************"
)

add_custom_target(
    COMMENT "******************************注册Go组件******************************"
    crypto ALL
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Plugins/lib/libcrypto.so
)

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
    Utils/imgutils.h Utils/imgutils.cpp

    # 安全加密组件封装(Go组件编译绑定)
    Security/encryption.h Security/encryption.cpp

    # 业务逻辑组件封装
    Service/accountservice.h Service/accountservice.cpp
    Service/employeeservice.h Service/employeeservice.cpp
    Service/articleservice.h Service/articleservice.cpp
    Service/tasksetservice.h Service/tasksetservice.cpp
    Service/taskservice.h Service/taskservice.cpp
    Service/attendanceservice.h Service/attendanceservice.cpp
    Service/feedbackservice.h Service/feedbackservice.cpp

    ModeData/employeedata.h ModeData/employeedata.cpp
    ModeData/articledata.h ModeData/articledata.cpp
    ModeData/tasksetdata.h ModeData/tasksetdata.cpp
    ModeData/taskdata.h ModeData/taskdata.cpp
    ModeData/attendancedata.h ModeData/attendancedata.cpp
    ModeData/feedbackdata.h ModeData/feedbackdata.cpp

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
    QML_FILES UIFlame/GlobalOverviewPage/GlobalOverviewPage.qml
    QML_FILES UIFlame/DataMonitorPage/DataMonitorPage.qml
    QML_FILES UIFlame/FeedbackPage/FeedbackPage.qml
    QML_FILES UIFlame/EmployeePage/EmployeePage.qml
    QML_FILES UIFlame/TaskPage/TaskPage.qml
    QML_FILES UIFlame/ContentMgrPage/ContentMgrPage.qml
    QML_FILES UIFlame/TaskSetPage/TaskSetPage.qml
    QML_FILES UIFlame/LsKyPage/LsKyPage.qml
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

 qt_create_translation(appSSIMP_pc
     ${PROJECT_SOURCE_DIR}
     ${TS_FILES}
     OPTIONS -source-language zh_CN -no-obsolete
     OPTIONS -source-language en_US -no-obsolete
 )
#qt_add_translations(appSSIMP_pc
#    TS_FILES
#    translations/SSIMP_pc_zh_CN.ts
#    translations/SSIMP_pc_en_US.ts
#    QM_FILES_OUTPUT_VARIABLE qm_files
#)
#install(FILES ${qm_files} DESTINATION "translations")

set_target_properties(appSSIMP_pc PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER stvsljl.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(appSSIMP_pc
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(appSSIMP_pc
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Widgets
    PRIVATE Qt6::QuickControls2
    PRIVATE Qt6::Qml
    PRIVATE Qt6::WebEngineQuick
    PRIVATE Qt6::WebEngineCore
    PRIVATE Qt6::WebChannel
    )

target_link_libraries(appSSIMP_pc PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/Plugins/lib/libcrypto.so)


# target_compile_definitions(appSSIMP_pc PRIVATE QT_DEPRECATED_WARNINGS)
