#ifndef CNNMAIN_HPP
#define CNNMAIN_HPP

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <regex>
#include <random>
#include <time.h>
#include <ctime>

#include "Matrix.hpp"
#include "Tensor.hpp"
#include "Filter.hpp"
#include "utils.hpp"

#include "tinyxml.h"

#define TIXML_USE_STL

using namespace std;


void run();


void readParams();

int cnnmain();

#endif // CNNMAIN_HPP
