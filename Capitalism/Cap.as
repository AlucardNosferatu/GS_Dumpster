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
    g_Scheduler.SetInterval( "UpdateProfit", 600, g_Scheduler.REPEAT_INFINITE_TIMES);
}

void InitBank()
{
    File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/bank.txt" , OpenFile::READ);
    if( fHandle !is null ) 
    {
        string sLine;
        fHandle.ReadLine(sLine);
        bank_cap=atof(sLine.Split("\t")[1]);
        while(sLine.Length()>0)
        {
            fHandle.ReadLine(sLine);
            Accounts.insertLast(sLine);
        }
        fHandle.Close();
    }
}

void UpdateProfit()
{
    int pCount=g_PlayerFuncs.GetNumPlayers();
    for(int i=0;i<pCount;i++)
    {
        CBasePlayer@ pPlayer=g_PlayerFuncs.FindPlayerByIndex(i);
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
                profit=atof(sLine.Split("\t")[1]));
                fHandle.ReadLine(sLine);
                profRate=atof(sLine.Split("\t")[1]);
                fHandle.Close();
            }
        }
        else
        {
            Accounts.insertLast(PlayerUniqueId);
            @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/bank.txt" , OpenFile::WRITE);
            if( fHandle !is null ) 
            {
                fHandle.Write("CAPITAL\t"+formatFloat(bank_cap,"0",0,4)+"\n");
                for(uint i=0;i<Accounts.length();i++)
                {
                    fHandle.Write(Accounts[i]+"\n");
                }
                fHandle.Close();
            }
        }
        profit+=(balance*profRate/6);
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