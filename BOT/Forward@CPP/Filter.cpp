/*
 * Filter.cpp
 *
 *  Created on: Jun 11, 2019
 *      Author: monky
 */

#include "Filter.hpp"

Filter::Filter(){}


Filter::Filter(int numFilter, int depth, int row, int col)
{
	this->row = row;
	this->col = col;
	this->depth = depth;
	this->numFilter = numFilter;
	this->filters = vector<Tensor>(numFilter);
	for (int i = 0; i<numFilter; i++){
		filters[i] = Tensor(depth, row, col);
		//TODO load weight
		for(int j=0; j<depth; j++){
			Matrix mat = Matrix(row,col,1.2);
			filters[i].addLayer(mat);
		}
	}
}




int Filter::getRow() const
{
	return this->row;
}

int Filter::getCol() const
{
	return this->col;
}

int Filter::getDepth() const
{
	return this->depth;
}
int Filter::getSize() const
{
	return this->numFilter;
}

Tensor Filter::getFilter(int index) const
{
	return this->filters[index];
}

void Filter::setFilter(int index, Tensor tensor)
{
	this->filters[index] = tensor;
}

void Filter::addFilter(Tensor tensor)
{
	this->filters.push_back(tensor);
	this->numFilter ++;
}

void Filter::showFilter()
{
	getShape();
	for(int i=0; i<this->getSize(); i++){
		this->filters[i].showTensor();
	}
}

void Filter::getShape()
{
	cout << "Filter: (" << this->getSize() << ", " << this->getDepth() << ", " << this->row << ", " << this->col << ")" << endl;
}




