array<string> players_in_server;
dictionary fired_primary;
dictionary fired_secondary;

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "I love Carol forever and ever!\n");
    g_Hooks.RegisterHook(Hooks::Player::ClientDisconnect, @PlayerDisconnectH);
    g_Hooks.RegisterHook(Hooks::Player::ClientSay, @PlayerSayH);
    g_Hooks.RegisterHook(Hooks::Game::MapChange, @MapChangeH);
    g_Hooks.RegisterHook(Hooks::Player::PlayerSpawn, @PlayerSpawnH);
    g_Hooks.RegisterHook(Hooks::Player::PlayerKilled, @PlayerKilledH);
    g_Hooks.RegisterHook(Hooks::Player::PlayerTakeDamage, @PlayerTakeDamageH);
    g_Hooks.RegisterHook(Hooks::Weapon::WeaponPrimaryAttack, @WeaponPrimaryAttackH);
    g_Hooks.RegisterHook(Hooks::Weapon::WeaponSecondaryAttack, @WeaponSecondaryAttackH);
    
}

HookReturnCode PlayerDisconnectH(CBasePlayer@ pPlayer)
{
    DateTime datetime=DateTime();
    string dt_str;
    datetime.ToString(dt_str);

    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    authid_pp=authid_pp.Replace(":","");

    int ping;
    int loss;
    const edict_t@ c_edict_pp = pPlayer.edict();
    g_EngineFuncs.GetPlayerStats(c_edict_pp, ping, loss);

	File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
    if( fHandle !is null ) 
    {
        fHandle.Write("==================================================\n");
        fHandle.Write(dt_str+"\n\n");
        fHandle.Write("Player: "+authid_pp+" ejected!\n");
        fHandle.Write("PING: "+string(ping)+"\n");
        fHandle.Write("Packet Loss: "+string(loss)+"\n");
        fHandle.Write("Position Vector: "+pPlayer.Center().ToString()+"\n");
        fHandle.Write("He/She/It died: "+pPlayer.m_iDeaths+" time!\n");
        fHandle.Write("Current players in map: "+string(g_PlayerFuncs.GetNumPlayers())+"\n");
        fHandle.Write("==================================================\n");
    }
    fHandle.Close();
	
    int index = players_in_server.find(authid_pp);
    if(index!=-1)
    {
        players_in_server.removeAt(index);
    }

	return HOOK_CONTINUE;
}

HookReturnCode PlayerSayH(SayParameters@ pParams)
{
    DateTime datetime=DateTime();
    string dt_str;
    datetime.ToString(dt_str);

    CBasePlayer@ pPlayer=pParams.GetPlayer();
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Player: "+authid_pp+" says:\n"+pParams.GetCommand()+"\n");
    authid_pp=authid_pp.Replace(":","");

    int ping;
    int loss;
    const edict_t@ c_edict_pp = pPlayer.edict();
    g_EngineFuncs.GetPlayerStats(c_edict_pp, ping, loss);

	File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
    if( fHandle !is null ) 
    {
        fHandle.Write("==================================================\n");
        fHandle.Write(dt_str+"\n\n");
        fHandle.Write("Player: "+authid_pp+" says:\n"+pParams.GetCommand()+"\n");
        fHandle.Write("PING: "+string(ping)+"\n");
        fHandle.Write("Packet Loss: "+string(loss)+"\n");
        fHandle.Write("Position Vector: "+pPlayer.Center().ToString()+"\n");
        const CCommand@ pArguments=pParams.GetArguments();
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

HookReturnCode MapChangeH()
{
    DateTime datetime=DateTime();
    string dt_str;
    datetime.ToString(dt_str);

    int pCount=g_PlayerFuncs.GetNumPlayers();
    int pCount2=players_in_server.length();
    if(pCount!=pCount2)
    {
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "WARNING! PlayerCount Mismatch!\n");
    }
    for(int n=0;n<pCount2;n++)
    {
        string authid_pp=players_in_server[n];

        File@ fHandle;
        @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
        if( fHandle !is null ) 
        {
            fHandle.Write("==================================================\n");
            fHandle.Write(dt_str+"\n\n");
            fHandle.Write("Map changed to: "+g_Engine.mapname+"\n");
            if(pCount!=pCount2)
            {
                fHandle.Write("WARNING! PlayerCount Mismatch!\n");
            }
            fHandle.Write("==================================================\n");
        }
        fHandle.Close();
    }
		
	return HOOK_CONTINUE;
}

HookReturnCode PlayerSpawnH(CBasePlayer@ pPlayer)
{
    DateTime datetime=DateTime();
    string dt_str;
    datetime.ToString(dt_str);
		
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "New player: "+authid_pp+"\n");
    authid_pp=authid_pp.Replace(":","");

    int ping;
    int loss;
    const edict_t@ c_edict_pp = pPlayer.edict();
    g_EngineFuncs.GetPlayerStats(c_edict_pp, ping, loss);

    File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
    if( fHandle !is null ) 
    {
        fHandle.Write("==================================================\n");
        fHandle.Write(dt_str+"\n\n");
        fHandle.Write("New player: "+authid_pp+" spawned!\n");
        fHandle.Write("PING: "+string(ping)+"\n");
        fHandle.Write("Packet Loss: "+string(loss)+"\n");
        fHandle.Write("Position Vector: "+pPlayer.Center().ToString()+"\n");
        fHandle.Write("Map name: "+g_Engine.mapname+"\n");
        fHandle.Write("Current players in map: "+string(g_PlayerFuncs.GetNumPlayers())+"\n");
        fHandle.Write("==================================================\n");
    }
    fHandle.Close();

    int index = players_in_server.find(authid_pp);
    if(index==-1)
    {
        players_in_server.insertAt(0,authid_pp);
    }

    return HOOK_CONTINUE;
}

HookReturnCode PlayerKilledH(CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib)
{
    DateTime datetime=DateTime();
    string dt_str;
    datetime.ToString(dt_str);

    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Fucked player: "+authid_pp+"\n");
    authid_pp=authid_pp.Replace(":","");

    int ping;
    int loss;
    const edict_t@ c_edict_pp = pPlayer.edict();
    g_EngineFuncs.GetPlayerStats(c_edict_pp, ping, loss);

    File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
    if( fHandle !is null ) 
    {
        fHandle.Write("==================================================\n");
        fHandle.Write(dt_str+"\n\n");
        fHandle.Write("Player: "+authid_pp+" get fucked!!!\n");
        fHandle.Write("PING: "+string(ping)+"\n");
        fHandle.Write("Packet Loss: "+string(loss)+"\n");
        fHandle.Write("Position Vector: "+pPlayer.Center().ToString()+"\n");
        fHandle.Write("Fucker name: "+pAttacker.GetClassname()+"\n");
        switch(iGib)
        {
            case 0:
            case 3:
                fHandle.Write("Player dies normally\n");
                break;
            case 1:
                fHandle.Write("Player dies in one piece\n");
                break;
            case 2:
                fHandle.Write("Player dies in pieces!!!\n");
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
    DateTime datetime=DateTime();
    string dt_str;
    datetime.ToString(dt_str);

    if(pDamageInfo.pVictim.IsPlayer())
    {
        CBasePlayer@ pPlayer=cast<CBasePlayer@>(pDamageInfo.pVictim);
        edict_t@ edict_pp = pPlayer.edict();
        string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Damaged player: "+authid_pp+"\n");
        authid_pp=authid_pp.Replace(":","");

        int ping;
        int loss;
        const edict_t@ c_edict_pp = pPlayer.edict();
        g_EngineFuncs.GetPlayerStats(c_edict_pp, ping, loss);

        if(pDamageInfo.flDamage<1){
            return HOOK_CONTINUE;
        }
        File@ fHandle;
        @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
        if( fHandle !is null ) 
        {
            fHandle.Write("==================================================\n");
            fHandle.Write(dt_str+"\n\n");
            fHandle.Write("Player: "+authid_pp+" is being fucked\n");
            fHandle.Write("PING: "+string(ping)+"\n");
            fHandle.Write("Packet Loss: "+string(loss)+"\n");
            fHandle.Write("Position Vector: "+pPlayer.Center().ToString()+"\n");
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
            fHandle.Write("Attacker: "+pAtk.GetClassname()+"\n");
            CBaseEntity@ pInf=pDamageInfo.pInflictor;
            fHandle.Write("Inflictor: "+pInf.GetClassname()+"\n");
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

HookReturnCode WeaponPrimaryAttackH(CBasePlayer@ pPlayer, CBasePlayerWeapon@ pWeapon)
{
    DateTime datetime=DateTime();
    string dt_str;
    datetime.ToString(dt_str);

    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Player: "+authid_pp+" is attacking!\n");
    authid_pp=authid_pp.Replace(":","");

    int ping;
    int loss;
    const edict_t@ c_edict_pp = pPlayer.edict();
    g_EngineFuncs.GetPlayerStats(c_edict_pp, ping, loss);

    bool b_wrtie_to_file=false;
    if(fired_primary.exists(authid_pp))
    {
        // Not the first time
        if(string(fired_primary[authid_pp])==pWeapon.GetClassname())
        {
            // Same weapon
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Time Elapsed: "+string(g_Engine.time-float(fired_primary[authid_pp+"_time"]))+"\n");
            
            if(g_Engine.time-float(fired_primary[authid_pp+"_time"])>20)
            {
                // Long enough after last firing
                b_wrtie_to_file=true;
                fired_primary.set(authid_pp+"_time",g_Engine.time);
            }
        }
        else
        {
            // Not first time, but use a different weapon
            b_wrtie_to_file=true;
            fired_primary.set(authid_pp,pWeapon.GetClassname());
            fired_primary.set(authid_pp+"_time",g_Engine.time);
        }
    }
    else
    {
        // First time to fire
        b_wrtie_to_file=true;
        fired_primary.set(authid_pp,pWeapon.GetClassname());
        fired_primary.set(authid_pp+"_time",g_Engine.time);
    }
    
    if(b_wrtie_to_file)
    {
        File@ fHandle;
        @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
        if( fHandle !is null ) 
        {
            fHandle.Write("==================================================\n");
            fHandle.Write(dt_str+"\n\n");
            fHandle.Write("Player: "+authid_pp+" is attacking!\n");
            fHandle.Write("PING: "+string(ping)+"\n");
            fHandle.Write("Packet Loss: "+string(loss)+"\n");
            fHandle.Write("With primary fire mode of: "+pWeapon.GetClassname()+"\n");
            fHandle.Write("Position Vector: "+pPlayer.Center().ToString()+"\n");
            fHandle.Write("Primary ammo: "+pWeapon.pszAmmo1()+"\n");
            fHandle.Write(string(pWeapon.m_iClip)+" rounds left in the current clip.\n");
            fHandle.Write(string(pPlayer.m_rgAmmo(size_t(pWeapon.m_iPrimaryAmmoType)))+" rounds left in total.\n");
            fHandle.Write("==================================================\n");
        }
        fHandle.Close();
    }
    return HOOK_CONTINUE;
}

HookReturnCode WeaponSecondaryAttackH(CBasePlayer@ pPlayer, CBasePlayerWeapon@ pWeapon)
{
    DateTime datetime=DateTime();
    string dt_str;
    datetime.ToString(dt_str);

    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Player: "+authid_pp+" is attacking!\n");
    authid_pp=authid_pp.Replace(":","");

    int ping;
    int loss;
    const edict_t@ c_edict_pp = pPlayer.edict();
    g_EngineFuncs.GetPlayerStats(c_edict_pp, ping, loss);

    bool b_wrtie_to_file=false;
    if(fired_secondary.exists(authid_pp))
    {
        // Not the first time
        if(string(fired_secondary[authid_pp])==pWeapon.GetClassname())
        {
            // Same weapon
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Time Elapsed: "+string(g_Engine.time-float(fired_secondary[authid_pp+"_time"]))+"\n");

            if(g_Engine.time-float(fired_secondary[authid_pp+"_time"])>20)
            {
                // Long enough after last firing
                b_wrtie_to_file=true;
                fired_secondary.set(authid_pp+"_time",g_Engine.time);
            }
        }
        else
        {
            // Not first time, but use a different weapon
            b_wrtie_to_file=true;
            fired_secondary.set(authid_pp,pWeapon.GetClassname());
            fired_secondary.set(authid_pp+"_time",g_Engine.time);
        }
    }
    else
    {
        // First time to fire
        b_wrtie_to_file=true;
        fired_secondary.set(authid_pp,pWeapon.GetClassname());
        fired_secondary.set(authid_pp+"_time",g_Engine.time);
    }
    
    if(b_wrtie_to_file)
    {
        File@ fHandle;
        @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
        if( fHandle !is null ) 
        {
            fHandle.Write("==================================================\n");
            fHandle.Write(dt_str+"\n\n");
            fHandle.Write("Player: "+authid_pp+" is attacking!\n");
            fHandle.Write("PING: "+string(ping)+"\n");
            fHandle.Write("Packet Loss: "+string(loss)+"\n");
            fHandle.Write("With secondary fire mode of: "+pWeapon.GetClassname()+"\n");
            fHandle.Write("Position Vector: "+pPlayer.Center().ToString()+"\n");
            fHandle.Write("Secondary ammo: "+pWeapon.pszAmmo2()+"\n");
            fHandle.Write(string(pWeapon.m_iClip2)+" rounds left in the current clip.\n");
            fHandle.Write(string(pPlayer.m_rgAmmo(size_t(pWeapon.m_iSecondaryAmmoType)))+" rounds left in total.\n");
            fHandle.Write("==================================================\n");
        }
        fHandle.Close();
    }
    return HOOK_CONTINUE;
}

