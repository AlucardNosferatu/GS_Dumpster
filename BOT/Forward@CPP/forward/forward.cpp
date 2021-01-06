/*
 *
 * AMX Mod X Module
 * Basic ANN Forward Utilities
 *
 * Codebase from Ivan, -g-s-ivan@web.de (AMX 0.9.3)
 * Modification by Olaf Reusch, kenterfie@hlsw.de (AMXX 0.16, AMX 0.96)
 * Modification by David Anderson, dvander@tcwonline.org (AMXx 0.20)
 * Modification by Scrooge2029, 1641367382@qq.com (AMXx 1.82)
 *
 * Bugs/Fixes
 *
 * v0.1
 * - code structure renewed
 * v0.2
 * - added socket_send2 to send data containing null bytes (FALUCO)(AMXX v1.65)
 */

 // AMX Headers
#include "amxxmodule.h"

// ANN Headers
#include "cnnmain.hpp"

// INI Reader Headers
#include "ReadWriteini.hpp"

vector<void*> model;
vector<string> layer_types;
int input_slice;
int input_length;

const string model_path = "svencoop/addons/amxmodx/data/models/";

class BN_Layer
{
public:
	vector<vector<double>> bn;
	BN_Layer(rwini::ReadWriteini* rw, string layer_key)
	{
		bn.clear();

		string weight_path = rw->FindValue(layer_key, "weight_path");
		string bias_path = rw->FindValue(layer_key, "bias_path");
		string weight_dims = rw->FindValue(layer_key, "weight_dims");
		string run_mean_path = rw->FindValue(layer_key, "run_mean_path");
		string run_var_path = rw->FindValue(layer_key, "run_var_path");

		string temp;

		temp = "";
		temp += model_path;
		temp += weight_path;
		vector<double> bn_weight = parseBias(temp.c_str(), stoi(weight_dims));
		bn.push_back(bn_weight);

		temp = "";
		temp += model_path;
		temp += bias_path;
		vector<double> bn_bias = parseBias(temp.c_str(), stoi(weight_dims));
		bn.push_back(bn_bias);

		temp = "";
		temp += model_path;
		temp += run_mean_path;
		vector<double> bn_running_mean = parseBias(temp.c_str(), stoi(weight_dims));
		bn.push_back(bn_running_mean);

		temp = "";
		temp += model_path;
		temp += run_var_path;
		vector<double> bn_running_var = parseBias(temp.c_str(), stoi(weight_dims));
		bn.push_back(bn_running_var);
	}
};

class Conv_Layer
{
public:
	Filter layer_weights;
	vector<double> layer_bias;
	vector<int> layer_params;
	Conv_Layer(rwini::ReadWriteini* rw, string layer_key)
	{
		string layer_shape = rw->FindValue(layer_key, "layer_shape");
		string weight_path = rw->FindValue(layer_key, "weight_path");
		string bias_path = rw->FindValue(layer_key, "bias_path");
		string forward_params = rw->FindValue(layer_key, "forward_params");

		vector<string> value = split(layer_shape, "%");
		string temp;

		temp = "";
		temp += model_path;
		temp += weight_path;
		layer_weights = Filter(stoi(value.at(0)), stoi(value.at(1)), stoi(value.at(2)), stoi(value.at(3)));
		layer_weights = parseFilterWeight(temp.c_str(), stoi(value.at(0)), stoi(value.at(1)), stoi(value.at(2)), stoi(value.at(3)));

		temp = "";
		temp += model_path;
		temp += bias_path;
		layer_bias = parseBias(temp.c_str(), stoi(value.at(0)));

		vector<string> value_str = split(forward_params, "%");
		vector<int>::size_type ix = 0;
		for (ix; ix < value_str.size(); ++ix)
		{
			layer_params.push_back(stoi(value_str.at(ix)));
		}
	}
};

class Dense_Layer
{
public:
	Matrix layer_weights;
	vector<double> layer_bias;
	vector<int> layer_params;
	Dense_Layer(rwini::ReadWriteini* rw, string layer_key)
	{
		string layer_shape = rw->FindValue(layer_key, "layer_shape");
		string weight_path = rw->FindValue(layer_key, "weight_path");
		string bias_path = rw->FindValue(layer_key, "bias_path");

		vector<string> value = split(layer_shape, "%");
		string temp;

		temp = "";
		temp += model_path;
		temp += weight_path;
		layer_weights = parseFullConnWeight(temp.c_str(), stoi(value.at(0)), stoi(value.at(1)));

		temp = "";
		temp += model_path;
		temp += bias_path;
		layer_bias = parseBias(temp.c_str(), stoi(value.at(1)));

		vector<string> value_str = split(layer_shape, "%");
		vector<int>::size_type ix = 0;
		for (ix; ix < value_str.size(); ++ix)
		{
			layer_params.push_back(stoi(value_str.at(ix)));
		}
	}
};

class Pool_Layer {
public:
	vector<int> value;
	Pool_Layer(rwini::ReadWriteini* rw, string layer_key)
	{
		string forward_params = rw->FindValue(layer_key, "forward_params");
		vector<string>value_str = split(forward_params, "%");
		vector<int>::size_type ix = 0;
		for (ix; ix < value_str.size(); ++ix)
		{
			value.push_back(stoi(value_str.at(ix)));
		}
	}
};

static void release_layers()
{
	const int l_Count = layer_types.size();
	for (int i = 0; i < l_Count; i++)
	{
		delete model.at(i);
	}
}

static cell AMX_NATIVE_CALL load_model(AMX* amx, cell* params)  /* 1 param */
{
	release_layers();
	layer_types.clear();
	model.clear();

	int len;
	const char* ini_path = MF_GetAmxString(amx, params[1], 0, &len);
	string ini_path_str = ini_path;

	string prefix = "";
	prefix += model_path;
	prefix += ini_path_str;

	rwini::ReadWriteini* rw = new rwini::ReadWriteini(prefix.c_str());
	string layer_count_str = rw->FindValue("General", "layer_count");
	const int layer_count = stoi(layer_count_str);
	//layer_type:
	//BN Conv Dense Flat Pool Softmax
	for (int i = 0; i < layer_count; i++)
	{
		string layer_key = "layer_";
		layer_key += to_string(i);
		string layer_type = rw->FindValue(layer_key, "layer_type");
		MF_PrintSrvConsole("Now loading: %s: %s\n", layer_key.c_str(), layer_type.c_str());
		layer_types.push_back(layer_type);

		if (layer_type._Equal("BN"))
		{
			BN_Layer* BN = new BN_Layer(rw, layer_key);
			model.push_back((void*)BN);
		}
		else if (layer_type._Equal("Conv"))
		{
			Conv_Layer* Conv = new Conv_Layer(rw, layer_key);
			model.push_back((void*)Conv);
		}
		else if (layer_type._Equal("Dense"))
		{
			Dense_Layer* Dense = new Dense_Layer(rw, layer_key);
			model.push_back((void*)Dense);
		}
		else if (layer_type._Equal("Flat"))
		{
			model.push_back((void*)&layer_type);
		}
		else if (layer_type._Equal("Pool"))
		{
			Pool_Layer* Pool = new Pool_Layer(rw, layer_key);
			model.push_back((void*)Pool);
		}
		else if (layer_type._Equal("Softmax"))
		{
			model.push_back((void*)&layer_type);
		}
		else if (layer_type._Equal("Sigmoid"))
		{
			model.push_back((void*)&layer_type);
		}
		else
		{
			return -1;
		}
	}
	MF_PrintSrvConsole("Loaded.\n");
	return 0;
}

static cell AMX_NATIVE_CALL forward_model(AMX* amx, cell* params)  /* 3 param */
{
	cell* out_class = MF_GetAmxAddr(amx, params[1]);
	const cell out_dims = params[2];
	input_slice = params[3];
	input_length = params[4];

	Matrix InputMat = Matrix(input_slice, input_length / input_slice, 0);

	const cell* input_tensor_slice = MF_GetAmxAddr(amx, params[5]);
	for (int i = 0; i < input_length; i++)
	{
		const float element = amx_ctof(input_tensor_slice[i]);
		InputMat.setValue(i % input_slice, i / input_slice, static_cast<double>(element));
	}

	Tensor InputTensor = Tensor(0, input_slice, input_length / input_slice);
	InputTensor.addLayer(InputMat);

	Tensor TempTensor = InputTensor;
	Matrix TempMatrix = InputMat;
	bool TensorOrMatrix = true;
	for (unsigned int i = 0; i < layer_types.size(); i++)
	{
		if (TensorOrMatrix)
		{
			if (layer_types.at(i)._Equal("Conv"))
			{
				Conv_Layer* Conv = (Conv_Layer*)model.at(i);
				TempTensor = TempTensor.forwardConv(
					Conv->layer_weights,
					Conv->layer_params.at(0),
					Conv->layer_params.at(1),
					Conv->layer_params.at(2),
					Conv->layer_params.at(3),
					Conv->layer_bias
				);
				TempTensor.forwardReLu();
				TensorOrMatrix = true;
			}
			else if (layer_types.at(i)._Equal("Pool"))
			{
				Pool_Layer* Pool = (Pool_Layer*)model.at(i);
				TempTensor = TempTensor.forwardMaxpool(Pool->value.at(0), Pool->value.at(1));
				TensorOrMatrix = true;
			}
			else if (layer_types.at(i)._Equal("Flat"))
			{
				TempMatrix = TempTensor.forwardFlat();
				TensorOrMatrix = false;
			}
			else
			{
				return -1;
			}
		}
		else
		{
			if (layer_types.at(i)._Equal("Dense"))
			{
				Dense_Layer* Dense = (Dense_Layer*)model.at(i);
				TempMatrix = TempMatrix.forwardFullConnect(
					Dense->layer_params.at(0),
					Dense->layer_params.at(1),
					Dense->layer_weights,
					Dense->layer_bias
				);
				TensorOrMatrix = false;
			}
			else if (layer_types.at(i)._Equal("BN"))
			{
				BN_Layer* BN = (BN_Layer*)model.at(i);
				TempMatrix.batchNormal(
					BN->bn.at(0),
					BN->bn.at(1),
					BN->bn.at(2),
					BN->bn.at(3)
				);
				TempMatrix.forwardReLu();
				TensorOrMatrix = false;
			}
			else if (layer_types.at(i)._Equal("Softmax"))
			{
				TempMatrix.forwardSoftmax();
				TensorOrMatrix = false;
			}
			else if (layer_types.at(i)._Equal("Sigmoid"))
			{
				TempMatrix.forwardSigmoid();
				TensorOrMatrix = false;
			}
			else
			{
				return -1;
			}
		}
	}
	if (TensorOrMatrix)
	{
		return -3;
	}
	else
	{
		double** out_mat = TempMatrix.getPtr();
		const int row = TempMatrix.getRow();
		const int col = TempMatrix.getCol();

		vector<double> out_vec;
		out_vec.push_back(static_cast<double>(row));
		out_vec.push_back(static_cast<double>(col));
		for (int i = 0; i < row; i++)
		{
			for (int j = 0; j < col; j++)
			{
				out_vec.push_back(out_mat[i][j]);
			}
		}

		const int dv_dims = out_vec.size();
		if (dv_dims <= out_dims)
		{
			for (int i = 0; i < dv_dims; i++)
			{
				out_class[i] = amx_ftoc(static_cast<float>(out_vec.at(i)));
			}
			return 2;
		}
		else
		{
			for (int i = 0; i < out_dims; i++)
			{
				out_class[i] = amx_ftoc(static_cast<float>(out_vec.at(i)));
			}
			return 2;
		}
	}
	return -1;
}

static cell AMX_NATIVE_CALL test_forward(AMX* amx, cell* params)  /* 2 param */
{
	const unsigned int p2 = params[2];
	const unsigned int p3 = params[3];
	int len;
	const char* p1 = MF_GetAmxString(amx, params[1], 0, &len); // Get the hostname from AMX
	cell* p4 = MF_GetAmxAddr(amx, params[4]);
	*p4 = p2; // params[4] is error backchannel
	return p3;
}

AMX_NATIVE_INFO forward_natives[] = {
	{"test_forward", test_forward},
	{"load_model", load_model},
	{"forward_model", forward_model},
	{NULL, NULL}
};

void OnAmxxAttach()
{
	MF_AddNatives(forward_natives);
	return;
}

void OnAmxxDetach()
{
	return;
}
