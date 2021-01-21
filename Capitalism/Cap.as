#include "Ecco/Include"
array<string> Accounts;
int bank_cap;

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
        fHandle.ReadLine(sLine);
        bank_cap=atoi(sLine.Split("\t")[1]);
        while(sLine.Length()>0)
        {
            fHandle.ReadLine(sLine);
            Accounts.insertLast(sLine);
        }
    }
    fHandle.Close();
}

void UpdateAccount(CBasePlayer@ pPlayer)
{
    string PlayerUniqueId = e_PlayerInventory.GetUniquePlayerId(pPlayer);
    File@ fHandle;
    int balance=0;
    int profit=0;
    float profRate=0.1;
    if(Accounts.find(PlayerUniqueId)>=0)
    {
        @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+PlayerUniqueId+".txt" , OpenFile::READ);
        if( fHandle !is null ) 
        {
            string sLine;
            fHandle.ReadLine(sLine);
        }
        fHandle.Close();
    }
    else
    {
        Accounts.insertLast(PlayerUniqueId);
    }
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/"+PlayerUniqueId+".txt" , OpenFile::WRITE);
    if( fHandle !is null ) 
    {   
        fHandle.Write("BALANCE\t"+string(balance)+"\n");
        fHandle.Write("PROFIT\t"+string(profit)+"\n");
        fHandle.Write("PROFIT RATE\t"+string(profRate));
    }
    fHandle.Close();
}