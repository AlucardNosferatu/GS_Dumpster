
#include <string>
#include "amxxmodule.h"

using namespace std;

static cell AMX_NATIVE_CALL native_Execute(AMX* amx, cell* amxparams) {

	char work_dir[1000];

	char* file = MF_GetAmxString(amx, amxparams[1], 0, NULL);
	char* params = MF_GetAmxString(amx, amxparams[2], 1, NULL);

	string wd_str = string(work_dir);
	string f_str = string(file);
	string relative(".\\");
	bool startwith = f_str.compare(0, relative.size(), relative) == 0;
	if (startwith) {
		f_str = f_str.replace(f_str.find(".\\"), 1, wd_str.c_str());
	}
	const char* f_c_str = f_str.c_str();
	int nLen = strlen(f_c_str) + 1;
	char* file2 = (char*)malloc(sizeof(char) * nLen);
	strcpy(file2, f_c_str);


	return 1;
}

AMX_NATIVE_INFO natives[] = {
	{ "Execute", native_Execute },
	{ NULL, NULL }
};

void OnAmxxAttach() {
	; MF_AddNatives(natives);
}
