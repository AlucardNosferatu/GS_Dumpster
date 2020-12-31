#include <amxmodx>
#include <sockets>

new IP[32]
new PORT_STR[32]
new PORT
new s[32]
new users[32]
new error, data[256];
new temp[256]
new xstr[32]
new ystr[32]
new zstr[32]
new x
new y
new z

public plugin_init()
{
	register_plugin("Cell Phone Controlled Crowbar","0.0","Relaxing/Scrooge")
	register_clcmd("set_phone", "set_phone");
}

public set_phone(const id)
{
	
	read_argv(1, IP, charsmax(IP));
	read_argv(2, PORT_STR, charsmax(PORT_STR));
	PORT=str_to_num(PORT_STR)
	client_print(id,print_console,"Now configure CPCC")
	client_print(id,print_console,IP)
	client_print(id,print_console,PORT_STR)
	s = socket_open(IP, PORT, SOCKET_TCP, error);
	if (!error){
		client_print(id,print_console,"No error, set task for the sock now")
		set_task(0.1, "get_data", .flags="b");
		data = "connected";
		socket_send(s, data, charsmax(data));
	}
	else
	{
		client_print(id,print_console,"Error occurs when configuring CPCC^nError Code: %d",error)
	}
}

public get_data(){
	if (socket_is_readable(s))
	{
		socket_recv(s, data, charsmax(data))
		if(strlen(data)>0)
		{
			client_print(id,print_console,data)
			split(data,xstr,charsmax(xstr),temp,charsmax(temp),"#")
			split(temp,ystr,charsmax(ystr),zstr,charsmax(zstr),"#")
			x=str_to_float(xstr)
			y=str_to_float(ystr)
			z=str_to_float(zstr)
			new dmg=calculate_damage(x,y,z)
			
		}
	}
}

public calculate_damage(x,y,z)
{
	new damage=x*x+y*y+z*z
	return damage
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/
