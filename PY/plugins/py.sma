#include <amxmodx>
#include <py>

/*
* 
* Requests & Bugs:
*	1641367382@qq.com
*   https://github.com/AlucardNosferatu
* 
*/

//new InCMD;

public plugin_init()
{
	register_plugin("Sample", "1.0", "Scrooge2029");
	register_concmd("python","python_util")
}



public python_util()
{
	init_py();
	eval_py("a=20291224");
	exit_py();
}


