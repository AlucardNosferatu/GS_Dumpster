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
    ScanForward(pPlayer);
    ScanBackward(pPlayer);
}

void ScanForward(CBasePlayer@ pPlayer)
{
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
    File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/ScanResult.txt" , OpenFile::APPEND);
    if( fHandle !is null ) 
    {
        for(int i=0;i<x_scan_lines;i++)
        {
            int ScanX=i*stride;
            int ScanY=start_y;
            int ScanZ=z;
            ScanLineF(float(ScanX),float(ScanY),float(ScanZ),float(end_y),stride,pPlayer,fHandle);
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "\n");
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "\n");
        }
        fHandle.Close();
    }
}

void ScanBackward(CBasePlayer@ pPlayer)
{
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Start Maze Scanning\n");
    int z=68;
    int start_x=0;
    int start_y=-1024;
    int end_x=1024;
    int end_y=0;
    int stride=8;
    int dx=end_x-start_x;
    int dy=end_y-start_y;
    int x_scan_lines=dx/stride;
    File@ fHandle;
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/ScanResult.txt" , OpenFile::APPEND);
    if( fHandle !is null ) 
    {
        for(int i=0;i<x_scan_lines;i++)
        {
            int ScanX=i*stride;
            int ScanY=start_y;
            int ScanZ=z;
            ScanLineB(float(ScanX),float(ScanY),float(ScanZ),float(end_y),stride,pPlayer,fHandle);
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "\n");
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "\n");
        }
        fHandle.Close();
    }
}

void ScanLineF(float ScanX,float ScanY,float ScanZ,float end_y,int stride,CBasePlayer@ pPlayer,File@ fHandle)
{
    TraceResult tr;
    Vector vecSrc=Vector(ScanX,ScanY,ScanZ);
    Vector vecEnd=Vector(ScanX,end_y,ScanZ);
    g_Utility.TraceLine(vecSrc, vecEnd, ignore_monsters, ignore_glass, pPlayer.edict(), tr);
    // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "AllSolid:"+string(tr.fAllSolid)+" StartSolid:"+string(tr.fStartSolid)+" Start:"+vecSrc.ToString()+" End:"+tr.vecEndPos.ToString()+"\n");
    int x_seg=int(ScanX/stride);
    int y_seg_start=int(vecSrc.y/stride);
    int y_seg_end=int(tr.vecEndPos.y/stride);
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "x_seg:"+string(x_seg)+" y_seg_start:"+string(y_seg_start)+" y_seg_end:"+string(y_seg_end)+"\n");
    fHandle.Write("x_seg:"+string(x_seg)+"\ty_seg_start:"+string(y_seg_start)+"\ty_seg_end:"+string(y_seg_end)+"\n");
    while((vecEnd-tr.vecEndPos).Length()>1.0)
    {
        vecSrc=tr.vecEndPos;
        vecSrc.y-=1.0;
        g_Utility.TraceLine(vecSrc, vecEnd, ignore_monsters, ignore_glass, pPlayer.edict(), tr);
        vecSrc.y+=1.0;
        // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "AllSolid:"+string(tr.fAllSolid)+" StartSolid:"+string(tr.fStartSolid)+" Start:"+vecSrc.ToString()+" End:"+tr.vecEndPos.ToString()+"\n");
        y_seg_start=int(vecSrc.y/stride);
        y_seg_end=int(tr.vecEndPos.y/stride);
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "x_seg:"+string(x_seg)+" y_seg_start:"+string(y_seg_start)+" y_seg_end:"+string(y_seg_end)+"\n");
        fHandle.Write("x_seg:"+string(x_seg)+"\ty_seg_start:"+string(y_seg_start)+"\ty_seg_end:"+string(y_seg_end)+"\n");
    }
}

void ScanLineB(float ScanX,float ScanY,float ScanZ,float end_y,int stride,CBasePlayer@ pPlayer,File@ fHandle)
{
    TraceResult tr;
    Vector vecSrc=Vector(ScanX,ScanY,ScanZ);
    Vector vecEnd=Vector(ScanX,end_y,ScanZ);
    g_Utility.TraceLine(vecSrc, vecEnd, ignore_monsters, ignore_glass, pPlayer.edict(), tr);
    // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "AllSolid:"+string(tr.fAllSolid)+" StartSolid:"+string(tr.fStartSolid)+" Start:"+vecSrc.ToString()+" End:"+tr.vecEndPos.ToString()+"\n");
    int x_seg=int(ScanX/stride);
    int y_seg_start=int(vecSrc.y/stride);
    int y_seg_end=int(tr.vecEndPos.y/stride);
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "x_seg:"+string(x_seg)+" y_seg_start:"+string(y_seg_start)+" y_seg_end:"+string(y_seg_end)+"\n");
    fHandle.Write("x_seg:"+string(x_seg)+"\ty_seg_start:"+string(y_seg_start)+"\ty_seg_end:"+string(y_seg_end)+"\n");
    while((vecEnd-tr.vecEndPos).Length()>1.0)
    {
        vecSrc=tr.vecEndPos;
        vecSrc.y+=1.0;
        g_Utility.TraceLine(vecSrc, vecEnd, ignore_monsters, ignore_glass, pPlayer.edict(), tr);
        vecSrc.y-=1.0;
        // g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "AllSolid:"+string(tr.fAllSolid)+" StartSolid:"+string(tr.fStartSolid)+" Start:"+vecSrc.ToString()+" End:"+tr.vecEndPos.ToString()+"\n");
        y_seg_start=int(vecSrc.y/stride);
        y_seg_end=int(tr.vecEndPos.y/stride);
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "x_seg:"+string(x_seg)+" y_seg_start:"+string(y_seg_start)+" y_seg_end:"+string(y_seg_end)+"\n");
        fHandle.Write("x_seg:"+string(x_seg)+"\ty_seg_start:"+string(y_seg_start)+"\ty_seg_end:"+string(y_seg_end)+"\n");
    }
}