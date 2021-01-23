#include "../Ecco/Include"

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "My-Dearest-Girl...Ms.Carol!\n");
    InitEcco();
    InitEsate();
}

void InitEstate()
{
    GetEstateList();
    g_Hooks.RegisterHook(Hooks::Player::ClientSay, @estate_servive);
    g_Hooks.RegisterHook(Hooks::Player::ClientPutInServer, @toll_fee);
}

HookReturnCode estate_servive(SayParameters@ pParams)
{
    CBasePlayer@ pPlayer = pParams.GetPlayer();
    const CCommand@ cArgs = pParams.GetArguments();
    if(pPlayer !is null && (cArgs[0].ToLowercase() == "!estate" || cArgs[0].ToLowercase() == "/estate"))
    {
        if( cArgs.ArgC() < 2 )
        {
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Plz specify the action you want to do with this estate.\n");
            return HOOK_CONTINUE;
        }
        string action=cArgs[1];
        if(action=="buy")
        {

        }
        else if(action=="sell")
        {

        }
        else if(action=="collect")
        {
            
        }
    }
    return HOOK_CONTINUE;
}

HookReturnCode toll_fee(CBasePlayer@ pPlayer)
{
    string id=e_PlayerInventory.GetUniquePlayerId(pPlayer);
    if(Debts.exists(id))
    {
        e_PlayerInventory.ChangeBalance(pPlayer, -int(Debts[id]));
        Debts.delete(id);
        UpdateDebtList();
    }
    return HOOK_CONTINUE;
}