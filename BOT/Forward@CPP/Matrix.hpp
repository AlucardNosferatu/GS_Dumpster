/*************************************************
Matrix.hpp
Author:Mitom
Date:2019-05-30
Description:矩阵类
**************************************************/

#ifndef MATRIX_MATRIX_HPP_
#define MATRIX_MATRIX_HPP_

#include "sEMG.hpp"

class Matrix {
public:
	Matrix();
	Matrix(int row, int col);
	Matrix(int row, int col, double value);
	Matrix(double **p, int row, int col);
//	~Matrix();

	double getValue(int row, int col) const;
	void setValue(int row, int col, double value);
	void getShape() const;
	int getRow() const;
	int getCol() const;
	double ** getPtr() const;

	void showMatrix() const;

	static Matrix multiply(const Matrix & matA, const Matrix & inputMat); //要修改

	void dotMatCoefficient(double coeff);
	Matrix addPadding(int pad_row, int pad_col);
	double dotProduct(const Matrix &filterMat);
	Matrix singleMatConv(const Matrix & filterMat, int stride_row, int stride_col, int pad_row, int pad_col);
	void sumMat(const Matrix & mat);
	void forwardRelu();

	Matrix forwardFullConnect(int inputSize, int outputSize, const Matrix & wMat, const vector<double> & bias);
	vector<int> softmax();
	void batchNormal(const vector<double> & weight, const vector<double> & bais, const vector<double> & mean, const vector<double> & var);
    string printAction(int gst);

protected:
	int row;
	int col;
	double **p;
	void initialize();//初始化矩阵
};


#endif /* MATRIX_MATRIX_HPP_ */
