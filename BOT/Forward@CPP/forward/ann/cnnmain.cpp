/*************************************************
main.cpp
Author:Mitom
Date:2019-05-30
Description:矩阵类
**************************************************/

//#include <iostream>
//#include <fstream>
//#include <string>
//#include <vector>
//#include <regex>
//#include <random>
//#include <time.h>
//#include <ctime>

//#include "Matrix.hpp"
//#include "Tensor.hpp"
//#include "Filter.hpp"
//#include "utils.hpp"

//#include "tinyxml/tinyxml.h"

//#define TIXML_USE_STL

//using namespace std;

#include "cnnmain.hpp"

double strToDouble(string str)
{
	double result;
	istringstream is(str);
	is >> result;
	return result;
}

void run()
{
	Tensor tensor = Tensor(2,4,4);
	for(int i=0; i<2; i++){
		Matrix mat = Matrix(4,4,(i+1));
		tensor.addLayer(mat);
	}


	Filter filter = Filter(3, 2, 3, 3);

	Tensor tensor1 = tensor.forwardConv(filter, 1,1,1,1);
	tensor1.getLayer(0).setValue(0,0,-22.0);

    cout << "----------------------" << endl;
	tensor1.showTensor();
//	Tensor maxTensor = tensor1.forwardMaxpool(2,2);
//	maxTensor.getLayer(0).showMatrix();
//	maxTensor.getLayer(1).showMatrix();
//	maxTensor.getLayer(2).showMatrix();
	cout << "----------------------" << endl;
	tensor1.forwardReLu();
	tensor1.showTensor();
	tensor1.forwardFlat().showMatrix();

	Matrix weight = Matrix(48,10,1);
	weight.setValue(1,1,0.2);
	weight.setValue(5,5,33);
	Matrix out = Matrix::multiply(tensor1.forwardFlat(), weight);
	cout << "=====================" << endl;
	out.dotMatCoefficient(0.001);
	out.showMatrix();
	vector<int> outClass = out.softmax();
	out.showMatrix();

	for(size_t i=0; i<outClass.size(); i++){
		cout <<"sample " << i << " pred:" << outClass[i] << endl;
	}
}


void readParams()
{
	TiXmlDocument mydoc("conv1_0_weight_1.xml");//xml文档对象
	bool loadOk=mydoc.LoadFile();//加载文档
	if(!loadOk)
	{
		cout<<"could not load the test file.Error:"<<mydoc.ErrorDesc()<<endl;
		exit(1);
	}

	int fsize = 128;
	int depth = 64;
	int row = 3;
	int col = 1;

	Filter filter = Filter(fsize,depth,row,col);
	TiXmlElement *rootElem = mydoc.RootElement();	// filter
	TiXmlElement *fElem = rootElem;
	int fcount = 0;
	for(TiXmlElement *tensonElem = fElem->FirstChildElement();tensonElem != NULL;tensonElem = tensonElem->NextSiblingElement()){// tensor

		Tensor tensor = Tensor(row,col);
		for(TiXmlElement *matElem = tensonElem->FirstChildElement();matElem != NULL;matElem=matElem->NextSiblingElement()){ // matrix
			Matrix mat = Matrix(row,col);
			int row = 0;
			for(TiXmlElement *rowElem = matElem->FirstChildElement();rowElem != NULL;rowElem=rowElem->NextSiblingElement()){ // row
				mat.getPtr()[row][0] = strToDouble(rowElem->FirstChild()->Value());
				row++;
			}
			tensor.addLayer(mat);
		}
		filter.setFilter(fcount, tensor);
		fcount ++;
	}
}

int cnnmain() {

//	clock_t startTime,endTime;
	run();
//	startTime = clock();
//	readParams();
//	endTime = clock();
//	cout << (endTime-startTime) /  (double)CLOCKS_PER_SEC << endl;


	return 0;
}















