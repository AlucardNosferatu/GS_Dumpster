void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor( "Scrooge2029" );
    g_Module.ScriptInfo.SetContactInfo( "1641367382@qq.com" );
    g_PlayerFuncs.ClientPrintAll( HUD_PRINTCONSOLE, "Hello World!\n" );
    Monitor m=Monitor();
    m.map_name=g_Engine.mapname;
    g_PlayerFuncs.ClientPrintAll( HUD_PRINTCONSOLE, "This map is: "+m.map_name );
}

class Monitor
{
    string map_name;
    File@ fHandle;
    Monitor(){
        map_name="";
        @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/Text.txt" , OpenFile::WRITE);
		if( fHandle !is null ) 
		{
            fHandle.Write("I love Carol forever and ever!\n");
        }
        fHandle.Close();
    }

}

