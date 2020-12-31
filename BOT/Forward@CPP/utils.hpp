/*************************************************
utils.hpp
Author:Mitom
Date:2019-5-30
Description:工具
**************************************************/

#ifndef UTILS_HPP_
#define UTILS_HPP_

#include "sEMG.hpp"
#include "Matrix.hpp"
#include "Filter.hpp"
#include "tinyxml/tinyxml.h"

int getFileRowCount(string file);

int getFileColCount(string file);

vector<string> split(string srcStr, const string& delim);

Matrix loadEMGData(string file);

Filter parseFilterWeight(const char * path, int fsize, int depth, int row, int col);

double strToDouble(string str);

string intToString(int num);

Matrix parseFullConnWeight(const char * path, int row, int col);

vector<double> parseBias(const char * path, int num);

void emgDataToMat(Matrix & res, string path);

#endif /* UTILS_HPP_ */
