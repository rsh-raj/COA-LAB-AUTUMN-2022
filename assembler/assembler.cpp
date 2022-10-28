#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <unordered_map>
using namespace std;
typedef struct format
{
    vector<string> instructions;
    vector<pair<int, string>> format;

} format;
void makeEncodingTable(vector<format> &formatTable, unordered_map<string, pair<int, int>> &opCodeTable)
{
    // append i to the immediate shrl before looking up this table

    formatTable[0].instructions.insert(formatTable[0].instructions.end(), {"add", "comp", "and", "xor", "diff", "shllv", "shrl", "shrav"});
    formatTable[0].format.insert(formatTable[0].format.end(), {{6, "OC"}, {5, "rs"}, {5, "rt"}, {10, "DC"}, {6, "func"}});
    formatTable[1].instructions.insert(formatTable[1].instructions.end(), {"addi", "compi", "shll", "shrli", "shra"});
    formatTable[1].format.insert(formatTable[1].format.end(), {{6, "OC"}, {5, "rs"}, {5, "rs"}, {16, "IMM"}});
    formatTable[2].instructions.insert(formatTable[2].instructions.end(), {"lw", "sw"});
    formatTable[2].format.insert(formatTable[2].format.end(), {{6, "OC"}, {5, "rt"}, {5, "rs"}, {16, "IMM"}});
    formatTable[3].instructions.insert(formatTable[3].instructions.end(), {"br"});
    formatTable[3].format.insert(formatTable[3].format.end(), {{6, "OC"}, {5, "DC"}, {5, "rs"}, {16, "DC"}});
    formatTable[4].instructions.insert(formatTable[4].instructions.end(), {"bltz", "bz", "bnz"});
    formatTable[4].format.insert(formatTable[4].format.end(), {{6, "OC"}, {5, "DC"}, {5, "rs"}, {16, "L"}});
    formatTable[5].instructions.insert(formatTable[5].instructions.end(), {"b", "bcy", "bncy", "bl"});
    formatTable[5].format.insert(formatTable[5].format.end(), {{6, "OC"}, {10, "DC"}, {16, "L"}});
    formatTable[6].instructions.insert(formatTable[6].instructions.end(), {"halt", "nop"});
    formatTable[6].format.insert(formatTable[6].format.end(), {{6, "OC"}, {26, "DC"}});
    // opCodeTable["add"]={0000000,000001}
    opCodeTable["add"] = {0, 1};
    opCodeTable["comp"] = {0, 2};
    opCodeTable["and"] = {0, 3};
    opCodeTable["xor"] = {0, 4};
    opCodeTable["diff"] = {0, 5};
    opCodeTable["shllv"] = {0, 6};
    opCodeTable["shrl"] = {0, 7};
    opCodeTable["shrav"] = {0, 8};
    opCodeTable["addi"] = {1, 0};
    opCodeTable["compi"] = {2, 0};
    opCodeTable["shll"] = {3, 0};
    opCodeTable["shrli"] = {4, 0};
    opCodeTable["shra"] = {5, 0};
    opCodeTable["lw"] = {6, 0};
    opCodeTable["sw"] = {7, 0};
    opCodeTable["bltz"] = {8, 0};
    opCodeTable["bz"] = {9, 0};
    opCodeTable["bnz"] = {10, 0};
    opCodeTable["br"] = {11, 0};
    opCodeTable["b"] = {12, 0};
    opCodeTable["bcy"] = {13, 0};
    opCodeTable["bncy"] = {14, 0};
    opCodeTable["bl"] = {15, 0};
    opCodeTable["halt"] = {63, 0};
    opCodeTable["nop"] = {62, 0};
}
string decTobinary(int n, int bits)
{
    string binaryNo = "";
    // cout<<n;
    while (n)
    {

        binaryNo = to_string(n % 2) + binaryNo;
        n /= 2;
    }

    int remainingBits = bits - binaryNo.length();
    while (remainingBits > 0)
    {
        binaryNo = "0" + binaryNo;
        remainingBits--;
    }
    return binaryNo;
}
unordered_map<string, int> labelTable;
string encode(string line, int lineNo)
{

    if (line == "")
        return "";
    cout << "-----------------------";

    cout << "Encoding" << ' ' << line << "----------------" << endl;
    unordered_map<string, pair<int, int>> opCodeTable;
    vector<format> formatTable(7);
    makeEncodingTable(formatTable, opCodeTable);

    stringstream ss(line);
    string word;
    ss >> word;
    if (word == "shrl")
    {
        // handling the shrl case (need to append i in case of shrl rs,sh)
        stringstream temp(line);
        string temp1;
        for (int i = 0; i < 3; i++)
            temp >> temp1;
        // check if the second value is an immediate value
        bool flag = 1;
        for (auto ch : temp1)
        {
            if (ch > '9' || ch < '0')
            {
                flag = 0;
                break;
            }
        }
        if (flag)
            word += 'i';
    }
    if (word.find(":") != string::npos)
    {
        labelTable[word.substr(0, word.length() - 1)] = lineNo;
        return "";
    }
    string encoding = "", opCode = "", func = "";
    vector<pair<int, string>> instructionFormat;
    for (int i = 0; i < 32; i++)
        encoding += "0";

    opCode = decTobinary(opCodeTable[word].first, 6);
    func = decTobinary(opCodeTable[word].second, 6);
    for (auto format : formatTable)
    {
        for (auto instruct : format.instructions)
        {

            if (instruct == word)
            {

                instructionFormat = format.format;
                break;
            }
        }
    }
    int curr_bit = 0, curr_rs = 0;
    string immValue = "";

    for (auto frmt : instructionFormat)
    {
        if (frmt.second == "OC")
        {
            for (int i = 0; i < frmt.first; i++)
            {
                encoding[curr_bit++] = opCode[i];
            }
            cout << "OPCODE: " << opCode << endl;
        }
        else if (frmt.second == "rs")
        {

            if (!curr_rs)
                ss >> word;
            curr_rs++;
            string regValue;

            if (word.find("(") != string::npos)
            {
                immValue = word.substr(0, word.find("("));

                immValue = decTobinary(stoi(immValue), 5);
                regValue = word.substr(word.find("(") + 1, word.find(")"));
                regValue[0] = '0';
                regValue = decTobinary(stoi(regValue), 5);
            }
            else
            {
                word[0] = '0';

                regValue = decTobinary(stoi(word), 5);
            }
            for (int i = 0; i < int(regValue.length()); i++)
            {
                encoding[curr_bit++] = regValue[i];
            }
            cout << "RS: " << regValue << endl;
        }
        else if (frmt.second == "rt")
        {
            ss >> word;
            if (word == ",")
                ss >> word;

            word[0] = '0';
            cout << word << ' ';
            string regValue = decTobinary(stoi(word), 5);
            for (int i = 0; i < int(regValue.length()); i++)
            {
                encoding[curr_bit++] = regValue[i];
            }
            cout << "RT: " << regValue << endl;
        }
        else if (frmt.second == "DC")
        {
            for (int i = 0; i < frmt.first; i++)
                curr_bit++;
            cout << "DC:" << endl;
        }
        else if (frmt.second == "func")
        {
            for (int i = 0; i < frmt.first; i++)
            {
                encoding[curr_bit++] = func[i];
            }
            cout << "FUNC: " << func << endl;
        }
        else if (frmt.second == "IMM")
        {
            if (immValue == "")
                ss >> word;
            immValue = decTobinary(stoi(word), 16);
            for (int i = 0; i < frmt.first; i++)
            {
                encoding[curr_bit++] = immValue[i];
            }
            cout << "IMM: " << immValue << endl;
        }
        else if (frmt.second == "L")
        {
            ss >> word;
            string labelValue = decTobinary(labelTable[word], 16);
            for (int i = 0; i < frmt.first; i++)
            {
                encoding[curr_bit++] = labelValue[i];
            }
            cout << "LABEL: " << labelValue << endl;
            // return labelValue;
        }
    }
    cout << "\n";
    cout << encoding << endl;
    cout << "---------------------------------------------"
         << "\n\n";
    return encoding;
    // );
}
int main(int argc, char const *argv[])
{
    if(argc==1){
        cout<<"Please provide the input file name as command line argument"<<endl;
        return 0;
    }
    string filename=argv[1];
    
    // cout<<filename;
    ifstream inputFile;
    ofstream outputFile, outputFile2;
    inputFile.open(filename);
    outputFile.open("memory.txt");
    outputFile2.open(filename.substr(0, filename.find(".")) + ".coe");
    outputFile2<<"memory_initialization_radix=2;\nmemory_initialization_vector=\n";

    int lineNo = 0;

    while (inputFile)
    {
        string line;
        getline(inputFile, line);

        lineNo++;
        string encodingString = encode(line, lineNo);
        if (encodingString != "")
        {
            outputFile << encodingString << endl;
            outputFile2<<encodingString<<','<<endl;
        }
    }
    inputFile.close();
    outputFile.close();
    cout << "Encoding successfully written to memory.txt && "<<filename.substr(0, filename.find(".")) + ".coe" << endl;

    return 0;
}
