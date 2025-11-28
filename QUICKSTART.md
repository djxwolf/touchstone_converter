# Quick Start Guide

## 1. Open Project in VS Code

```bash
cd touchstone_converter
code .
```

## 2. Build Project

VS Code will automatically detect CMake project and ask for build configuration when first opened.

### Manual Build (if needed)

```bash
# Create build directory
mkdir build
cd build

# Configure CMake
cmake ..

# Build
make
```

## 3. Run Conversion

### Basic Usage

```bash
# v1 to v2
./build/touchstone_converter v1tov2 examples/sample.s2p output.ts

# v2 to v1
./build/touchstone_converter v2tov1 examples/sample_v2.ts output.s2p
```

### Running in VS Code

1. Press `Ctrl+Shift+B` (or `Cmd+Shift+B` on Mac) to build project
2. Press `Ctrl+Shift+P` select "Tasks: Run Task"
3. Select "Run Converter"
4. Enter conversion mode, input file and output file

## 4. Debugging

1. Set breakpoints in code
2. Press `F5` to start debugging
3. Select conversion mode and files

## 5. Run Tests

```bash
# Run complete test suite
./test_converter.sh

# Or go to build directory and run
cd build
../test_converter.sh
```

## 6. Example Files

- `examples/sample.s2p` - Touchstone v1 format example
- `examples/sample_ri.s2p` - v1 format (Real/Imaginary)
- `examples/sample_v2.ts` - Touchstone v2 format example

## Common Issues

### Build Errors

If you encounter build errors, ensure:

1. Xcode Command Line Tools are installed (macOS)
2. Using C++17 compatible compiler
3. CMake 3.10+

### Runtime Errors

If program cannot run, check:

1. Input file exists and has correct format
2. Output path has write permissions
3. Conversion mode parameters are correct

## Project Structure

```
touchstone_converter/
├── include/touchstone.h     # Header file
├── src/
│   ├── main.cpp            # Main program
│   └── touchstone.cpp      # Core implementation
├── examples/               # Example files
├── build/                  # Build output
├── .vscode/               # VS Code configuration
├── CMakeLists.txt         # CMake configuration
├── test_converter.sh      # Test script
├── QUICKSTART.md          # This document
└── README.md              # Detailed documentation
```

## Supported Formats

- **v1 format**: .s1p, .s2p, .s3p, .s4p
- **v2 format**: .ts
- **Data formats**: MA, DB_ANGLE, RI
- **Parameter types**: S, Y, Z, H, G, A