#include <amxmodx>
#include <engine>
#include <py>

/*
* 
* Requests & Bugs:
*	1641367382@qq.com
*   https://github.com/AlucardNosferatu
* 
*/

new bool:InCMD
new UserId;

public plugin_init()
{
	register_plugin("Python Interpreter", "0.1", "Scrooge2029");
	register_concmd("python_test","python_test")
	register_concmd("say","python_util")
	UserId=-1;
	InCMD=false;
}

public python_util(id)
{
	new msg[512]
	read_argv(1, msg, charsmax(msg))
	if(InCMD)
	{
		if(id==UserId)
		{
			if(strcmp(msg,"exit()")==0)
			{
				exit_py()
				UserId=-1;
				InCMD=false;
			}
			else if(contain(msg,"$SET$")!=-1)
			{
				new params[512]
				new param1[128]//$SET$
				new param2[128]//ent_name
				new param3[128]//ent_kv
				new param4[128]//py_var_name
				new param5[128]//type
				params=""
				
				strcat(params,msg,charsmax(msg))
				split(params,param1,charsmax(param1),param2,charsmax(param2),"@#")
				//server_print(param1)
				params=""
				
				strcat(params,param2,charsmax(param2))
				split(params,param2,charsmax(param2),param3,charsmax(param3),"@#")
				//server_print(param2)
				params=""
				
				strcat(params,param3,charsmax(param3))
				split(params,param3,charsmax(param3),param4,charsmax(param4),"@#")
				//server_print(param3)
				params=""
				
				strcat(params,param4,charsmax(param4))
				split(params,param4,charsmax(param4),param5,charsmax(param5),"@#")
				//server_print(param4)
				params=""
				
				new dst_int;
				new Float:dst_fl
				new dst_str[512]
				new Float:dst_vec[3]
				new dst_temp[512]=""
				
				if(strcmp(param5,"i")==0)
				{
					new ent=find_ent_by_tname(0,param2)
					if(ent!=0)
					{
						new kv_index=str_to_num(param3)
						if(kv_index!=0)
						{
							dst_int=entity_get_int(ent,kv_index)
							num_to_str(dst_int,dst_temp,charsmax(dst_temp))
						}
					}
				}
				else if(strcmp(param5,"d")==0)
				{
					new ent=find_ent_by_tname(0,param2)
					if(ent!=0)
					{
						new kv_index=str_to_num(param3)
						if(kv_index!=0)
						{
							dst_fl=entity_get_float(ent,kv_index)
							float_to_str(dst_fl,dst_temp,charsmax(dst_temp))
						}
					}
				}
				else if(strcmp(param5,"s")==0)
				{
					new ent=find_ent_by_tname(0,param2)
					if(ent!=0)
					{
						new kv_index=str_to_num(param3)
						if(kv_index!=0)
						{
							entity_get_string(ent, kv_index, dst_str, charsmax(dst_str))
							strcat(dst_temp,dst_str,charsmax(dst_temp))
						}
					}
				}
				else if(strcmp(param5,"[d,d,d]")==0)
				{
					new ent=find_ent_by_tname(0,param2)
					if(ent!=0)
					{
						new kv_index=str_to_num(param3)
						if(kv_index!=0)
						{
							entity_get_vector(ent, kv_index, dst_vec)
							new Float:x=dst_vec[0]
							new Float:y=dst_vec[1]
							new Float:z=dst_vec[2]
							new fTemp[32]=""
							float_to_str(x,fTemp,charsmax(fTemp))
							strcat(dst_temp,fTemp,charsmax(dst_temp))
							fTemp=""
							strcat(dst_temp,"#",charsmax(dst_temp))
							float_to_str(y,fTemp,charsmax(fTemp))
							strcat(dst_temp,fTemp,charsmax(dst_temp))
							fTemp=""
							strcat(dst_temp,"#",charsmax(dst_temp))
							float_to_str(z,fTemp,charsmax(fTemp))
							strcat(dst_temp,fTemp,charsmax(dst_temp))
							fTemp=""
						}
					}
				}
				else
				{
					server_print("type error!")
				}
				set_var(param5,dst_temp,param4)
			}
			else if(contain(msg,"$GET$")!=-1)
			{
				new params[512]
				new param1[128]//$GET$
				new param2[128]//py_var_name
				new param3[128]//type
				new param4[128]//ent_name
				new param5[128]//ent_kv
				params=""
				
				strcat(params,msg,charsmax(msg))
				split(params,param1,charsmax(param1),param2,charsmax(param2),"@#")
				//server_print(param1)
				params=""
				
				strcat(params,param2,charsmax(param2))
				split(params,param2,charsmax(param2),param3,charsmax(param3),"@#")
				//server_print(param2)
				params=""
				
				strcat(params,param3,charsmax(param3))
				split(params,param3,charsmax(param3),param4,charsmax(param4),"@#")
				//server_print(param3)
				params=""
				
				strcat(params,param4,charsmax(param4))
				split(params,param4,charsmax(param4),param5,charsmax(param5),"@#")
				//server_print(param4)
				params=""
				
				new dst_int;
				new Float:dst_fl
				new dst_str[512]
				new Float:dst_vec[3]
				
				get_var(charsmax(dst_str), param3, param2, dst_int, dst_fl, dst_str, dst_vec);
				
				if(strcmp(param3,"i")==0)
				{
					new ent=find_ent_by_tname(0,param4)
					if(ent!=0)
					{
						new kv_index=str_to_num(param5)
						if(kv_index!=0)
						{
							entity_set_int(ent,kv_index,dst_int)
						}
					}
				}
				else if(strcmp(param3,"d")==0)
				{
					new ent=find_ent_by_tname(0,param4)
					if(ent!=0)
					{
						new kv_index=str_to_num(param5)
						if(kv_index!=0)
						{
							entity_set_float(ent,kv_index,dst_fl)
						}
					}
				}
				else if(strcmp(param3,"s")==0)
				{
					new ent=find_ent_by_tname(0,param4)
					if(ent!=0)
					{
						new kv_index=str_to_num(param5)
						if(kv_index!=0)
						{
							entity_set_string(ent,kv_index,dst_str)
						}
					}
				}
				else if(strcmp(param3,"[d,d,d]")==0)
				{
					new ent=find_ent_by_tname(0,param4)
					if(ent!=0)
					{
						new kv_index=str_to_num(param5)
						if(kv_index!=0)
						{
							entity_set_vector(ent,kv_index,dst_vec)
						}
					}
				}
			}
			else if(contain(msg,"$PRINT$")!=-1)
			{
				new params[512]
				new param1[128]//$GET$
				new param2[128]//py_var_name
				new param3[128]//type

				params=""
				
				strcat(params,msg,charsmax(msg))
				split(params,param1,charsmax(param1),param2,charsmax(param2),"@#")
				//server_print(param1)
				params=""
				
				strcat(params,param2,charsmax(param2))
				split(params,param2,charsmax(param2),param3,charsmax(param3),"@#")
				//server_print(param2)
				params=""
				
				new dst_int;
				new Float:dst_fl
				new dst_str[512]
				new Float:dst_vec[3]
				new dst_temp[512]=""
				
				get_var(charsmax(dst_str), param3, param2, dst_int, dst_fl, dst_str, dst_vec)
				
				if(strcmp(param3,"i")==0)
				{
					num_to_str(dst_int,dst_temp,charsmax(dst_temp))
				}
				else if(strcmp(param3,"d")==0)
				{
					float_to_str(dst_fl,dst_temp,charsmax(dst_temp))
				}
				else if(strcmp(param3,"s")==0)
				{
					strcat(dst_temp,dst_str,charsmax(dst_temp))
				}
				else if(strcmp(param3,"[d,d,d]")==0)
				{
					
					new Float:x=dst_vec[0]
					new Float:y=dst_vec[1]
					new Float:z=dst_vec[2]
					
					new fTemp[32]=""
					
					float_to_str(x,fTemp,charsmax(fTemp))
					strcat(dst_temp,fTemp,charsmax(dst_temp))
					fTemp=""
					
					strcat(dst_temp,"#",charsmax(dst_temp))
					
					float_to_str(y,fTemp,charsmax(fTemp))
					strcat(dst_temp,fTemp,charsmax(dst_temp))
					fTemp=""
					
					strcat(dst_temp,"#",charsmax(dst_temp))
					
					float_to_str(z,fTemp,charsmax(fTemp))
					strcat(dst_temp,fTemp,charsmax(dst_temp))
					fTemp=""
				}
				else
				{
					server_print("type error!")
				}
				server_print("Value:%s",dst_temp)
			}
			else
			{
				eval_py(msg)
			}
		}
		else
		{
			server_print("Py Interpreter is in use now.")
		}
	}
	else
	{
		if(strcmp(msg,"python")==0)
		{
			UserId=id
			InCMD=true
			init_py()
		}
	}
	
}

public python_test()
{
	init_py();
	
	eval_py("a=2029");
	eval_py("b=a/100");
	eval_py("c=str(a)");
	eval_py("d=[b,2*b,3*b]")
	
	new dst_int;
	new Float:dst_fl
	new dst_str[32]
	new Float:dst_vec[3]
	
	get_var(charsmax(dst_str), "i", "a", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "d", "b", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "s", "c", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "[d,d,d]", "d", dst_int, dst_fl, dst_str, dst_vec);
	
	server_print("a=%d",dst_int)
	server_print("b=%f",dst_fl)
	server_print("c=%s",dst_str)
	server_print("d=%f %f %f",dst_vec[0],dst_vec[1],dst_vec[2])
	
	set_var("i","1224","a")
	set_var("d","42.21","b")
	set_var("s","I love Carol","c")
	set_var("[d,d,d]","20.29#12.24#52.10","d")
	
	get_var(charsmax(dst_str), "i", "a", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "d", "b", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "s", "c", dst_int, dst_fl, dst_str, dst_vec);
	get_var(charsmax(dst_str), "[d,d,d]", "d", dst_int, dst_fl, dst_str, dst_vec);
	
	server_print("a=%d",dst_int)
	server_print("b=%f",dst_fl)
	server_print("c=%s",dst_str)
	server_print("d=%f %f %f",dst_vec[0],dst_vec[1],dst_vec[2])
	
	exit_py();
}


