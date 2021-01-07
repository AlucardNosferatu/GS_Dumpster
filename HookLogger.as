array<string> players_in_server;
dictionary fired_primary;
dictionary fired_secondary;
dictionary RadarP;
array<Vector> GraveYards;
int GYMax;
int NewestGYIndex;

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
    g_Hooks.RegisterHook(Hooks::Player::PlayerPostThink, @PlayerPostThinkH);
    g_Hooks.RegisterHook(Hooks::Player::PlayerTakeDamage, @PlayerTakeDamageH);
    g_Hooks.RegisterHook(Hooks::Weapon::WeaponPrimaryAttack, @WeaponPrimaryAttackH);
    g_Hooks.RegisterHook(Hooks::Weapon::WeaponSecondaryAttack, @WeaponSecondaryAttackH);
    init_GraveYard();
}

void init_GraveYard()
{
    GYMax=8;
    int CurrentGYC=GraveYards.length();
    if(CurrentGYC!=0)
    {
        GraveYards.removeRange(0, CurrentGYC);
    }
    NewestGYIndex=0;
}

float min_of_fArray(array<float> fArray)
{
    float minF=999.0;
    for(int i=0;i<fArray.length();i++)
    {
        if(i==0)
        {
            minF=fArray[i];
        }
        else
        {
            if(fArray[i]<minF)
            {
                minF=fArray[i];
            }
        }
    }
    return minF;
}

void merge_GraveYards(int indexGY,Vector vecDie)
{
    Vector midPoint=(GraveYards[indexGY]+vecDie)/2;
    GraveYards[indexGY]=midPoint;
}

void dig_NewGrave(Vector vecDie)
{
    if(NewestGYIndex<GYMax)
    {
        GraveYards.insertLast(vecDie);
        NewestGYIndex+=1;
    }
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

    init_GraveYard();

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

    RadarP.set(authid_pp,666);

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

    RadarP.set(authid_pp,0);

    int ping;
    int loss;
    const edict_t@ c_edict_pp = pPlayer.edict();
    g_EngineFuncs.GetPlayerStats(c_edict_pp, ping, loss);

    int CurrentGYC=GraveYards.length();
    array<float> distances(CurrentGYC);
    Vector vecDie=pPlayer.pev.origin;

    for(int i=0;i<CurrentGYC;i++)
    {
        distacnes[i]=(vecDie-GraveYards[i]).Length();
    }
    if(distances.length>0 and min_of_fArray(distances)<32.0)
    {
        int indexGY=distances.find(min_of_fArray(distances));
        merge_GraveYards(indexGY,vecDie);
    }
    else
    {
        dig_NewGrave(vecDie);
    }


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

HookReturnCode PlayerPostThinkH(CBasePlayer@ pPlayer)
{
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    authid_pp=authid_pp.Replace(":","");
    if(RadarP.exists(authid_pp) and int(RadarP[authid_pp])>100)
    {
        Vector vecSrc = pPlayer.pev.origin;
        Math.MakeVectors(pPlayer.pev.angles);
        Math.VecToAngles(pPlayer.pev.velocity);
        
        float total_health=0.0;
        float total_distance=0.0;
        int mCount=0;

        uint maxCount = 256;
        array<CBaseEntity@> arrMonsters(maxCount + 1);
        mCount=g_EntityFuncs.MonstersInSphere(arrMonsters, vecSrc, 512.0);
        arrMonsters.resize(mCount);
        for(int i=0;i<mCount;i++)
        {
            TraceResult tr;
            Vector vecEnd=arrMonsters[i].pev.origin;
            g_Utility.TraceLine(vecSrc, vecEnd, dont_ignore_monsters, dont_ignore_glass, pPlayer.edict(), tr);
            if(arrMonsters[i].edict()==tr.pHit)
            {
                total_health+=arrMonsters[i].pev.health;
                float dist=(vecSrc-vecEnd).Length();
                total_distance+=dist;
            }
        }
        
        int ping;
        int loss;
        const edict_t@ c_edict_pp = pPlayer.edict();
        g_EngineFuncs.GetPlayerStats(c_edict_pp, ping, loss);

        File@ fHandle;
        @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+".txt" , OpenFile::APPEND);
        if( fHandle !is null ) 
        {
            fHandle.Write("==================================================\n");
            fHandle.Write("Player: "+authid_pp+" is scanning...\n");
            fHandle.Write("PING: "+string(ping)+"\n");
            fHandle.Write("Packet Loss: "+string(loss)+"\n");
            fHandle.Write("Position Vector: "+pPlayer.Center().ToString()+"\n");
            fHandle.Write("Nearby Monsters: "+string(mCount)+"\n");
            fHandle.Write("Average health: "+string(total_health/mCount)+"\n");
            fHandle.Write("Average Distance: "+string(total_distance/mCount)+"\n");
            fHandle.Write("==================================================\n");
        }
        fHandle.Close();


    }
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

