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
	g_Hooks.RegisterHook(Hooks::Player::PlayerKilled, @PlayerKilledH);
}

HookReturnCode PlayerKilledH(CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib)
{
	g_EngineFuncs.ServerPrint("Someone died\n");
	CBasePlayerWeapon@ weaponHeld= cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
	File@ fHandle;
	@fHandle  = g_FileSystem.OpenFile( szEntFile, OpenFile::APPEND );
	if( fHandle !is null )
	{
		fHandle.Write("{\n");
		fHandle.Write("  \"origin\" \""+pPlayer.pev.origin.ToString()+"\"\n");
		fHandle.Write("  \"angles\" \"0 0 0\"\n");
		fHandle.Write("  \"classname\" \""+weaponHeld.GetClassname()+"\"\n");
		fHandle.Write("}\n");
		fHandle.Close();
	}
	else
	{
		g_EngineFuncs.ServerPrint("Cant open file, NullPointer returned.\n");
	}
    return HOOK_CONTINUE;
}