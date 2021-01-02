/*
 * Tensor.hpp
 *
 *  Created on: Jun 15, 2019
 *      Author: monky
 */

#ifndef TENSOR_HPP_
#define TENSOR_HPP_

#include "sEMG.hpp"
#include "Matrix.hpp"
#include "Filter.hpp"

class Filter;

class Tensor{
public:

	Tensor();
	Tensor(int row, int col);
	Tensor(int depth, int row, int col);
	void addLayer(Matrix layer);
	Matrix getLayer(int index) const;
	int getRow() const;
	int getCol() const;
	int getDepth() const;
	void getShape();
	void showTensor();

	Tensor forwardConv(const Filter & filter, int stride_row, int stride_col, int pad_row, int pad_col, const vector<double> & bias);
	void forwardReLu();
	Tensor forwardMaxpool(int box_row, int box_col);
	Matrix forwardFlat();


	vector<Matrix> layers;

protected:
	int row;
	int col;
	int depth;
};

#endif /* TENSOR_HPP_ */
