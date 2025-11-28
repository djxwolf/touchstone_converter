# macOS Touchstone Converter Guide

## VS Code Shortcuts (macOS)

### Important Shortcuts
- ⌘+Shift+B: Build project (not Ctrl+Shift+B)
- ⌘+Shift+P: Open Command Palette
- F5: Start debugging
- ⌘+/: Toggle comment

### Building Project in VS Code

#### Method 1: Using Shortcuts
1. Open project in VS Code
2. Press `⌘+Shift+B` to select build task

#### Method 2: Using Command Palette
1. Press `⌘+Shift+P`
2. Type "Tasks: Run Task"
3. Select "CMake Build"

#### Method 3: Using Terminal
1. Press `⌘+\`` in VS Code to open integrated terminal
2. Run the following commands:

```bash
# If build directory doesn't exist
mkdir -p build

# Configure CMake
cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug

# Build
cmake --build build
```

## Running the Program

### In VS Code Terminal
```bash
cd build
./touchstone_converter v1tov2 ../examples/sample.s2p output.ts
```

### Using Command Palette to Run
1. Press `⌘+Shift+P`
2. Type "Tasks: Run Task"
3. Select "Run Converter"

## Debugging Program

1. Set breakpoints in code (click left side of line numbers)
2. Press `F5` to start debugging
3. Select configuration in dialog (usually default is fine)

## Common Troubleshooting

### If Shortcuts Don't Work
1. Check if VS Code is latest version
2. Restart VS Code
3. Use Command Palette (`⌘+Shift+P`) to manually run tasks

### If Build Fails
```bash
# Clean and rebuild
rm -rf build
mkdir build
cd build
cmake ..
make
```

### If Executable Not Found
```bash
# Check if in correct directory
cd /Users/wenjian/work/touchstone_converter/build
ls -la touchstone_converter
```

## One-Click Script

Create a convenient script:

```bash
# Create in project root directory
cat > run_converter.sh << 'EOF'
#!/bin/bash
cd /Users/wenjian/work/touchstone_converter/build
./touchstone_converter "$@"
EOF

chmod +x run_converter.sh
```

Now you can use directly:
```bash
./run_converter.sh v1tov2 examples/sample.s2p output.ts
```

## Verify Installation

Run complete tests:
```bash
./test_converter.sh
```

## Recommended VS Code Extensions

Install the following extensions for better experience:
1. C/C++ (Microsoft)
2. CMake Tools (Microsoft)
3. CMake Language Support (twxs)

## Environment Check

Ensure your environment is properly configured:

```bash
# Check compiler
clang++ --version

# Check CMake
cmake --version

# Check Xcode command line tools
xcode-select --print-path
```

If any tool is not installed, run:
```bash
# Install Xcode command line tools
xcode-select --install

# Install CMake (if not available)
brew install cmake
```