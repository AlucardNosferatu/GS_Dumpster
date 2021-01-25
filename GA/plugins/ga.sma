#include <amxmodx>
#include <ga>

/*
* 
* Requests & Bugs:
*	DivinityX@live.se
*   DivinityX.no-ip.org/forum
* 
*/


public plugin_init()
{
	register_plugin("Sample", "1.0", "DivinityX");
	register_concmd("tga","test_ga_2_gen")

}

public test_ga_2_gen()
{
	new ret1;
	new ret2=test_ga("LostXmas",2029,1224,ret1);
	server_print("Ret:%d %d",ret1,ret2);
}