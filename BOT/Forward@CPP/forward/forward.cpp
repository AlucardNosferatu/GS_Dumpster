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

static cell AMX_NATIVE_CALL load_model(AMX* amx, cell* params)  /* 1 param */
{
	model.clear();
	int len;
	const char* ini_path = MF_GetAmxString(amx, params[1], 0, &len);
	rwini::ReadWriteini* rw = new rwini::ReadWriteini(ini_path);
	string layer_count_str = rw->FindValue("General", "layer_count");
	const int layer_count = stoi(layer_count_str);
	//layer_type:
	//Conv Pool Flat Dense BN Softmax

	//Need Nothing:
	//Flat Softmax

	//Need Shape:
	//Conv Dense Pool

	//Need Weight:
	//Conv Dense BN

	//Need More Weight:
	//BN


	for (int i = 0; i < layer_count; i++)
	{
		char* layer_key = "";
		sprintf(layer_key, "layer_%d", i);
		string layer_type = rw->FindValue(layer_key, "layer_type");
		layer_types.push_back(layer_type);

		if (!layer_type._Equal("Flat") && !layer_type._Equal("Softmax"))//Conv Pool Dense BN
		{
			if (!layer_type._Equal("BN"))//Conv Pool Dense
			{
				string layer_shape = rw->FindValue(layer_key, "layer_shape");
				vector<string> value_str = split(layer_shape, "#");
				vector<int> value;
				vector<int>::size_type ix = 0;
				for (ix; ix < value_str.size(); ++ix)
				{
					value.push_back(stoi(value_str[ix]));
				}

				if (!layer_type._Equal("Pool"))//Conv & Dense
				{
					vector<void*> shape_and_weight;
					shape_and_weight.push_back((void*)&value);

					string weight_path = rw->FindValue(layer_key, "weight_path");
					string bias_path = rw->FindValue(layer_key, "bias_path");

					vector<vector<double>> layer_weights;
					char* temp = "";

					strcpy(temp, weight_path.c_str());
					vector<double> bn_weight = parseBias(temp, 256);
					layer_weights.push_back(bn_weight);

					strcpy(temp, bias_path.c_str());
					vector<double> bn_bias = parseBias(temp, 256);
					layer_weights.push_back(bn_bias);


				}
				else//Pool
				{
					model.push_back((void*)&value);
				}
			}
			else//BN
			{
				string weight_path = rw->FindValue(layer_key, "weight_path");
				string bias_path = rw->FindValue(layer_key, "bias_path");
				string run_mean_path = rw->FindValue(layer_key, "run_mean_path");
				string run_var_path = rw->FindValue(layer_key, "run_var_path");

				vector<vector<double>> bn;
				char* temp = "";

				strcpy(temp, weight_path.c_str());
				vector<double> bn_weight = parseBias(temp, 256);
				bn.push_back(bn_weight);

				strcpy(temp, bias_path.c_str());
				vector<double> bn_bias = parseBias(temp, 256);
				bn.push_back(bn_bias);

				strcpy(temp, run_mean_path.c_str());
				vector<double> bn_running_mean = parseBias(temp, 256);
				bn.push_back(bn_running_mean);

				strcpy(temp, run_var_path.c_str());
				vector<double> bn_running_var = parseBias(temp, 256);
				bn.push_back(bn_running_var);

				model.push_back((void*)&bn);
			}
		}
		else//Flat & Softmax 
		{
			model.push_back((void*)&layer_type);
		}
	}
	return 0;
}

static cell AMX_NATIVE_CALL forward_model(AMX* amx, cell* params)  /* 2 param */
{
	return 0;
}

// native socket_open(_hostname[], _port, _protocol = SOCKET_TCP, &_error);
static cell AMX_NATIVE_CALL socket_open(AMX* amx, cell* params)  /* 2 param */
{
	unsigned int p2 = params[2];
	unsigned int p3 = params[3];
	int len;
	char* p1 = MF_GetAmxString(amx, params[1], 0, &len); // Get the hostname from AMX
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
	{"socket_open", socket_open},
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
