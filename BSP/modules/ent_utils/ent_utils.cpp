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

// 
#include <vector>
#include <string>


using namespace std;

vector<void*> model;
vector<string> layer_types;
int input_slice;
int input_length;

const string model_path = "svencoop/addons/amxmodx/data/models/";

static cell AMX_NATIVE_CALL test_read_ent(AMX* amx, cell* params)  /* 2 param */
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
	{"test_read_ent", test_read_ent},
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
