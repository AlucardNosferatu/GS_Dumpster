void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "I love Carol forever and ever!\n");

}

CClientCommand g_GetEnhanced("fuck", "I Need Power!!!!", @enhance);
void enhance(const CCommand@ pArgs) 
{
    CBasePlayer@ pPlayer=g_ConCommandSystem.GetCurrentPlayer();
    pPlayer.m_fLongJump=true;
    pPlayer.m_flMaxSpeed=600;
    pPlayer.GiveNamedItem("weapon_egon",0,450);
    pPlayer.GiveNamedItem("weapon_rpg",0,5);
    pPlayer.GiveNamedItem("weapon_m249",0,150);
    pPlayer.GiveNamedItem("weapon_uziakimbo",0,128);
    pPlayer.GiveNamedItem("item_healthkit");
    pPlayer.GiveNamedItem("item_healthkit");
    pPlayer.GiveNamedItem("item_battery");
    pPlayer.GiveNamedItem("item_battery");
}

CClientCommand g_GetEnhanced("fuckfuck", "I Need More Power!!!!", @enhanceMore);
void enhanceMore(const CCommand@ pArgs) 
{
    CBasePlayer@ pPlayer=g_ConCommandSystem.GetCurrentPlayer();
    pPlayer.TakeHealth(666, DMG_GENERIC,666);
    pPlayer.TakeArmor(666, DMG_GENERIC,666);
    for (uint i = 0; i < MAX_ITEM_TYPES; i++ ) {
            CBasePlayerItem@ pItem = pPlayer.m_rgpPlayerItems(i);
            if (pItem !is null) {      
                CBasePlayerWeapon@ pWeapon=pItem.GetWeaponPtr();
                if (pWeapon !is null)
                {
                    string entity_name=pWeapon.GetClassname();
                    switch(entity_name)
                    {
                        case "weapon_crowbar":
                        case "weapon_grapple":
                        case "weapon_pipewrench":
                            break;
                        default:
                            pWeapon.m_iClip=666;
                            pWeapon.m_flNextPrimaryAttack=0.001;
                            pWeapon.m_flNextSecondaryAttack=0.001;
                            break;
                    }
                }
            }
        }
}