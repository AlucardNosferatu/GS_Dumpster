string szEntFile="BlackMask/BlackMask.ent"

void MapActivate()
{
	if ( !g_EntityLoader.LoadFromFile( szEntFile ) )
		g_EngineFuncs.ServerPrint( "Can't open " + szEntFile + "\n" );
}

void MapInit()
{
	g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "I love Carol forever and ever!\n");
}