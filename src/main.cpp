#include "touchstone.h"
#include <iostream>
#include <string>
#include <exception>

void printUsage(const char* programName) {
    std::cout << "Touchstone Format Converter v1.0" << std::endl;
    std::cout << "Usage: " << programName << " <conversion_mode> <input_file> <output_file>" << std::endl;
    std::cout << std::endl;
    std::cout << "Conversion Modes:" << std::endl;
    std::cout << "  v1tov2   Convert Touchstone v1 format to v2 format" << std::endl;
    std::cout << "  v2tov1   Convert Touchstone v2 format to v1 format" << std::endl;
    std::cout << std::endl;
    std::cout << "Examples:" << std::endl;
    std::cout << "  " << programName << " v1tov2 input.s2p output.ts" << std::endl;
    std::cout << "  " << programName << " v2tov1 input.ts output.s2p" << std::endl;
    std::cout << std::endl;
    std::cout << "Supported Formats:" << std::endl;
    std::cout << "  Touchstone v1: .s1p, .s2p, .s3p, .s4p" << std::endl;
    std::cout << "  Touchstone v2: .ts" << std::endl;
}

int main(int argc, char* argv[]) {
    try {
        if (argc != 4) {
            printUsage(argv[0]);
            return 1;
        }

        std::string mode = argv[1];
        std::string inputFile = argv[2];
        std::string outputFile = argv[3];

        std::cout << "Touchstone Format Converter" << std::endl;
        std::cout << "Input file: " << inputFile << std::endl;
        std::cout << "Output file: " << outputFile << std::endl;
        std::cout << "Conversion mode: " << mode << std::endl;
        std::cout << "------------------------" << std::endl;

        if (mode == "v1tov2") {
            std::cout << "Converting Touchstone v1 format to v2 format..." << std::endl;
            TouchstoneConverter::convertV1toV2(inputFile, outputFile);
            std::cout << "Conversion completed!" << std::endl;
        } else if (mode == "v2tov1") {
            std::cout << "Converting Touchstone v2 format to v1 format..." << std::endl;
            TouchstoneConverter::convertV2toV1(inputFile, outputFile);
            std::cout << "Conversion completed!" << std::endl;
        } else {
            std::cerr << "Error: Invalid conversion mode '" << mode << "'" << std::endl;
            std::cerr << "Supported modes: v1tov2, v2tov1" << std::endl;
            printUsage(argv[0]);
            return 1;
        }

        return 0;

    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "Unknown error occurred" << std::endl;
        return 1;
    }
}