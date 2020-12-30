#include <amxmodx>
#include <sockets>
#include <fakemeta>

#define PORT 54500
#define DEFAULT_LOCAL "127.0.0.1"

new s, error, data[256];
new data_packet[640]
new counter

public plugin_init(){
	
	register_plugin("Python Interface","0.0","Relaxing/Scrooge")
	register_srvcmd("cfg_sock", "retry_cfg");
	register_srvcmd("send", "srvcmd_send");
	counter=0
	data_packet=""
}


public plugin_cfg(){
	server_print("Now configure AMXX2PY")
	s = socket_open(DEFAULT_LOCAL, PORT, SOCKET_TCP, error);
	if (!error){
		server_print("No error, set task for the sock now")
		//set_task(1.0, "get_data", .flags="b");
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
		if(strlen(data)>0)
		{
			server_print(data)
		}
	}
}

public feed_dicks()
{	
	new cid=get_user_index("Scrooge")
	if(cid!=0)
	{
		new hp=get_user_health(cid)
		//server_print("health is %d",hp)
		if(hp<=300)
		{
			//server_print("should say dirtywords")
			engclient_cmd(cid, ".fuckfuck")
		}
		new float:origin[3]
		pev(cid, pev_origin, origin)
		new output_text[32]
		
		format(output_text,charsmax(output_text),"X:%.2f,Y:%.2f,Z:%.2f", origin[0], origin[1], origin[2])
		counter+=1
		strcat(data_packet,output_text,charsmax(data_packet))
		strcat(data_packet,"^n",charsmax(data_packet))
		if(counter==20)
		{
			counter=0
			socket_send(s, data_packet, charsmax(data_packet))
			data_packet=""
		}
		
	}
}
