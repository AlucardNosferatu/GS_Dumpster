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

static cell AMX_NATIVE_CALL load_model(AMX* amx, cell* params)  /* 1 param */
{
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
	//Conv Pool Dense 
	for (int i = 0; i < layer_count; i++)
	{
		char* layer_key = "";
		sprintf(layer_key, "layer_%d", i);
		string layer_type = rw->FindValue(layer_key, "layer_type");
		if (!layer_type._Equal("Flat") && !layer_type._Equal("Softmax"))
		{
			string layer_shape = rw->FindValue(layer_key, "layer_shape");
			string weight_path = rw->FindValue(layer_key, "weight_path");
			string bias_path = rw->FindValue(layer_key, "bias_path");
			string run_means_path = rw->FindValue(layer_key, "run_means_path");
		}
		else {

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
