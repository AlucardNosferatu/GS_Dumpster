#include <amxmodx>
#include <ExecuteX>

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
}

public run_ripent()
{
	
	Execute(".\svencoop\maps\5minutes_b1_motd.txt");
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/
