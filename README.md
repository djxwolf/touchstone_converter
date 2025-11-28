# Touchstone格式转换器

一个用于在Touchstone v1和v2格式之间进行转换的C++应用程序。

## 功能特性

- ✅ 支持Touchstone v1格式 (.s1p, .s2p, .s3p, .s4p)
- ✅ 支持Touchstone v2格式 (.ts)
- ✅ 支持多种数据格式：MA（幅度/角度）、DB_ANGLE（dB/角度）、RI（实部/虚部）
- ✅ 支持多种网络参数类型：S、Y、Z、H、G、A参数
- ✅ 跨平台支持（Windows、Linux、macOS）
- ✅ VS Code集成开发环境支持

## 项目结构

```
touchstone_converter/
├── include/
│   └── touchstone.h          # 主要头文件
├── src/
│   ├── main.cpp              # 程序入口点
│   └── touchstone.cpp        # 核心实现
├── examples/
│   ├── sample.s2p           # v1格式示例文件
│   ├── sample_ri.s2p        # v1格式示例文件（实部/虚部）
│   └── sample_v2.ts         # v2格式示例文件
├── .vscode/
│   ├── tasks.json           # VS Code构建任务
│   ├── launch.json          # VS Code调试配置
│   ├── settings.json        # VS Code项目设置
│   └── c_cpp_properties.json # C++配置
├── build/                   # 构建输出目录
├── CMakeLists.txt           # CMake配置文件
└── README.md                # 项目说明文档
```

## 编译要求

- C++17或更高版本
- CMake 3.10或更高版本
- 支持的编译器：
  - GCC 7.0+
  - Clang 6.0+
  - MSVC 2017+

## 编译说明

### 使用VS Code（推荐）

1. 在VS Code中打开项目文件夹：
   ```bash
   code touchstone_converter/
   ```

2. VS Code会自动配置CMake工具，首次打开时会询问构建配置，选择"Debug"

3. **macOS用户注意**：使用`Cmd+Shift+B`构建项目（不是Ctrl+Shift+B）

   或者使用命令面板（`Cmd+Shift+P`）选择"Tasks: Run Task"，然后选择"CMake Build"

4. 如果快捷键不工作，请查看 [MACOS_GUIDE.md](MACOS_GUIDE.md) 获取详细说明

### 手动编译

```bash
# 创建构建目录
cd touchstone_converter
mkdir build
cd build

# 配置CMake
cmake -DCMAKE_BUILD_TYPE=Debug ..

# 编译
cmake --build .

# 或者使用make（Linux/macOS）
make
```

## 使用方法

### 命令行格式

```bash
./touchstone_converter <转换模式> <输入文件> <输出文件>
```

### 转换模式

- `v1tov2`: 将Touchstone v1格式转换为v2格式
- `v2tov1`: 将Touchstone v2格式转换为v1格式

### 使用示例

#### v1转v2
```bash
# 转换2端口S参数文件
./touchstone_converter v1tov2 examples/sample.s2p output.ts

# 转换实部/虚部格式
./touchstone_converter v1tov2 examples/sample_ri.s2p output_ri.ts
```

#### v2转v1
```bash
# 转换为v1格式
./touchstone_converter v2tov1 examples/sample_v2.ts output.s2p
```

## VS Code调试

在VS Code中，您可以：

1. 设置断点：在代码行号左侧点击
2. 启动调试：按`F5`或选择"Run > Start Debugging"
3. 调试时可以选择转换模式、输入文件和输出文件

## 支持的格式

### Touchstone v1格式

- 文件扩展名：`.s1p`, `.s2p`, `.s3p`, `.s4p`
- 选项行格式：`# GHz S MA R 50`
- 数据格式：
  - **MA**: 幅度 角度
  - **DB**: dB值 角度
  - **RI**: 实部 虚部

### Touchstone v2格式

- 文件扩展名：`.ts`
- 结构化头部信息
- 支持元数据和注释
- 更好的错误处理和验证

## 错误处理

程序包含完整的错误处理机制：

- 文件访问错误
- 格式解析错误
- 数据验证错误
- 内存分配错误

所有错误都会显示详细的中文错误信息。

## 扩展功能

该项目设计为可扩展的，您可以轻松添加：

- 其他参数类型支持
- 不同的数据格式
- 额外的验证功能
- 性能优化

## 许可证

本项目采用MIT许可证，详见LICENSE文件。

## 贡献

欢迎提交问题报告和功能请求！