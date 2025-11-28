#!/bin/bash

# Touchstone转换器一键运行脚本 (macOS)
# 使用方法: ./run_converter.sh <转换模式> <输入文件> <输出文件>

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目路径
PROJECT_DIR="/Users/wenjian/work/touchstone_converter"
BUILD_DIR="$PROJECT_DIR/build"
EXECUTABLE="$BUILD_DIR/touchstone_converter"

# 检查参数
if [ $# -ne 3 ]; then
    echo -e "${BLUE}Touchstone格式转换器 v1.0${NC}"
    echo
    echo "用法: $0 <转换模式> <输入文件> <输出文件>"
    echo
    echo "转换模式:"
    echo "  v1tov2   将Touchstone v1格式转换为v2格式"
    echo "  v2tov1   将Touchstone v2格式转换为v1格式"
    echo
    echo "示例:"
    echo "  $0 v1tov2 examples/sample.s2p output.ts"
    echo "  $0 v2tov1 examples/sample_v2.ts output.s2p"
    echo
    echo "支持格式:"
    echo "  Touchstone v1: .s1p, .s2p, .s3p, .s4p"
    echo "  Touchstone v2: .ts"
    exit 1
fi

MODE=$1
INPUT=$2
OUTPUT=$3

# 检查可执行文件是否存在
if [ ! -f "$EXECUTABLE" ]; then
    echo -e "${YELLOW}未找到可执行文件，开始编译...${NC}"

    # 创建build目录
    if [ ! -d "$BUILD_DIR" ]; then
        mkdir -p "$BUILD_DIR"
        echo -e "${GREEN}✓ 创建构建目录${NC}"
    fi

    # 配置CMake
    cd "$PROJECT_DIR"
    if cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug; then
        echo -e "${GREEN}✓ CMake配置成功${NC}"
    else
        echo -e "${RED}✗ CMake配置失败${NC}"
        exit 1
    fi

    # 编译
    if cmake --build build; then
        echo -e "${GREEN}✓ 编译成功${NC}"
    else
        echo -e "${RED}✗ 编译失败${NC}"
        exit 1
    fi

    # 再次检查可执行文件
    if [ ! -f "$EXECUTABLE" ]; then
        echo -e "${RED}✗ 编译后仍找不到可执行文件${NC}"
        exit 1
    fi
fi

# 检查输入文件
if [ ! -f "$PROJECT_DIR/$INPUT" ]; then
    echo -e "${RED}错误: 输入文件不存在: $PROJECT_DIR/$INPUT${NC}"
    exit 1
fi

# 切换到build目录
cd "$BUILD_DIR"

# 构建完整路径
FULL_INPUT="../$INPUT"
FULL_OUTPUT="../$OUTPUT"

# 运行转换
echo -e "${BLUE}Touchstone格式转换器${NC}"
echo -e "输入文件: $FULL_INPUT"
echo -e "输出文件: $FULL_OUTPUT"
echo -e "转换模式: $MODE"
echo "------------------------"

if ./touchstone_converter "$MODE" "$FULL_INPUT" "$FULL_OUTPUT"; then
    echo
    echo -e "${GREEN}✓ 转换完成!${NC}"

    # 检查输出文件
    if [ -f "$PROJECT_DIR/$OUTPUT" ]; then
        FILE_SIZE=$(stat -f%z "$PROJECT_DIR/$OUTPUT" 2>/dev/null || echo "未知")
        echo -e "${GREEN}输出文件大小: $FILE_SIZE 字节${NC}"
        echo -e "输出文件位置: ${BLUE}$PROJECT_DIR/$OUTPUT${NC}"

        # 显示文件前几行
        echo
        echo -e "${YELLOW}输出文件预览:${NC}"
        head -10 "$PROJECT_DIR/$OUTPUT" | sed 's/^/  /'
    fi
else
    echo -e "${RED}✗ 转换失败${NC}"
    exit 1
fi