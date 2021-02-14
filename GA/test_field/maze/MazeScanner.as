void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "I love Carol forever and ever!\n");
}

CClientCommand g_GetEnhanced("scan", "Start Maze Scanning!!!!", @ScanMaze);
void ScanMaze(const CCommand@ pArgs)
{
    CBasePlayer@ pPlayer=g_ConCommandSystem.GetCurrentPlayer();
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Start Maze Scanning\n");
    int z=68;
    int start_x=0;
    int start_y=0;
    int end_x=1024;
    int end_y=-1024;
    int stride=8;
    int dx=end_x-start_x;
    int dy=end_y-start_y;
    int x_scan_lines=dx/stride;
    // x_scan_lines=8;
    for(int i=0;i<x_scan_lines;i++)
    {
        int ScanX=i*stride;
        int ScanY=0;
        int ScanZ=z;
        ScanLine(float(ScanX),float(ScanY),float(ScanZ),float(dy),pPlayer);
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "\n");
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "\n");
    }
}

void ScanLine(float ScanX,float ScanY,float ScanZ,float dy,CBasePlayer@ pPlayer)
{
    TraceResult tr;
    Vector vecSrc=Vector(ScanX,ScanY,ScanZ);
    Vector vecEnd=Vector(ScanX,dy,ScanZ);
    g_Utility.TraceLine(vecSrc, vecEnd, ignore_monsters, ignore_glass, pPlayer.edict(), tr);
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "AllSolid:"+string(tr.fAllSolid)+" StartSolid:"+string(tr.fStartSolid)+" Start:"+vecSrc.ToString()+" End:"+tr.vecEndPos.ToString()+"\n");
    while((vecEnd-tr.vecEndPos).Length()>1.0)
    {
        vecSrc=tr.vecEndPos;
        vecSrc.y-=1.0;
        g_Utility.TraceLine(vecSrc, vecEnd, ignore_monsters, ignore_glass, pPlayer.edict(), tr);

        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "AllSolid:"+string(tr.fAllSolid)+" StartSolid:"+string(tr.fStartSolid)+" Start:"+vecSrc.ToString()+" End:"+tr.vecEndPos.ToString()+"\n");
    }
}