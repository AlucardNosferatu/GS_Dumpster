#include "../Ecco/Include"
dictionary Bet;
dictionary Players;
dictionary Debts;

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
    InitDebtList();
    g_Hooks.RegisterHook(Hooks::Player::ClientSay, @bet);
    g_Hooks.RegisterHook(Hooks::Player::PlayerKilled, @check_corpse);
    g_Hooks.RegisterHook(Hooks::Player::ClientPutInServer, @check_debt);
}

void InitDebtList()
{
    File@ fHandle;
    @fHandle = g_FileSystem.OpenFile( "scripts/plugins/store/Debts.txt" , OpenFile::READ);
    if( fHandle !is null )
    {
        string sLine;
        while(!fHandle.EOFReached())
        {
            fHandle.ReadLine(sLine);
            if(sLine.Length()>0)
            {
                string gambler=sLine.Split("\t")[0];
                int debt=atoi(sLine.Split("\t")[1]);
                Debts.set(gambler,debt);
            }
        }
        fHandle.Close();
    }
}

void UpdateDebtList()
{
    File@ fHandle;
    @fHandle = g_FileSystem.OpenFile( "scripts/plugins/store/Debts.txt" , OpenFile::WRITE);
    if( fHandle !is null )
    {
        array<string> gamblers=Debts.getKeys();
        int gamblers_count=int(gamblers.length());
        for(int i=0;i<gamblers_count;i++)
        {
            if(i==gamblers_count-1)
            {
                fHandle.Write(gamblers[i]+"\t"+string(int(Debts[gamblers[i]])));
            }
            else
            {
                fHandle.Write(gamblers[i]+"\t"+string(int(Debts[gamblers[i]]))+"\n");
            }
        }
        fHandle.Close();
    }
}

void CheckBet()
{
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Time to check bet.\n");
    string Game=string(Bet["Game"]);
    string Mode=Game.Split("_")[0];//survive or score
    int Time=atoi(Game.Split("_")[1]);//seconds to check
    if(Mode=="survive")
    {
        statement_survive(string(Bet["Banker"]),string(Bet["Result"]));
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

void statement_survive(string Banker, string die)
{
    CBasePlayer@ pBanker=e_PlayerInventory.FindPlayerById(Banker);
    if(pBanker is null)
    {
        array<string> gamblers=Players.getKeys();
        int gamblers_count=int(gamblers.length());
        for(int i=0;i<gamblers_count;i++)
        {
            CBasePlayer@ pGamble=e_PlayerInventory.FindPlayerById(gamblers[i]);
            array<string> gamble=cast<array<string>>(Players[gamblers[i]]);
            int Stake=atoi(gamble[0]);
            string Target=gamble[1];
            float odds;
            if(pGamble !is null)
            {
                e_PlayerInventory.ChangeBalance(pGamble, Stake);
            }
        }
    }
    else
    {
        float odds_live=atof(string(Bet["Game"]).Split("_")[2]);
        float odds_die=1/odds_live;

        array<string> gamblers=Players.getKeys();
        int gamblers_count=int(gamblers.length());
        for(int i=0;i<gamblers_count;i++)
        {
            CBasePlayer@ pGamble=e_PlayerInventory.FindPlayerById(gamblers[i]);
            array<string> gamble=cast<array<string>>(Players[gamblers[i]]);
            int Stake=atoi(gamble[0]);
            string Target=gamble[1];
            float odds;
            if(Target=="live")
            {
                odds=odds_live;
            }
            else
            {
                odds=odds_die;
            }   
            if(die==Target)
            {
                if(pGamble !is null)
                {
                    e_PlayerInventory.ChangeBalance(pGamble, Stake);
                    e_PlayerInventory.ChangeBalance(pGamble, int(Stake*odds));
                    e_PlayerInventory.ChangeBalance(pBanker, int(-Stake*odds));
                }
            }
            else
            {
                if(pGamble !is null)
                {
                    e_PlayerInventory.ChangeBalance(pGamble, int(-Stake*odds));
                    e_PlayerInventory.ChangeBalance(pBanker, int(Stake*odds));
                }
                else
                {
                    e_PlayerInventory.ChangeBalance(pBanker, int(Stake*odds));
                    Debts.set(gamblers[i],int(Stake*odds));
                    UpdateDebtList();
                }
            }
        }
    }

}

void statement_score(string Banker)
{
    CBasePlayer@ pBanker=e_PlayerInventory.FindPlayerById(Banker);
    if(pBanker is null)
    {
        array<string> gamblers=Players.getKeys();
        int gamblers_count=int(gamblers.length());
        for(int i=0;i<gamblers_count;i++)
        {
            CBasePlayer@ pGamble=e_PlayerInventory.FindPlayerById(gamblers[i]);
            array<string> gamble=cast<array<string>>(Players[gamblers[i]]);
            int Stake=atoi(gamble[0]);
            string Target=gamble[1];
            float odds;
            if(pGamble !is null)
            {
                e_PlayerInventory.ChangeBalance(pGamble, Stake);
            }
        }
    }
    else
    {
        array<string> TopN=string(Bet["Result"]).Split("_");
        int N=int(TopN.length());
        float odds_miss=atof(string(Bet["Game"]).Split("_")[2]);
        float odds_match_modifier=atof(string(Bet["Game"]).Split("_")[3]);

        array<string> gamblers=Players.getKeys();
        int gamblers_count=int(gamblers.length());
        for(int i=0;i<gamblers_count;i++)
        {
            CBasePlayer@ pGamble=e_PlayerInventory.FindPlayerById(gamblers[i]);
            array<string> gamble=cast<array<string>>(Players[gamblers[i]]);
            int Stake=atoi(gamble[0]);
            string Target=gamble[1];
            float odds;
            int order=TopN.find(Target);
            if(order>=0)
            {
                odds=odds_match_modifier*(N-order);
                if(pGamble !is null)
                {
                    e_PlayerInventory.ChangeBalance(pGamble, Stake);
                    e_PlayerInventory.ChangeBalance(pGamble, int(Stake*odds));
                    e_PlayerInventory.ChangeBalance(pBanker, int(-Stake*odds));
                }
            }
            else
            {
                odds=odds_miss;
                if(pGamble !is null)
                {
                    e_PlayerInventory.ChangeBalance(pGamble, int(-Stake*odds));
                    e_PlayerInventory.ChangeBalance(pBanker, int(Stake*odds));
                }
                else
                {
                    e_PlayerInventory.ChangeBalance(pBanker, int(Stake*odds));
                    Debts.set(gamblers[i],int(Stake*odds));
                    UpdateDebtList();
                }
            }
        }
    }
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
            if(Game.StartsWith("survive_"))
            {
                if( cArgs.ArgC() < 3 )
                {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Plz specify the target to check.\n");
                    return HOOK_CONTINUE;
                }
                string Target=cArgs[2];
                CBasePlayer@ pTarget = g_PlayerFuncs.FindPlayerByName(Target);
                if(pTarget is null)
                {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Invalid Target Player.\n");
                    return HOOK_CONTINUE;
                }
                if(Game.Split("_").length()!=3)
                {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "survive_#seconds#_#odds#.\n");
                    return HOOK_CONTINUE;
                }
                Bet.set("Banker", PlayerUniqueId);
                Bet.set("Game", Game);
                Bet.set('Target', Target);
                Bet.set("Result","live");
                Bet.set("Status","OnGoing");
                int seconds_to_check=atoi(Game.Split("_")[1]);
                g_Scheduler.SetInterval( "CheckBet", seconds_to_check, 1);
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Game set.\n");
            }
            else if(Game.StartsWith("score_"))
            {
                if( cArgs.ArgC() < 3 )
                {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Plz specify the TopN you want to bet, cannot be larger than half of the current amount of players.\n");
                    return HOOK_CONTINUE;
                }
                string Target=cArgs[2];
                if(Game.Split("_").length()!=4)
                {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "score_#seconds#_#odds@miss#_#odds@match#.\n");
                    return HOOK_CONTINUE;
                }
                Bet.set("Banker", PlayerUniqueId);
                Bet.set("Game", Game);
                Bet.set('Target', Target);
                Bet.set("Result","wait");
                Bet.set("Status","OnGoing");
                int seconds_to_check=atoi(Game.Split("_")[1]);
                g_Scheduler.SetInterval( "CheckBet", seconds_to_check, 1);
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Game set.\n");
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
        if(Bet.exists("Status") and string(Bet["Status"])=="OnGoing")
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
            Players.set(PlayerUniqueId,stake_and_target);
            return HOOK_CONTINUE;
        }
        else
        {
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "No bet is on currently.\n");
            return HOOK_CONTINUE;
        }
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

HookReturnCode check_debt(CBasePlayer@ pPlayer)
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