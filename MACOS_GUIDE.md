# macOS上使用Touchstone转换器指南

## VS Code快捷键 (macOS)

### 重要快捷键
- ⌘+Shift+B: 构建项目 (不是Ctrl+Shift+B)
- ⌘+Shift+P: 打开命令面板
- F5: 开始调试
- ⌘+/: 切换注释

### VS Code中构建项目

#### 方法1: 使用快捷键
1. 在VS Code中打开项目
2. 按 `⌘+Shift+B` 选择构建任务

#### 方法2: 使用命令面板
1. 按 `⌘+Shift+P`
2. 输入 "Tasks: Run Task"
3. 选择 "CMake Build"

#### 方法3: 使用终端
1. 在VS Code中按 `⌘+\`` 打开集成终端
2. 运行以下命令：

```bash
# 如果build目录不存在
mkdir -p build

# 配置CMake
cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug

# 编译
cmake --build build
```

## 运行程序

### 在VS Code终端中
```bash
cd build
./touchstone_converter v1tov2 ../examples/sample.s2p output.ts
```

### 使用命令面板运行
1. 按 `⌘+Shift+P`
2. 输入 "Tasks: Run Task"
3. 选择 "Run Converter"

## 调试程序

1. 在代码中设置断点（点击行号左侧）
2. 按 `F5` 开始调试
3. 在弹出的对话框中选择配置（通常默认即可）

## 常见问题解决

### 如果快捷键不工作
1. 检查VS Code是否是最新版本
2. 重启VS Code
3. 使用命令面板 (`⌘+Shift+P`) 手动运行任务

### 如果编译失败
```bash
# 清理并重新编译
rm -rf build
mkdir build
cd build
cmake ..
make
```

### 如果找不到可执行文件
```bash
# 检查是否在正确的目录
cd /Users/wenjian/work/touchstone_converter/build
ls -la touchstone_converter
```

## 一键脚本

创建一个便于使用的脚本：

```bash
# 在项目根目录创建
cat > run_converter.sh << 'EOF'
#!/bin/bash
cd /Users/wenjian/work/touchstone_converter/build
./touchstone_converter "$@"
EOF

chmod +x run_converter.sh
```

现在可以直接使用：
```bash
./run_converter.sh v1tov2 examples/sample.s2p output.ts
```

## 验证安装

运行完整测试：
```bash
./test_converter.sh
```

## VS Code扩展推荐

安装以下扩展以获得更好的体验：
1. C/C++ (Microsoft)
2. CMake Tools (Microsoft)
3. CMake Language Support (twxs)

## 环境检查

确保您的环境正确配置：

```bash
# 检查编译器
clang++ --version

# 检查CMake
cmake --version

# 检查Xcode命令行工具
xcode-select --print-path
```

如果任何工具未安装，运行：
```bash
# 安装Xcode命令行工具
xcode-select --install

# 安装CMake (如果没有)
brew install cmake
```