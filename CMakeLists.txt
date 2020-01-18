cmake_minimum_required(VERSION 3.13)
project("hello_world")

set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
include(GNUInstallDirs)
include(macros)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_definitions(-Wall -Wpedantic -Werror)

set(CMAKE_ORIGINAL_BINARY_DIR ${CMAKE_BINARY_DIR})
set(CMAKE_BINARY_DIR ${CMAKE_BINARY_DIR}/bin)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})
set(LIBRARY_OUTPUT_PATH ${CMAKE_ORIGINAL_BINARY_DIR}/lib)
set(HEADER_OUTPUT_PATH ${CMAKE_ORIGINAL_BINARY_DIR}/include)

include_directories(${HEADER_OUTPUT_PATH})

add_subdirectory(${PROJECT_SOURCE_DIR}/src)

enable_testing()
set(CMAKE_BINARY_DIR ${CMAKE_ORIGINAL_BINARY_DIR}/testbin)
include(GTest)
add_subdirectory(test)
