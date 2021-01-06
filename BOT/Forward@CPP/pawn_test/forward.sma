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
	load_model("Test/Test.ini")
}

public test_output()
{
	new Float:out_class[10]
	new Float:flatten_input[800]
	for(new i=0;i<800;i++)
	{
		if(i<400)
		{
			flatten_input[i]=floatmul(float(i),2.0)
		}
		else
		{
			flatten_input[i]=floatdiv(float(i),2.0)
		}
	}
	new od_count=forward_model(out_class,charsmax(out_class)+1,100,charsmax(flatten_input)+1,flatten_input)
	new Float:total_dims=1.0
	for(new i=0;i<od_count;i++)
	{
		total_dims=floatmul(out_class[i],total_dims)
		server_print("Dim: %f Index: %d DimCount: %d^n",out_class[i],i,od_count)
	}
	new td_int=floatround(total_dims)
	for(new i=od_count;i<od_count+td_int;i++)
	{
		server_print("Value: %f Index: %d ValueCount: %d^n",out_class[i],i,td_int)
	}
}
