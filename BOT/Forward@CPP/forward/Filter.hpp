/*
 * Filter.hpp
 *
 *  Created on: Jun 11, 2019
 *      Author: monky
 */

#ifndef FILTER_HPP_
#define FILTER_HPP_

#include "sEMG.hpp"
#include "Matrix.hpp"
#include "Tensor.hpp"

class Tensor;

class Filter {
public:
	Filter();
	Filter(int numFilter, int depth, int row, int col);

	int getRow() const;
	int getCol() const;
	int getDepth() const;
	int getSize() const;

	Tensor getFilter(int index) const;
	void setFilter(int index, Tensor tensor);
	void addFilter(Tensor tensor);
	void showFilter();
	void getShape();

	vector<Tensor> filters;


protected:
	int row;
	int col;
	int depth;
	int numFilter;
};


#endif /* FILTER_HPP_ */
