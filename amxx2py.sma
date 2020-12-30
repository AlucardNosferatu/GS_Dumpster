#include <amxmodx>
#include <sockets>
#include <hamsandwich>

#define PORT 54500
#define DEFAULT_LOCAL "127.0.0.1"

new s, error, data[256];

public plugin_init(){
	
	register_plugin("Python Interface","0.0","Relaxing/Scrooge")
	register_srvcmd("cfg_sock", "retry_cfg");
	register_srvcmd("send", "srvcmd_send");
}

public plugin_cfg(){
	server_print("Now configure AMXX2PY")
	s = socket_open(DEFAULT_LOCAL, PORT, SOCKET_TCP, error);
	if (!error){
		server_print("No error, set task for the sock now")
		set_task(0.1, "get_data", .flags="b");
		set_task(1.0, "feed_dicks", .flags="b");
		data = "connected";
		socket_send(s, data, charsmax(data));       
	}
	else
	{
		server_print("Error occurs when configuring AMXX2PY")
		new errstr[32]
		num_to_str(error,errstr,charsmax(errstr))
		server_print(errstr)
	}
}

public retry_cfg(){
	new LOCAL[32]
	read_args(LOCAL, charsmax(LOCAL));
	server_print("Now configure AMXX2PY")
	s = socket_open(LOCAL, PORT, SOCKET_TCP, error);
	if (!error){
		server_print("No error, set task for the sock now")
		set_task(0.1, "get_data", .flags="b");
		set_task(1.0, "feed_dicks", .flags="b");
		data = "connected";
		socket_send(s, data, charsmax(data));       
	}
	else
	{
		server_print("Error occurs when configuring AMXX2PY")
		new errstr[32]
		num_to_str(error,errstr,charsmax(errstr))
		server_print(errstr)
	}
}

public srvcmd_send(){
	new args[32];
	read_args(args, charsmax(args));
	server_print(args)
	socket_send(s, args, charsmax(args));
}

public get_data(){
	if (socket_is_readable(s))
	{
		socket_recv(s, data, charsmax(data))
		server_print(data)
	}
}

public feed_dicks()
{
	new dick[32]
	server_print("Make server sucks dicks")
	dick="Hey You Suck Dicks?"
	socket_send(s, dick, charsmax(dick))
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/
