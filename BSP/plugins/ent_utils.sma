/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <ent_utils>

#define PLUGIN "Test Ripent"
#define VERSION "0.0"
#define AUTHOR "Scrooge"


public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_concmd("ent_export","ent_export")
}

public ent_export()
{
	new ret1
	new ret2=test_read_ent("toonrun1.bsp", 2029, 1224, ret1)
	server_print("Test Module: %d, %d",ret1,ret2)
}
