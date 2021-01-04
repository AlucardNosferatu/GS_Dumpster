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
int input_scount;
int input_slength;

static const string model_path = "svencoop/addons/amxmodx/data/models/";

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
	Conv_Layer(rwini::ReadWriteini* rw, string layer_key) {

		layer_bias.clear();
		layer_params.clear();

		string layer_shape = rw->FindValue(layer_key, "layer_shape");
		string weight_path = rw->FindValue(layer_key, "weight_path");
		string bias_path = rw->FindValue(layer_key, "bias_path");
		string forward_params = rw->FindValue(layer_key, "forward_params");

		vector<string> value = split(layer_shape, "%");
		string temp;

		temp = "";
		temp += model_path;
		temp += weight_path;
		layer_weights = Filter(stoi(value[0]), stoi(value[1]), stoi(value[2]), stoi(value[3]));
		layer_weights = parseFilterWeight(temp.c_str(), stoi(value[0]), stoi(value[1]), stoi(value[2]), stoi(value[3]));

		temp = "";
		temp += model_path;
		temp += bias_path;
		layer_bias = parseBias(temp.c_str(), stoi(value[0]));

		vector<string> value_str = split(forward_params, "%");
		vector<int>::size_type ix = 0;
		for (ix; ix < value_str.size(); ++ix)
		{
			layer_params.push_back(stoi(value_str[ix]));
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
		layer_weights = parseFullConnWeight(temp.c_str(), stoi(value[0]), stoi(value[1]));

		temp = "";
		temp += model_path;
		temp += bias_path;
		layer_bias = parseBias(temp.c_str(), stoi(value[1]));

		vector<string> value_str = split(layer_shape, "%");
		vector<int>::size_type ix = 0;
		for (ix; ix < value_str.size(); ++ix)
		{
			layer_params.push_back(stoi(value_str[ix]));
		}
	}
};

static vector<int> Pool_Layer(rwini::ReadWriteini* rw, string layer_key)
{
	string forward_params = rw->FindValue(layer_key, "forward_params");
	vector<int> value;

	vector<string> value_str = split(forward_params, "%");
	vector<int>::size_type ix = 0;
	for (ix; ix < value_str.size(); ++ix)
	{
		value.push_back(stoi(value_str[ix]));
	}
	return value;
}

static void release_layers()
{
	int l_Count = layer_types.size();
	for (int i = 0; i < l_Count; i++)
	{
		delete model[i];
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
		MF_PrintSrvConsole("Now loading: %s: layer_type\n", layer_key.c_str(), layer_type.c_str());
		layer_types.push_back(layer_type);

		if (layer_type._Equal("BN"))
		{
			BN_Layer* BN = new BN_Layer(rw, layer_key);
			model.push_back((void*)&BN);
		}
		else if (layer_type._Equal("Conv"))
		{
			Conv_Layer* Conv = new Conv_Layer(rw, layer_key);
			model.push_back((void*)Conv);
		}
		else if (layer_type._Equal("Dense"))
		{
			Dense_Layer* Dense = new Dense_Layer(rw, layer_key);
			model.push_back((void*)&Dense);
		}
		else if (layer_type._Equal("Flat"))
		{
			model.push_back((void*)&layer_type);
		}
		else if (layer_type._Equal("Pool"))
		{
			vector<int> Pool = Pool_Layer(rw, layer_key);
			model.push_back((void*)&Pool);
		}
		else if (layer_type._Equal("Softmax"))
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
	input_scount = params[1];
	input_slength = params[2];
	static double** t_double = new double* [input_scount];
	for (int i = 0; i < input_scount; i++)
	{
		const cell* input_tensor_slice = MF_GetAmxAddr(amx, params[3 + i]);
		t_double[i] = new double[input_slength];
		for (int j = 0; j < input_slength; j++)
		{
			float element = amx_ctof(input_tensor_slice[j]);
			t_double[i][j] = static_cast<double>(element);
		}
	}
	return 0;
}

static cell AMX_NATIVE_CALL test_forward(AMX* amx, cell* params)  /* 2 param */
{
	const unsigned int p2 = params[2];
	const unsigned int p3 = params[3];
	int len;
	const char* p1 = MF_GetAmxString(amx, params[1], 0, &len); // Get the hostname from AMX
	cell* p4 = MF_GetAmxAddr(amx, params[4]);
	*p4 = p2; // params[4] is error backchannel
	vector<int> res = run();
	vector<int>::size_type ix = 0;
	for (ix; ix < res.size(); ++ix)
	{
		MF_PrintSrvConsole("Class: %d\n", res[ix]);
	}
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
