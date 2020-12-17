void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor( "Scrooge2029" );
    g_Module.ScriptInfo.SetContactInfo( "1641367382@qq.com" );
    g_PlayerFuncs.ClientPrintAll( HUD_PRINTCONSOLE, "I love Carol forever and ever!\n" );
    g_Hooks.RegisterHook( Hooks::Player::ClientSay, @ClientSayH );
    g_Hooks.RegisterHook( Hooks::Player::PlayerSpawn, @PlayerSpawnH );
    g_Hooks.RegisterHook( Hooks::Player::PlayerKilled, @PlayerKilledH );
    g_Hooks.RegisterHook( Hooks::Player::PlayerTakeDamage, @PlayerTakeDamageH);
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
        switch(iGib)
        {
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

HookReturnCode PlayerTakeDamageH(DamageInfo@ pDamageInfo)
{
    if(pDamageInfo.pVictim.IsPlayer())
    {
        CBasePlayer@ pPlayer=cast<CBasePlayer@>(pDamageInfo.pVictim);
        edict_t@ edict_pp = pPlayer.edict();
        string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
        g_PlayerFuncs.ClientPrintAll( HUD_PRINTCONSOLE, "New player: "+authid_pp+"\n" );
        authid_pp=authid_pp.Replace(":","");

        File@ fHandle;
        @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
        if( fHandle !is null ) 
        {
            fHandle.Write("==================================================\n");
            fHandle.Write("Player: "+authid_pp+" is being fucked\n");
            fHandle.Write("Fucked: "+string(pDamageInfo.flDamage)+"\n");
            switch(pDamageInfo.bitsDamageType)
            {
                case DMG_GENERIC:
                    fHandle.Write("By: Generic damage.\n");
                    break;
                case DMG_CRUSH:
                    fHandle.Write("By: Something crushed him/her/it.\n");
                    break;
                case DMG_BULLET:
                    fHandle.Write("By: Bullets pierced him/her/it.\n");
                    break;
                case DMG_SLASH:
                    fHandle.Write("By: Some kinds of sharp melee attack.\n");
                    break;
                case DMG_BURN:
                    fHandle.Write("By: FFF Torchs.\n");
                    break;
                case DMG_FALL:
                    fHandle.Write("By: Concrete shoes...\n");
                    break;
                case DMG_BLAST:
                    fHandle.Write("By: TNT!!!(Done Dirt Cheap!!!)\n");
                    break;
                case DMG_CLUB:
                    fHandle.Write("By: Duang!\n");
                    break;
                case DMG_SHOCK:
                    fHandle.Write("By: High Voltage!!!.\n");
                    break;
                case DMG_SONIC:
                    fHandle.Write("By: Shizuka's songs.\n");
                    break;
                case DMG_ENERGYBEAM:
                    fHandle.Write("By: Prism cannon invented by Einstein.\n");
                    break;
                case DMG_LAUNCH:
                    fHandle.Write("By: <<From The Earth To The ...>>.\n");
                    break;
                case DMG_DROWN:
                    fHandle.Write("By: Waters in lungs.\n");
                    break;
                case DMG_TIMEBASED:
                    fHandle.Write("By: Prosciutto.\n");
                    break;
                case DMG_PARALYZE:
                    fHandle.Write("By: Amyotrophic Lateral Sclerosis.\n");
                    break;
                case DMG_NERVEGAS:
                    fHandle.Write("By: Nova Six!!!\n");
                    break;
                case DMG_POISON:
                    fHandle.Write("By: Cyanide...\n");
                    break;
                case DMG_RADIATION:
                    fHandle.Write("By: Fukushima & Chernobyl.\n");
                    break;
                case DMG_DROWNRECOVER:
                    fHandle.Write("By: Fresh Air.\n");
                    break;
                case DMG_ACID:
                    fHandle.Write("By: Toilet Cleaner.\n");
                    break;
                case DMG_SLOWBURN:
                    fHandle.Write("By: Gordon Ramsy.\n");
                    break;
                case DMG_SLOWFREEZE:
                    fHandle.Write("By: Nice~!.\n");
                    break;
                case DMG_MORTAR:
                    fHandle.Write("By: Explosion from above.\n");
                    break;
                case DMG_SNIPER:
                    fHandle.Write("By: Vasili Zezov.\n");
                    break;
                case DMG_MEDKITHEAL:
                    fHandle.Write("By: X~!\n");
                    break;
                case DMG_SHOCK_GLOW:
                    fHandle.Write("By: Tesla coil invented by Nicola Tesla.\n");
                    break;
                default:
                    fHandle.Write("By: Unknown or unhandled Damage.\n");
                    break;
            }
            CBaseEntity@ pAtk=pDamageInfo.pAttacker;
            fHandle.Write("Attacker: "+pAttacker.GetClassname()+"\n");
            CBaseEntity@ pInf=pDamageInfo.pInflictor;
            fHandle.Write("Inflictor: "+pInflictor.GetClassname()+"\n");
            fHandle.Write("==================================================\n");
        }
        fHandle.Close();
        return HOOK_CONTINUE;
    }
    else
    {
        return HOOK_CONTINUE;
    }

    
}
