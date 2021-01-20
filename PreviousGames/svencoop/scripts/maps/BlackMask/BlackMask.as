string szEntFile="store/BlackMask.ent";

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
	g_Hooks.RegisterHook(Hooks::PickupObject::Collected, @CollectedH);
}

string GetBuffType(CBasePlayer@ pPlayer)
{
	int32 choice=Math.RandomLong(0,3);
	if(choice==1)
	{
		return "DMG#75.0";
	}
	else if(choice==2)
	{
		return "HEALTH#2.0";
	}
	return "DMG#75.0";
}

HookReturnCode PlayerKilledH(CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib)
{
	g_EngineFuncs.ServerPrint("Someone died\n");
	CBasePlayerWeapon@ weaponHeld= cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
	File@ fHandle;
	array<string> prev;
	@fHandle  = g_FileSystem.OpenFile( "scripts/maps/"+szEntFile, OpenFile::READ );
	if( fHandle !is null )
	{
		while(!fHandle.EOFReached())
		{
    		string sLine;
        	fHandle.ReadLine(sLine);
			prev.insertLast(sLine);
        }
        fHandle.Close();
	}
	if(prev.length()==1)
	{
		prev.removeAt(0);
	}
	if(prev.length()>81)
	{
		prev.removeAt(0);
		prev.removeAt(0);
		prev.removeAt(0);
		prev.removeAt(0);
		prev.removeAt(0);
		prev.removeAt(0);
		prev.removeAt(0);
		prev.removeAt(0);
		prev.removeAt(0);
	}

	string BTypeStr=GetBuffType(pPlayer);
	float BValueFloat=atof(BTypeStr.Split("#")[1]);
	BTypeStr=BTypeStr.Split("#")[0];

	int DMG_BUFF=0;
	if(BTypeStr=="DMG")
	{
		DMG_BUFF=int(BValueFloat);
	}

	string OriginStr=string(int(pPlayer.pev.origin.x));
	OriginStr+=" ";
	OriginStr+=string(int(pPlayer.pev.origin.y));
	OriginStr+=" ";
	OriginStr+=string(int(pPlayer.pev.origin.z));
	prev.insertLast("{");
	prev.insertLast("  \"origin\" \""+OriginStr+"\"");
	prev.insertLast("  \"targetname\" \"LEGACY_BUFF\"");
	prev.insertLast("  \"classname\" \""+weaponHeld.GetClassname()+"\"");
	prev.insertLast("  \"$s_BUFF_TYPE\" \""+BTypeStr+"\"");
	prev.insertLast("  \"$f_BUFF_VALUE\" \""+formatFloat(BValueFloat,"0",0,2)+"\"");
	prev.insertLast("  \"dmg\" \""+string(DMG_BUFF)+"\"");
	prev.insertLast("  \"spawnflags\" \"1024\"");
	prev.insertLast("}");

	@fHandle  = g_FileSystem.OpenFile( "scripts/maps/"+szEntFile, OpenFile::WRITE );
	if( fHandle !is null )
	{
		for(uint i=0;i<prev.length();i++)
		{
			if(i==prev.length()-1)
			{
				fHandle.Write(prev[i]);
			}
			else
			{
				fHandle.Write(prev[i]+"\n");
			}
		}
		fHandle.Close();
	}
	else
	{
		g_EngineFuncs.ServerPrint("Cant open file, NullPointer returned.\n");
	}
    return HOOK_CONTINUE;
}

HookReturnCode CollectedH( CBaseEntity@ pPickup, CBaseEntity@ pOther )
{
	if(pPickup.GetTargetname()=="LEGACY_BUFF")
	{
		CustomKeyvalues@ CKV=pPickup.GetCustomKeyvalues();
		CustomKeyvalue BUFF_TYPE=CKV.GetKeyvalue("$s_BUFF_TYPE");
		string BTypeStr=BUFF_TYPE.GetString();
		CustomKeyvalue BUFF_VALUE=CKV.GetKeyvalue("$f_BUFF_VALUE");
		float BValueFloat=BUFF_VALUE.GetFloat();
		g_EngineFuncs.ServerPrint("Get BUFF: TYPE-"+BTypeStr+" VALUE-"+string(BValueFloat)+"\n");
		if(BTypeStr=="HEALTH")
		{
			CBasePlayerItem@ BuffItem=cast<CBasePlayerItem@>(pPickup);
			EHandle Owner=BuffItem.m_hPlayer;
			if(Owner.IsValid())
			{
				CBaseEntity@ ePlayer=Owner.GetEntity();
				if(ePlayer !is null)
				{
					CBasePlayer@ pPlayer=cast<CBasePlayer@>(ePlayer);
					pPlayer.pev.health*=BValueFloat;
				}
			}
		}
	}
	return HOOK_CONTINUE;
}