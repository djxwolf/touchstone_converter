#!/bin/bash

# VS Code C++环境配置脚本 (macOS)
echo "🔧 配置VS Code C++开发环境..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_DIR="/Users/wenjian/work/touchstone_converter"

echo -e "${BLUE}当前项目目录: $PROJECT_DIR${NC}"

# 检查项目目录
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}错误: 找不到项目目录 $PROJECT_DIR${NC}"
    exit 1
fi

# 检查Xcode命令行工具
echo -e "\n${YELLOW}检查开发工具...${NC}"
if [ -d "/Library/Developer/CommandLineTools" ]; then
    echo -e "${GREEN}✓ Xcode命令行工具已安装${NC}"

    # 检查可用的SDK
    SDK_BASE="/Library/Developer/CommandLineTools/SDKs"
    if [ -d "$SDK_BASE" ]; then
        echo -e "${GREEN}✓ 可用的SDK:${NC}"
        ls -la "$SDK_BASE" | grep ".sdk" | awk '{print "  " $9}'
    fi
else
    echo -e "${RED}✗ 未安装Xcode命令行工具${NC}"
    echo -e "${YELLOW}请运行: xcode-select --install${NC}"
    exit 1
fi

# 检查编译器
echo -e "\n${YELLOW}检查编译器...${NC}"
if command -v clang++ >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Clang++: $(clang++ --version | head -1)${NC}"
else
    echo -e "${RED}✗ 未找到Clang++${NC}"
    exit 1
fi

# 检查CMake
if command -v cmake >/dev/null 2>&1; then
    echo -e "${GREEN}✓ CMake: $(cmake --version | head -1)${NC}"
else
    echo -e "${RED}✗ 未安装CMake${NC}"
    echo -e "${YELLOW}请安装: brew install cmake${NC}"
    exit 1
fi

# 检查VS Code扩展
echo -e "\n${YELLOW}推荐的VS Code扩展:${NC}"
echo -e "${BLUE}  • C/C++ (Microsoft)${NC}"
echo -e "${BLUE}  • CMake Tools (Microsoft)${NC}"
echo -e "${BLUE}  • C/C++ Extension Pack (Microsoft)${NC}"

# 创建简化配置
echo -e "\n${YELLOW}生成VS Code配置文件...${NC}"

# 更新c_cpp_properties.json为简化版本
cat > "$PROJECT_DIR/.vscode/c_cpp_properties_simple.json" << 'EOF'
{
    "configurations": [
        {
            "name": "Mac",
            "includePath": [
                "${workspaceFolder}/**",
                "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1",
                "/Library/Developer/CommandLineTools/usr/include/c++/v1"
            ],
            "defines": [],
            "compilerPath": "/usr/bin/clang++",
            "cStandard": "c17",
            "cppStandard": "c++17",
            "intelliSenseMode": "macos-clang-arm64"
        }
    ],
    "version": 4
}
EOF

# 临时替换配置文件
cp "$PROJECT_DIR/.vscode/c_cpp_properties_simple.json" "$PROJECT_DIR/.vscode/c_cpp_properties.json"
echo -e "${GREEN}✓ 已更新c_cpp_properties.json${NC}"

# 创建测试用的简单文件
cat > "$PROJECT_DIR/test_vscode.cpp" << 'EOF'
// 测试VS Code C++配置
#include <iostream>
#include <vector>
#include <string>
#include <complex>

int main() {
    std::vector<std::string> messages = {
        "✓ vector头文件正常",
        "✓ string头文件正常",
        "✓ complex头文件正常",
        "✓ iostream头文件正常"
    };

    for (const auto& msg : messages) {
        std::cout << msg << std::endl;
    }

    std::complex<double> test(1.0, 2.0);
    std::cout << "复数测试: " << test << std::endl;

    return 0;
}
EOF

echo -e "${GREEN}✓ 已创建测试文件 test_vscode.cpp${NC}"

# 创建VS Code启动配置
cat > "$PROJECT_DIR/.vscode/settings_simple.json" << 'EOF'
{
    "C_Cpp.intelliSenseEngine": "default",
    "C_Cpp.default.configurationProvider": "ms-vscode.cmake-tools",
    "C_Cpp.default.cppStandard": "c++17",
    "C_Cpp.default.cStandard": "c17",
    "files.associations": {
        "*.h": "cpp",
        "*.hpp": "cpp"
    },
    "editor.tabSize": 4,
    "editor.insertSpaces": true
}
EOF

echo -e "${GREEN}✓ 已创建简化设置文件${NC}"

# 提供使用说明
echo -e "\n${BLUE}=== 配置完成 ===${NC}"
echo -e "\n${YELLOW}下一步操作:${NC}"
echo -e "1. 重新启动VS Code (关闭后重新打开项目)"
echo -e "2. 按Ctrl+Shift+P (或Cmd+Shift+P) 打开命令面板"
echo -e "3. 输入 'C/C++: Select a Configuration...'"
echo -e "4. 选择 'Mac' 配置"
echo -e "5. 打开 include/touchstone.h 检查头文件错误是否解决"
echo -e "6. 打开 test_vscode.cpp 测试基本功能"

echo -e "\n${YELLOW}如果问题仍然存在:${NC}"
echo -e "• 在VS Code中按 Ctrl+Shift+P"
echo -e "• 输入 'C/C++: Reset IntelliSense Database'"
echo -e "• 重启VS Code"

echo -e "\n${GREEN}配置脚本执行完成！${NC}"