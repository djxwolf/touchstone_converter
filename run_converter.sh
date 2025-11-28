#!/bin/bash

# Touchstone Converter One-Click Run Script (macOS)
# Usage: ./run_converter.sh <conversion_mode> <input_file> <output_file>

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project path
PROJECT_DIR="/Users/wenjian/work/touchstone_converter"
BUILD_DIR="$PROJECT_DIR/build"
EXECUTABLE="$BUILD_DIR/touchstone_converter"

# Check parameters
if [ $# -ne 3 ]; then
    echo -e "${BLUE}Touchstone Format Converter v1.0${NC}"
    echo
    echo "Usage: $0 <conversion_mode> <input_file> <output_file>"
    echo
    echo "Conversion Modes:"
    echo "  v1tov2   Convert Touchstone v1 format to v2 format"
    echo "  v2tov1   Convert Touchstone v2 format to v1 format"
    echo
    echo "Examples:"
    echo "  $0 v1tov2 examples/sample.s2p output.ts"
    echo "  $0 v2tov1 examples/sample_v2.ts output.s2p"
    echo
    echo "Supported Formats:"
    echo "  Touchstone v1: .s1p, .s2p, .s3p, .s4p"
    echo "  Touchstone v2: .ts"
    exit 1
fi

MODE=$1
INPUT=$2
OUTPUT=$3

# Check if executable exists
if [ ! -f "$EXECUTABLE" ]; then
    echo -e "${YELLOW}Executable not found, starting build...${NC}"

    # Create build directory
    if [ ! -d "$BUILD_DIR" ]; then
        mkdir -p "$BUILD_DIR"
        echo -e "${GREEN}✓ Build directory created${NC}"
    fi

    # Configure CMake
    cd "$PROJECT_DIR"
    if cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug; then
        echo -e "${GREEN}✓ CMake configuration successful${NC}"
    else
        echo -e "${RED}✗ CMake configuration failed${NC}"
        exit 1
    fi

    # Build
    if cmake --build build; then
        echo -e "${GREEN}✓ Build successful${NC}"
    else
        echo -e "${RED}✗ Build failed${NC}"
        exit 1
    fi

    # Check executable again
    if [ ! -f "$EXECUTABLE" ]; then
        echo -e "${RED}✗ Executable still not found after build${NC}"
        exit 1
    fi
fi

# Check input file
if [ ! -f "$PROJECT_DIR/$INPUT" ]; then
    echo -e "${RED}Error: Input file does not exist: $PROJECT_DIR/$INPUT${NC}"
    exit 1
fi

# Switch to build directory
cd "$BUILD_DIR"

# Build full paths
FULL_INPUT="../$INPUT"
FULL_OUTPUT="../$OUTPUT"

# Run conversion
echo -e "${BLUE}Touchstone Format Converter${NC}"
echo -e "Input file: $FULL_INPUT"
echo -e "Output file: $FULL_OUTPUT"
echo -e "Conversion mode: $MODE"
echo "------------------------"

if ./touchstone_converter "$MODE" "$FULL_INPUT" "$FULL_OUTPUT"; then
    echo
    echo -e "${GREEN}✓ Conversion completed!${NC}"

    # Check output file
    if [ -f "$PROJECT_DIR/$OUTPUT" ]; then
        FILE_SIZE=$(stat -f%z "$PROJECT_DIR/$OUTPUT" 2>/dev/null || echo "unknown")
        echo -e "${GREEN}Output file size: $FILE_SIZE bytes${NC}"
        echo -e "Output file location: ${BLUE}$PROJECT_DIR/$OUTPUT${NC}"

        # Show first few lines of file
        echo
        echo -e "${YELLOW}Output file preview:${NC}"
        head -10 "$PROJECT_DIR/$OUTPUT" | sed 's/^/  /'
    fi
else
    echo -e "${RED}✗ Conversion failed${NC}"
    exit 1
fi