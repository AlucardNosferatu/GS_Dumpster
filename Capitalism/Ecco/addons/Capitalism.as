namespace Capitalism
{
    void Activate()
    {
        e_ScriptParser.Register("buycount", CustomMacro(buycount));
        e_ScriptParser.Register("discount", CustomMacro(discount));
    }

    bool buycount(CBasePlayer@ pPlayer, array<string>@ args)
    {
        string weaponClassname=args[0];
        int countTotal=0;
        int countThis=0;
        float currentRatio=0.0;
        float fluctuation=0.0;

        File@ fHandle;
        
        @fHandle = g_FileSystem.OpenFile( "scripts/plugins/store/total.price" , OpenFile::READ);
        if( fHandle !is null ) 
        {
            string sLine;
            fHandle.ReadLine(sLine);
            countTotal=atoi(sLine.Split("\t")[1]);
            fHandle.Close();
            countTotal+=1;
        }
        else
        {
            countTotal=1;
        }

        @fHandle = g_FileSystem.OpenFile( "scripts/plugins/store/total.price" , OpenFile::WRITE);
        if( fHandle !is null )
        {
            fHandle.Write("TOTAL_DEAL_COUNT\t"+string(countTotal));
            fHandle.Close();
        }
        else
        {
            return false;
        }

        @fHandle = g_FileSystem.OpenFile( "scripts/plugins/store/"+weaponClassname+".price" , OpenFile::READ);
        if( fHandle !is null ) 
        {
            string sLine;
            fHandle.ReadLine(sLine);
            countThis=atoi(sLine.Split("\t")[1]);
            fHandle.ReadLine(sLine);
            float LastRecordedRatio=atof(sLine.Split("\t")[1]);
            float PreviousRatio=(float(countThis)/float(countTotal-1));
            currentRatio=(LastRecordedRatio+PreviousRatio)/2;
            fHandle.ReadLine(sLine);
            fluctuation=atof(sLine.Split("\t")[1]);
            fHandle.Close();
            countThis+=1;
            fluctuation=(float(countThis)/float(countTotal))-currentRatio;
            currentRatio=float(countThis)/float(countTotal);
        }
        else
        {
            countThis=1;
            fluctuation=(float(countThis)/float(countTotal))-0.0;
            currentRatio=float(countThis)/float(countTotal);
        }

        @fHandle = g_FileSystem.OpenFile( "scripts/plugins/store/"+weaponClassname+".price" , OpenFile::WRITE);
        if( fHandle !is null )
        {
            fHandle.Write("DEAL_COUNT\t"+string(countThis)+"\n");
            fHandle.Write("MARKET_SHARE\t"+formatFloat(currentRatio,"0",0,4)+"\n");
            fHandle.Write("PRICE_FLUC\t"+formatFloat(fluctuation,"0",0,4));
            fHandle.Close();
        }
        else
        {
            return false;
        }
        return true;
    }

    bool discount(CBasePlayer@ pPlayer, array<string>@ args)
    {
        string weaponClassname=args[0];

        int countThis=0;
        float currentRatio=0.0;
        float fluctuation=0.0;

        File@ fHandle;

        @fHandle = g_FileSystem.OpenFile( "scripts/plugins/store/"+weaponClassname+".price" , OpenFile::READ);
        if( fHandle !is null ) 
        {
            string sLine;
            fHandle.ReadLine(sLine);
            countThis=atoi(sLine.Split("\t")[1]);
            fHandle.ReadLine(sLine);
            currentRatio=atof(sLine.Split("\t")[1]);
            fHandle.ReadLine(sLine);
            fluctuation=atof(sLine.Split("\t")[1]);
            fluctuation*=10;
            fHandle.Close();
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Fluc:"+formatFloat(fluctuation,"0",0,4)+"\n");

            string weaponFile="scripts/plugins/Ecco/scripts/"+weaponClassname+".echo";
            File@ file = g_FileSystem.OpenFile(weaponFile, OpenFile::READ);
            if(file !is null)
            {
                file.Close();
                dictionary WeaponInfo=e_ScriptParser.RetrieveInfo(weaponFile);
                float PriceInfo=atof(string(WeaponInfo['cost']));
                float discount;
                if(PriceInfo>1)
                {
                    if(fluctuation>-0.9)
                    {
                        //跌幅不超过90%，购买减免跌幅*底价
                        discount=-(fluctuation*PriceInfo);
                    }
                    else
                    {
                        //跌幅超过90%，折扣模式为1元购（返利模式，先款不足无法购买）防止倒贴现金
                        discount=1-PriceInfo;
                    }
                }
                else
                {
                    //基础物资（撬棍、藤壶、扳手）为计划经济，不参与市场调控
                    discount=0.0;
                }
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Disc:"+formatFloat(discount,"0",0,4)+"\n");
                e_PlayerInventory.ChangeBalance(pPlayer, int(discount));
            }
            else
            {
                return false;
            }
            return true;
        }
        else
        {
            return false;
        }
    }
}