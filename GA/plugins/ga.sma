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
	register_concmd("tga","test_ga_loop")

}

public test_ga_loop()
{
	init_task(200,20.0,29.0,12.0,24.0);
	set_task(1.0, "test_ga_once", .flags="b")
}

public test_ga_once()
{
	new ret1;
	new ret2;
	new ret3;
	new ret4;
	test_ga(ret1,ret2,ret3,ret4);
	server_print("Ret:%d %d %d %d",ret1,ret2,ret3,ret4);
}
