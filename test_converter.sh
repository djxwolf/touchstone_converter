#!/bin/bash

# Touchstone Converter Test Script

echo "=== Touchstone Format Converter Test ==="
echo

# Set colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test function
test_conversion() {
    local mode=$1
    local input=$2
    local output=$3
    local description=$4

    echo -e "${YELLOW}Test: $description${NC}"
    echo "Command: $mode $input $output"

    if ./touchstone_converter "$mode" "$input" "$output"; then
        echo -e "${GREEN}✓ Conversion successful${NC}"
        if [ -f "$output" ]; then
            echo "Output file size: $(stat -f%z "$output" 2>/dev/null || stat -c%s "$output" 2>/dev/null || echo "unknown") bytes"
            echo "First 5 lines of output:"
            head -5 "$output" | sed 's/^/  /'
        fi
    else
        echo -e "${RED}✗ Conversion failed${NC}"
    fi
    echo "----------------------------------------"
    echo
}

# Enter build directory
cd "$(dirname "$0")/build" || {
    echo "Error: Cannot enter build directory"
    echo "Please run first: mkdir build && cd build && cmake .. && make"
    exit 1
}

# Check executable
if [ ! -f "./touchstone_converter" ]; then
    echo "Error: Cannot find touchstone_converter executable"
    echo "Please build the project first"
    exit 1
fi

echo "Executable: $(realpath ./touchstone_converter)"
echo

# Run tests
test_conversion "v1tov2" "../examples/sample.s2p" "../examples/test1_output.ts" "v1 to v2 format conversion (MA format)"
test_conversion "v1tov2" "../examples/sample_ri.s2p" "../examples/test2_output.ts" "v1 to v2 format conversion (RI format)"
test_conversion "v2tov1" "../examples/sample_v2.ts" "../examples/test3_output.s2p" "v2 to v1 format conversion"
test_conversion "v2tov1" "../examples/test1_output.ts" "../examples/test4_output.s2p" "Convert back test"

# Error handling tests
echo -e "${YELLOW}Error handling tests:${NC}"
echo "1. Testing invalid parameters..."
./touchstone_converter invalid_mode input.s2p output.ts 2>&1 | head -3
echo

echo "2. Testing non-existent file..."
./touchstone_converter v1tov2 nonexistent.s2p output.ts 2>&1 | head -3
echo

echo "3. Testing missing parameters..."
./touchstone_converter v1tov2 input.s2p 2>&1 | head -3
echo

echo -e "${GREEN}=== Tests Completed ===${NC}"