#include <string>
#include "ga.hpp"
#include "amxxmodule.h"

using namespace std;

GATask* gTask;

static cell AMX_NATIVE_CALL test_ga(AMX* amx, cell* params) {
	gTask->Eva();
	gTask->Update();
	gTask->Eva();
	Test BestForNow = gTask->GetBest();
	cell* a = MF_GetAmxAddr(amx, params[4]);
	*a = int(std::round(BestForNow.a));
	cell b = int(std::round(BestForNow.b));
	return b;
}

AMX_NATIVE_INFO natives[] = {
	{ "test_ga", test_ga },
	{ NULL, NULL }
};

void OnAmxxAttach() {
	gTask = new GATask(200, 7.15, 2.22, 8.4, 6.07);
	MF_AddNatives(natives);
}
