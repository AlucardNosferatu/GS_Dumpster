#include <string>
#include "ga.hpp"
#include "amxxmodule.h"

using namespace std;

GATask* gTask;

static cell AMX_NATIVE_CALL test_ga(AMX* amx, cell* params) {
	gTask->Eva();
	gTask->Update();
	gTask->Eva();
	const Test BestForNow = gTask->GetBest();
	cell* a = MF_GetAmxAddr(amx, params[1]);
	cell* b = MF_GetAmxAddr(amx, params[2]);
	cell* c = MF_GetAmxAddr(amx, params[3]);
	cell* d = MF_GetAmxAddr(amx, params[4]);
	*a = static_cast<int>(std::round(BestForNow.a));
	*b = static_cast<int>(std::round(BestForNow.b));
	*c = static_cast<int>(std::round(BestForNow.c));
	*d = static_cast<int>(std::round(BestForNow.d));
	return 1;
}

static cell AMX_NATIVE_CALL init_task(AMX* amx, cell* params) {

	const int population = params[1];
	const double x = static_cast<double>(amx_ctof(params[2]));
	const double y = static_cast<double>(amx_ctof(params[3]));
	const double z = static_cast<double>(amx_ctof(params[4]));
	const double w = static_cast<double>(amx_ctof(params[5]));
	gTask = new GATask(population, x, y, z, w);
	return 1;
}

AMX_NATIVE_INFO natives[] = {
	{ "test_ga", test_ga },
	{ "init_task", init_task },
	{ NULL, NULL }
};

void OnAmxxAttach() {
	MF_AddNatives(natives);
}
