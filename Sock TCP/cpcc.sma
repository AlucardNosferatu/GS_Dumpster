#include <amxmodx>
#include <sockets>
#include <fun>

new IP[32]
new PORT_STR[32]
new PORT
new reg_players[32]
new reg_pCount
new s[32]
new error, data[256];
new Float:x[32]
new Float:y[32]
new Float:z[32]

public plugin_init()
{
	register_plugin("Cell Phone Controlled Crowbar","0.0","Relaxing/Scrooge")
	reg_pCount=0
	register_concmd("set_phone", "id2socket");
	//register_srvcmd("purge_sock","purge_sock")
	
}

public ArrayFindValue(array[], value)
{
	for(new i=0;i<charsmax(array);i++)
	{
		if(array[i]==value)
		{
			return i
		}
	}
	return -1
}

public id2socket(const id)
{
	new result=ArrayFindValue(reg_players,id)
	
	if(result==-1)
	{
		if(reg_pCount<32)
		{
			read_argv(1, IP, charsmax(IP));
			read_argv(2, PORT_STR, charsmax(PORT_STR));
			PORT=str_to_num(PORT_STR)
			reg_players[reg_pCount]=id
			set_socket(reg_pCount,id)
			reg_pCount+=1
			set_task(0.1, "get_data", .flags="b");
		}
		else
		{
			client_print(id,print_console,"id slots are full")
			server_print("%d: id slots are full", id)
		}
	}
	else
	{
		client_print(id,print_console,"already set, update socket")
		server_print("%d: already set, update socket", id)
		read_argv(1, IP, charsmax(IP));
		read_argv(2, PORT_STR, charsmax(PORT_STR));
		PORT=str_to_num(PORT_STR)
		socket_close(s[result])
		set_socket(result,id)
	}
}

public set_socket(s_index,uid)
{	
	client_print(uid,print_console,"Now configure CPCC")
	server_print("%d: Now configure CPCC", uid)
	client_print(uid,print_console,IP)
	server_print("%d: %s", uid, IP)
	client_print(uid,print_console,PORT_STR)
	server_print("%d: %s", uid, PORT_STR)
	s[s_index] = socket_open(IP, PORT, SOCKET_TCP, error);
	if (!error){
		client_print(uid,print_console,"No error, set task for the sock now")
		server_print("%d: No error, set task for the sock now",uid)
		data = "connected";
		socket_send(s[s_index], data, charsmax(data));
	}
	else
	{
		client_print(uid,print_console,"Error occurs when configuring CPCC^nError Code: %d", error)
		server_print("%d: Error occurs when configuring CPCC^nError Code: %d", uid, error)
	}
}

public get_data(){
	for(new i=0;i<32;i++)
	{
		//server_print("now for %d", reg_players[i])
		if(is_user_connected(reg_players[i])==1 || reg_players[i]==0)
		{
			if (socket_is_readable(s[i]))
			{
				socket_recv(s[i], data, charsmax(data))
				if(strlen(data)>0)
				{
					//client_print(reg_players[i],print_console,data)
					//server_print("%d: %s", reg_players[i], data)
					new temp[256]
					new xstr[32]
					new ystr[32]
					new zstr[32]
					split(data,xstr,charsmax(xstr),temp,charsmax(temp),"#")
					split(temp,ystr,charsmax(ystr),zstr,charsmax(zstr),"#")
					x[i]=str_to_float(xstr)
					y[i]=str_to_float(ystr)
					z[i]=str_to_float(zstr)
					if(x[i]>20.0 || y[i]>20.0 || z[i]>20.0 || x[i]<-20.0 || y[i]<-20.0 || z[i]<-20.0)
					{
						client_print(reg_players[i],print_console,"^nX: %f",x[i])
						server_print("^n%d: X: %f", reg_players[i], x[i])
						client_print(reg_players[i],print_console,"Y: %f",y[i])
						server_print("%d: Y: %f", reg_players[i], y[i])
						client_print(reg_players[i],print_console,"Z: %f",y[i])
						server_print("%d: Z: %f", reg_players[i], y[i])		
						new health=get_user_health(reg_players[i])
						set_user_health(reg_players[i],health+20);
					}
				}
			}
		}
	}
}
