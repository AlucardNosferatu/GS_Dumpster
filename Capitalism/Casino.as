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
    string Game=string(Bet["Game"]);
    string Mode=Game.Split("_")[0];//survive or score
    int Time=atoi(Game.Split("_")[1]);//seconds to check
    if(Mode=="survive")
    {
        bool die=(string(Bet["Result"])=="die");
        statement_survive(string(Bet["Banker"]),die);
    }
    else if(Mode=="score")
    {
        int N=atoi(string(Bet["Target"]));
        Bet.set("Result",GetTopN(N));
        statement_score(string(Bet["Banker"]));
    }
    ResetBet();
}

void ResetBet()
{
    Bet.deleteAll();
    Players.deleteAll();
}

string GetTopN(int N)
{
    return "Scrooge_Carol_Drood";
}


void statement_survive(string Banker, bool die)
{
    int lose=0;
    int win=0;
    array<string> users=Players.getKeys();
        int users_count=int(keys.length());
        for(int i=0;i<users_count;i++)
}

void statement_score(string Banker)
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
                Bet.set("Result","live");
                Bet.set("Status","OnGoing")
                int seconds_to_check=atoi(Game.Split("_")[1]);
                g_Scheduler.SetInterval( "CheckBet", seconds_to_check, 1);
            }
            else if(Game.StartsWith("score_"))
            {
                if( cArgs.ArgC() < 3 or )
                {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Plz specify the TopN you want to bet, cannot be larger than half of the current amount of players.\n");
                    return HOOK_CONTINUE;
                }
                string Target=cArgs[2];
                Bet.set('Target', Target);
                Bet.set("Result","wait");
                Bet.set("Status","OnGoing");
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
        return HOOK_CONTINUE;
    }
    return HOOK_CONTINUE;
}

HookReturnCode check_corpse(CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib)
{
    if(Bet.exists("Status") and string(Bet["Status"])=="OnGoing" and Bet.exists("Game") and string(Bet["Game"]).StartsWith("survive_"))
    {
        string PlayerUniqueId = e_PlayerInventory.GetUniquePlayerId(pPlayer);
        CBasePlayer@ target=g_PlayerFuncs.FindPlayerByName(string(Bet["Target"]));
        string TargetUniqueId = e_PlayerInventory.GetUniquePlayerId(target);
        if(PlayerUniqueId==TargetUniqueId)
        {
            Bet.set("Result","die");
        }
        return HOOK_CONTINUE;
    }
    return HOOK_CONTINUE;
}