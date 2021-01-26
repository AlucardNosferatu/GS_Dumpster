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
	register_plugin("Sample", "1.0", "Scrooge2029");
	register_concmd("tga","test_ga_loop")

}

public test_ga_loop()
{
	init_task(200);
	set_task(1.0, "test_ga_once", .flags="b")
}

public test_ga_once()
{
	new Float:ind[4];
	new Float:scores[200];
	for(new i=0;i<200;i++)
	{
		get_individual(i,ind,4);
		new Float:aSqr=floatpower(ind[0]-20.0,2.0);
		new Float:bSqr=floatpower(ind[1]-29.0,2.0);
		new Float:cSqr=floatpower(ind[2]-12.0,2.0);
		new Float:dSqr=floatpower(ind[3]-24.0,2.0);
		server_print("Score:%f %f %f %f",aSqr,bSqr,cSqr,dSqr);
		scores[i]=(-(aSqr+bSqr+cSqr+dSqr));
	}
	evaluate_gen(ind,4,scores,200);
	server_print("Best:%d %d %d %d",ret1,ret2,ret3,ret4);
	
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/
