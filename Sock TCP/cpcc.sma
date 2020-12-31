#include <amxmodx>
#include <sockets>

new IP[32][32]
new PORT[32]
new sockets[32]
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
	set_task(0.1, "scan_sockets", .id=0, .flags="b");
}

public scan_sockets()
{
	for(new i=0;i<charsmax(CanUse);i++)
	{
		if(CanUse[i]==1)
		{
			new data_buff[512]
			socket_recv(sockets[i],data_buff,charsmax(data_buff))
			if(strlen(data_buff)>0)
			{
				client_print(reg_players[i],print_console,data_buff)
				server_print(data_buff)
				new ack[8]="recv^n"
				socket_send(sockets[i],ack,charsmax(ack))
			}
		}
	}
}

public init_global()
{
	for(new i=0;i<charsmax(IP);i++)
	{
		IP[i]=""
	}
	arrayset(PORT,54500,charsmax(PORT))
	arrayset(sockets,-1,charsmax(sockets))
	arrayset(CanUse,0,charsmax(CanUse))
	arrayset(reg_players,-1,charsmax(reg_players))
	reg_pCount=0
	
}

public ArrayFindValue(array[], value, size)
{
	for(new i=0;i<size;i++)
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
