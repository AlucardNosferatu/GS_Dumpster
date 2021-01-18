#include <amxmodx>
#include <ExecuteX>
#include <engine>
#include <json>
#include <fun>

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
	register_clcmd("aae","add_an_ent")

}

public run_ripent()
{
	Execute(".\svencoop\maps\Ripent.exe", ".\svencoop\maps\stadium4.bsp -export -parse");
}

public add_an_ent(id)
{
	new end[3]
	new origin[3]
	get_user_origin(id, end, 3)
	get_user_origin(id, origin)
	end[0]=origin[0]+((end[0]-origin[0])/3)
	end[1]=origin[1]+((end[1]-origin[1])/3)
	end[2]=origin[2]+((end[2]-origin[2])/3)
	end[2]=end[2]+100
	set_user_origin(id, end)
	client_print(id,print_console,"X:%d Y:%d Z:%d",end[0],end[1],end[2])
	new ent_index=create_entity("weapon_9mmAR")
	client_print(id,print_console,"EntIndex:%d ",ent_index)
	entity_set_string(ent_index, EV_SZ_targetname, "AMXX_TEST_SL")
	new Float:origin_f[3]
	origin_f[0]=float(end[0])
	origin_f[1]=float(end[1])
	origin_f[2]=float(end[2])
	client_print(id,print_console,"X:%f Y:%f Z:%f",origin_f[0],origin_f[1],origin_f[2])
	entity_set_vector(ent_index, EV_VEC_origin, origin_f);
	entity_set_vector(ent_index, EV_VEC_oldorigin, origin_f);
}
