#include "touchstone.h"
#include <fstream>
#include <sstream>
#include <algorithm>
#include <stdexcept>
#include <cmath>
#include <cctype>

TouchstoneData TouchstoneParser::parseV1(const std::string& filename) {
    std::ifstream file(filename);
    if (!file.is_open()) {
        throw std::runtime_error("Cannot open file: " + filename);
    }

    TouchstoneData data;
    std::string line;

    // Parse option line (starts with #)
    if (std::getline(file, line)) {
        if (line.empty() || line[0] != '#') {
            throw std::runtime_error("Invalid Touchstone v1 format: missing option line");
        }

        data.optionLine = line;

        // Parse option line content
        std::istringstream iss(line.substr(1)); // Skip # character
        std::string freqUnit, paramType, formatStr, refImpedanceStr;

        iss >> freqUnit >> paramType >> formatStr;
        if (!iss) {
            throw std::runtime_error("Invalid option line format");
        }

        data.parameterType = stringToParameterType(paramType);
        data.format = stringToFormat(formatStr);

        iss >> data.referenceResistance;
        if (!iss) {
            data.referenceResistance = 50.0; // Default reference impedance
        }
    }

    // Determine number of ports from file extension
    std::string ext = filename.substr(filename.find_last_of('.') + 1);
    if (ext.length() >= 2 && ext[0] == 's' && ext[1] >= '1' && ext[1] <= '9') {
        data.ports = ext[1] - '0';
    } else {
        throw std::runtime_error("Invalid file extension for determining port count");
    }

    // Parse data lines
    while (std::getline(file, line)) {
        line.erase(0, line.find_first_not_of(" \t\r\n")); // Trim leading whitespace
        line.erase(line.find_last_not_of(" \t\r\n") + 1);   // Trim trailing whitespace

        if (line.empty() || line[0] == '!' || line[0] == '#') {
            if (!line.empty() && line[0] == '!') {
                data.comments.push_back(line.substr(1));
            }
            continue;
        }

        std::istringstream iss(line);
        double frequency;
        iss >> frequency;

        if (!iss) continue;

        data.frequencies.push_back(frequency);

        std::vector<std::complex<double>> freqData;
        int expectedValues = data.ports * data.ports;

        for (int i = 0; i < expectedValues; ++i) {
            if (data.format == Format::RI) {
                double real, imag;
                iss >> real >> imag;
                if (!iss) break;
                freqData.emplace_back(real, imag);
            } else {
                double val1, val2;
                iss >> val1 >> val2;
                if (!iss) break;
                freqData.push_back(parseComplex(std::to_string(val1) + " " + std::to_string(val2), data.format));
            }
        }

        if (freqData.size() == expectedValues) {
            data.data.push_back(freqData);
        }
    }

    return data;
}

TouchstoneData TouchstoneParser::parseV2(const std::string& filename) {
    std::ifstream file(filename);
    if (!file.is_open()) {
        throw std::runtime_error("Cannot open file: " + filename);
    }

    TouchstoneData data;
    std::string line;
    bool inDataSection = false;

    // Default values for v2
    data.parameterType = ParameterType::S;
    data.format = Format::DB_ANGLE;
    data.referenceResistance = 50.0;
    data.ports = 2;

    while (std::getline(file, line)) {
        // Trim whitespace
        line.erase(0, line.find_first_not_of(" \t\r\n"));
        line.erase(line.find_last_not_of(" \t\r\n") + 1);

        if (line.empty()) continue;

        if (line[0] == '!') {
            data.comments.push_back(line.substr(1));
            continue;
        }

        if (line[0] == '[') {
            // Parse header section
            if (line.find("[Number of Ports]") != std::string::npos) {
                std::getline(file, line);
                data.ports = std::stoi(line);
            } else if (line.find("[Reference]") != std::string::npos) {
                std::getline(file, line);
                data.referenceResistance = std::stod(line);
            } else if (line.find("[Parameter]") != std::string::npos) {
                std::getline(file, line);
                data.parameterType = stringToParameterType(line);
            } else if (line.find("[Format]") != std::string::npos) {
                std::getline(file, line);
                data.format = stringToFormat(line);
            } else if (line.find("[Data]") != std::string::npos) {
                inDataSection = true;
            }
        } else if (inDataSection) {
            // Parse data line
            std::istringstream iss(line);
            double frequency;
            iss >> frequency;

            if (!iss) continue;

            data.frequencies.push_back(frequency);

            std::vector<std::complex<double>> freqData;
            int expectedValues = data.ports * data.ports;

            if (data.format == Format::RI) {
                for (int i = 0; i < expectedValues; ++i) {
                    double real, imag;
                    iss >> real >> imag;
                    if (!iss) break;
                    freqData.emplace_back(real, imag);
                }
            } else {
                for (int i = 0; i < expectedValues; ++i) {
                    double val1, val2;
                    iss >> val1 >> val2;
                    if (!iss) break;
                    freqData.push_back(parseComplex(line, data.format));
                }
            }

            if (freqData.size() == expectedValues) {
                data.data.push_back(freqData);
            }
        }
    }

    return data;
}

void TouchstoneParser::writeV1(const TouchstoneData& data, const std::string& filename) {
    std::ofstream file(filename);
    if (!file.is_open()) {
        throw std::runtime_error("Cannot create file: " + filename);
    }

    // Write option line
    file << "! " << parameterTypeToString(data.parameterType) << " parameters" << std::endl;
    file << "# GHz S " << formatToString(data.format) << " R " << data.referenceResistance << std::endl;

    // Write comments
    for (const auto& comment : data.comments) {
        file << "! " << comment << std::endl;
    }

    // Write data
    for (size_t i = 0; i < data.frequencies.size(); ++i) {
        file << data.frequencies[i] << "\t";

        for (size_t j = 0; j < data.data[i].size(); ++j) {
            if (data.format == Format::RI) {
                file << data.data[i][j].real() << "\t" << data.data[i][j].imag();
            } else {
                file << formatComplex(data.data[i][j], data.format);
            }

            if (j < data.data[i].size() - 1) {
                file << "\t";
            }
        }
        file << std::endl;
    }
}

void TouchstoneParser::writeV2(const TouchstoneData& data, const std::string& filename) {
    std::ofstream file(filename);
    if (!file.is_open()) {
        throw std::runtime_error("Cannot create file: " + filename);
    }

    // Write header
    file << "[Version]" << std::endl;
    file << "2.0" << std::endl;
    file << std::endl;

    file << "[Number of Ports]" << std::endl;
    file << data.ports << std::endl;
    file << std::endl;

    file << "[Two-Port Data Order]" << std::endl;
    file << "12_21" << std::endl;
    file << std::endl;

    file << "[Reference]" << std::endl;
    file << data.referenceResistance << std::endl;
    file << std::endl;

    file << "[Network Data]" << std::endl;
    file << "Freq(MHz)" << std::endl;
    file << parameterTypeToString(data.parameterType) << std::endl;
    file << formatToString(data.format) << std::endl;
    file << std::endl;

    // Write comments
    for (const auto& comment : data.comments) {
        file << "! " << comment << std::endl;
    }
    file << std::endl;

    // Write data
    for (size_t i = 0; i < data.frequencies.size(); ++i) {
        file << data.frequencies[i] << "\t";

        for (size_t j = 0; j < data.data[i].size(); ++j) {
            if (data.format == Format::RI) {
                file << data.data[i][j].real() << "\t" << data.data[i][j].imag();
            } else {
                file << formatComplex(data.data[i][j], data.format);
            }

            if (j < data.data[i].size() - 1) {
                file << "\t";
            }
        }
        file << std::endl;
    }
}

std::complex<double> TouchstoneParser::parseComplex(const std::string& str, Format format) {
    std::istringstream iss(str);
    double val1, val2;
    iss >> val1 >> val2;

    switch (format) {
        case Format::MA:
            return std::polar(val1, val2 * M_PI / 180.0);
        case Format::DB_ANGLE:
            return std::polar(std::pow(10.0, val1 / 20.0), val2 * M_PI / 180.0);
        case Format::RI:
        default:
            return std::complex<double>(val1, val2);
    }
}

std::string TouchstoneParser::formatComplex(std::complex<double> value, Format format) {
    std::ostringstream oss;

    switch (format) {
        case Format::MA: {
            double mag = std::abs(value);
            double angle = std::arg(value) * 180.0 / M_PI;
            oss << mag << "\t" << angle;
            break;
        }
        case Format::DB_ANGLE: {
            double db = 20.0 * std::log10(std::abs(value));
            double angle = std::arg(value) * 180.0 / M_PI;
            oss << db << "\t" << angle;
            break;
        }
        case Format::RI:
        default:
            oss << value.real() << "\t" << value.imag();
            break;
    }

    return oss.str();
}

std::string TouchstoneParser::parameterTypeToString(ParameterType type) {
    switch (type) {
        case ParameterType::S: return "S";
        case ParameterType::Y: return "Y";
        case ParameterType::Z: return "Z";
        case ParameterType::H: return "H";
        case ParameterType::G: return "G";
        case ParameterType::A: return "A";
        default: return "S";
    }
}

ParameterType TouchstoneParser::stringToParameterType(const std::string& type) {
    std::string upperType = type;
    std::transform(upperType.begin(), upperType.end(), upperType.begin(), ::toupper);

    if (upperType == "S") return ParameterType::S;
    if (upperType == "Y") return ParameterType::Y;
    if (upperType == "Z") return ParameterType::Z;
    if (upperType == "H") return ParameterType::H;
    if (upperType == "G") return ParameterType::G;
    if (upperType == "A") return ParameterType::A;

    return ParameterType::S; // Default to S-parameters
}

std::string TouchstoneParser::formatToString(Format format) {
    switch (format) {
        case Format::DB_ANGLE: return "DB";
        case Format::MA: return "MA";
        case Format::RI: return "RI";
        default: return "DB";
    }
}

Format TouchstoneParser::stringToFormat(const std::string& format) {
    std::string upperFormat = format;
    std::transform(upperFormat.begin(), upperFormat.end(), upperFormat.begin(), ::toupper);

    if (upperFormat == "DB" || upperFormat == "DB_ANGLE") return Format::DB_ANGLE;
    if (upperFormat == "MA") return Format::MA;
    if (upperFormat == "RI") return Format::RI;

    return Format::DB_ANGLE; // Default to DB angle format
}

void TouchstoneConverter::convertV1toV2(const std::string& inputFile, const std::string& outputFile) {
    TouchstoneData data = TouchstoneParser::parseV1(inputFile);
    TouchstoneParser::writeV2(data, outputFile);
}

void TouchstoneConverter::convertV2toV1(const std::string& inputFile, const std::string& outputFile) {
    TouchstoneData data = TouchstoneParser::parseV2(inputFile);

    // Determine output file extension based on port count
    std::string ext = ".s" + std::to_string(data.ports) + "p";
    std::string fullOutputFile = outputFile;
    if (fullOutputFile.find('.') == std::string::npos) {
        fullOutputFile += ext;
    }

    TouchstoneParser::writeV1(data, fullOutputFile);
}