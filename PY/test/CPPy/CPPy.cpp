// CPPy.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>
#include <windows.h>
#include <Python.h>

struct amxx_module_info_s
{
	const char* name;
	const char* author;
	const char* version;
	int reload;				// reload on mapchange when nonzero
	const char* logtag;		// added in version 2
	const char* library;	// added in version 4
	const char* libclass;	// added in version 4
};


int main()
{
	//Py_Initialize();
	//if (!Py_IsInitialized()) {
	//	return -1;
	//}
	//PyRun_SimpleString("print('Yeah')");

	typedef int (*_pQ)(int* interfaceVersion, amxx_module_info_s* moduleInfo);

	HINSTANCE hDll = LoadLibraryA("py_amxx.dll");
	int nParam1 = 4;
	amxx_module_info_s* nParam2 = new amxx_module_info_s();
	_pQ pQ = (_pQ)GetProcAddress(hDll, "AMXX_Query");
	int ret = pQ(&nParam1, nParam2);
	std::cout << ret << std::endl;
	FreeLibrary(hDll);
	system("pause");

	std::cout << "Hello World!\n";
}

// 运行程序: Ctrl + F5 或调试 >“开始执行(不调试)”菜单
// 调试程序: F5 或调试 >“开始调试”菜单

// 入门使用技巧: 
//   1. 使用解决方案资源管理器窗口添加/管理文件
//   2. 使用团队资源管理器窗口连接到源代码管理
//   3. 使用输出窗口查看生成输出和其他消息
//   4. 使用错误列表窗口查看错误
//   5. 转到“项目”>“添加新项”以创建新的代码文件，或转到“项目”>“添加现有项”以将现有代码文件添加到项目
//   6. 将来，若要再次打开此项目，请转到“文件”>“打开”>“项目”并选择 .sln 文件
