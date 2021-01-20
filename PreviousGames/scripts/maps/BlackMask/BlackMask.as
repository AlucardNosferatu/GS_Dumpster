string szEntFile="BlackMask/BlackMask.ent";

void MapActivate()
{
	g_EngineFuncs.ServerPrint("Try to load ent file\n");
	if ( !g_EntityLoader.LoadFromFile( szEntFile ) )
		g_EngineFuncs.ServerPrint( "Can't open " + szEntFile + "\n" );
}

void MapInit()
{
	g_EngineFuncs.ServerPrint("I love Carol forever and ever!\n");
}