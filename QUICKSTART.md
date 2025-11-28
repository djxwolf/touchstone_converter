# 快速开始指南

## 1. 在VS Code中打开项目

```bash
cd touchstone_converter
code .
```

## 2. 编译项目

VS Code会自动检测CMake项目，首次打开时会询问构建配置。

### 手动编译（如果需要）

```bash
# 创建构建目录
mkdir build
cd build

# 配置CMake
cmake ..

# 编译
make
```

## 3. 运行转换

### 基本用法

```bash
# v1转v2
./build/touchstone_converter v1tov2 examples/sample.s2p output.ts

# v2转v1
./build/touchstone_converter v2tov1 examples/sample_v2.ts output.s2p
```

### 在VS Code中运行

1. 按 `Ctrl+Shift+B` (或 `Cmd+Shift+B` on Mac) 构建项目
2. 按 `Ctrl+Shift+P` 选择 "Tasks: Run Task"
3. 选择 "Run Converter"
4. 输入转换模式、输入文件和输出文件

## 4. 调试

1. 在代码中设置断点
2. 按 `F5` 启动调试
3. 选择转换模式和文件

## 5. 运行测试

```bash
# 运行完整测试套件
./test_converter.sh

# 或者进入build目录运行
cd build
../test_converter.sh
```

## 6. 示例文件

- `examples/sample.s2p` - Touchstone v1格式示例
- `examples/sample_ri.s2p` - v1格式（实部/虚部）
- `examples/sample_v2.ts` - Touchstone v2格式示例

## 常见问题

### 编译错误

如果遇到编译错误，请确保：

1. 已安装Xcode Command Line Tools (macOS)
2. 使用C++17兼容的编译器
3. CMake 3.10+

### 运行时错误

如果程序无法运行，检查：

1. 输入文件存在且格式正确
2. 输出路径有写入权限
3. 转换模式参数正确

## 项目结构

```
touchstone_converter/
├── include/touchstone.h     # 头文件
├── src/
│   ├── main.cpp            # 主程序
│   └── touchstone.cpp      # 核心实现
├── examples/               # 示例文件
├── build/                  # 编译输出
├── .vscode/               # VS Code配置
├── CMakeLists.txt         # CMake配置
├── test_converter.sh      # 测试脚本
├── QUICKSTART.md          # 本文档
└── README.md              # 详细文档
```

## 支持的格式

- **v1格式**: .s1p, .s2p, .s3p, .s4p
- **v2格式**: .ts
- **数据格式**: MA, DB_ANGLE, RI
- **参数类型**: S, Y, Z, H, G, A