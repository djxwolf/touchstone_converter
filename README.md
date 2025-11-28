# Touchstone Format Converter

A C++ application for converting between Touchstone v1 and v2 formats.

## Features

- ✅ Support for Touchstone v1 format (.s1p, .s2p, .s3p, .s4p)
- ✅ Support for Touchstone v2 format (.ts)
- ✅ Support for multiple data formats: MA (Magnitude/Angle), DB_ANGLE (dB/Angle), RI (Real/Imaginary)
- ✅ Support for multiple network parameter types: S, Y, Z, H, G, A parameters
- ✅ Cross-platform support (Windows, Linux, macOS)
- ✅ VS Code integrated development environment support

## Project Structure

```
touchstone_converter/
├── include/
│   └── touchstone.h          # Main header file
├── src/
│   ├── main.cpp              # Program entry point
│   └── touchstone.cpp        # Core implementation
├── examples/
│   ├── sample.s2p           # v1 format example file
│   ├── sample_ri.s2p        # v1 format example file (Real/Imaginary)
│   └── sample_v2.ts         # v2 format example file
├── .vscode/
│   ├── tasks.json           # VS Code build tasks
│   ├── launch.json          # VS Code debug configuration
│   ├── settings.json        # VS Code project settings
│   └── c_cpp_properties.json # C++ configuration
├── build/                   # Build output directory
├── CMakeLists.txt           # CMake configuration file
└── README.md                # Project documentation
```

## Build Requirements

- C++17 or higher
- CMake 3.10 or higher
- Supported compilers:
  - GCC 7.0+
  - Clang 6.0+
  - MSVC 2017+

## Build Instructions

### Using VS Code (Recommended)

1. Open the project folder in VS Code:
   ```bash
   code touchstone_converter/
   ```

2. VS Code will automatically configure CMake tools. When first opened, it will ask for build configuration. Select "Debug".

3. **macOS users note**: Use `Cmd+Shift+B` to build the project (not Ctrl+Shift+B)

   Or use the Command Palette (`Cmd+Shift+P`) and select "Tasks: Run Task", then choose "CMake Build".

4. If the shortcuts don't work, see [MACOS_GUIDE.md](MACOS_GUIDE.md) for detailed instructions.

### Manual Build

```bash
# Create build directory
cd touchstone_converter
mkdir build
cd build

# Configure CMake
cmake -DCMAKE_BUILD_TYPE=Debug ..

# Build
cmake --build .

# Or use make (Linux/macOS)
make
```

## Usage

### Command Line Format

```bash
./touchstone_converter <conversion_mode> <input_file> <output_file>
```

### Conversion Modes

- `v1tov2`: Convert Touchstone v1 format to v2 format
- `v2tov1`: Convert Touchstone v2 format to v1 format

### Usage Examples

#### v1 to v2
```bash
# Convert 2-port S-parameter file
./touchstone_converter v1tov2 examples/sample.s2p output.ts

# Convert real/imaginary format
./touchstone_converter v1tov2 examples/sample_ri.s2p output_ri.ts
```

#### v2 to v1
```bash
# Convert to v1 format
./touchstone_converter v2tov1 examples/sample_v2.ts output.s2p
```

## VS Code Debugging

In VS Code, you can:

1. Set breakpoints: Click on the left side of line numbers
2. Start debugging: Press `F5` or select "Run > Start Debugging"
3. Select conversion mode, input file, and output file when debugging

## Supported Formats

### Touchstone v1 Format

- File extensions: `.s1p`, `.s2p`, `.s3p`, `.s4p`
- Option line format: `# GHz S MA R 50`
- Data formats:
  - **MA**: Magnitude Angle
  - **DB**: dB value Angle
  - **RI**: Real Imaginary

### Touchstone v2 Format

- File extensions: `.ts`
- Structured header information
- Support for metadata and comments
- Better error handling and validation

## Error Handling

The program includes comprehensive error handling:

- File access errors
- Format parsing errors
- Data validation errors
- Memory allocation errors

All errors display detailed English error messages.

## Extensibility

This project is designed to be extensible. You can easily add:

- Additional parameter type support
- Different data formats
- Extra validation features
- Performance optimizations

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Contributing

Bug reports and feature requests are welcome!