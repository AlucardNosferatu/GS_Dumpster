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
    g_Scheduler.SetInterval( "UpdateProfit", 6, g_Scheduler.REPEAT_INFINITE_TIMES);
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
}