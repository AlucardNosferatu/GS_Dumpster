#include <amxmodx>
#include <sockets>
#include <fun>

new response[32][32]
new send_dmg[32]
new dmg[32]
new IP[32][32]
new PORT[32]
new sockets[32]
new data_buff[32][128]
new CanUse[32]
new reg_players[32]
new reg_pCount



public plugin_init()
{
	register_plugin("Cell Phone Controlled Crowbar","0.0","Relaxing/Scrooge")
	register_concmd("set_p", "set_phone");
	register_concmd("stop_p", "stop_phone");
	register_concmd("start_p", "start_phone");
	init_global()
	register_event("Damage","player_take_dmg","b","2>0")
	set_task(0.3, "scan_sockets", .id=0, .flags="b");
	set_task(0.3, "check_buff", .id=1, .flags="b");
}

public player_take_dmg(id)
{
	new damage = read_data(2)
	if(damage>0)
	{
		new result=ArrayFindValue(reg_players,id,charsmax(reg_players))
		if(result!=-1)
		{
			dmg[result]=dmg[result]+damage
			send_dmg[result]=true
	
		}		
	}
}

public scan_sockets()
{
	for(new i=0;i<=charsmax(CanUse);i++)
	{
		if(CanUse[i]==1)
		{
			socket_recv(sockets[i],data_buff[i],charsmax(data_buff[]))
			if(send_dmg[i])
			{
				new dStr[8]
				num_to_str(dmg[i],dStr,charsmax(dStr))
				response[i]="DMG#"
				strcat(response[i],dStr,charsmax(response[]))
				strcat(response[i],"^n",charsmax(response[]))
				server_print("Now send buffer: %s",response[i])
			}
			
			socket_send(sockets[i],response[i],charsmax(response[]))
			if(send_dmg[i])
			{
				send_dmg[i]=false
				dmg[i]=0
				response[i]="recv^n"
			}
		}
	}
}




public get_health_increment(Float:xf,Float:yf,Float:zf)
{
	if(xf<0)
	{
		xf=-xf
	}
	if(yf<0)
	{
		yf=-yf
	}
	if(zf<0)
	{
		zf=-zf
	}
	new Float:incr=xf
	incr=incr+yf
	incr=incr+zf
	incr=floatdiv(incr,2.5)
	new incr_int=floatround(incr)
	return incr_int
}

public check_buff()
{
	for(new i=0;i<=charsmax(CanUse);i++)
	{
		if(CanUse[i]==1)
		{
			server_print("Now read buffer: %s",data_buff[i])
			if(strlen(data_buff[i])>0)
			{
				new temp[128]
				new xstr[32]
				new ystr[32]
				new zstr[32]
				split(data_buff[i],xstr,charsmax(xstr),temp,charsmax(temp),"#")
				split(temp,ystr,charsmax(ystr),zstr,charsmax(zstr),"#")
				new Float:x=str_to_float(xstr)
				new Float:y=str_to_float(ystr)
				new Float:z=str_to_float(zstr)
				if(x>20.0 || y>20.0 || z>20.0 || x<-20.0 || y<-20.0 || z<-20.0)
				{
					new health=get_user_health(reg_players[i])
					new increment=get_health_increment(x,y,z)
					set_user_health(reg_players[i],health+increment);
				}
			}
			
		}
	}
}

public init_global()
{
	for(new i=0;i<=charsmax(IP);i++)
	{
		IP[i]=""
	}
	for(new i=0;i<=charsmax(response);i++)
	{
		response[i]="recv^n"
	}
	arrayset(dmg,0,charsmax(dmg))
	arrayset(PORT,54500,charsmax(PORT))
	arrayset(sockets,-1,charsmax(sockets))
	arrayset(CanUse,0,charsmax(CanUse))
	arrayset(send_dmg,false,charsmax(send_dmg))
	arrayset(reg_players,-1,charsmax(reg_players))
	reg_pCount=0
	
}

public ArrayFindValue(array[], value, size)
{
	for(new i=0;i<=size;i++)
	{
		if(array[i]==value)
		{
			return i
		}
	}
	return -1
}

public set_phone(const id)
{
	new result=ArrayFindValue(reg_players,id,charsmax(reg_players))
	
	new TEMP_IP[32]
	new PORT_STR[32]
	read_argv(1, TEMP_IP, charsmax(TEMP_IP));
	read_argv(2, PORT_STR, charsmax(PORT_STR));
	if(result==-1)
	{
	//no reg yet
		if(reg_pCount<32)
		{
			client_print(id,print_console,"set start")
			server_print("%d: set start", id)
			IP[reg_pCount]=""
			strcat(IP[reg_pCount],TEMP_IP,charsmax(IP[]))
			PORT[reg_pCount]=str_to_num(PORT_STR)
			reg_players[reg_pCount]=id
			reg_pCount+=1
			
		}
		else
		{
			client_print(id,print_console,"id slots are full")
			server_print("%d: id slots are full", id)
		}
	}
	else
	{
	//already reg
		client_print(id,print_console,"set start")
		server_print("%d: set start", id)
		IP[result]=""
		strcat(IP[result],TEMP_IP,charsmax(IP[]))
		PORT[result]=str_to_num(PORT_STR)
	}
}

public stop_phone(const id)
{
	new result=ArrayFindValue(reg_players,id,charsmax(reg_players))
	
	if(result==-1)
	{
	//no reg yet
		client_print(id,print_console,"haven't set yet")
		server_print("%d: haven't set yet", id)
	}
	else
	{
		socket_close(sockets[result])
		CanUse[result]=0
	}
}

public start_phone(const id)
{
	new result=ArrayFindValue(reg_players,id,charsmax(reg_players))
	
	if(result==-1)
	{
	//no reg yet
		client_print(id,print_console,"haven't set yet")
		server_print("%d: haven't set yet", id)
	}
	else
	{
		new error
		sockets[result]=socket_open(IP[result],PORT[result],SOCKET_TCP,error)
		if (!error){
			client_print(id,print_console,"No error, set task for the sock now")
			server_print("%d: No error, set task for the sock now",id)
			CanUse[result]=1
			new data[32] = "connected^n";
			socket_send(sockets[result], data, charsmax(data));
		}
		else
		{
			client_print(id,print_console,"Error occurs when configuring CPCC^nError Code: %d", error)
			server_print("%d: Error occurs when configuring CPCC^nError Code: %d", id, error)
			CanUse[result]=0
		}

	}
}
