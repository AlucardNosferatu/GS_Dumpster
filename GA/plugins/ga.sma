#include <amxmodx>
#include <ga>

/*
* 
* Requests & Bugs:
*	DivinityX@live.se
*   DivinityX.no-ip.org/forum
* 
*/
new Float:ind[4];
new Float:scores[200];

public plugin_init()
{
	register_plugin("Sample", "1.0", "Scrooge2029");
	register_concmd("tga","test_ga_loop")
	register_concmd("col","test_ga_once")
	register_concmd("eva","evaluation")

}

public test_ga_loop()
{
	init_task(200);
	set_task(1.0, "test_ga_once", .flags="b")
}

public test_ga_once()
{
	for(new i=0;i<200;i++)
	{
		get_individual(i,ind,4);
		scores[i]=process_score(ind,i)
	}
	evaluation();
}

public evaluation()
{
	evaluate_gen(ind,4,scores,200);
	update_gen();
	server_print("Best:%f %f %f %f",ind[0],ind[1],ind[2],ind[3]);
	server_print("  ");
	server_print("  ");
}

public Float:process_score(Float:ind[],i)
{
	new Float:aSqr=floatmul(ind[0]-20.0,ind[0]-20.0);
	new Float:bSqr=floatmul(ind[1]-29.0,ind[1]-29.0);
	new Float:cSqr=floatmul(ind[2]-12.0,ind[2]-12.0);
	new Float:dSqr=floatmul(ind[3]-24.0,ind[3]-24.0);
	new Float:score=-(aSqr+bSqr+cSqr+dSqr);
	//server_print("Score:%d %f abcd:%f %f %f %f",i,score,floatsub(ind[0],20.0),floatsub(ind[1],29.0),floatsub(ind[2],12.0),floatsub(ind[3],24.0));
	return score
}
