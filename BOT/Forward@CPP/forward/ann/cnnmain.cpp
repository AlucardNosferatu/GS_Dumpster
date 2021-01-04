/*************************************************
main.cpp
Author:Mitom & Scrooge
Date:2019-05-30
Description:矩阵类
**************************************************/


#include "cnnmain.hpp"

vector<int> run()
{
	Tensor tensor = Tensor(2, 4, 4);
	for (int i = 0; i < 2; i++) {
		const Matrix mat = Matrix(4, 4, (i + 1));
		tensor.addLayer(mat);
	}

	Filter filter = Filter(3, 2, 3, 3);
	vector<double> bias(3);
	vector<int>::size_type ix = 0;
	for (ix; ix < bias.size(); ++ix)
	{
		bias[ix] = 2.0; //下标操作  
	}
	Tensor tensor1 = tensor.forwardConv(filter, 1, 1, 1, 1, bias);
	tensor1.getLayer(0).setValue(0, 0, -22.0);
	tensor1.forwardReLu();

	Matrix weight = Matrix(48, 10, 1);
	weight.setValue(1, 1, 0.2);
	weight.setValue(5, 5, 33);
	Matrix out = Matrix::multiply(tensor1.forwardFlat(), weight);
	out.dotMatCoefficient(0.001);
	vector<int> outClass = out.softmax();

	for (size_t i = 0; i < outClass.size(); i++) {
		cout << "sample " << i << " pred:" << outClass[i] << endl;
	}
	return outClass;
}

void readParams()
{
	TiXmlDocument mydoc("conv1_0_weight_1.xml");//xml文档对象
	const bool loadOk = mydoc.LoadFile();//加载文档
	if (!loadOk)
	{
		cout << "could not load the test file.Error:" << mydoc.ErrorDesc() << endl;
		exit(1);
	}

	const int fsize = 128;
	const int depth = 64;
	const int row = 3;
	const int col = 1;

	Filter filter = Filter(fsize, depth, row, col);
	TiXmlElement* rootElem = mydoc.RootElement();	// filter
	TiXmlElement* fElem = rootElem;
	int fcount = 0;
	for (TiXmlElement* tensonElem = fElem->FirstChildElement(); tensonElem != NULL; tensonElem = tensonElem->NextSiblingElement()) {// tensor

		Tensor tensor = Tensor(row, col);
		for (TiXmlElement* matElem = tensonElem->FirstChildElement(); matElem != NULL; matElem = matElem->NextSiblingElement()) { // matrix
			const Matrix mat = Matrix(row, col);
			int row = 0;
			for (TiXmlElement* rowElem = matElem->FirstChildElement(); rowElem != NULL; rowElem = rowElem->NextSiblingElement()) { // row
				mat.getPtr()[row][0] = strToDouble(rowElem->FirstChild()->Value());
				row++;
			}
			tensor.addLayer(mat);
		}
		filter.setFilter(fcount, tensor);
		fcount++;
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
