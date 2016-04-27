cmake_minimum_required(VERSION 2.8.11)

project(vncmanager-greeter)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt5Widgets REQUIRED)

add_definitions(-std=c++11)

include_directories(${QT_INCLUDES} ${CMAKE_CURRENT_BINARY_DIR})

set(vncmanager-greeter_SRCS Greeter.cpp ManagerConnection.cpp Session.cpp main.cpp)

set(vncmanager-greeter_FORMS Greeter.ui)

qt5_wrap_ui(vncmanager-greeter_FORMS_HEADERS ${vncmanager-greeter_FORMS})

add_executable(vncmanager-greeter ${vncmanager-greeter_SRCS} ${vncmanager-greeter_FORMS_HEADERS})
target_link_libraries(vncmanager-greeter Qt5::Widgets)

install(TARGETS vncmanager-greeter RUNTIME DESTINATION bin)
