#!/bin/bash

# VS Code C++环境诊断脚本
echo "🔍 VS Code C++环境诊断..."
echo

# Color定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_DIR="/Users/wenjian/work/touchstone_converter"
cd "$PROJECT_DIR"

echo -e "${BLUE}=== 环境检查 ===${NC}"

# 1. 检查编译器
echo -e "${YELLOW}1. 检查编译器:${NC}"
if command -v clang++ >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Clang++: $(clang++ --version | head -1)${NC}"
    CLANG_PATH=$(which clang++)
    echo -e "   路径: $CLANG_PATH"

    # Test头文件路径
    TEST_FILE=$(mktemp)
    echo "#include <vector>" | clang++ -x c++ -E - > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ 标准库头文件可访问${NC}"
    else
        echo -e "${RED}✗ 标准库头文件不可访问${NC}"
    fi
    rm -f $TEST_FILE
else
    echo -e "${RED}✗ 未找到Clang++${NC}"
    echo -e "   请安装Xcode命令行工具: xcode-select --install"
fi

echo

# 2. 检查CMake
echo -e "${YELLOW}2. 检查CMake:${NC}"
if command -v cmake >/dev/null 2>&1; then
    echo -e "${GREEN}✓ CMake: $(cmake --version | head -1)${NC}"
else
    echo -e "${RED}✗ 未安装CMake${NC}"
    echo -e "   请安装: brew install cmake"
fi

echo

# 3. 检查VS Code
echo -e "${YELLOW}3. 检查VS Code:${NC}"
if command -v code >/dev/null 2>&1; then
    echo -e "${GREEN}✓ VS Code已安装${NC}"
    CODE_VERSION=$(code --version | head -1)
    echo -e "   版本: $CODE_VERSION"
else
    echo -e "${RED}✗ 未安装VS Code${NC}"
    echo -e "   请安装: https://code.visualstudio.com/"
fi

echo

# 4. 检查SDK路径
echo -e "${YELLOW}4. 检查SDK路径:${NC}"
SDK_PATHS=(
    "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1"
    "/Library/Developer/CommandLineTools/usr/include/c++/v1"
    "/usr/include/c++/v1"
)

for path in "${SDK_PATHS[@]}"; do
    if [ -d "$path" ]; then
        echo -e "${GREEN}✓ 找到SDK路径: $path${NC}"
        # Check关键头文件
        if [ -f "$path/vector" ]; then
            echo -e "  ✓ 包含vector"
        else
            echo -e "  ✗ 缺少vector"
        fi
    else
        echo -e "${RED}✗ SDK路径不存在: $path${NC}"
    fi
done

echo

# 5. 检查项目配置
echo -e "${YELLOW}5. 检查项目配置:${NC}"
if [ -f ".vscode/c_cpp_properties.json" ]; then
    echo -e "${GREEN}✓ 找到c_cpp_properties.json${NC}"

    # Check配置内容
    if grep -q "includePath" .vscode/c_cpp_properties.json; then
        echo -e "  ✓ 包含includePath配置"
    else
        echo -e "  ✗ 缺少includePath配置"
    fi

    if grep -q "Mac" .vscode/c_cpp_properties.json; then
        echo -e "  ✓ 包含Mac配置"
    else
        echo -e "  ✗ 缺少Mac配置"
    fi
else
    echo -e "${RED}✗ 未找到c_cpp_properties.json${NC}"
fi

if [ -f "CMakeLists.txt" ]; then
    echo -e "${GREEN}✓ 找到CMakeLists.txt${NC}"
else
    echo -e "${RED}✗ 未找到CMakeLists.txt${NC}"
fi

echo

# 6. 检查源文件
echo -e "${YELLOW}6. 检查源文件:${NC}"
if [ -f "include/touchstone.h" ]; then
    echo -e "${GREEN}✓ 找到头文件: include/touchstone.h${NC}"

    # Check头文件内容
    if grep -q "#include <vector>" include/touchstone.h; then
        echo -e "  ✓ 使用vector头文件"
    else
        echo -e "  ✗ 未使用vector头文件"
    fi
else
    echo -e "${RED}✗ 未找到头文件${NC}"
fi

if [ -f "src/main.cpp" ]; then
    echo -e "${GREEN}✓ 找到主文件: src/main.cpp${NC}"
else
    echo -e "${RED}✗ 未找到主文件${NC}"
fi

echo

# 7. 测试编译
echo -e "${YELLOW}7. 测试编译:${NC}"
echo -e "正在测试编译..."

if [ -d "build" ]; then
    echo -e "${GREEN}✓ 构建目录存在${NC}"
    cd build

    if [ -f "touchstone_converter" ]; then
        echo -e "${GREEN}✓ 可执行文件存在${NC}"
        cd ..
    else
        echo -e "${YELLOW}⚠ 可执行文件不存在，尝试编译...${NC}"
        cd ..

        if cmake --build build >/dev/null 2>&1; then
            echo -e "${GREEN}✓ 编译成功${NC}"
        else
            echo -e "${RED}✗ 编译失败${NC}"
            echo -e "  尝试重新配置:"
            echo -e "    rm -rf build"
            echo -e "    mkdir build && cd build"
            echo -e "    cmake .."
            echo -e "    make"
        fi
    fi
else
    echo -e "${YELLOW}⚠ 构建目录不存在，创建并编译...${NC}"

    if mkdir -p build && cd build && cmake .. >/dev/null 2>&1 && make >/dev/null 2>&1; then
        echo -e "${GREEN}✓ 创建构建目录并编译成功${NC}"
    else
        echo -e "${RED}✗ 创建构建目录或编译失败${NC}"
        cd ..
    fi
fi

echo

# 8. VS Code扩展检查
echo -e "${YELLOW}8. VS Code扩展建议:${NC}"
echo -e "请安装以下扩展："
echo -e "${BLUE}• C/C++ (Microsoft) - ms-vscode.cpptools${NC}"
echo -e "${BLUE}• CMake Tools (Microsoft) - ms-vscode.cmake-tools${NC}"
echo -e "${BLUE}• C/C++ Extension Pack (Microsoft) - ms-vscode.cpptools-extension-pack${NC}"

echo

# 9. 生成修复命令
echo -e "${BLUE}=== 修复命令 ===${NC}"
echo -e "${YELLOW}如果发现问题，请依次执行:${NC}"
echo
echo -e "${BLUE}1. 重置IntelliSense:${NC}"
echo -e "   在VS Code中按 Cmd+Shift+P"
echo -e "   输入: C/C++: Reset IntelliSense Database"
echo
echo -e "${BLUE}2. 重新选择配置:${NC}"
echo -e "   在VS Code中按 Cmd+Shift+P"
echo -e "   输入: C/C++: Select a Configuration..."
echo -e "   选择: Mac"
echo
echo -e "${BLUE}3. 重新编译:${NC}"
echo -e "   rm -rf build"
echo -e "   mkdir build && cd build"
echo -e "   cmake .. && make"
echo
echo -e "${BLUE}4. 测试运行:${NC}"
echo -e "   cd build"
echo -e "   ./touchstone_converter --help"

echo
echo -e "${GREEN}诊断完成！${NC}"
echo -e "${YELLOW}如果仍有问题，请查看 VSCODE_FIX_GUIDE.md 获取详细解决方案${NC}"