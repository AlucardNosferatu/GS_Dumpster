/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <forward>

#define PLUGIN "Test Forward"
#define VERSION "0.0"
#define AUTHOR "Scrooge"


public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_concmd("l_model","test_load")
	register_concmd("f_model","test_output")
}

public test_load()
{
	load_model("TTD/TTD.ini")
}

public test_output()
{
	new Float:out_class[8]
	new Float:flatten_input[16]
	for(new i=0;i<16;i++)
	{
		flatten_input[i]=0.0
	}
	new od_count=forward_model(out_class,charsmax(out_class)+1,1,charsmax(flatten_input)+1,flatten_input)
	new Float:total_dims=1.0
	for(new i=0;i<od_count;i++)
	{
		total_dims=floatmul(out_class[i],total_dims)
		server_print("Dim: %f Index: %d DimCount: %d^n",out_class[i],i,od_count)
	}
	new td_int=floatround(total_dims)
	for(new i=od_count;i<charsmax(out_class)+1;i++)
	{
		server_print("Value: %f Index: %d ValueCount: %d AvailableSize: %d^n",out_class[i],i,td_int,charsmax(out_class)+1-od_count)
	}
}