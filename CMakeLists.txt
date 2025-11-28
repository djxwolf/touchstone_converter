cmake_minimum_required(VERSION 3.10)
project(TouchstoneConverter VERSION 1.0.0 LANGUAGES CXX)

# 设置C++标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 为macOS设置正确的编译器标志
if(APPLE)
    set(CMAKE_OSX_SYSROOT "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -isystem ${CMAKE_OSX_SYSROOT}/usr/include/c++/v1")
endif()

# 设置编译选项
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -Wall -Wextra -Wpedantic")
    set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(CMAKE_CXX_FLAGS_DEBUG "/Od /Zi /W4")
    set(CMAKE_CXX_FLAGS_RELEASE "/O2 /DNDEBUG")
endif()

# 包含头文件目录
include_directories(${CMAKE_SOURCE_DIR}/include)

# 添加源文件
set(SOURCES
    src/main.cpp
    src/touchstone.cpp
)

# 创建可执行文件
add_executable(touchstone_converter ${SOURCES})

# 设置输出目录
set_target_properties(touchstone_converter PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
    RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}
    RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}
)

# 安装目标
install(TARGETS touchstone_converter
    RUNTIME DESTINATION bin
)

# 如果是Unix系统，添加rpath支持
if(UNIX)
    set_target_properties(touchstone_converter PROPERTIES
        INSTALL_RPATH "$ORIGIN"
        BUILD_WITH_INSTALL_RPATH TRUE
    )
endif()

# 添加测试支持
enable_testing()

# 添加自定义目标用于运行示例
add_custom_target(run-example
    COMMAND touchstone_converter v1tov2 examples/sample.s2p examples/output.ts
    DEPENDS touchstone_converter
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "运行示例转换"
)

# 打印配置信息
message(STATUS "Touchstone Converter v${PROJECT_VERSION}")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C++ compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "C++ standard: ${CMAKE_CXX_STANDARD}")