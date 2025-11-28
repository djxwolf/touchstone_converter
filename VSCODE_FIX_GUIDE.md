# VS Code Header File Issues Fix Guide

## Problem Description
VS Code shows it cannot open standard library headers, such as `#include <vector>`

## 🚀 Quick Solution (Recommended)

### 1. Restart VS Code
Close VS Code and reopen the project directory:
```bash
code touchstone_converter/
```

### 2. Install Recommended VS Code Extensions
Press `Cmd+Shift+X` to open extensions panel, search and install:
- **C/C++** (Microsoft)
- **CMake Tools** (Microsoft)

### 3. Run Automatic Configuration Script
```bash
cd touchstone_converter
./setup_vscode.sh
```

## 🔧 Manual Solution

If automatic configuration doesn't work, please follow these steps:

### Step 1: Select Correct Configuration
1. Press `Cmd+Shift+P` in VS Code
2. Type "C/C++: Edit Configurations (JSON)" and press Enter
3. Choose the correct configuration file

### Step 2: Check Compiler Path
1. Ensure Xcode Command Line Tools are installed:
   ```bash
   xcode-select --install
   ```

2. Verify compiler path:
   ```bash
   which clang++
   ```

3. Test compiler:
   ```bash
   clang++ --version
   ```

### Step 3: Update Configuration Files

#### c_cpp_properties.json
Create or update `.vscode/c_cpp_properties.json`:
```json
{
    "configurations": [
        {
            "name": "Mac",
            "includePath": [
                "${workspaceFolder}/**",
                "/usr/include",
                "/usr/local/include",
                "/Library/Developer/CommandLineTools/usr/include/c++/v1",
                "/Library/Developer/CommandLineTools/usr/lib/clang/*/include"
            ],
            "defines": [],
            "macFrameworkPath": [
                "/Library/Frameworks",
                "/System/Library/Frameworks"
            ],
            "compilerPath": "/usr/bin/clang++",
            "cStandard": "c11",
            "cppStandard": "c++17",
            "intelliSenseMode": "clang-x64"
        }
    ],
    "version": 4
}
```

#### settings.json
Update `.vscode/settings.json`:
```json
{
    "cmake.configureOnOpen": true,
    "cmake.buildDirectory": "${workspaceFolder}/build",
    "C_Cpp.default.configurationProvider": "ms-vscode.cmake-tools"
}
```

## 🔍 Debugging Steps

### Check Include Paths
1. In VS Code, press `Cmd+Shift+P`
2. Type "C/C++: Log Diagnostics" and press Enter
3. Check the output for include path errors

### Verify CMake Configuration
1. Press `Cmd+Shift+P`
2. Type "CMake: Configure" and press Enter
3. Check for any configuration errors

### Test Build
1. Press `Cmd+Shift+P`
2. Type "CMake: Build" and press Enter
3. Check if build completes successfully

## 📋 Common Issues and Solutions

### Issue 1: "Cannot open source file"
**Solution**: Install Xcode Command Line Tools
```bash
xcode-select --install
```

### Issue 2: IntelliSense not working
**Solution**: Restart VS Code and reload window
1. Press `Cmd+Shift+P`
2. Type "Developer: Reload Window"

### Issue 3: CMake not detected
**Solution**: Install CMake
```bash
brew install cmake
```

### Issue 4: Compiler not found
**Solution**: Check compiler installation
```bash
# Check if clang++ is installed
which clang++

# If not found, install Xcode Command Line Tools
xcode-select --install
```

## 🧪 Verification Steps

After applying fixes, verify the setup:

### 1. Test Header Recognition
- Open `src/main.cpp`
- Check if `#include <iostream>`, `#include <string>`, `#include <vector>` are recognized
- No red squiggles should appear under standard includes

### 2. Test Build
```bash
cd touchstone_converter
mkdir -p build
cd build
cmake ..
make
```

### 3. Test IntelliSense
- Hover over standard library functions
- Try code completion for `std::`
- Check if parameter hints appear

## 📞 Additional Help

If problems persist:

1. Check VS Code Output panel:
   - View → Output
   - Select "C/C++" from dropdown
   - Look for error messages

2. Clean and reconfigure:
   ```bash
   cd touchstone_converter
   rm -rf build
   mkdir build
   cd build
   cmake ..
   ```

3. Use diagnostic command:
   ```bash
   ./diagnose_vscode.sh
   ```

## 🔄 Alternative Approach

If VS Code configuration continues to have issues, consider using:

### CLion
- Professional C++ IDE by JetBrains
- Excellent CMake integration
- Built-in debugging and profiling

### Xcode
- Native macOS development environment
- Complete toolchain integration
- Excellent debugging capabilities

### vim/emacs + command line
- Lightweight alternative
- Full control over build process
- Highly configurable

## 📚 Recommended Resources

- [VS Code C++ Extension Documentation](https://code.visualstudio.com/docs/cpp/)
- [CMake Tools Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)
- [macOS Development Setup Guide](https://developer.apple.com/xcode/)

This guide should resolve most common VS Code configuration issues for C++ development on macOS.