dictionary EnhancedP;
dictionary MindControllerP;

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "I love Carol forever and ever!\n");
    g_Hooks.RegisterHook(Hooks::Weapon::WeaponPrimaryAttack, @EnhancePrimary);
    g_Hooks.RegisterHook(Hooks::Weapon::WeaponSecondaryAttack, @EnhanceSecondary);
    g_Hooks.RegisterHook(Hooks::Player::PlayerKilled, @CancelByDeath);
}

CClientCommand g_GetEnhanced("fuck", "I Need Power!!!!", @enhance);
void enhance(const CCommand@ pArgs) 
{
    CBasePlayer@ pPlayer=g_ConCommandSystem.GetCurrentPlayer();
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
    pPlayer.TakeHealth(666, DMG_GENERIC,666);
    pPlayer.TakeArmor(666, DMG_GENERIC,666);
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    authid_pp=authid_pp.Replace(":","");
    if(EnhancedP.exists(authid_pp) and int(EnhancedP[authid_pp])>100)
    {
        EnhancedP.set(authid_pp,0);
    }
    else
    {
        EnhancedP.set(authid_pp,666);
    }
}

CClientCommand g_GetEnhancedMooore("fuckfuckfuck", "Moooorrrrre Power!!!!", @enhanceMooore);
void enhanceMooore(const CCommand@ pArgs) 
{
    CBasePlayer@ pPlayer=g_ConCommandSystem.GetCurrentPlayer();
    pPlayer.TakeHealth(666, DMG_GENERIC,666);
    pPlayer.TakeArmor(666, DMG_GENERIC,666);
    edict_t@ edict_pp = pPlayer.edict();
    string authid_pp = g_EngineFuncs.GetPlayerAuthId(edict_pp);
    authid_pp=authid_pp.Replace(":","");
    if(MindControllerP.exists(authid_pp) and int(MindControllerP[authid_pp])>100)
    {
        MindControllerP.set(authid_pp,0);
    }
    else
    {
        MindControllerP.set(authid_pp,666);
    }
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
        if(pWeapon.m_iClip2>0)
        {
            pWeapon.m_iClip2=666;
        }
        pPlayer.m_rgAmmo(pWeapon.PrimaryAmmoIndex(),pWeapon.iMaxAmmo1());
        if(pWeapon.SecondaryAmmoIndex()!=-1)
        {
            pPlayer.m_rgAmmo(pWeapon.SecondaryAmmoIndex(),pWeapon.iMaxAmmo2());
        }
        pWeapon.m_flNextSecondaryAttack/=10;
        pWeapon.m_flNextPrimaryAttack/=10;
        if(pWeapon.GetClassname()=="weapon_357" or pWeapon.GetClassname()=="weapon_eagle" or pWeapon.GetClassname()=="weapon_sniperrifle")
        {
            // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE,pWeapon.GetClassname()+" has AP ammo\n");
            edict_t@ pentIgnore = pPlayer.edict();
            Vector vecSrc = pPlayer.GetGunPosition();
            g_EngineFuncs.MakeVectors(pPlayer.pev.v_angle+pPlayer.pev.punchangle);
            Vector vecDir = g_Engine.v_forward;
            Vector vecEnd;
            int PuncMax = 4;
            int PunchCap = PuncMax;
            TraceResult tr, beam_tr;
            while(PunchCap>0)
            {
                vecEnd = vecSrc+vecDir*8192;
                g_Utility.TraceLine(vecSrc, vecEnd, dont_ignore_monsters, dont_ignore_glass, pentIgnore, tr); 
                              
                if (tr.fAllSolid != 0 )
                {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE,"All solid\n");
                    break;
                }
                CBaseEntity@ pHitEnt=g_EntityFuncs.Instance(tr.pHit);
                if(pHitEnt is null)
                {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE,"Hit nothing\n");
                    break;
                }
                if(PunchCap<PuncMax)
                {
                    te_tracer(vecSrc,tr.vecEndPos);
                    te_gunshot(tr.vecEndPos);
                    if( pHitEnt.pev.takedamage != DAMAGE_NO )
                    {
                        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE,pHitEnt.GetClassname()+" take damage from AP ammo\n");
                        g_WeaponFuncs.ClearMultiDamage();
                        float iDamage;
                        if(pWeapon.GetClassname()=="weapon_sniperrilfe")
                        {
                            iDamage = g_EngineFuncs.CVarGetFloat( "sk_plr_762_bullet" )/(PuncMax-PunchCap+1);
                        }
                        else
                        {
                            iDamage = g_EngineFuncs.CVarGetFloat( "sk_plr_357_bullet" )/(PuncMax-PunchCap+1);
                        }
                        pHitEnt.TraceAttack( pPlayer.pev, iDamage, vecDir, tr, DMG_BULLET );
                        g_WeaponFuncs.ApplyMultiDamage( pPlayer.pev, pPlayer.pev );
                    }
                    else
                    {
                        g_Utility.GunshotDecalTrace(tr, 1);
                    }
                }
                float n = -DotProduct(tr.vecPlaneNormal, vecDir);
                if (n > 0.8)
                {
                    g_Utility.TraceLine( tr.vecEndPos + vecDir * 8, vecEnd, dont_ignore_monsters, pentIgnore, beam_tr);
                    if (beam_tr.fAllSolid == 0)
                    {
                        g_Utility.TraceLine( beam_tr.vecEndPos, tr.vecEndPos, dont_ignore_monsters, pentIgnore, beam_tr);
                        vecSrc = beam_tr.vecEndPos + vecDir;
                    }
                    PunchCap-=1;
                }
                else
                {
                    PunchCap=0;
                }
                
            }
        }
    }
    if(MindControllerP.exists(authid_pp) and int(MindControllerP[authid_pp])>100)
    {
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE,"MC Activated...\n");
        Vector vecSrc = pPlayer.GetGunPosition();
        Vector vecEnd = pPlayer.GetAutoaimVector( 0.0f );
        Math.MakeVectors( pPlayer.pev.v_angle );
        TraceResult tr;
        g_Utility.TraceLine(vecSrc, vecEnd*65536.0f, dont_ignore_monsters, dont_ignore_glass, pPlayer.edict(), tr)	;
        if(tr.pHit !is null)
        {
            CBaseEntity@ HitM=g_EntityFuncs.Instance(tr.pHit);
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE,HitM.GetClassname()+"\n");
            if(HitM.IsMonster() and HitM.IRelationshipByClass(CLASS_PLAYER)>0)
            {
                HitM.SetClassification(11);
            }
            else if(HitM.IsMonster() and HitM.IRelationshipByClass(CLASS_PLAYER)<=0)
            {
                HitM.SetClassification(16);
            }
            else if(HitM.GetClassname()=="func_door" or HitM.GetClassname()=="func_door_rotating" or HitM.GetClassname()=="func_button")
            {
                HitM.Use(cast<CBaseEntity@>(pPlayer), cast<CBaseEntity@>(pPlayer), USE_TOGGLE);
            }
        }
    }
    return HOOK_CONTINUE;

}

HookReturnCode EnhanceSecondary(CBasePlayer@ pPlayer, CBasePlayerWeapon@ pWeapon)
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
        if(pWeapon.m_iClip2>0)
        {
            pWeapon.m_iClip2=666;
        }
        pPlayer.m_rgAmmo(pWeapon.PrimaryAmmoIndex(),pWeapon.iMaxAmmo1());
        if(pWeapon.SecondaryAmmoIndex()!=-1)
        {
            pPlayer.m_rgAmmo(pWeapon.SecondaryAmmoIndex(),pWeapon.iMaxAmmo2());
        }
        pWeapon.m_flNextSecondaryAttack/=10;
        pWeapon.m_flNextPrimaryAttack/=10;
    }
    if(MindControllerP.exists(authid_pp) and int(MindControllerP[authid_pp])>100)
    {
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE,"MC Activated...\n");
        Vector vecSrc = pPlayer.GetOrigin();
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE,"vecSrc:"+vecSrc.ToString()+"\n");
        Vector vecDir = pPlayer.GetAutoaimVector(0.0f);
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE,"vecDir:"+vecDir.ToString()+"\n");
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE,"len:"+formatFloat(vecDir.Length(),"0",0,4)+"\n");
        Vector vecEnd = vecSrc+4*vecDir;
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE,"vecEnd:"+vecEnd.ToString()+"\n");
        Math.MakeVectors( pPlayer.pev.v_angle );
        pPlayer.SetOrigin(vecEnd);
    }
    return HOOK_CONTINUE;
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
    if(MindControllerP.exists(authid_pp))
    {
        MindControllerP.set(authid_pp,0);
    }
    return HOOK_CONTINUE;
}

void te_gunshot(Vector pos, 
	NetworkMessageDest msgType=MSG_BROADCAST, edict_t@ dest=null)
{
	NetworkMessage m(msgType, NetworkMessages::SVC_TEMPENTITY, dest);
	m.WriteByte(TE_GUNSHOT);
	m.WriteCoord(pos.x);
	m.WriteCoord(pos.y);
	m.WriteCoord(pos.z);
	m.End();
}

void te_tracer(Vector start, Vector end, 
	NetworkMessageDest msgType=MSG_BROADCAST, edict_t@ dest=null)
{
	NetworkMessage m(msgType, NetworkMessages::SVC_TEMPENTITY, dest);
	m.WriteByte(TE_TRACER);
	m.WriteCoord(start.x);
	m.WriteCoord(start.y);
	m.WriteCoord(start.z);
	m.WriteCoord(end.x);
	m.WriteCoord(end.y);
	m.WriteCoord(end.z);
	m.End();
}