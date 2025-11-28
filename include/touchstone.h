#ifndef TOUCHSTONE_H
#define TOUCHSTONE_H

#include <vector>
#include <complex>
#include <string>
#include <iostream>
#include <variant>

enum class ParameterType {
    S, Y, Z, H, G, A
};

enum class Format {
    DB_ANGLE, MA, RI
};

struct TouchstoneData {
    std::string optionLine;
    ParameterType parameterType;
    Format format;
    double referenceResistance;
    std::vector<double> frequencies;
    std::vector<std::vector<std::complex<double>>> data;
    int ports;
    std::vector<std::string> comments;
};

class TouchstoneParser {
public:
    static TouchstoneData parseV1(const std::string& filename);
    static TouchstoneData parseV2(const std::string& filename);
    static void writeV1(const TouchstoneData& data, const std::string& filename);
    static void writeV2(const TouchstoneData& data, const std::string& filename);

private:
    static std::complex<double> parseComplex(const std::string& str, Format format);
    static std::string formatComplex(std::complex<double> value, Format format);
    static std::string parameterTypeToString(ParameterType type);
    static ParameterType stringToParameterType(const std::string& type);
    static std::string formatToString(Format format);
    static Format stringToFormat(const std::string& format);
};

class TouchstoneConverter {
public:
    static void convertV1toV2(const std::string& inputFile, const std::string& outputFile);
    static void convertV2toV1(const std::string& inputFile, const std::string& outputFile);
};

#endif // TOUCHSTONE_H