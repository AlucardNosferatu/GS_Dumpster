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
	
	eval_py("a=2029");
	eval_py("b=a/100");
	eval_py("c=str(a)");
	eval_py("d=[b,2*b,3*b]")
	
	new dst_int;
	new Float:dst_fl
	new dst_str[32]
	new Float:dst_vec[3]
	
	get_var(charsmax(dst_str), "i", "a", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "d", "b", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "s", "c", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "[d,d,d]", "d", dst_int, dst_fl, dst_str, dst_vec);
	
	server_print("a=%d",dst_int)
	server_print("b=%f",dst_fl)
	server_print("c=%s",dst_str)
	server_print("d=%f %f %f",dst_vec[0],dst_vec[1],dst_vec[2])
	
	set_var("i","1224","a")
	set_var("d","42.21","b")
	set_var("s","I love Carol","c")
	set_var("[d,d,d]","20.29#12.24#52.10","d")
	
	get_var(charsmax(dst_str), "i", "a", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "d", "b", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "s", "c", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "[d,d,d]", "d", dst_int, dst_fl, dst_str, dst_vec);
	
	server_print("a=%d",dst_int)
	server_print("b=%f",dst_fl)
	server_print("c=%s",dst_str)
	server_print("d=%f %f %f",dst_vec[0],dst_vec[1],dst_vec[2])
	
	exit_py();
}


