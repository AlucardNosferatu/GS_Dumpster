#include <amxmodx>
#include <sockets>

new IP[32]
new PORT_STR[32]
new PORT
new s, error, data[256];
new temp[256]
new xstr[32]
new ystr[32]
new zstr[32]
new x,prev_x
new y,prev_y
new z,prev_z

public plugin_init(){
	
	register_plugin("Cell Phone Controlled Crowbar","0.0","Relaxing/Scrooge")
	register_srvcmd("set_phone", "set_phone");
}

public set_phone(){
	prev_x=0
	prev_y=0
	prev_z=0
	read_argv(1, IP, charsmax(IP));
	read_argv(2, PORT_STR, charsmax(PORT_STR));
	PORT=str_to_num(PORT_STR)
	server_print("Now configure CPCC")
	server_print(IP)
	server_print(PORT_STR)
	s = socket_open(IP, PORT, SOCKET_TCP, error);
	if (!error){
		server_print("No error, set task for the sock now")
		set_task(0.1, "get_data", .flags="b");
		data = "connected";
		socket_send(s, data, charsmax(data));       
	}
	else
	{
		server_print("Error occurs when configuring CPCC^nError Code: %d",error)
	}
}

public get_data(){
	if (socket_is_readable(s))
	{
		socket_recv(s, data, charsmax(data))
		if(strlen(data)>0)
		{
			server_print(data)
			split(data,xstr,charsmax(xstr),temp,charsmax(temp),"#")
			split(temp,ystr,charsmax(ystr),zstr,charsmax(zstr),"#")
			x=str_to_float(xstr)
			y=str_to_float(ystr)
			z=str_to_float(zstr)
			
			
		}
	}
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/
