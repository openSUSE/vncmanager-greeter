cmake_minimum_required(VERSION 3.16)

project(vncmanager-greeter)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(vncmanager-greeter
    main.cpp
    ManagerConnection.cpp
)

qt_add_qml_module(vncmanager-greeter
    URI vncmanager_greeter
    VERSION 1.0
    QML_FILES greeter.qml
)

target_compile_definitions(vncmanager-greeter
    PRIVATE $<$<CONFIG:Debug>:QT_QML_DEBUG>)
target_link_libraries(vncmanager-greeter
    PRIVATE Qt6::Quick)

install(TARGETS vncmanager-greeter RUNTIME DESTINATION bin)
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/vncmanager-greeter.conf" DESTINATION "${CMAKE_INSTALL_FULL_SYSCONFDIR}/vnc")
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/style/" DESTINATION "${CMAKE_INSTALL_FULL_DATADIR}/vncmanager-greeter")
