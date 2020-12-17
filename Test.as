void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor( "Scrooge2029" );
    g_Module.ScriptInfo.SetContactInfo( "1641367382@qq.com" );
    g_PlayerFuncs.ClientPrintAll( HUD_PRINTCONSOLE, "I love Carol forever and ever!\n" );
    g_Hooks.RegisterHook( Hooks::Player::ClientSay, @ClientSayH );
    g_Hooks.RegisterHook( Hooks::Player::PlayerSpawn, @PlayerSpawnH );
    g_Hooks.RegisterHook( Hooks::Player::PlayerKilled, @PlayerKilledH );

}

HookReturnCode ClientSayH( SayParameters@ pParams )
{
    CBasePlayer@ pPlayer=pParams.GetPlayer();
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Player: "+authid_pp+" says:\n"+pParams.GetCommand()+"\n");
    authid_pp=authid_pp.Replace(":","");

	File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
    if( fHandle !is null ) 
    {
        fHandle.Write("==================================================\n");
        fHandle.Write("Player: "+authid_pp+" says:\n"+pParams.GetCommand()+"\n");
        CCommand@ pArguments=pParams.GetArguments();
        int pAC=pArguments.ArgC();
        fHandle.Write("Arguments number: "+string(pAC)+"\n");
        for( int n = 0; n < pAC; n++ ) 
        {
            string pArgStr=pArguments.Arg(n);
            fHandle.Write("Command argument "+string(n)+": "+pArgStr+"\n");
            fHandle.Write("Value: "+pArguments.FindArg(pArgStr)+"\n");
        }
        fHandle.Write("==================================================\n");
    }
    fHandle.Close();
		
	return HOOK_CONTINUE;
}

HookReturnCode PlayerSpawnH( CBasePlayer@ pPlayer )
{		
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    g_PlayerFuncs.ClientPrintAll( HUD_PRINTCONSOLE, "New player: "+authid_pp+"\n" );
    authid_pp=authid_pp.Replace(":","");

    File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
    if( fHandle !is null ) 
    {
        fHandle.Write("==================================================\n");
        fHandle.Write("New player spawned!\n");
        fHandle.Write("Map name: "+g_Engine.mapname+"\n");
        fhandle.Write("Current players in map: "+string(g_PlayerFuncs.GetNumPlayers())+"\n");
        fHandle.Write("==================================================\n");
    }
    fHandle.Close();
    return HOOK_CONTINUE;
}

HookReturnCode PlayerKilledH(CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib)
{
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    g_PlayerFuncs.ClientPrintAll( HUD_PRINTCONSOLE, "New player: "+authid_pp+"\n" );
    authid_pp=authid_pp.Replace(":","");

    File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
    if( fHandle !is null ) 
    {
        fHandle.Write("==================================================\n");
        fHandle.Write("Player: "+authid_pp+" get fucked!!!\n");
        fHandle.Write("Fucker name: "+pAttacker.GetClassname()+"\n");
        switch(iGib){
            case 0:
            case 3:
                fhandle.Write("Player dies normally\n");
                break;
            case 1:
                fhandle.Write("Player dies in one piece\n");
                break;
            case 2:
                fhandle.Write("Player dies in pieces!!!\n");
                break;
            default:
                fHandle.Write("Unknown GIB code\n");
                break;
        }
        fHandle.Write("==================================================\n");
    }
    fHandle.Close();
    return HOOK_CONTINUE;
}