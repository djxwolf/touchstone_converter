#!/bin/bash

# Touchstone转换器测试脚本

echo "=== Touchstone格式转换器测试 ==="
echo

# 设置颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 测试函数
test_conversion() {
    local mode=$1
    local input=$2
    local output=$3
    local description=$4

    echo -e "${YELLOW}测试: $description${NC}"
    echo "命令: $mode $input $output"

    if ./touchstone_converter "$mode" "$input" "$output"; then
        echo -e "${GREEN}✓ 转换成功${NC}"
        if [ -f "$output" ]; then
            echo "输出文件大小: $(stat -f%z "$output" 2>/dev/null || stat -c%s "$output" 2>/dev/null || echo "未知") 字节"
            echo "前5行输出:"
            head -5 "$output" | sed 's/^/  /'
        fi
    else
        echo -e "${RED}✗ 转换失败${NC}"
    fi
    echo "----------------------------------------"
    echo
}

# 进入build目录
cd "$(dirname "$0")/build" || {
    echo "错误: 无法进入build目录"
    echo "请先运行: mkdir build && cd build && cmake .. && make"
    exit 1
}

# 检查可执行文件
if [ ! -f "./touchstone_converter" ]; then
    echo "错误: 找不到touchstone_converter可执行文件"
    echo "请先编译项目"
    exit 1
fi

echo "可执行文件: $(realpath ./touchstone_converter)"
echo

# 运行测试
test_conversion "v1tov2" "../examples/sample.s2p" "../examples/test1_output.ts" "v1到v2格式转换 (MA格式)"
test_conversion "v1tov2" "../examples/sample_ri.s2p" "../examples/test2_output.ts" "v1到v2格式转换 (RI格式)"
test_conversion "v2tov1" "../examples/sample_v2.ts" "../examples/test3_output.s2p" "v2到v1格式转换"
test_conversion "v2tov1" "../examples/test1_output.ts" "../examples/test4_output.s2p" "转换回去测试"

# 错误测试
echo -e "${YELLOW}错误处理测试:${NC}"
echo "1. 测试无效参数..."
./touchstone_converter invalid_mode input.s2p output.ts 2>&1 | head -3
echo

echo "2. 测试不存在的文件..."
./touchstone_converter v1tov2 nonexistent.s2p output.ts 2>&1 | head -3
echo

echo "3. 测试缺少参数..."
./touchstone_converter v1tov2 input.s2p 2>&1 | head -3
echo

echo -e "${GREEN}=== 测试完成 ===${NC}"