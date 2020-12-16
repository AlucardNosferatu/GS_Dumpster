void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor( "Scrooge2029" );
    g_Module.ScriptInfo.SetContactInfo( "1641367382@qq.com" );
    g_Hooks.RegisterHook( Hooks::Player::PlayerSpawn, @PlayerSpawnH );
    g_PlayerFuncs.ClientPrintAll( HUD_PRINTCONSOLE, "Hello World!\n" );
    
}

void MapInit()
{
    Monitor m=Monitor();
    m.map_name=g_Engine.mapname;
    g_PlayerFuncs.ClientPrintAll( HUD_PRINTCONSOLE, "This map is: "+m.map_name+"\n" );
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

HookReturnCode PlayerSpawnH( CBasePlayer@ pPlayer )
{		
    File@ fHandle;
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    g_PlayerFuncs.ClientPrintAll( HUD_PRINTCONSOLE, "New player: "+authid_pp+"\n" );
    authid_pp=authid_pp.Replace(":","");
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::WRITE);
    if( fHandle !is null ) 
    {
        fHandle.Write("New player spawned!\n");
    }
    fHandle.Close();
    return HOOK_CONTINUE;
}