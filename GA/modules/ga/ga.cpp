#include <string>
#include "ga.hpp"
#include "amxxmodule.h"

using namespace std;

static cell AMX_NATIVE_CALL test_ga(AMX* amx, cell* amxparams) {

	const cell result = main_test();
	return result;
}

AMX_NATIVE_INFO natives[] = {
	{ "test_ga", test_ga },
	{ NULL, NULL }
};

void OnAmxxAttach() {
	; MF_AddNatives(natives);
}
