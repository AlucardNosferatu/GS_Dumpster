/*
 *
 * AMX Mod X Module
 * Basic Python Wrapper
 *
 * Codebase from Ivan, -g-s-ivan@web.de (AMX 0.9.3)
 * Modification by Olaf Reusch, kenterfie@hlsw.de (AMXX 0.16, AMX 0.96)
 * Modification by David Anderson, dvander@tcwonline.org (AMXx 0.20)
 * Modification by Scrooge2029, 1641367382@qq.com (AMXx 1.8.2)
 *
 * Bugs/Fixes
 *
 */

#include <Python.h>
#include <string>
#include <vector>
#include <Windows.h>
 // AMX Headers
#include "amxxmodule.h"

using namespace std;


vector<string> split(const char* s, const char* delim)
{
	vector<string> result;
	if (s && strlen(s))
	{
		int len = strlen(s);
		char* src = new char[len + 1];
		strcpy(src, s);
		src[len] = '\0';
		char* tokenptr = strtok(src, delim);
		while (tokenptr != NULL)
		{
			string tk = tokenptr;
			result.emplace_back(tk);
			tokenptr = strtok(NULL, delim);
		}
		delete[] src;
	}
	return result;
}

//将 单字节char* 转换为 宽字节 wchar*
inline wchar_t* AnsiToUnicode(const char* szStr)
{
	const int nLen = MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, szStr, -1, NULL, 0);
	if (nLen == 0)
	{
		return NULL;
	}
	wchar_t* pResult = new wchar_t[nLen];
	MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, szStr, -1, pResult, nLen);
	return pResult;
}
//----------------------------------------------------------------------------------
// 将 宽字节wchar_t* 转换 单字节char*
inline char* UnicodeToAnsi(const wchar_t* szStr)
{
	const int nLen = WideCharToMultiByte(CP_ACP, 0, szStr, -1, NULL, 0, NULL, NULL);
	if (nLen == 0)
	{
		return NULL;
	}
	char* pResult = new char[nLen];
	WideCharToMultiByte(CP_ACP, 0, szStr, -1, pResult, nLen, NULL, NULL);
	return pResult;
}

static cell AMX_NATIVE_CALL init_py(AMX* amx, cell* params)
{
	const cell buff_size = params[1];
	int len;
	char* pyhome = MF_GetAmxString(amx, params[2], 0, &len);
	if (len > 0)
	{
		wchar_t* pyhome_w = AnsiToUnicode(pyhome);
		if (pyhome_w != NULL)
		{
			Py_SetPythonHome(pyhome_w);
			delete pyhome_w;
		}
	}
	Py_Initialize();
	char* pyhome_c = UnicodeToAnsi(Py_GetPythonHome());
	if (pyhome_c != NULL)
	{
		if ((cell)strlen(pyhome_c) <= buff_size)
		{
			strcpy(pyhome, pyhome_c);
		}
		delete pyhome_c;
	}
	MF_SetAmxString(amx, params[2], pyhome, buff_size);
	return 1;
}

static cell AMX_NATIVE_CALL get_var(AMX* amx, cell* params)
{
	int len;
	const cell dst_str_len = params[1];
	const char* type = MF_GetAmxString(amx, params[2], 0, &len);
	const char* src_key_str = MF_GetAmxString(amx, params[3], 1, &len);

	PyObject* Py_main = PyImport_AddModule("__main__");
	PyObject* Py_src_obj = PyObject_GetAttrString(Py_main, src_key_str);
	if (Py_src_obj == NULL)
	{
		return -1;
	}
	if (strcmp(type, "i") == 0)
	{
		cell* dst_ptr = MF_GetAmxAddr(amx, params[4]);
		*dst_ptr = static_cast<int>(PyLong_AsLong(Py_src_obj));
	}
	else if (strcmp(type, "d") == 0)
	{
		cell* dst_ptr = MF_GetAmxAddr(amx, params[5]);
		*dst_ptr = amx_ftoc(static_cast<float>(PyFloat_AsDouble(Py_src_obj)));
	}
	else if (strcmp(type, "s") == 0)
	{
		PyObject* Py_src_str = PyUnicode_AsEncodedString(Py_src_obj, "utf-8", "~E~");
		const char* Py_src_bytes = PyBytes_AS_STRING(Py_src_str);
		MF_SetAmxString(amx, params[6], Py_src_bytes, dst_str_len);
	}
	else if (strcmp(type, "[d,d,d]") == 0)
	{
		cell* dst_ptr = MF_GetAmxAddr(amx, params[7]);
		dst_ptr[0] = amx_ftoc(static_cast<float>(PyFloat_AsDouble(PyList_GetItem(Py_src_obj, 0))));
		dst_ptr[1] = amx_ftoc(static_cast<float>(PyFloat_AsDouble(PyList_GetItem(Py_src_obj, 1))));
		dst_ptr[2] = amx_ftoc(static_cast<float>(PyFloat_AsDouble(PyList_GetItem(Py_src_obj, 2))));
	}
	else
	{
		return -1;
	}
	return 1;
}

static cell AMX_NATIVE_CALL eval_py(AMX* amx, cell* params)
{
	int len;
	const char* cmd = MF_GetAmxString(amx, params[1], 0, &len);
	PyRun_SimpleString(cmd);
	return 1;
}

static cell AMX_NATIVE_CALL set_var(AMX* amx, cell* params)
{
	int len;
	const char* type = MF_GetAmxString(amx, params[1], 0, &len);
	const char* src_val_str = MF_GetAmxString(amx, params[2], 1, &len);
	const char* dst_key_str = MF_GetAmxString(amx, params[3], 2, &len);
	PyObject* Py_main = PyImport_AddModule("__main__");
	PyObject* Py_var = Py_BuildValue("");
	if (strcmp(type, "i") == 0)
	{
		const int int_var = atoi(src_val_str);
		Py_var = Py_BuildValue(type, int_var);
	}
	else if (strcmp(type, "d") == 0)
	{
		const double float_var = atof(src_val_str);
		Py_var = Py_BuildValue(type, float_var);
	}
	else if (strcmp(type, "s") == 0)
	{
		Py_var = Py_BuildValue(type, src_val_str);
	}
	else if (strcmp(type, "[d,d,d]") == 0)
	{
		vector<string> src_vec = split(src_val_str, "#");
		const double fx = atof(src_vec.at(0).c_str());
		const double fy = atof(src_vec.at(1).c_str());
		const double fz = atof(src_vec.at(2).c_str());
		Py_var = Py_BuildValue(type, fx, fy, fz);
	}
	else
	{
		return -1;
	}
	PyObject_SetAttrString(Py_main, dst_key_str, Py_var);
	return 1;
}

static cell AMX_NATIVE_CALL exit_py(AMX* amx, cell* params)
{
	Py_Finalize();
	return 1;
}

AMX_NATIVE_INFO py_natives[] = {
	{ "init_py", init_py },
	{ "get_var", get_var },
	{ "eval_py", eval_py },
	{ "set_var", set_var },
	{ "exit_py", exit_py },
	{NULL, NULL}
};

void OnAmxxAttach()
{
	MF_AddNatives(py_natives);
	return;
}

void OnAmxxDetach()
{
	return;
}
