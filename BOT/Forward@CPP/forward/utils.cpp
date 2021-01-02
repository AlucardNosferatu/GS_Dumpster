/*************************************************
utils.cpp
Author:Mitom
Date:2019-5-30
Description:工具
**************************************************/

#include "sEMG.hpp"
#include "utils.hpp"

//获取文件行数
int getFileRowCount(string file)
{
	ifstream infile;
	infile.open(file.data());
	int rowNumber = 0;
	string s;
	while(getline(infile,s)){
		rowNumber++;
	}
	infile.close();
	return rowNumber;
}

//获取文件列数
int getFileColCount(string file)
{
	ifstream infile;
	infile.open(file.data());
	//assert(infile.is_open());
	int colNumber = 0;
	string s;
	vector<string> vecRow;
	while(getline(infile,s)){
		vecRow = split(s, " ");
		break;
	}

	colNumber = vecRow.size();
	infile.close();

	return colNumber;
}

//字符串分割函数
vector<string> split(string srcStr, const string& delim)
{
	int nPos = 0;
	vector<string> vec;
	nPos = srcStr.find(delim.c_str());
	while(-1 != nPos)
	{
		string temp = srcStr.substr(0, nPos);
		if(temp!="" && temp!=" "){
			vec.push_back(temp);
		}
		srcStr = srcStr.substr(nPos+1);
		nPos = srcStr.find(delim.c_str());
	}
	if(srcStr!="" && srcStr!=" "){
		vec.push_back(srcStr);
	}
	return vec;
}

//加载模型参数
Matrix loadEMGData(string file)
{
	ifstream infile;
	infile.open(file.data());
	//assert(infile.is_open());
	int rowCount = getFileRowCount(file);
	int colCount = getFileColCount(file);

	Matrix mat = Matrix(rowCount, colCount);
	double **matPtr = mat.getPtr();

    string s;
    int rowIndex = 0;
    while(getline(infile,s))
    {
        vector<string> ret = split(s, " ");
        for(size_t i=0; i<ret.size(); i++){
        	matPtr[rowIndex][i] = strToDouble(ret[i].c_str());
        }
        rowIndex++;
    }
    infile.close();
    return mat;
}

Filter parseFilterWeight(const char * path, int fsize, int depth, int row, int col)
{
	TiXmlDocument mydoc(path);//xml文档对象
	bool loadOk=mydoc.LoadFile();//加载文档
	if(!loadOk)
	{
		cout<<"could not load the test file.Error:"<<mydoc.ErrorDesc()<<endl;
		exit(1);
	}

	Filter filter = Filter(fsize,depth,row,col);
	TiXmlElement *rootElem = mydoc.RootElement();	// filters
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
	return filter;
}

double strToDouble(string str)
{
	double result;
	istringstream is(str);
	is >> result;
	return result;
}

string intToString(int num)
{
    string str = "";
    ostringstream oss;
    oss << num;
    str = oss.str();
    return str;
}

Matrix parseFullConnWeight(const char * path, int row, int col)
{
	TiXmlDocument mydoc(path);//xml文档对象
	bool loadOk=mydoc.LoadFile();//加载文档
	if(!loadOk)
	{
		cout<<"could not load the test file.Error:"<<mydoc.ErrorDesc()<<endl;
		exit(1);
	}

	Matrix outMat = Matrix(row, col);

	//Filter filter = Filter(fsize,depth,row,col);
	TiXmlElement *rootElem = mydoc.RootElement();
	TiXmlElement *mElem = rootElem;//  mat
	int fcount = 0;
	int rowIndex = 0;
	int colIndex = 0;
	string result;
	for(TiXmlElement *rowElem = mElem->FirstChildElement();rowElem != NULL;rowElem=rowElem->NextSiblingElement()){ // row
		stringstream input(rowElem->FirstChild()->Value());
		while(input>>result){
			//cout << result << endl;
			outMat.getPtr()[rowIndex][colIndex] = strToDouble(result);
			colIndex ++;
		}
		colIndex = 0;
		//input.close();
		rowIndex++;
	}
	return outMat;
}

vector<double> parseBias(const char * path, int num)
{
	TiXmlDocument mydoc(path);//xml文档对象
	bool loadOk=mydoc.LoadFile();//加载文档
	if(!loadOk)
	{
		cout<<"could not load the test file.Error:"<<mydoc.ErrorDesc()<<endl;
		exit(1);
	}
	vector<double> outBias(num);
	TiXmlElement *rootElem = mydoc.RootElement();
	TiXmlElement *mElem = rootElem;
	int fcount = 0;
	int rowIndex = 0;
	int colIndex = 0;
	string result;
	stringstream input(mElem->FirstChild()->Value());
	while(input>>result){
		//cout << result << endl;
		outBias[colIndex] = strToDouble(result);
		colIndex ++;
	}
	//input.close();
	return outBias;
}

void emgDataToMat(Matrix & res, string path)
{
	ifstream infile;
	infile.open(path.data());   //将文件流对象与文件连接起来
	assert(infile.is_open());   //若失败,则输出错误消息,并终止程序运行

	int rowCount = getFileRowCount(path);
	int colCount = getFileColCount(path);

	res = Matrix(rowCount, colCount);

	string s;
	int row = 0;
	int col = 0;
	while (getline(infile, s)) {
		istringstream is(s); //将读出的一行转成数据流进行操作
		double d;
		//cout << row << " ";
		while (!is.eof()) {
			is >> d;
			//cout << d << " ";
			res.setValue(row, col, d);
			col ++;
		}
		//cout << endl;
		row ++;
		col = 0;
		s.clear();
	}
	infile.close();             //关闭文件输入流
}


