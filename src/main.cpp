#include "touchstone.h"
#include <iostream>
#include <string>
#include <exception>

void printUsage(const char* programName) {
    std::cout << "Touchstone格式转换器 v1.0" << std::endl;
    std::cout << "用法: " << programName << " <转换模式> <输入文件> <输出文件>" << std::endl;
    std::cout << std::endl;
    std::cout << "转换模式:" << std::endl;
    std::cout << "  v1tov2   将Touchstone v1格式转换为v2格式" << std::endl;
    std::cout << "  v2tov1   将Touchstone v2格式转换为v1格式" << std::endl;
    std::cout << std::endl;
    std::cout << "示例:" << std::endl;
    std::cout << "  " << programName << " v1tov2 input.s2p output.ts" << std::endl;
    std::cout << "  " << programName << " v2tov1 input.ts output.s2p" << std::endl;
    std::cout << std::endl;
    std::cout << "支持格式:" << std::endl;
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

        std::cout << "Touchstone格式转换器" << std::endl;
        std::cout << "输入文件: " << inputFile << std::endl;
        std::cout << "输出文件: " << outputFile << std::endl;
        std::cout << "转换模式: " << mode << std::endl;
        std::cout << "------------------------" << std::endl;

        if (mode == "v1tov2") {
            std::cout << "正在将Touchstone v1格式转换为v2格式..." << std::endl;
            TouchstoneConverter::convertV1toV2(inputFile, outputFile);
            std::cout << "转换完成!" << std::endl;
        } else if (mode == "v2tov1") {
            std::cout << "正在将Touchstone v2格式转换为v1格式..." << std::endl;
            TouchstoneConverter::convertV2toV1(inputFile, outputFile);
            std::cout << "转换完成!" << std::endl;
        } else {
            std::cerr << "错误: 无效的转换模式 '" << mode << "'" << std::endl;
            std::cerr << "支持的模式: v1tov2, v2tov1" << std::endl;
            printUsage(argv[0]);
            return 1;
        }

        return 0;

    } catch (const std::exception& e) {
        std::cerr << "错误: " << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "未知错误发生" << std::endl;
        return 1;
    }
}