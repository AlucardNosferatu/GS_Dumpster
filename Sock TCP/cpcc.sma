#include <amxmodx>
#include <sockets>

new s, error, data[256];

public plugin_init(){
	
	register_plugin("Cell Phone Controlled Crowbar","0.0","Relaxing/Scrooge")
	register_srvcmd("set_phone", "set_phone");
}

public set_phone(){
	new LOCAL[32]
	new PORT_STR[32]
	new PORT
	read_argv(1, LOCAL, charsmax(LOCAL));
	read_argv(2, PORT_STR, charsmax(PORT_STR));
	PORT=str_to_num(PORT_STR)
	server_print("Now configure CPCC")
	s = socket_open(LOCAL, PORT, SOCKET_TCP, error);
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
		}
	}
}
