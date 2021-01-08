array<string> players_in_server;
dictionary fired_primary;
dictionary fired_secondary;
dictionary RadarP;
dictionary birthplaces;
array<Vector> GraveYards;
array<DateTime> PrevTolls;
array<TimeDifference> TimeToNext;
int GYMax;
int NewestGYIndex;
dictionary sample_count;

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "I love Carol forever and ever!\n");
    g_Hooks.RegisterHook(Hooks::Game::MapChange, @MapChangeH);
    g_Hooks.RegisterHook(Hooks::Player::ClientSay, @ClientSayH);
    g_Hooks.RegisterHook(Hooks::Player::ClientDisconnect, @ClientDisconnectH);
    g_Hooks.RegisterHook(Hooks::Player::ClientPutInServer, @ClientPutInServerH);
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
    GYMax=16;
    int CurrentGYC=GraveYards.length();
    if(CurrentGYC!=0)
    {
        GraveYards.removeRange(0, CurrentGYC);
        PrevTolls.removeRange(0, CurrentGYC);
        TimeToNext.removeRange(0, CurrentGYC);
    }
    NewestGYIndex=0;
}

float min_of_fArray(array<float> fArray)
{
    float minF=999.0;
    for(uint i=0;i<fArray.length();i++)
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
    DateTime FToll=DateTime();
    Vector midPoint=(GraveYards[indexGY]+vecDie)/2;
    GraveYards[indexGY]=midPoint;
    TimeToNext[indexGY]=FToll-PrevTolls[indexGY];
    PrevTolls[indexGY]=FToll;
}

void dig_NewGrave(Vector vecDie)
{
    if(NewestGYIndex<GYMax)
    {
        DateTime FToll=DateTime();
        GraveYards.insertLast(vecDie);
        TimeToNext.insertLast(FToll-FToll);
        PrevTolls.insertLast(FToll);
        NewestGYIndex+=1;
    }
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

HookReturnCode ClientSayH(SayParameters@ pParams)
{
    DateTime datetime=DateTime();
    string dt_str;
    datetime.ToString(dt_str);

    CBasePlayer@ pPlayer=pParams.GetPlayer();
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Player: "+authid_pp+" says:\n"+pParams.GetCommand()+"\n");
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

HookReturnCode ClientDisconnectH(CBasePlayer@ pPlayer)
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

HookReturnCode ClientPutInServerH(CBasePlayer@ pPlayer)
{
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "New player: "+authid_pp+"\n");
    authid_pp=authid_pp.Replace(":","");
    RadarP.set(authid_pp,666);
    birthplaces.set(authid_pp,pPlayer.pev.origin);
    return HOOK_CONTINUE;
}

HookReturnCode PlayerSpawnH(CBasePlayer@ pPlayer)
{
    DateTime datetime=DateTime();
    string dt_str;
    datetime.ToString(dt_str);
		
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "New player: "+authid_pp+"\n");
    authid_pp=authid_pp.Replace(":","");

    RadarP.set(authid_pp,666);
    birthplaces.set(authid_pp,pPlayer.pev.origin);

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
    // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Fucked player: "+authid_pp+"\n");
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
        distances[i]=(vecDie-GraveYards[i]).Length();
    }
    if(distances.length()>0 and min_of_fArray(distances)<256.0)
    {
        int indexGY=distances.find(min_of_fArray(distances));
        merge_GraveYards(indexGY,vecDie);
        g_PlayerFuncs.ShowMessage(pPlayer,"Merge with a old grave:"+string(indexGY)+"\nlocates:"+string(vecDie.x)+"#"+string(vecDie.y)+"#"+string(vecDie.z)+"\nDPM:"+string(60.0/float(TimeToNext[indexGY].GetSeconds())));
    }
    else
    {
        dig_NewGrave(vecDie);
        g_PlayerFuncs.ShowMessage(pPlayer, "Current GYC:"+string(distances.length())+", Dig a new grave:"+string(vecDie.x)+"#"+string(vecDie.y)+"#"+string(vecDie.z)+"\n");
    }

    File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+"_radar.txt" , OpenFile::APPEND);
    if( fHandle !is null ) 
    {
        fHandle.Write("==================================================\n");
        fHandle.Write(dt_str+"\n\n");
        fHandle.Write("Player: "+authid_pp+" get fucked!!!\n");
        fHandle.Write("==================================================\n");
    }
    fHandle.Close();

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
        float total_ally_health=0.0;
        float total_ally_distance=0.0;
        int mCount=0;
        int valid_mCount=0;
        int nearby_pCount=0;
        uint maxCount = 256;
        array<CBaseEntity@> arrMonsters(maxCount + 1);
        mCount=g_EntityFuncs.MonstersInSphere(arrMonsters, vecSrc, 512.0);
        arrMonsters.resize(mCount);
        string all_enemies="";
        for(int i=0;i<mCount;i++)
        {
            if(!arrMonsters[i].IsPlayer() and arrMonsters[i].IsMonster() and arrMonsters[i].IsAlive() and arrMonsters[i].IRelationshipByClass(CLASS_PLAYER)>0)
            {
                all_enemies+=arrMonsters[i].GetClassname();
                all_enemies+="\n";
                Vector vecEnd=arrMonsters[i].pev.origin;
                total_health+=arrMonsters[i].pev.health;
                float dist=(vecSrc-vecEnd).Length();
                total_distance+=dist;
                valid_mCount+=1;

            }
            else if(arrMonsters[i].IsPlayer() and !(arrMonsters[i].edict() is pPlayer.edict()))
            {
                total_ally_distance+=(arrMonsters[i].pev.origin-vecSrc).Length();
                total_ally_health+=arrMonsters[i].pev.health;
                nearby_pCount+=1;
            }
        }
        int CurrentGYC=GraveYards.length();
        float to_nearest_GY=-1.0;
        float correspond_DPM=0.0;
        float to_birthplace=-1.0;
        if(CurrentGYC>0){
            array<float> distances;
            for(int i=0;i<CurrentGYC;i++)
            {
                distances.insertLast((GraveYards[i]-vecSrc).Length());
            }
            to_nearest_GY=min_of_fArray(distances);
            int indexGY=distances.find(to_nearest_GY);
            int TTN=TimeToNext[indexGY].GetSeconds();
            if(TTN!=0)
            {
                correspond_DPM=60.0/float(TimeToNext[indexGY].GetSeconds());
            }
            to_birthplace=(Vector(birthplaces[authid_pp])-pPlayer.pev.origin).Length();
        }
        if(sample_count.exists(authid_pp))
        {
            if(int(sample_count[authid_pp])>=200)
            {
                string info="";
                if(valid_mCount!=0)
                {
                    info="Detected:"+string(valid_mCount);
                    info+=" AveHP:"+string(total_health/float(valid_mCount));
                    info+=" AveDist:"+string(total_distance/float(valid_mCount));
                    if(to_nearest_GY>0 and to_nearest_GY<512.0)
                    {
                        info+=" NearestGY:"+string(to_nearest_GY);
                        info+=" DPM:"+string(correspond_DPM);
                    }
                    else
                    {
                        info+=" No GY detected.";
                    }
                }
                else
                {
                    info="No enemies detected. ";
                    if(to_nearest_GY>0 and to_nearest_GY<512.0)
                    {
                        info+="To nearest Graveyard:"+string(to_nearest_GY);
                        info+=" DPM:"+string(correspond_DPM);
                    }
                    else
                    {
                        info+="No Graveyards on this map now.";
                    }
                }
                info+="\n";
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE,info);

                sample_count.set(authid_pp,0);

                int ping;
                int loss;
                const edict_t@ c_edict_pp = pPlayer.edict();
                g_EngineFuncs.GetPlayerStats(c_edict_pp, ping, loss);

                CBasePlayerWeapon@ weaponHeld= cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
                int AmmoCount=0;
                if(weaponHeld.m_iPrimaryAmmoType!=-1)
                {
                    AmmoCount=pPlayer.m_rgAmmo(size_t(weaponHeld.m_iPrimaryAmmoType));
                }
                float FireRate=weaponHeld.m_flNextPrimaryAttack;
                int ClipSize=weaponHeld.iMaxClip();
                int AcutalAmmoInClip=weaponHeld.m_iClip;

                File@ fHandle;
                @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+authid_pp+"_radar.txt" , OpenFile::APPEND);
                if( fHandle !is null ) 
                {
                    fHandle.Write("==================================================\n");
                    fHandle.Write("Player: "+authid_pp+" is scanning...\n");
                    fHandle.Write("PING: "+string(ping)+"\n");
                    fHandle.Write("Packet Loss: "+string(loss)+"\n");
                    fHandle.Write("Position Vector: "+pPlayer.Center().ToString()+"\n");
                    fHandle.Write("==================================================\n");
                    fHandle.Write("Health: "+string(pPlayer.pev.health)+"\n");
                    fHandle.Write("Armor: "+string(pPlayer.pev.armorvalue)+"\n");
                    fHandle.Write("Frags: "+string(pPlayer.pev.frags)+"\n");
                    fHandle.Write("Death: "+string(pPlayer.m_iDeaths)+"\n");
                    fHandle.Write("Other Player In Server: "+string(nearby_pCount)+"\n");
                    if(nearby_pCount==0)
                    {
                        fHandle.Write("Other Player Ave Distance: "+string(-1.0)+"\n");
                        fHandle.Write("Other Player Ave Health: "+string(0)+"\n");
                    }
                    else
                    {
                        fHandle.Write("Other Player Ave Distance: "+string(total_ally_health/float(nearby_pCount))+"\n");
                        fHandle.Write("Other Player Ave Health: "+string(total_ally_distance/float(nearby_pCount))+"\n");
                    }
                    fHandle.Write("Weapon: "+weaponHeld.GetClassname()+"\n");
                    fHandle.Write("Ammo: "+string(AmmoCount)+"\n");
                    fHandle.Write("ClipSize: "+string(ClipSize)+"\n");
                    fHandle.Write("AmmoInClip: "+string(AcutalAmmoInClip)+"\n");
                    fHandle.Write("Nearby Monsters: "+string(valid_mCount)+"\n");
                    if(valid_mCount!=0)
                    {
                        fHandle.Write("Average health: "+string(total_health/float(valid_mCount))+"\n");
                        fHandle.Write("Average Distance: "+string(total_health/float(valid_mCount))+"\n");                    
                    }
                    else{
                        fHandle.Write("Average health: "+string(0)+"\n");
                        fHandle.Write("Average Distance: "+string(-1)+"\n");                    
                    }
                    if(to_nearest_GY<512.0)
                    {
                        fHandle.Write("NearestGY:"+string(to_nearest_GY)+"\n");
                        fHandle.Write("To BirthPlace:"+string(to_birthplace)+"\n");
                        fHandle.Write("DPM:"+string(correspond_DPM)+"\n");
                    }
                    else
                    {
                        fHandle.Write("NearestGY:"+string(-1.0)+"\n");
                        fHandle.Write("To BirthPlace:"+string(-1.0)+"\n");
                        fHandle.Write("DPM:"+string(0.0)+"\n");
                    }
                    fHandle.Write("==================================================\n");
                }
                fHandle.Close();
            }
            else
            {
                sample_count.set(authid_pp,int(sample_count[authid_pp])+1);
            }
        }
        else
        {
            sample_count.set(authid_pp,0);
        }
        
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
        // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Damaged player: "+authid_pp+"\n");
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
    // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Player: "+authid_pp+" is attacking!\n");
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
            // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Time Elapsed: "+string(g_Engine.time-float(fired_primary[authid_pp+"_time"]))+"\n");
            
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
    // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Player: "+authid_pp+" is attacking!\n");
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
            // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Time Elapsed: "+string(g_Engine.time-float(fired_secondary[authid_pp+"_time"]))+"\n");

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

