#include "Ecco/Include"
dictionary Bet;
dictionary Players;

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "My-Dearest-Girl...Ms.Carol!\n");
    InitEcco();
    InitCasino();
}

void InitCasino()
{
    g_Hooks.RegisterHook(Hooks::Player::ClientSay, @bet);
    g_Hooks.RegisterHook(Hooks::Player::PlayerKilled, @check_corpse);
}

void CheckBet()
{

}


HookReturnCode bet(SayParameters@ pParams)
{
    CBasePlayer@ pPlayer = pParams.GetPlayer();
    const CCommand@ cArgs = pParams.GetArguments();
    if(pPlayer !is null && (cArgs[0].ToLowercase() == "!bet" || cArgs[0].ToLowercase() == "/bet"))
    {
        if(Bet.exists("Status") and string(Bet["Status"])=="OnGoing")
        {
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Plz wait until current game finishes.\n");
            return HOOK_CONTINUE;
        }
        else
        {
            if( cArgs.ArgC() < 2 )
            {
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Plz specify the type of bet and value of odds you want to play.\n");
                return HOOK_CONTINUE;
            }
            string PlayerUniqueId = e_PlayerInventory.GetUniquePlayerId(pPlayer);
            string Game=cArgs[1];
            
            Bet.set("Banker", PlayerUniqueId);
            Bet.set("Game", Game);
            
            if(Game.StartsWith("survive_"))
            {
                if( cArgs.ArgC() < 3 )
                {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Plz specify the target to check.\n");
                    return HOOK_CONTINUE;
                }
                string Target=cArgs[2];
                Bet.set('Target', Target);
                Bet.set("Status","OnGoing")
                int seconds_to_check=atoi(Game.Split("_")[1]);
                g_Scheduler.SetInterval( "CheckBet", seconds_to_check, 1);
            }
            else if(Game.StartsWith("score_"))
            {
                Bet.set("Status","OnGoing")
                int seconds_to_check=atoi(Game.Split("_")[1]);
                g_Scheduler.SetInterval( "CheckBet", seconds_to_check, 1);
            }
            else
            {
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Unknown type of game.\n");
                return HOOK_CONTINUE;
            }
        }
        return HOOK_CONTINUE;
    }
    else if(pPlayer !is null && (cArgs[0].ToLowercase() == "!gamble" || cArgs[0].ToLowercase() == "/gamble"))
    {
        if( cArgs.ArgC() < 3 )
        {
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Plz specify your stake and target(live/die for survive prediction game).\n");
            return HOOK_CONTINUE;
        }
        string PlayerUniqueId = e_PlayerInventory.GetUniquePlayerId(pPlayer);
        int stake=atoi(cArgs[1]);
        e_PlayerInventory.ChangeBalance(pPlayer, -stake);

        string target=cArgs[2];
        array<string> stake_and_target={cArgs[1],cArgs[2]};
        Players.set[PlayerUniqueId,stake_and_target];
    }
    return HOOK_CONTINUE;
}

HookReturnCode check_corpse(CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib)
{
    if(Bet.exists("Status") and string(Bet["Status"])=="OnGoing" and Bet.exists("Game") and string(Bet["Game"]).StartsWith("survive_"))
    {
        CBasePlayer@ target=g_PlayerFuncs.FindPlayerByName(string(Bet["Target"]));
        
    }
    return HOOK_CONTINUE;
}