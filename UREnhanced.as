dictionary EnhancedP;

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "I love Carol forever and ever!\n");
    g_Hooks.RegisterHook(Hooks::Weapon::WeaponPrimaryAttack, @EnhancePrimary);
    g_Hooks.RegisterHook(Hooks::Player::PlayerKilled, @CancelByDeath);
}

CClientCommand g_GetEnhanced("fuck", "I Need Power!!!!", @enhance);
void enhance(const CCommand@ pArgs) 
{
    CBasePlayer@ pPlayer=g_ConCommandSystem.GetCurrentPlayer();
    pPlayer.m_flMaxSpeed=600;
    pPlayer.GiveNamedItem("weapon_egon",0,450);
    pPlayer.GiveNamedItem("weapon_rpg",0,15);
    pPlayer.GiveNamedItem("weapon_m249",0,150);
    pPlayer.GiveNamedItem("weapon_uziakimbo",0,128);
    pPlayer.GiveNamedItem("item_healthkit");
    pPlayer.GiveNamedItem("item_healthkit");
    pPlayer.GiveNamedItem("item_battery");
    pPlayer.GiveNamedItem("item_battery");
    pPlayer.GiveNamedItem("item_longjump");
}

CClientCommand g_GetEnhancedMore("fuckfuck", "I Need More Power!!!!", @enhanceMore);
void enhanceMore(const CCommand@ pArgs) 
{
    CBasePlayer@ pPlayer=g_ConCommandSystem.GetCurrentPlayer();
    pPlayer.m_flMaxSpeed=600;
    pPlayer.TakeHealth(666, DMG_GENERIC,666);
    pPlayer.TakeArmor(666, DMG_GENERIC,666);
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    authid_pp=authid_pp.Replace(":","");
    EnhancedP.set(authid_pp,666);
}


HookReturnCode EnhancePrimary(CBasePlayer@ pPlayer, CBasePlayerWeapon@ pWeapon)
{
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    authid_pp=authid_pp.Replace(":","");

    if(EnhancedP.exists(authid_pp) and int(EnhancedP[authid_pp])>100)
    {
        if(pWeapon.m_iClip>0)
        {
            pWeapon.m_iClip=666;
        }
        pWeapon.m_flNextPrimaryAttack/=10;
        return HOOK_CONTINUE;
    }
    else
    {
        return HOOK_CONTINUE;
    }

}

HookReturnCode CancelByDeath(CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib)
{
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    authid_pp=authid_pp.Replace(":","");
    if(EnhancedP.exists(authid_pp))
    {
        EnhancedP.set(authid_pp,0);
    }
    return HOOK_CONTINUE;
}