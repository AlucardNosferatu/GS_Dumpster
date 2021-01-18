#include <amxmodx>
#include <ExecuteX>
#include <engine>
#include <json>

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
	register_concmd("rr","run_ripent")
	register_concmd("aae","add_an_ent")

}

public run_ripent()
{
	Execute(".\svencoop\maps\Ripent.exe", ".\svencoop\maps\stadium4.bsp -export -parse");
}

public add_an_ent()
{
	new cid=get_user_index("Scrooge")
	if(cid!=0)
	{
		new origin[3]
		get_user_origin(cid, origin);
		server_print("X:%f Y:%f Z:%f \n",origin[0],origin[1],origin[2])
		new ent_index=create_entity("weapon_sporelauncher")
		entity_set_string(ent_index, EV_SZ_targetname, "AMXX_TEST_SL")
		new Float:origin_f[3]
		origin_f[0]=float(origin[0])
		origin_f[1]=float(origin[1])
		origin_f[2]=float(origin[2])
		entity_set_vector(ent_index, EV_VEC_origin, origin_f);
	}	
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/
