#include "Ecco/Include"
array<string> Accounts;
float bank_cap;

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Carol is my angel!\n");
    InitEcco();
    InitBank();
}

void InitBank()
{
    File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/bank.txt" , OpenFile::READ);
    if( fHandle !is null ) 
    {
        string sLine;
        while(true)
        {
            fHandle.ReadLine(sLine);
            if(sLine.Length()>0)
            {
                Accounts.insertLast(sLine);
            }
            else
            {
                break;
            }
        }
        fHandle.Close();
        bank_cap=atof(Accounts[0].Split("\t")[1]);
        Accounts.removeAt(0);
    }
    g_Scheduler.SetInterval( "UpdateProfit", 6, g_Scheduler.REPEAT_INFINITE_TIMES);
    g_Hooks.RegisterHook(Hooks::Player::ClientSay, @deposit);
    g_Hooks.RegisterHook(Hooks::Game::MapChange, @statement);
}

void UpdateProfit()
{
    int pCount=g_PlayerFuncs.GetNumPlayers();
    for(int i=1;i<=pCount;i++)
    {
        CBasePlayer@ pPlayer=g_PlayerFuncs.FindPlayerByIndex(i);
        if ( pPlayer !is null && pPlayer.IsConnected() )
        {
            string PlayerUniqueId = e_PlayerInventory.GetUniquePlayerId(pPlayer);
            File@ fHandle;
            float balance=0;
            float profit=0;
            float profRate=0.1;
            if(Accounts.find(PlayerUniqueId)>=0)
            {
                @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+PlayerUniqueId+".txt" , OpenFile::READ);
                if( fHandle !is null ) 
                {
                    string sLine;
                    fHandle.ReadLine(sLine);
                    balance=atof(sLine.Split("\t")[1]);
                    fHandle.ReadLine(sLine);
                    profit=atof(sLine.Split("\t")[1]);
                    fHandle.ReadLine(sLine);
                    profRate=atof(sLine.Split("\t")[1]);
                    fHandle.Close();
                }
            }
            else
            {
                Accounts.insertLast(PlayerUniqueId);
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Inserting:"+PlayerUniqueId+"\n");
                @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/bank.txt" , OpenFile::WRITE);
                if( fHandle !is null ) 
                {
                    fHandle.Write("CAPITAL\t"+formatFloat(bank_cap,"0",0,4)+"\n");
                    for(uint j=0;j<Accounts.length();j++)
                    {
                        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Creating:"+Accounts[j]+"\n");
                        fHandle.Write(Accounts[j]+"\n");
                    }
                    fHandle.Close();
                }
            }
            profit+=(balance*profRate/60);
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Profiting:"+string(profit)+"\n");
            @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+PlayerUniqueId+".txt" , OpenFile::WRITE);
            if( fHandle !is null ) 
            {
                fHandle.Write("BALANCE\t"+formatFloat(balance,"0",0,4)+"\n");
                fHandle.Write("PROFIT\t"+formatFloat(profit,"0",0,4)+"\n");
                fHandle.Write("PROFIT RATE\t"+formatFloat(profRate,"0",0,4));
                fHandle.Close();
            }
        }
    }
}

HookReturnCode deposit(SayParameters@ pParams)
{
    CBasePlayer@ pPlayer = pParams.GetPlayer();
    const CCommand@ cArgs = pParams.GetArguments();
    if( cArgs.ArgC() < 2 )
        return HOOK_CONTINUE;
    if(pPlayer !is null && (cArgs[0].ToLowercase() == "!deposit" || cArgs[0].ToLowercase() == "/deposit"))
    {
        int fund = atoi(cArgs.Arg(1));
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Depositing:"+string(fund)+"\n");
        string PlayerUniqueId = e_PlayerInventory.GetUniquePlayerId(pPlayer);
        File@ fHandle;
        float balance=0;
        float profit=0;
        float profRate=0.1;
        if(Accounts.find(PlayerUniqueId)>=0)
        {
            @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+PlayerUniqueId+".txt" , OpenFile::READ);
            if( fHandle !is null ) 
            {
                string sLine;
                fHandle.ReadLine(sLine);
                balance=atof(sLine.Split("\t")[1]);
                fHandle.ReadLine(sLine);
                profit=atof(sLine.Split("\t")[1]);
                fHandle.ReadLine(sLine);
                profRate=atof(sLine.Split("\t")[1]);
                fHandle.Close();
            }
            balance+=float(fund);
            e_PlayerInventory.ChangeBalance(pPlayer, -fund);
            @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+PlayerUniqueId+".txt" , OpenFile::WRITE);
            if( fHandle !is null ) 
            {
                fHandle.Write("BALANCE\t"+formatFloat(balance,"0",0,4)+"\n");
                fHandle.Write("PROFIT\t"+formatFloat(profit,"0",0,4)+"\n");
                fHandle.Write("PROFIT RATE\t"+formatFloat(profRate,"0",0,4));
                fHandle.Close();
            }
        }
        else
        {
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Plz wait until your account having been created.\n");
        }
    }
    return HOOK_CONTINUE;
}

HookReturnCode statement()
{
    int pCount=g_PlayerFuncs.GetNumPlayers();
    for(int i=1;i<=pCount;i++)
    {
        CBasePlayer@ pPlayer=g_PlayerFuncs.FindPlayerByIndex(i);
        if ( pPlayer !is null && pPlayer.IsConnected() )
        {
            string PlayerUniqueId = e_PlayerInventory.GetUniquePlayerId(pPlayer);
            File@ fHandle;
            float balance=0;
            float profit=0;
            float profRate=0.1;
            if(Accounts.find(PlayerUniqueId)>=0)
            {
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Doing statement when players leave.\n");
                @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+PlayerUniqueId+".txt" , OpenFile::READ);
                if( fHandle !is null ) 
                {
                    string sLine;
                    fHandle.ReadLine(sLine);
                    balance=atof(sLine.Split("\t")[1]);
                    fHandle.ReadLine(sLine);
                    profit=atof(sLine.Split("\t")[1]);
                    fHandle.ReadLine(sLine);
                    profRate=atof(sLine.Split("\t")[1]);
                    fHandle.Close();
                }
                balance+=profit;
                profit=0;
                @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+PlayerUniqueId+".txt" , OpenFile::WRITE);
                if( fHandle !is null ) 
                {
                    fHandle.Write("BALANCE\t"+formatFloat(balance,"0",0,4)+"\n");
                    fHandle.Write("PROFIT\t"+formatFloat(profit,"0",0,4)+"\n");
                    fHandle.Write("PROFIT RATE\t"+formatFloat(profRate,"0",0,4));
                    fHandle.Close();
                }
            }
        }
    }
	return HOOK_CONTINUE;
}