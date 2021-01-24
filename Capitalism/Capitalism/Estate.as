#include "../Ecco/Include"
dictionary Estates;


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
    g_Scheduler.SetInterval( "UpdateVisitors", 600, g_Scheduler.REPEAT_INFINITE_TIMES);
    g_Hooks.RegisterHook(Hooks::Player::ClientSay, @estate_servive);
}

void GetEstateList()
{
    File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/estates.txt" , OpenFile::READ);
    if( fHandle !is null ) 
    {
        string sLine;
        while(true)
        {
            fHandle.ReadLine(sLine);
            if(sLine.Length()>0)
            {
                array<string> EsInfo=sLine.Split("\t");
                if(EsInfo.length()==3)
            }
            else
            {
                break;
            }
        }
        fHandle.Close();
    }
}

void UpdateEstateList()
{
    File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/estates.txt" , OpenFile::WRITE);
    if( fHandle !is null ) 
    {
        array<string> mapnames=Estates.getKeys();
        int maps_count=int(mapnames.length());
        for(int i=0;i<maps_count;i++)
        {
            array<string> infoArray=cast<array<string>>(Estates[mapnames[i]]);
            string price=infoArray[0];
            string owner=infoArray[1];
            string status=infoArray[2];
            if(i==maps_count-1)
            {
                fHandle.Write(mapnames[i]+"\t"+price+"\t"+owner+"\t"+status);
            }
            else
            {
                fHandle.Write(mapnames[i]+"\t"+price+"\t"+owner+"\t"+status+"\n");
            }
        }
        fHandle.Close();
    }
}

void UpdateVisitors()
{
    
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
            int price=0;
            CBaseEntity@ pWorld = g_EntityFuncs.Instance(0);
            Vector wSize=pWorld.pev.size;
            price=int(wSize.x*wSize.y*wSize.z);
            if(e_PlayerInventory.GetBalance(pPlayer)>price)
            {
                e_PlayerInventory.ChangeBalance(pPlayer, -price);
                array<string> infoArray;
                string UID=e_PlayerInventory.GetUniquePlayerId(pPlayer);
                infoArray.insertLast(string(price));
                infoArray.insertLast(UID);
                infoArray.insertLast("SOLD");
                Estates.set(g_Engine.mapname,infoArray);
                UpdateEstateList();
            }
            else
            {
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "No enough cash!\n");
                return HOOK_CONTINUE;
            }

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