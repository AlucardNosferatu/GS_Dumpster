#include <amxmodx>
#include <fakemeta>


public plugin_init(){
	
	register_plugin("Princess Of Deadpool","0.0","Scrooge")
	register_srvcmd("cfg_sock", "retry_cfg");
}


public plugin_cfg(){
	server_print("Now configure AMXX2PY")

	set_task(1.0, "get_buff", .flags="b")
}

public get_buff()
{	
	new cid=get_user_index("Carol")
	if(cid!=0)
	{
		new hp=get_user_health(cid)
		if(hp<=300)
		{
			engclient_cmd(cid, ".fuckfuck")
		}
	}
}