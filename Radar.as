dictionary RadarP;

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "I love Carol forever and ever!\n")
    g_Hooks.RegisterHook(Hooks::Player::PlayerSpawn, @PlayerSpawnH);
    g_Hooks.RegisterHook(Hooks::Player::PlayerKilled, @PlayerKilledH);
    g_Hooks.RegisterHook(Hooks::Player::PlayerPostThink, @PlayerPostThinkH);
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

        uint maxCount = 256;
        array<CBaseEntity@> arrMonsters(maxCount + 1);
        int mCount=g_EntityFuncs.MonstersInSphere(arrMonsters, vecSrc, 512.0);
        arrMonsters.resize(mCount);
        for(int i=0;i<mCount;i++)
        {
            TraceResult tr;
            Vector vecEnd=arrMonsters[i].pev.origin;
            g_Utility.TraceLine(vecSrc, vecEnd, dont_ignore_monsters, dont_ignore_glass, pPlayer.edict(), tr);
            if(arrMonsters[i].edict()==tr.pHit)
            {
                //TODO
            }
        }
    }
    return HOOK_CONTINUE;
}

HookReturnCode PlayerSpawnH(CBasePlayer@ pPlayer)
{
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    authid_pp=authid_pp.Replace(":","");
    RadarP.set(authid_pp,666);
    return HOOK_CONTINUE;
}

HookReturnCode PlayerKilledH(CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib)
{
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    authid_pp=authid_pp.Replace(":","");
    RadarP.set(authid_pp,0);
    return HOOK_CONTINUE;
}