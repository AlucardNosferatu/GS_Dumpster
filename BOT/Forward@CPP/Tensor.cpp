/*
 * Tensor.cpp
 *
 *  Created on: Jun 15, 2019
 *      Author: monky
 */

#include "Tensor.hpp"

Tensor::Tensor(){}

Tensor::Tensor(int row, int col)
{
	this->row = row;
	this->col = col;
	this->depth = 0;
}

Tensor::Tensor(int depth, int row, int col)
{
	this->depth = depth;
	this->row = row;
	this->col = col;
}

void Tensor::addLayer(Matrix layer)
{
	this->layers.push_back(layer);
	this->depth ++;
}

Matrix Tensor::getLayer(int index) const
{
	return this->layers[index];
}

int Tensor::getRow() const
{
	return this->row;
}

int Tensor::getCol() const
{
	return this->col;
}

int Tensor::getDepth() const
{
	return this->depth;
}

void Tensor::getShape()
{
	cout << "Tensor: (" << this->getDepth() << ", " << this->row << ", " << this->col << ")" << endl;
}

void Tensor::showTensor()
{
	getShape();
	for(int d=0; d<depth; d++){
		layers[d].showMatrix();
	}
}

Tensor Tensor::forwardConv(const Filter & filter, int stride_row, int stride_col, int pad_row, int pad_col, const vector<double> & bias)
{
	int filterSize = filter.getSize();
	int filterDepth = filter.getDepth();
	int filterRow = filter.getRow();
	int filterCol = filter.getCol();

	int outRow = ceil((this->row + 2*pad_row - filterRow)/stride_row + 1);
	int outCol = ceil((this->col + 2*pad_col - filterCol)/stride_col + 1);

	Tensor outTensor = Tensor(outRow, outCol);

	// filter number ->  Tensor (d,_,_)
	for(int f=0; f<filterSize; f++){
		Matrix outMat = Matrix(outRow, outCol);

		//get per matrix -> Tensor(1,row,col)
		for(int d=0; d<filterDepth; d++){
			outMat.sumMat(this->layers[d].singleMatConv(filter.getFilter(f).getLayer(d), stride_row, stride_col, pad_row, pad_col));
		}
		//TODO load bias
		Matrix biasMat = Matrix(outRow, outCol, bias[f]);
		outMat.sumMat(biasMat);

		outTensor.addLayer(outMat);
	}
	return outTensor;
}


void Tensor::forwardReLu()
{
	for(int d=0; d<depth; d++){
		double value = 0.0;
		for(int i=0; i<row; i++){
			for(int j=0; j<col; j++){
				value = this->layers[d].getValue(i, j);
				this->layers[d].setValue(i, j, value > 0 ? value : 0);
			}
		}

	}
}


//默认是pool_box是不重叠的，也就是步长和box是一致的
Tensor Tensor::forwardMaxpool(int box_row, int box_col)
{
	int depth = this->depth;
	int outRow = row / box_row;
	int outCol = col / box_col;

	Tensor poolTensor = Tensor(0, outRow, outCol);

	for(int d=0; d<depth; d++){
		double **p = this->layers[d].getPtr();
		Matrix maxMat = Matrix(outRow, outCol);
		int maxRowIndex = 0;
		int maxColIndex = 0;

		for(int i=0; i<row; i=i+box_row){
			for(int j=0; j<col; j=j+box_col){
				//find max value
				double max = 0;
				for(int x=0; x<box_row; x++){
					for(int y=0; y<box_col; y++){
						if(max <= p[x+i][y+j]){
							max = p[x+i][y+j];
						}
					}
				}
				maxMat.getPtr()[maxRowIndex][maxColIndex] = max;
				maxColIndex	++;
			}
			maxRowIndex ++;
			maxColIndex = 0;
		}
		poolTensor.addLayer(maxMat);
//		maxMat.showMatrix();
	}

	return poolTensor;
}

//Tensor(a,b,c) -> Matrix(1, a*b*c)
Matrix Tensor::forwardFlat()
{
	Matrix outMat = Matrix(1, depth*row*col);
	int index = 0;
	for(int d=0; d<depth; d++){
		for(int i=0; i<row; i++){
			for(int j=0; j<col; j++){
				outMat.setValue(0, index, layers[d].getValue(i, j));
				index ++;
			}
		}
	}
	return outMat;
}


