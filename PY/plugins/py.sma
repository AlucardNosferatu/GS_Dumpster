#include <amxmodx>
#include <py>

/*
* 
* Requests & Bugs:
*	DivinityX@live.se
*   DivinityX.no-ip.org/forum
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
	server_print("I init, I exit.");
	exit_py();
}


