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
        int countThis=0;
        int countTotal=0;
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
            currentRatio=atof(sLine.Split("\t")[1]);
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
        return true;
    }

}