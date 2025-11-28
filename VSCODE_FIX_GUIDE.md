# VS Code头文件问题修复指南

## 问题描述
VS Code显示无法打开标准库头文件，如 `#include <vector>`

## 🚀 快速解决方案 (推荐)

### 1. 重新启动VS Code
关闭VS Code，重新打开项目目录：
```bash
code touchstone_converter/
```

### 2. 安装推荐的VS Code扩展
按 `Cmd+Shift+X` 打开扩展面板，搜索并安装：
- **C/C++** (Microsoft)
- **CMake Tools** (Microsoft)

### 3. 运行自动配置脚本
```bash
cd touchstone_converter
./setup_vscode.sh
```

## 🔧 手动解决方案

如果自动配置不起作用，请按以下步骤操作：

### 步骤1: 选择正确的配置
1. 在VS Code中按 `Cmd+Shift+P`
2. 输入: `C/C++: Select a Configuration...`
3. 选择: **Mac**

### 步骤2: 重置IntelliSense
1. 按 `Cmd+Shift+P`
2. 输入: `C/C++: Reset IntelliSense Database`
3. 重启VS Code

### 步骤3: 检查配置文件
确认 `.vscode/c_cpp_properties.json` 包含以下路径：

```json
{
    "configurations": [
        {
            "name": "Mac",
            "includePath": [
                "${workspaceFolder}/**",
                "${workspaceFolder}/include",
                "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1"
            ],
            "compilerPath": "/usr/bin/clang++",
            "cppStandard": "c++17",
            "intelliSenseMode": "macos-clang-arm64"
        }
    ],
    "version": 4
}
```

## 🧪 测试修复是否成功

### 测试1: 检查头文件
1. 打开 `include/touchstone.h`
2. 检查是否还有红色波浪线
3. 尝试按 `F12` 或 `Cmd+Click` 跳转到 `vector` 定义

### 测试2: 编译测试代码
1. 打开 `test_vscode.cpp`
2. 按 `Cmd+Shift+P`
3. 选择 "Tasks: Run Task" → "CMake Build"
4. 检查是否编译成功

### 测试3: 直接运行测试
```bash
cd touchstone_converter
g++ -std=c++17 test_vscode.cpp -o test
./test
```

## 📋 常见问题解决

### 问题1: 扩展冲突
如果安装了多个C++扩展：
```bash
# 卸载旧扩展
code --list-extensions | grep -i "cpp\|c\+\+"
# 只保留Microsoft的官方扩展
```

### 问题2: 配置冲突
```bash
# 删除旧的配置缓存
rm -rf .vscode/.c_cpp_* cache
```

### 问题3: 权限问题
```bash
# 确保项目目录权限正确
chmod -R 755 .
```

## 🔍 验证环境

检查开发环境是否正确：
```bash
# 检查编译器
clang++ --version

# 检查CMake
cmake --version

# 检查Xcode工具
xcode-select --print-path

# 检查SDK
ls /Library/Developer/CommandLineTools/SDKs/
```

## 💡 替代方案

如果VS Code配置仍有问题，可以：

### 使用VS Code Remote
1. 安装 "Remote - Containers" 扩展
2. 使用包含C++开发环境的Docker容器

### 使用其他编辑器
- **CLion**: JetBrains的专业C++ IDE
- **Xcode**: macOS原生IDE
- **Vim/Neovim**: 配置正确的插件

### 使用命令行开发
```bash
# 编译项目
cd touchstone_converter
mkdir -p build && cd build
cmake ..
make

# 运行程序
./touchstone_converter v1tov2 ../examples/sample.s2p output.ts
```

## 📞 获取帮助

如果问题仍然存在：
1. 运行诊断脚本：`./setup_vscode.sh`
2. 检查VS Code输出面板的错误信息
3. 查看VS Code问题报告：`Help → Show Developer → Issue Reporter`

---

## ✅ 成功标志

当修复成功时，您应该看到：
- ✅ `#include <vector>` 等头文件没有错误提示
- ✅ 代码补全正常工作
- ✅ `F12` 可以跳转到标准库定义
- ✅ 编译没有错误
- ✅ 程序可以正常运行