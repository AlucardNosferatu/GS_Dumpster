/*************************************************
Matrix.cpp
Author:Mitom
Date:2019-05-30
Description:矩阵类
**************************************************/
#include "Matrix.hpp"

//析构函数
Matrix::Matrix(){}

//二维数组，动态分配内存
void Matrix::initialize()
{
	p = new double*[this->row];
	for(int i=0; i<this->row; i++){
		p[i] = new double[this->col];
	}
}

//初始化矩阵值全为0
Matrix::Matrix(int row, int col)
{
	this->row = row;
	this->col = col;
	initialize();
	for(int i=0; i<this->row; i++){
		for(int j=0; j<this->col; j++){
			p[i][j] = 0.0;
		}
	}
}

//初始化矩阵值全为value
Matrix::Matrix(int row, int col, double value)
{
	this->row = row;
	this->col = col;
	initialize();
	for(int i=0; i<this->row; i++){
		for(int j=0; j<this->col; j++){
			p[i][j] = value;
		}
	}
}

//由指针数组数组得到Matrix对象
Matrix::Matrix(double **p, int row, int col)
{
	this->p = p;
	this->row = row;
	this->col = col;
}

////析构函数
//Matrix::~Matrix() {
//  for (int i = 0; i < this->row; ++i) {
//      delete[] p[i];
//    }
//    delete[] p;
//}

double Matrix::getValue(int row, int col) const
{
	return p[row][col];
}

void Matrix::setValue(int row, int col, double value)
{
	p[row][col] = value;
}

void Matrix::getShape() const
{
	cout << "Matrix: (" << this->row << ", " << this->col << ")" << endl;
}

int Matrix::getRow() const
{
	return this->row;
}

int Matrix::getCol() const
{
	return this->col;
}

double ** Matrix::getPtr() const
{
	return this->p;
}

//打印矩阵
void Matrix::showMatrix() const {
	cout << "(" << this->row <<", "<< this->col << ")"<< endl;//显示矩阵的行数和列数
	for (int i = 0; i < this->row; i++) {
		for (int j = 0; j < this->col; j++) {
			cout << setw(15) << this->p[i][j] << " ";
		}
		cout << endl;
	}
	cout << endl;
}



/*************************************************
Function:       multiply
Description:    矩阵乘积，outMat = Matrix::multiply(W,X)
Input:          matA:矩阵（一般是W*X中的W）
				matB:矩阵（一般是W*X中的X）
Output:         矩阵
Return:         Matrix矩阵
Others:			注意：matA的shape是不等于matB的shape，不是点乘
*************************************************/
Matrix Matrix::multiply(const Matrix & matA, const Matrix & matB)
{
	if(matA.col != matB.row){
		cout << "矩阵A列不等于矩阵B行" << endl;
		//abort();
	}
	Matrix outMat = Matrix(matA.row, matB.col);
	for(int i=0; i<matA.row; i++){
		for(int m=0; m<matB.col; m++){
			double sum = 0;
			for(int j=0; j<matA.col; j++){
				sum = sum + matA.p[i][j]*matB.p[j][m];
			}
			outMat.p[i][m] = sum;
		}
	}
	return outMat;
}

/*************************************************
Function:       dotMatCoefficient
Description:    矩阵shape不变，矩阵中的值同时放大缩小coeff倍
Input:          mat:输入矩阵
				coeff：系数
Output:         矩阵
Return:         Matrix矩阵
Others:
*************************************************/
void Matrix::dotMatCoefficient(double coeff)
{
	for(int i=0; i<row; i++){
		for(int j=0; j<col; j++){
			p[i][j] = p[i][j] * coeff;
		}
	}
}

/**
 *  Matrix mat = Matrix(3,3,1);
	Matrix out = mat.addPadding(2,0);
	这种方式待修改：。。。
	Matrix mat = Matrix(3,3,1);
	mat.addPadding(2,0);
 */
Matrix Matrix::addPadding(int pad_row, int pad_col)
{
	Matrix outMat = Matrix(row+2*pad_row, col+2*pad_col, 0);
	for(int i=pad_row; i<row+pad_row; i++){
		for(int j=pad_col; j<col+pad_col; j++){
			outMat.p[i][j] = this->p[i-pad_row][j-pad_col];
		}
	}
	this->row = this->row + 2*pad_row;
	this->col = this->col + 2*pad_col;
	return outMat;
}

/**
 * 点积
 */
double Matrix::dotProduct(const Matrix &filterMat)
{
	double value = 0;
	for(int i=0; i<filterMat.getRow(); i++){
		for(int j=0; j<filterMat.getCol(); j++){
			value += this->p[i][j] * filterMat.p[i][j];
		}
	}
	return value;
}

//Tensor的其中一个mat与filter其中一个mat做卷积操作
Matrix Matrix::singleMatConv(const Matrix & filterMat, int stride_row, int stride_col, int pad_row, int pad_col)
{
	int filterRow = filterMat.getRow();
	int filterCol = filterMat.getCol();

	Matrix padMat;
	padMat = Matrix(this->p, this->row, this->col).addPadding(pad_row, pad_col);

	int outRow = 0;
	int outCol = 0;
	outRow = ceil((this->row + 2*pad_row - filterRow)/stride_row + 1);
	outCol = ceil((this->col + 2*pad_col - filterCol)/stride_col + 1);

	Matrix windowMat = Matrix(filterRow, filterCol);
	Matrix outMat = Matrix(outRow, outCol);

	for(int i=0; i<outRow; i++){
		for(int j=0; j<outCol; j++){
			//get per window
			for(int x=0; x<filterRow; x++){
				for(int y=0; y<filterCol; y++){
					windowMat.p[x][y] = padMat.p[x+i][y+j];
				}
			}
			double value = windowMat.dotProduct(filterMat);
			outMat.p[i][j] = value;
		}
	}

	return outMat;
}

void Matrix::sumMat(const Matrix & mat)
{
//    cout << row << "," << mat.row << endl;
//    cout << col << "," << mat.col << endl;
	if(this->row != mat.row || this->col != mat.col){
		cout << "Matrix::sumMat(const Matrix & mat)" << endl;
		cout << "矩阵size不匹配" << endl;
        cout << row << "," << mat.row << endl;
        cout << col << "," << mat.col << endl;
	}
	for(int i=0; i<row; i++){
		for(int j=0; j<col; j++){
			this->p[i][j] += mat.p[i][j];
		}
	}
	//return Matrix(this->p, row, col);
}

void Matrix::forwardRelu()
{
	double value = 0.0;
	for(int i=0; i<row; i++){
		for(int j=0; j<col; j++){
			value = this->p[i][j];
			this->p[i][j] = value > 0 ? value : 0;
		}
    }
}


Matrix Matrix::forwardFullConnect(int inputSize, int outputSize, const Matrix & wMat, const vector<double> & bias)
{
	if(inputSize != wMat.getRow() || outputSize != wMat.getCol()){
		cout << "forwardFullConnect() 连接参数不对！" << endl;
	}
	Matrix outMat = Matrix(1, outputSize);
	outMat = multiply(Matrix(p, row, col), wMat);
	//add bias
	for(int i=0; i<outMat.getCol(); i++){
		outMat.setValue(0,i,(bias[i]+outMat.getValue(0,i)));
	}
	return outMat;
}

//softmax分类
vector<int> Matrix::softmax()
{
	vector<int> outClass;
	/*
	vector<int> rowSum;
	for(int i=0; i<row; i++){
		double sum = 0;
		for(int j=0; j<col; j++){
			p[i][j] = exp(p[i][j]);
			cout << p[i][j] << " ";
			sum += p[i][j];
		}
		rowSum.push_back(sum);
	}
	//可以省略概率转换，直接输出类别，还是输出概率吧，更直观
	for(int i=0; i<row; i++){
		for(int j=0; j<col; j++){
			p[i][j] = double(p[i][j])/rowSum[i];
		}
	}*/

	for(int i=0; i<row; i++){
		double max = 0;
		int maxIndex = 0;
		for(int j=0; j<col; j++){
            // cout << p[i][j] << ", ";
			if(max <= p[i][j]){
				max = p[i][j];
				maxIndex = j;
			}
		}
		outClass.push_back(maxIndex);

	}
    cout << "motion: " << outClass[0] << " ";
    string out = printAction(outClass[0]);


    cout << endl;
	return outClass;
}


void Matrix::batchNormal(const vector<double> & weight, const vector<double> & bais, const vector<double> & mean, const vector<double> & var)
{
	if(this->getCol() != weight.size()
		|| this->getCol() != bais.size()
		|| this->getCol() != mean.size()
		|| this->getCol() != var.size()){
		cout << "输入的bn参数数量不匹配" << endl;
		exit(0);
	}
	for(int i=0; i<this->getCol(); i++){
		this->p[0][i] = (p[0][i]-mean[i])*weight[i]/sqrt(var[i]+0.000000001) + bais[i];
	}
}


string Matrix::printAction(int gst)
{
    string out = "";
    switch(gst){
    case 0: cout << "放松";
            out = "放松";
            break;
    case 1: cout << "握拳";
            out = "握拳";
                break;
    case 2: cout << "上挥";
            out = "上挥";
                break;
    case 3: cout << "下挥";
            out = "下挥";
                break;
    case 4: cout << "左挥";
            out = "左挥";
                break;
    case 5: cout << "右挥";
            out = "右挥";
                break;
    case 6: cout << "一";
            out = "一";
                break;
    case 7: cout << "二";
            out = "二";
                break;
    case 8: cout << "五";
            out = "五";
                break;
    case 9: cout << "六";
            out = "六";
                break;
    }
    return out;
}



