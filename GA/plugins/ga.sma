#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <engine>
#include <fun>
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
	register_concmd("ecp","SpawnSendEnt")
	RegisterHam(Ham_Spawn, "info_target", "CheckRecvEnt", 1);  
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
	new Float:score=(aSqr+bSqr+cSqr+dSqr);
	return score
}

public SpawnSendEnt()
{
	new ent_index=create_entity("info_target")
	entity_set_string(ent_index, EV_SZ_targetname, "AMXX_GA_SEND")
	entity_set_float(ent_index, EV_FL_fuser1, 20.29)
	spawn(ent_index)
	ent_index=find_ent_by_tname(0,"AMXX_GA_SEND")
	new Float:test=entity_get_float(ent_index, EV_FL_fuser1)
	server_print("Find value %f",test)
}

public CheckRecvEnt(Ent)
{
	server_print("Detected Entity Spawned")
	if (pev_valid(Ent))
	{
		new targetname[32]
		pev(Ent, pev_targetname, targetname, charsmax(targetname))
		if (equal(targetname, "AS_RCBOT_SEND"))
		{
			new Float:test1=entity_get_float(Ent, EV_FL_fuser1)
			new Float:test2=entity_get_float(Ent, EV_FL_fuser2)
			new Float:test3=entity_get_float(Ent, EV_FL_fuser3)
			new Float:test4=entity_get_float(Ent, EV_FL_fuser4)
			server_print("Recv value %f %f %f %f",test1,test2,test3,test4)
		}
	}
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/
