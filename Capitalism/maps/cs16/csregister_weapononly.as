#include "weapons"
#include "BuyMenu"

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor( "KernCore" );
	g_Module.ScriptInfo.SetContactInfo( "https://discord.gg/0wtJ6aAd7XOGI6vI" );
	//Change each weapon's iPosition here so they don't conflict with Map's weapons
	//Melees
	CS16_KNIFE::POSITION 		= 14;
	//Pistols
	CS16_GLOCK18::POSITION 		= 13;
	CS16_USP::POSITION 			= 14;
	CS16_P228::POSITION 		= 15;
	CS16_57::POSITION 			= 16;
	CS16_ELITES::POSITION 		= 17;
	CS16_DEAGLE::POSITION 		= 18;
	//Shotguns
	CS16_M3::POSITION 			= 11;
	CS16_XM1014::POSITION 		= 12;
	//Submachine Guns
	CS16_MAC10::POSITION 		= 13;
	CS16_TMP::POSITION 			= 14;
	CS16_MP5::POSITION 			= 15;
	CS16_UMP45::POSITION 		= 16;
	CS16_P90::POSITION 			= 17;
	//Assault Rifles
	CS16_FAMAS::POSITION 		= 10;
	CS16_GALIL::POSITION 		= 11;
	CS16_AK47::POSITION 		= 12;
	CS16_M4A1::POSITION 		= 13;
	CS16_AUG::POSITION 			= 14;
	CS16_SG552::POSITION 		= 15;
	//Sniper Rifles
	CS16_SCOUT::POSITION 		= 11;
	CS16_AWP::POSITION 			= 12;
	CS16_SG550::POSITION 		= 13;
	CS16_G3SG1::POSITION 		= 14;
	//Light Machine Guns
	CS16_M249::POSITION 		= 15;
	//Misc
	CS16_HEGRENADE::POSITION 	= 10;
	CS16_C4::POSITION 			= 16;
}

void MapInit()
{
	RegisterAll();
}