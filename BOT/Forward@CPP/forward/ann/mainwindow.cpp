#include "utils.hpp"


Filter conv1Filter;
vector<double> convbias1;
Filter conv2Filter;
vector<double> convbias2;
Filter conv3Filter;
vector<double> convbias3;
Matrix fc1weight;
vector<double> fullbias1;
Matrix fc2weight;
vector<double> fullbias2;
vector<double> bn1_weight;
vector<double> bn1_bias;
vector<double> bn1_running_mean;
vector<double> bn1_running_var;

void load()
{

	//读取权重-----
	conv1Filter = Filter(32, 1, 3, 1);
	conv1Filter = parseFilterWeight("conv1_weight.xml", 32, 1, 3, 1);
	convbias1 = parseBias("bias1_weight.xml", 32);

	conv2Filter = Filter(64, 32, 3, 1);
	conv2Filter = parseFilterWeight("conv2_weight.xml", 64, 32, 3, 1);
	convbias2 = parseBias("bias2_weight.xml", 64);

	conv3Filter = Filter(128, 64, 3, 1);
	conv3Filter = parseFilterWeight("conv3_weight.xml", 128, 64, 3, 1);
	convbias3 = parseBias("bias3_weight.xml", 128);

	fc1weight = parseFullConnWeight("fullconn1_weight.xml", 5 * 8 * 128, 256);
	fullbias1 = parseBias("fullconn1_bias.xml", 256);

	fc2weight = parseFullConnWeight("fullconn2_weight.xml", 256, 10);
	fullbias2 = parseBias("fullconn2_bias.xml", 10);

	bn1_weight = parseBias("bn1_weight.xml", 256);
	bn1_bias = parseBias("bn1_bias.xml", 256);
	bn1_running_mean = parseBias("bn1_running_mean.xml", 256);
	bn1_running_var = parseBias("bn1_running_var.xml", 256);

}


void predict(double** p)      // the slot signal
{

	//CNNs                       CNNPrediction
	//=============================================================================================================================
	// index 8-15 channel data
	Matrix emgImg = Matrix(100, 8, 0);
	for (int imgRow = 0; imgRow < 100; imgRow++) {
		for (int imgCol = 0; imgCol < 8; imgCol++) {
			emgImg.setValue(imgRow, imgCol, p[imgRow][8 + imgCol] * 1000);
		}
	}

	Tensor semg = Tensor(0, 100, 8);
	semg.addLayer(emgImg);

	Tensor conv1 = semg.forwardConv(conv1Filter, 1, 1, 1, 0, convbias1);
	conv1.forwardReLu();
	Tensor pool1 = conv1.forwardMaxpool(10, 1);

	Tensor conv2 = pool1.forwardConv(conv2Filter, 1, 1, 1, 0, convbias2);
	conv2.forwardReLu();
	Tensor pool2 = conv2.forwardMaxpool(2, 1);
	Tensor conv3 = pool2.forwardConv(conv3Filter, 1, 1, 1, 0, convbias3);
	conv3.forwardReLu();
	Matrix flat = conv3.forwardFlat();
	Matrix fc1 = flat.forwardFullConnect(5 * 8 * 128, 256, fc1weight, fullbias1);
	fc1.batchNormal(bn1_weight, bn1_bias, bn1_running_mean, bn1_running_var);
	fc1.forwardRelu();
	//fc1.getShape();
	Matrix fc2 = fc1.forwardFullConnect(256, 10, fc2weight, fullbias2);
	vector<int> c = fc2.softmax();
}
