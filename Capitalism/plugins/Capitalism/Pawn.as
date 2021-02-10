#include "../Ecco/Include"

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "My-Dearest-Girl...Ms.Carol!\n");
    InitEcco();
    InitPawn();
}

void InitPawn()
{
    g_Hooks.RegisterHook(Hooks::Player::ClientSay, @sell);
}

HookReturnCode sell(SayParameters@ pParams)
{
    CBasePlayer@ pPlayer = pParams.GetPlayer();
    const CCommand@ cArgs = pParams.GetArguments();
    if(pPlayer !is null && (cArgs[0].ToLowercase() == "!sell" || cArgs[0].ToLowercase() == "/sell"))
    {
        int fund = atoi(cArgs.Arg(1));
        CBaseEntity@ weaponHeld= pPlayer.m_hActiveItem.GetEntity();
        string weaponFile="scripts/plugins/Ecco/scripts/"+weaponHeld.GetClassname()+".echo";
        File@ file = g_FileSystem.OpenFile(weaponFile, OpenFile::READ);
        if(file !is null)
        {
            file.Close();
            dictionary WeaponInfo=e_ScriptParser.RetrieveInfo(weaponFile);
            float PriceInfo=atof(string(WeaponInfo['cost']));
            if(PriceInfo>50.0)
            {
                PriceInfo*=0.4;
            }
            else if(PriceInfo>25.0)
            {
                PriceInfo*=0.45;
            }
            else if(PriceInfo>12.5)
            {
                PriceInfo*=0.55;
            }
            else if(PriceInfo>6.25)
            {
                PriceInfo*=0.7;
            }
            else if(PriceInfo>3.125)
            {
                PriceInfo*=0.9;
            }
            pPlayer.RemovePlayerItem(cast<CBasePlayerItem@>(weaponHeld));
            e_PlayerInventory.ChangeBalance(pPlayer, int(PriceInfo));
        }
        else
        {
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "We can't evaluate the price of this item.\n");
        }
    }
    return HOOK_CONTINUE;
}
