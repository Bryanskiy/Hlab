cmake_minimum_required(VERSION 3.10)
project(ParaCL)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_FLAGS_RELEASE "-O2")
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0")

find_package(BISON 3.7 REQUIRED)
find_package(FLEX REQUIRED)

set(grammarPath "${CMAKE_CURRENT_SOURCE_DIR}/parser")
set(driverPath "${CMAKE_CURRENT_SOURCE_DIR}/driver")

BISON_TARGET(parser ${grammarPath}/parser.y ${grammarPath}/parser.cc
             DEFINES_FILE ${grammarPath}/parser.hh)

message(STATUS "bison files generated in: ${BISON_parser_OUTPUTS}")

FLEX_TARGET(lexer ${grammarPath}/lexer.l  ${grammarPath}/lexer.cc)
message(STATUS "flex files generated in: ${FLEX_lexer_OUTPUTS}")

add_flex_bison_dependency(lexer parser)

add_executable(
    main main.cc
    ${driverPath}/driver.cc
    ${FLEX_lexer_OUTPUTS}  
    ${BISON_parser_OUTPUTS}
)

target_include_directories(
    main
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/driver
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/parser
)
