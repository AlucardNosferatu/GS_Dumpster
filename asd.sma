#include <amxmodx>
#include <amxmisc>
#include <curl>

#define CURL_BUFFER_SIZE 512

new Fname[32]

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
		curl_file(params)
	}
}

public reload_as()
{
	new text[128]
	text=""
	strcat(text,"^"plugin^"{^n^"name^" ^"",128)
	strcat(text,Fname,128)
	strcat(text,"^"^n^"script^" ^"",128)
	strcat(text,Fname,128)
	strcat(text,"^"^n}^n^n}",128)
	new pList=fopen("default_plugins.txt","wt")
	fseek(pList, 0, SEEK_END)
	new LineNo=ftell(pList)
	new LN[32]
	num_to_str(LineNo,LN,32)
	server_cmd(LN)
	fseek(pList, -1, SEEK_CUR)
	LineNo=ftell(pList)
	num_to_str(LineNo,LN,32)
	server_cmd(LN)
	fputs(pList, text)
	fclose(pList)
	//server_cmd("as_reloadplugins")
}

public curl_file(input_params[])
{
	new params[512]
	new param1[64]
	new param2[64]
	new param3[64]
	new param4[64]
	new param5[64]
	params=""
	strcat(params,input_params,512)
	split(params,param1,64,param2,64,":")
	params=""
	strcat(params,param2,64)
	split(params,param2,64,param3,64,":")
	params=""
	strcat(params,param3,64)
	split(params,param3,64,param4,64,":")
	params=""
	strcat(params,param4,64)
	split(params,param4,64,param5,64,"->")
	Fname=""
	strcat(Fname,param5,64)
	
	new url[512]="https://gitee.com/"
	strcat(url,param1,512)
	strcat(url,"/",512)
	strcat(url,param2,512)
	strcat(url,"/raw/",512)
	strcat(url,param3,512)
	strcat(url,"/",512)
	strcat(url,param4,512)
	
	new filepath[128]="scripts/plugins/"
	strcat(filepath,param5,128)
	
	new data[1]
	data[0] = fopen(filepath, "wb")
	new CURL:curl = curl_easy_init()
	curl_easy_setopt(curl, CURLOPT_BUFFERSIZE, CURL_BUFFER_SIZE)
	curl_easy_setopt(curl, CURLOPT_URL, url)
	curl_easy_setopt(curl, CURLOPT_WRITEDATA, data[0])
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, "write")
	curl_easy_perform(curl, "complete", data, sizeof(data))
}

public write(data[], size, nmemb, file)
{
	new actual_size = size * nmemb;
	
	fwrite_blocks(file, data, actual_size, BLOCK_CHAR)
	
	return actual_size
}

public complete(CURL:curl, CURLcode:code, data[])
{
	if(code == CURLE_WRITE_ERROR)
		server_print("transfer aborted")
	else
		server_print("curl complete")
	
	fclose(data[0])
	curl_easy_cleanup(curl)
	reload_as()
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/