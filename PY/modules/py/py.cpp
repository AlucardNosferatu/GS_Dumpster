#include <string>
#include <math.h>
#include "amxxmodule.h"

#include <Python.h>

using namespace std;

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
	return 1;
}

AMX_NATIVE_INFO natives[] = {
	{ "init_py", init_py },
	{ "get_individual", get_individual },
	{ "eval_py", eval_py },
	{ "update_gen", update_gen },
	{ "exit_py", exit_py },
	{ NULL, NULL }
};

void OnAmxxAttach() {
	MF_AddNatives(natives);
}
