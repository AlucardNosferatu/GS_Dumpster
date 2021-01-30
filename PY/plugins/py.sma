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
	eval_py("b='I love Carol!'");
	new dst_int;
	new Float:dst_fl
	new dst_str[32]
	new Float:dst_vec[3]
	get_var(charsmax(dst_str), "i", "a", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "s", "b", dst_int, dst_fl, dst_str, dst_vec);
	server_print("a=%d",dst_int)
	server_print("b=%s",dst_str)
	exit_py();
}


