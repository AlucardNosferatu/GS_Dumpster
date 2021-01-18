#include <windows.h>
#include <stdio.h>
#include <string>
#include "amxxmodule.h"

using namespace std;

void ErrorWrapper(int CustomErrornum = -666, const char szCustomError[] = "") {

	if (strlen(szCustomError))
		printf("[%s] Error X: %s\n", MODULE_NAME, szCustomError);

	else {

		DWORD dwRC = NULL;
		DWORD dwError = CustomErrornum;
		if (CustomErrornum == -666)
			dwError = GetLastError();
		LPVOID lpMsgBuf;
		lpMsgBuf = NULL;

		dwRC = FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER
			| FORMAT_MESSAGE_FROM_SYSTEM
			| FORMAT_MESSAGE_IGNORE_INSERTS,
			NULL,
			dwError,
			MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
			(LPTSTR)&lpMsgBuf,
			0,
			NULL);

		if (dwRC && lpMsgBuf)
			printf("[%s] Error %d: %s\n", MODULE_NAME, dwError, lpMsgBuf);
		else
			printf("[%s] Error %d\n", MODULE_NAME, dwError);
	}
}

static cell AMX_NATIVE_CALL native_Execute(AMX* amx, cell* amxparams) {

	char work_dir[1000];
	GetCurrentDirectory(1000, work_dir);

	char* file = MF_GetAmxString(amx, amxparams[1], 0, NULL);
	char* params = MF_GetAmxString(amx, amxparams[2], 1, NULL);

	string wd_str = string(work_dir);
	string f_str = string(file);
	string relative(".\\");
	bool startwith = f_str.compare(0, relative.size(), relative) == 0;

	SHELLEXECUTEINFO ShExecInfo;

	ShExecInfo.cbSize = sizeof(SHELLEXECUTEINFO);
	ShExecInfo.fMask = SEE_MASK_NOCLOSEPROCESS | SEE_MASK_FLAG_NO_UI;
	ShExecInfo.hwnd = NULL;
	ShExecInfo.lpVerb = NULL;
	ShExecInfo.lpFile = file;
	ShExecInfo.lpParameters = params;
	ShExecInfo.lpDirectory = NULL;
	ShExecInfo.nShow = SW_SHOWNORMAL;
	ShExecInfo.hInstApp = NULL;

	;

	if (!ShellExecuteEx(&ShExecInfo)) {
		ErrorWrapper();
		return 0;
	}

	int PID = GetProcessId(ShExecInfo.hProcess);
	CloseHandle(ShExecInfo.hProcess);

	return PID == 0 ? 1 : PID;
}

AMX_NATIVE_INFO natives[] = {
	{ "Execute", native_Execute },
	{ NULL, NULL }
};

void OnAmxxAttach() { ; MF_AddNatives(natives); }
