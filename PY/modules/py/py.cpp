/*
 *
 * AMX Mod X Module
 * Basic Socket Functions
 *
 * Codebase from Ivan, -g-s-ivan@web.de (AMX 0.9.3)
 * Modification by Olaf Reusch, kenterfie@hlsw.de (AMXX 0.16, AMX 0.96)
 * Modification by David Anderson, dvander@tcwonline.org (AMXx 0.20)
 *
 * Bugs/Fixes
 *
 * v0.1
 * - code structure renewed
 * v0.2
 * - added socket_send2 to send data containing null bytes (FALUCO)(AMXX v1.65)
 */

#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <Python.h>


 // AMX Headers
#include "amxxmodule.h"


// And global Variables:

static cell AMX_NATIVE_CALL init_py(AMX* amx, cell* params)
{
	Py_Initialize();
	return 1;
}

static cell AMX_NATIVE_CALL get_individual(AMX* amx, cell* params)
{
	return 1;
}

static cell AMX_NATIVE_CALL eval_py(AMX* amx, cell* params)
{

	return 1;
}

static cell AMX_NATIVE_CALL update_gen(AMX* amx, cell* params)
{
	return 1;
}

static cell AMX_NATIVE_CALL exit_py(AMX* amx, cell* params)
{
	Py_Finalize();
	return 1;
}

AMX_NATIVE_INFO sockets_natives[] = {
	{ "init_py", init_py },
	{ "get_individual", get_individual },
	{ "eval_py", eval_py },
	{ "update_gen", update_gen },
	{ "exit_py", exit_py },
	{NULL, NULL}
};

void OnAmxxAttach()
{
	MF_AddNatives(sockets_natives);
	return;
}

void OnAmxxDetach()
{
	return;
}
