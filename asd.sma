#include <amxmodx>
#include <amxmisc>
#include <curl>
#include <json>

#define CURL_BUFFER_SIZE 512

new Fname[32]
new JSON:jPURLs
new lastFile
new singleFile

new Proxy[32]
new Website[32]


public plugin_init()
{
	register_plugin("AS Plugins Downloader","0.0","Scrooge")
	register_concmd("dick","hysd")
	jPURLs=json_parse("addons/amxmodx/data/asp_urls.json", true)
}

public hysd(id)
{
	new msg[512]
	lastFile=false
	singleFile=false
	read_argv(1, msg, charsmax(msg))
	new command[32]
	new params[512]
	split(msg,command,32,params,512," ")
	if(strcmp(command,"install")==0)
	{
		singleFile=true
		curl_file(params)
	}
	else if(strcmp(command,"install_auto")==0)
	{
		read_json(params)
	}
}

public bool:read_json(params[])
{
	new JSON:jPURL
	
	new Author[32]
	new Repo[32]
	new Branch[32]
	new JSON:Files

	jPURL=json_object_get_value(jPURLs,params)
	json_object_get_string(jPURL,"Website",Website,charsmax(Website))
	json_object_get_string(jPURL,"Author",Author,charsmax(Author))
	json_object_get_string(jPURL,"Repo",Repo,charsmax(Repo))
	json_object_get_string(jPURL,"Branch",Branch,charsmax(Branch))
	Files=json_object_get_value(jPURL,"File")
	if(json_is_array(Files)==1)
	{
		new fCount=json_array_get_count(Files)
		for(new i = 0; i < fCount; i++)
		{
			new File[32]
			json_array_get_string(Files,i,File,charsmax(File))
			singleFile=false
			if(i!=fCount-1)
			{
				server_print("Not The Last File")
				lastFile=false
			}
			else
			{
				server_print("Is The Last File")
				lastFile=true
			}
			new Params4CF[512]
			
			Params4CF=""
			strcat(Params4CF,Author,512)
			strcat(Params4CF,":",512)
			strcat(Params4CF,Repo,512)
			strcat(Params4CF,":",512)
			if(strcmp(Website,"GitHub")!=0)
			{
				strcat(Params4CF,"raw/",512)
			}
			else
			{
				json_object_get_string(jPURLs,"Proxy",Proxy,charsmax(Proxy))
			}
			strcat(Params4CF,Branch,512)
			strcat(Params4CF,":",512)
			strcat(Params4CF,File,512)
			strcat(Params4CF,"->",512)
			strcat(Params4CF,File,512)
			curl_file(Params4CF)
		}
		return true
	}
	else
	{
		return false
	}
	return false
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
	new pList=fopen("default_plugins.txt","r+")
	fseek(pList,-2,SEEK_END)
	fprintf(pList, "%s", text)
	fclose(pList)
	server_cmd("as_reloadplugins")
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
	params=""
	if(singleFile)
	{
		split(param5,Fname,64,params,64,".as")
	}
	else
	{
		if(lastFile)
		{
			split(param5,Fname,64,params,64,".as")
		}
	}
	
	new url[512]
	if(strcmp(Website,"GitHub")==0)
	{
		url="https://raw.githubusercontent.com/"
	}
	else
	{
		url="https://gitee.com/"
	}
	
	
	strcat(url,param1,512)
	strcat(url,"/",512)
	strcat(url,param2,512)
	
	strcat(url,"/",512)
	
	strcat(url,param3,512)
	strcat(url,"/",512)
	strcat(url,param4,512)
	
	server_print("Target URL:")
	server_print(url)
	
	new filepath[128]="scripts/plugins/"
	strcat(filepath,param5,128)
	
	new data[1]
	data[0] = fopen(filepath, "wb")
	new CURL:curl = curl_easy_init()
	curl_easy_setopt(curl, CURLOPT_BUFFERSIZE, CURL_BUFFER_SIZE)
	curl_easy_setopt(curl, CURLOPT_URL, url)
	if(strcmp(Website,"GitHub")==0)
	{
		server_print("Using Proxy:")
		server_print(Proxy)
		curl_easy_setopt(curl, CURLOPT_PROXY, Proxy);
	}
	curl_easy_setopt(curl, CURLOPT_WRITEDATA, data[0])
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, "write")
	if(singleFile)
	{
		curl_easy_perform(curl, "complete_and_reload", data, sizeof(data))
	}
	else
	{
		if(lastFile)
		{
			curl_easy_perform(curl, "complete_and_reload", data, sizeof(data))
		}
		else
		{
			curl_easy_perform(curl, "complete", data, sizeof(data))
		}
	}
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
}

public complete_and_reload(CURL:curl, CURLcode:code, data[])
{
	if(code == CURLE_WRITE_ERROR)
		server_print("transfer aborted")
	else
		server_print("curl complete")
	
	fclose(data[0])
	curl_easy_cleanup(curl)
	reload_as()
}
