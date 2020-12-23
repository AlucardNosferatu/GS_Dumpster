/* SCXPM Version 17.0 by Silencer
** 
** 
** 
** Special Thanks to:
** 
** VEN			For heavily improving my Scripting-Skills.  ;p 
** darkghost9999	For his great Ideas!
** 
** 
** Thanks to:
** 
** ThomasNguyen
** `666
** g3x
** 
*/

#include <amxmodx>
#include <amxmisc>
#include <core>
#include <fakemeta>
#include <fun>

#define VERSION "17.0"
#define LASTUPDATE "12th, October (10), 2006"


new xp[33]
new neededxp[33]
new playerlevel[33]
new rank[33][32]
new skillpoints[33]
new medals[35]
new health[33]
new armor[33]
new rhealth[33]
new rarmor[33]
new rammo[33]
new gravity[33]
new speed[33]
new dist[33]
new dodge[33]
new rarmorwait[33]
new rhealthwait[33]
new ammowait[33]
new starthealth
new startarmor
new lastfrags[33]
new lastDeadflag[33]
new bool:onecount
new bool:has_godmode[33]

public plugin_init()
{
	register_plugin("SCXPM",VERSION,"Silencer")
	register_menucmd(register_menuid("Select Skill"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9),"SCXPMSkillChoice")
	register_forward(FM_GetGameDescription,"scxpm_gn")
	register_forward(FM_PlayerPreThink,"scxpm_prethink")
	register_concmd("setlvl","scxpm_setlvl",ADMIN_IMMUNITY,"Playername Value - Will set Players Level")
	register_concmd("addmedal","scxpm_addmedal",ADMIN_IMMUNITY,"Playername - Will award Player with a Medal")
	register_concmd("removemedal","scxpm_removemedal",ADMIN_IMMUNITY,"Playername - Will remove a Medal of a Player")
	register_concmd("godmode","scxpm_godmode",ADMIN_IMMUNITY,"Playername - Toggle Players God Mode On or Off.")
	register_concmd("noclipmode","scxpm_noclipmode",ADMIN_IMMUNITY,"Playername - Toggle Players God Mode On or Off.")
	register_concmd("say saveall","scxpm_removed",-1,"- REMOVED")
	register_concmd("say selectskills","SCXPMSkill",-1,"- Opens the Skill Choice Menu, if you have Skillpoints available")
	register_concmd("say resetskills","scxpm_reset",-1,"- Will reset your Skills so you can rechoose them")
	register_concmd("say playerskills","scxpm_others",-1,"- Will print Other Players Stats")
	register_concmd("say skillsinfo","scxpm_info",-1,"- Will print Information about all Skills")
	register_concmd("say scxpminfo","scxpm_version",-1,"- Will print Information about SCXPM")
	register_concmd("say /saveall","scxpm_removed",-1,"- REMOVED")
	register_concmd("say /selectskills","SCXPMSkill",-1,"- Opens the Skill Choice Menu, if you have Skillpoints available")
	register_concmd("say /resetskills","scxpm_reset",-1,"- Will reset your Skills so you can rechoose them")
	register_concmd("say /playerskills","scxpm_others",-1,"- Will print Other Players Stats")
	register_concmd("say /skillsinfo","scxpm_info",-1,"- Will print Information about all Skills")
	register_concmd("say /scxpminfo","scxpm_version",-1,"- Will print Information about SCXPM")
	register_concmd("saveall","scxpm_removed",-1,"- REMOVED")
	register_concmd("selectskills","SCXPMSkill",0,"- Opens the Skill Choice Menu, if you have Skillpoints available")
	register_concmd("resetskills","scxpm_reset",0,"- Will reset your Skills so you can rechoose them")
	register_concmd("playerskills","scxpm_others",0,"- Will print Other Players Stats")
	register_concmd("skillsinfo","scxpm_info",0,"- Will print Information about all Skills")
	register_concmd("scxpminfo","scxpm_version",0,"- Will print Information about SCXPM")
	register_cvar("amx_scxpm_gamename","1")
	register_cvar("amx_scxpm_xpgain","1.0")
	set_task(0.5,"scxpm_sdac",0,"",0,"b")
}

public scxpm_gn()
{ 
	if(get_cvar_num("amx_scxpm_gamename")>=1)
	{
		new g[32]
		format(g,31,"SCXPM %s",VERSION)
		forward_return(FMV_STRING,g)
		return FMRES_SUPERCEDE
	}
	return PLUGIN_HANDLED
}

public scxpm_setlvl(id,level,cid)
{
	if(!cmd_access(id,ADMIN_IMMUNITY,cid,3))
	{
		return PLUGIN_HANDLED
	}
	new targetarg[32]
	read_argv(1,targetarg,31)
	new target=cmd_target(id,targetarg,11)
	if(!target)
	{
		return PLUGIN_HANDLED
	}
	new lvlarg[32]
	read_argv(2,lvlarg,31)
	new nowlvl=str_to_num(lvlarg)
	new name[32]
	get_user_name(target,name,31)
	if(nowlvl>1800)
	{
		nowlvl=1800
	}
	else
	{
		if(nowlvl<0)
		{
			nowlvl=0
		}
	}
	if(nowlvl==playerlevel[target])
	{
		if(target==id)
		{
			console_print(id,"[SCXPM] Your Level is already %i.",nowlvl)
		}
		else
		{
			console_print(id,"[SCXPM] %s's Level is already %i.",name,nowlvl)
		}
		return PLUGIN_HANDLED
	}
	else
	{
		if(nowlvl>=1800)
		{
			nowlvl=1800
			xp[target]=11500000
		}
		else
		{
			if(nowlvl<=0)
			{
				nowlvl=0
				xp[target]=0
			}
			else
			{
				new helpvar=nowlvl-1
				new Float:m70b=float(helpvar)*70.0
				new Float:mselfm3dot2b=float(helpvar)*float(helpvar)*3.5
				xp[target]=floatround(m70b+mselfm3dot2b+30.0)
			}
		}
	}
	if(playerlevel[target]>nowlvl)
	{
		playerlevel[target]=nowlvl
		if(target==id)
		{
			console_print(id,"[SCXPM] You lowered your Level to %i. Calling Skill Reset!",playerlevel[target])
		}
		else
		{
			console_print(id,"[SCXPM] You lowered %s's Level to %i.",name,playerlevel[target])
		}
		if(nowlvl>0)
		{
			if(target!=id)
			{
				client_print(target,print_chat,"[SCXPM] An Admin has lowered your Level to %i! Calling Skill Reset!",playerlevel[target])
			}
			scxpm_reset(target)
		}
		else
		{
			if(target!=id)
			{
				client_print(target,print_chat,"[SCXPM] An Admin has lowered your Level to 0! You lost all Skills!")
			}
			health[target]=0
			armor[target]=0
			rhealth[target]=0
			rarmor[target]=0
			rammo[target]=0
			gravity[target]=0
			speed[target]=0
			dist[target]=0
			dodge[target]=0
			skillpoints[target]=0
			if(get_user_health(target)>starthealth)
			{
				set_user_health(target,starthealth)
			}
			if(get_user_armor(target)>startarmor)
			{
				set_user_armor(target,startarmor)
			}
			set_user_gravity(target,1.0)
		}
	}
	else
	{
		if(nowlvl<1800)
		{
			skillpoints[target]=skillpoints[target]+nowlvl-playerlevel[target]
			playerlevel[target]=nowlvl
			if(target==id)
			{
				console_print(id,"[SCXPM] You raised your Level to %i.",playerlevel[target])
			}
			else
			{
				console_print(id,"[SCXPM] You raised %s's Level to %i.",name,playerlevel[target])
				client_print(target,print_chat,"[SCXPM] An Admin has raised your Level to %i! Calling Skill Menu!",playerlevel[target])
			}
			SCXPMSkill(target)
		}
		else
		{
			set_user_health(target,get_user_health(target)+450-health[target])
			set_user_armor(target,get_user_armor(target)+450-armor[target])
			health[target]=450
			armor[target]=450
			rhealth[target]=300
			rarmor[target]=300
			rammo[target]=30
			gravity[target]=40
			speed[target]=80
			dist[target]=60
			dodge[target]=90
			skillpoints[target]=0
			playerlevel[target]=1800
			if(target==id)
			{
				console_print(id,"[SCXPM] You raised your Level to 1800.")
			}
			else
			{
				console_print(id,"[SCXPM] You raised %s's Level to 1800.",name)
				client_print(target,print_chat,"[SCXPM] An Admin has raised your Level to 1800! You got all Skills!")
			}
		}
	}
	scxpm_calcneedxp(target)
	return PLUGIN_HANDLED
}

public scxpm_addmedal(id,level,cid)
{
	if(!cmd_access(id,ADMIN_IMMUNITY,cid,2))
	{
		return PLUGIN_HANDLED
	}
	new targetarg[32]
	read_argv(1,targetarg,31)
	new target=cmd_target(id,targetarg,11)
	if(!target)
	{
		return PLUGIN_HANDLED
	}
	new name[32]
	get_user_name(target,name,31)
	if(medals[target]<16)
	{
		medals[target]+=1
		console_print(id,"You awarded %s with a Medal.",name)
		client_print(0,print_chat,"[SCXPM] %s was awarded with a Medal! (He now has %i Medals)",name,medals[target]-1)
	}
	else
	{
		console_print(id,"%s already has 15 Medals.",name)
	}
	return PLUGIN_HANDLED
}

public scxpm_removemedal(id,level,cid)
{
	if(!cmd_access(id,ADMIN_IMMUNITY,cid,2))
	{
		return PLUGIN_HANDLED
	}
	new targetarg[32]
	read_argv(1,targetarg,31)
	new target=cmd_target(id,targetarg,11)
	if(!target)
	{
		return PLUGIN_HANDLED
	}
	new name[32]
	get_user_name(target,name,31)
	if(medals[target]>1)
	{
		medals[target]-=1
		console_print(id,"You took a Medal of %s.",name)
		client_print(0,print_chat,"[SCXPM] %s lost a Medal! (He now has %i Medals)",name,medals[target]-1)
	}
	else
	{
		console_print(id,"%s already has no Medals.",name)
	}
	return PLUGIN_HANDLED
}

public scxpm_godmode(id,level,cid)
{
	if(!cmd_access(id,ADMIN_IMMUNITY,cid,2))
	{
		return PLUGIN_HANDLED
	}
	new godmode_arg[32]
	read_argv(1,godmode_arg,31)
	new godmode_target=cmd_target(id,godmode_arg,0)
	if(godmode_target)
	{
		new godmode_name[32]
		get_user_name(godmode_target,godmode_name,31)
		if(!is_user_alive(godmode_target))
		{
			console_print(id,"[SCXPM] The User %s is currently dead!",godmode_name)
			return PLUGIN_HANDLED
		}
		if(has_godmode[godmode_target])
		{
			set_user_godmode(godmode_target)
			has_godmode[godmode_target]=false
			if(godmode_target==id)
			{
				console_print(id,"[SCXPM] You disabled God Mode on yourself!")
			}
			else
			{
				console_print(id,"[SCXPM] The User %s lost his God Mode!",godmode_name)
				client_print(godmode_target,print_chat,"[SCXPM] An Admin has disabled God Mode on you!")
			}
		}
		else
		{
			has_godmode[godmode_target]=true
			set_user_godmode(godmode_target,1)
			if(godmode_target==id)
			{
				console_print(id,"[SCXPM] You enabled God Mode on yourself!")
			}
			else
			{
				console_print(id,"[SCXPM] The User %s now has God Mode!",godmode_name)
				client_print(godmode_target,print_chat,"[SCXPM] An Admin has enabled God Mode on you!")
			}
		}
	}
	return PLUGIN_HANDLED
}

public scxpm_noclipmode(id,level,cid)
{
	if(!cmd_access(id,ADMIN_IMMUNITY,cid,2))
	{
		return PLUGIN_HANDLED
	}
	new noclipmode_arg[32]
	read_argv(1,noclipmode_arg,31)
	new noclipmode_target=cmd_target(id,noclipmode_arg,0)
	if(noclipmode_target)
	{
		new noclipmode_name[32]
		get_user_name(noclipmode_target,noclipmode_name,31)
		if(!is_user_alive(noclipmode_target))
		{
			console_print(id,"[SCXPM] The User %s is currently dead!",noclipmode_name)
			return PLUGIN_HANDLED
		}
		if(get_user_noclip(noclipmode_target))
		{
			set_user_noclip(noclipmode_target)
			if(noclipmode_target==id)
			{
				console_print(id,"[SCXPM] You disabled Noclip Mode on yourself")
			}
			else
			{
				console_print(id,"[SCXPM] The User %s lost his Noclip Mode!",noclipmode_name)
				client_print(noclipmode_target,print_chat,"[SCXPM] An Admin has disabled Noclip Mode on you!")
			}
		}
		else
		{
			set_user_noclip(noclipmode_target,1)
			if(noclipmode_target==id)
			{
				console_print(id,"[SCXPM] You enabled Noclip Mode on yourself!")
			}
			else
			{

				console_print(id,"[SCXPM] The User %s now has Noclip Mode!",noclipmode_name)
				client_print(noclipmode_target,print_chat,"[SCXPM] An Admin has enabled Noclip Mode on you!")
			}
		}
	}
	return PLUGIN_HANDLED
}

public scxpm_reset(id)
{
	health[id]=0
	armor[id]=0
	rhealth[id]=0
	rarmor[id]=0
	rammo[id]=0
	gravity[id]=0
	speed[id]=0
	dist[id]=0
	dodge[id]=0
	skillpoints[id]=playerlevel[id]
	if(get_user_health(id)>starthealth+medals[id])
	{
		set_user_health(id,starthealth+medals[id])
	}
	if(get_user_armor(id)>startarmor+medals[id])
	{
		set_user_armor(id,startarmor+medals[id])
	}
	set_user_gravity(id,1.0)
	if(skillpoints[id]>0)
	{
		client_print(id,print_chat,"[SCXPM] All your Skills have been set back. Please choose...")
		SCXPMSkill(id)
	}
	else
	{
		client_print(id,print_chat,"[SCXPM] You have no Skills to reset.")
	}
}

public scxpm_version(id)
{
	new allinfo[1023]
	format(allinfo,1022,"Plugin Name: SCXPM (Sven Cooperative Experience Mod)^nPlugin Type: Running under AMXModX (www.amxmodx.org)^nAuthor: Silencer^nVersion: %s^nLast Update: %s^nExperience Multiplier (Server Side): %f^nInformation: http://forums.alliedmods.net/showthread.php?t=44168",VERSION,LASTUPDATE,get_cvar_float("amx_scxpm_xpgain"))
	show_motd(id,allinfo,"SCXPM Information")
}

public scxpm_info(id)
{
	new allskills[1023]="1. Strength:^n   Starthealth + 1 * Strengthlevel.^n"
	format(allskills,1022,"%s^n2. Superior Armor:^n   Startarmor + 1 * Armorlevel.^n",allskills)
	format(allskills,1022,"%s^n3. Regeneration:^n   One HP every (150.5-(Regenerationlevel/2)) Seconds^n   + Bonus Chance every 0.5 Seconds.^n",allskills)
	format(allskills,1022,"%s^n4. Nano Armor:^n   One AP every (150.5-(Nanoarmorlevel/2)) Seconds^n   + Bonus Chance every 0.5 Seconds.^n",allskills)
	format(allskills,1022,"%s^n5. Ammunition Reincarnation:^n   Ammunition for current Weapon every (90-(Ammolevel*2.5)) Seconds.^n",allskills)
	format(allskills,1022,"%s^n6. Anti Gravity Device:^n   Lowers your Gravity by (1.5)%% per Level. Hold Jump-Key!^n",allskills)
	format(allskills,1022,"%s^n7. Awareness:^n   Generic Skill which is enhancing many other Skills a bit.^n",allskills)
	format(allskills,1022,"%s^n8. Team Power:^n   Supports nearby Teammates with HP and AP^n   and also yourself on higher Level.^n",allskills)
	format(allskills,1022,"%s^n9. Block Attack:^n   Chance on fully blocking any Attack of (Blocklevel/3)%%.^n",allskills)
	format(allskills,1022,"%s^nSpecial - Medals:^n   Given by an Admin, Shows your Importance.^n   (Minimal Ability Support)",allskills)
	show_motd(id,allskills,"Skills Information")
}

public scxpm_others(id)
{
	new alldata[1152]="Playername            Level  Medals^n"
	new iPlayers[32],iNum
	get_players(iPlayers,iNum)
	for(new g=0;g<iNum;g++)
	{
		new i=iPlayers[g]
		if(is_user_connected(i))
		{
			new name[20]
			get_user_name(i,name,19)
			new toadd=20-strlen(name)
			new spaces[20]=""
			add(spaces,19,"                   ",toadd)
			format(alldata,1152,"%s^n%s %s %i     %i",alldata,name,spaces,playerlevel[i],medals[i]-1)
		}
	}
	show_motd(id,alldata,"Players Data")
}

public scxpm_getrank(id)
{
	switch(playerlevel[id])
	{
		case 1800:
		{
			rank[id]="Highest Force Leader"
		}
		case 1700..1799:
		{
			rank[id]="Highest Force Member"
		}
		case 1600..1699:
		{
			rank[id]="Top 15 of most famous Leaders"
		}
		case 1500..1599:
		{
			rank[id]="Top 30 of most famous Leaders"
		}
		case 1400..1499:
		{
			rank[id]="General"
		}
		case 1300..1399:
		{
			rank[id]="Hidden Operations Leader"
		}
		case 1200..1299:
		{
			rank[id]="Hidden Operations Scheduler"
		}
		case 1100..1199:
		{
			rank[id]="Hidden Operations Member"
		}
		case 1000..1099:
		{
			rank[id]="United Forces Leader"
		}
		case 900..999:
		{
			rank[id]="United Forces Member"
		}
		case 800..899:
		{
			rank[id]="Special Force Leader"
		}
		case 700..799:
		{
			rank[id]="Special Force Member"
		}
		case 600..699:
		{
			rank[id]="Professional Force Leader"
		}
		case 500..599:
		{
			rank[id]="Professional Force Member"
		}
		case 400..499:
		{
			rank[id]="Professional Free Agent"
		}
		case 300..399:
		{
			rank[id]="Free Agent"
		}
		case 200..299:
		{
			rank[id]="Private First Class"
		}
		case 100..199:
		{
			rank[id]="Private Second Class"
		}
		case 50..99:
		{
			rank[id]="Private Third Class"
		}
		case 20..49:
		{
			rank[id]="Fighter"
		}
		case 5..19:
		{
			rank[id]="Civilian"
		}
		case 0..4:
		{
			rank[id]="Frightened Civilian"
		}
	}
}

public scxpm_newbiehelp(id)
{
	if(is_user_connected(id))
	{
		new name[32]
		get_user_name(id,name,31)
		client_print(id,print_chat,"[SCXPM] Hello, %s! Sven Cooperative Experience Mod (SCXPM) %s by Silencer is enabled!",name,VERSION)
		client_print(id,print_chat,"[SCXPM] Commands: ^"'say skillsinfo', 'say selectskills', 'say resetskills', 'say playerskills', 'say scxpminfo'^"")
	}
}

public client_authorized(id)
{
	new authid[35]
	get_user_authid(id,authid,34)
	if(containi(authid,"STEAM_0:") !=-1)
	{
		new vaultkey[64],vaultdata[96]
		format(vaultkey,63,"%s-scxpm",authid)
		if(vaultdata_exists(vaultkey))
		{
			get_vaultdata(vaultkey,vaultdata,95)
			replace_all(vaultdata,95,"#"," ")
			new pre_xp[16],pre_playerlevel[8],pre_skillpoints[8],pre_medals[8],pre_health[8],pre_armor[8],pre_rhealth[8],pre_rarmor[8],pre_rammo[8],pre_gravity[8],pre_speed[8],pre_dist[8],pre_dodge[8]
			parse(vaultdata,pre_xp,15,pre_playerlevel,7,pre_skillpoints,7,pre_medals,7,pre_health,7,pre_armor,7,pre_rhealth,7,pre_rarmor,7,pre_rammo,7,pre_gravity,7,pre_speed,7,pre_dist,7,pre_dodge,7)
			xp[id]=str_to_num(pre_xp)
			playerlevel[id]=str_to_num(pre_playerlevel)
			scxpm_calcneedxp(id)
			scxpm_getrank(id)
			skillpoints[id]=str_to_num(pre_skillpoints)
			medals[id]=str_to_num(pre_medals)
			health[id]=str_to_num(pre_health)
			armor[id]=str_to_num(pre_armor)
			rhealth[id]=str_to_num(pre_rhealth)
			rarmor[id]=str_to_num(pre_rarmor)
			rammo[id]=str_to_num(pre_rammo)
			gravity[id]=str_to_num(pre_gravity)
			speed[id]=str_to_num(pre_speed)
			dist[id]=str_to_num(pre_dist)
			dodge[id]=str_to_num(pre_dodge)
		}
		else
		{
			neededxp[id]=30
			medals[id]=4
			rank[id]="Frightened Civilian"
			set_task(35.0,"scxpm_newbiehelp",id,"",0,"a",3)
		}
	}
}

public scxpm_savexp(id)
{
	new authid[35]
	get_user_authid(id,authid,34)
	if(containi(authid,"STEAM_0:") !=-1)
	{
		new vaultkey[64],vaultdata[96]
		format(vaultkey,63,"%s-scxpm",authid)
		format(vaultdata,95,"%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i",xp[id],playerlevel[id],skillpoints[id],medals[id],health[id],armor[id],rhealth[id],rarmor[id],rammo[id],gravity[id],speed[id],dist[id],dodge[id])
		set_vaultdata(vaultkey,vaultdata)
	}
}

public scxpm_removed(id)
{
	client_print(id,print_chat,"[SCXPM] This Function has been removed from SCXPM. Reason: Error-prone. Data is still saved automatically.")
}

public client_connect(id)
{
	neededxp[id]=99999999
	lastDeadflag[id]=1
	lastfrags[id]=0
}

public client_disconnect(id)
{
	scxpm_savexp(id)
	xp[id]=0
	neededxp[id]=0
	playerlevel[id]=0
	skillpoints[id]=0
	medals[id]=0
	health[id]=0
	armor[id]=0
	rhealth[id]=0
	rarmor[id]=0
	rammo[id]=0
	gravity[id]=0
	speed[id]=0
	dist[id]=0
	dodge[id]=0
	rarmorwait[id]=0
	rhealthwait[id]=0
	ammowait[id]=0
	rank[id]="Loading..."
}

public scxpm_client_spawn(id)
{
	starthealth=get_user_health(id)
	startarmor=get_user_armor(id)
	set_user_health(id,health[id]+starthealth+medals[id])
	set_user_armor(id,armor[id]+startarmor+medals[id])
}

public gravityon(id)
{
	if(is_user_connected(id))
	{
		if(is_user_alive(id))
		{
			set_user_gravity(id,1.0-(0.015*gravity[id])-(0.001*medals[id]))
		}
	}
}

public gravityoff(id)
{
	if(is_user_connected(id))
	{
		if(is_user_alive(id))
		{
			set_user_gravity(id,1.0)
		}
	}
}

public scxpm_prethink(id)
{
	new deadflag=pev(id,pev_deadflag)
	if(!deadflag&&lastDeadflag[id])
	{
		scxpm_client_spawn(id)
	}
	lastDeadflag[id]=deadflag
	if(pev(id,pev_button)&IN_JUMP)
	{
		gravityon(id)
	}
	else
	{
		if(pev(id,pev_oldbuttons)&IN_JUMP)
		{
			gravityoff(id)
		}
	}
}

public scxpm_calcneedxp(id)
{
	new Float:m70=float(playerlevel[id])*70.0
	new Float:mselfm3dot2=float(playerlevel[id])*float(playerlevel[id])*3.5
	neededxp[id]=floatround(m70+mselfm3dot2+30.0)
}

public scxpm_randomammo(i)
{
	new number=random_num(0,6)
	new clip,ammo
	if(number==0)
	{
		get_user_ammo(i,2,clip,ammo)
		if(ammo<250)
		{
			give_item(i,"ammo_9mmclip")
		}
		else
		{
			number=1
		}
	}
	if(number==1)
	{
		get_user_ammo(i,3,clip,ammo)
		if(ammo<36)
		{
			give_item(i,"ammo_357")
		}
		else
		{
			number=2
		}
	}
	if(number==2)
	{
		get_user_ammo(i,7,clip,ammo)
		if(ammo<125)
		{
			give_item(i,"ammo_buckshot")
		}
		else
		{
			number=3
		}
	}
	if(number==3)
	{
		get_user_ammo(i,9,clip,ammo)
		if(ammo<100)
		{
			give_item(i,"ammo_gaussclip")
		}
		else
		{
			number=4
		}
	}
	if(number==4)
	{
		get_user_ammo(i,6,clip,ammo)
		if(ammo<50)
		{
			give_item(i,"ammo_crossbow")
		}
		else
		{
			number=5
		}
	}
	if(number==5)
	{
		get_user_ammo(i,8,clip,ammo)
		if(ammo<5)
		{
			give_item(i,"ammo_rpgclip")
		}
		else
		{
			number=6
		}
	}
	if(number==6)
	{
		get_user_ammo(i,23,clip,ammo)
		if(ammo<15)
		{
			give_item(i,"ammo_762")
		}
		else
		{
			give_item(i,"ammo_556")
		}
	}
}

public scxpm_regen()
{
	new iPlayers[32],iNum
	get_players(iPlayers,iNum)
	for(new g=0;g<iNum;g++)
	{
		new i=iPlayers[g]
		if(is_user_connected(i))
		{
			if(is_user_alive(i))
			{
				new halfspeed=floatround(float(speed[i])/2.0)
				if(rhealth[i]>0)
				{
					if(rhealthwait[i]==0)
					{
						if(get_user_health(i)<health[i]+starthealth+medals[i]+halfspeed)
						{
							set_user_health(i,get_user_health(i)+1)
							rhealthwait[i]=300-rhealth[i]
						}
					}
					else
					{
						rhealthwait[i]-=1
						if(get_user_health(i)<health[i]+starthealth+medals[i]+halfspeed&&random_num(0,200+rhealth[i]+medals[i]+halfspeed)>200)
						{
							set_user_health(i,get_user_health(i)+1)
						}
					}
				}
				if(rarmor[i]>0)
				{
					if(rarmorwait[i]==0)
					{
						if(get_user_armor(i)<armor[i]+startarmor+medals[i]+halfspeed)
						{
							set_user_armor(i,get_user_armor(i)+1)
							rarmorwait[i]=300-rarmor[i]
						}
					}
					else
					{
						rarmorwait[i]-=1
						if(get_user_armor(i)<armor[i]+startarmor+medals[i]+halfspeed&&random_num(0,200+rarmor[i]+medals[i]+halfspeed)>200)
						{
							set_user_armor(i,get_user_armor(i)+1)
						}
					}
				}
				if(rammo[i]>0)
				{
					if(ammowait[i]==0)
					{
						new clip,ammo
						switch(get_user_weapon(i,clip,ammo))
						{
							case 1: /* Crowbar */
							{
								scxpm_randomammo(i)
							}
							case 2: /* 9mm Handgun */
							{
								get_user_ammo(i,2,clip,ammo)
								if(ammo<250)
								{
									give_item(i,"ammo_9mmclip")
								}
								else
								{
									scxpm_randomammo(i)
								}
							}
							case 3: /* 357 (Revolver) */
							{
								get_user_ammo(i,3,clip,ammo)
								if(ammo<36)
								{
									give_item(i,"ammo_357")
								}
								else
								{
									scxpm_randomammo(i)
								}
							}
							case 4: /* 9mm AR = MP5 */
							{
								get_user_ammo(i,4,clip,ammo)
								if(ammo<250)
								{
									give_item(i,"ammo_9mmAR")
								}
								else
								{
									scxpm_randomammo(i)
								}
								give_item(i,"ammo_ARgrenades")
							}
							case 6: /* Crossbow */
							{
								get_user_ammo(i,6,clip,ammo)
								if(ammo<50)
								{
									give_item(i,"ammo_crossbow")
								}
								else
								{
									scxpm_randomammo(i)
								}
							}
							case 7: /* Shotgun */
							{
								get_user_ammo(i,7,clip,ammo)
								if(ammo<125)
								{
									give_item(i,"ammo_buckshot")
								}
								else
								{
									scxpm_randomammo(i)
								}
							}
							case 8: /* RPG Launcher */
							{
								get_user_ammo(i,8,clip,ammo)
								if(ammo<5)
								{
									give_item(i,"ammo_rpgclip")
								}
								else
								{
									scxpm_randomammo(i)
								}
							}
							case 9: /* Gauss Cannon */
							{
								get_user_ammo(i,9,clip,ammo)
								if(ammo<100)
								{
									give_item(i,"ammo_gaussclip")
								}
								else
								{
									scxpm_randomammo(i)
								}
							}
							case 10: /* Egon */
							{
								get_user_ammo(i,10,clip,ammo)
								if(ammo<100)
								{
									give_item(i,"ammo_gaussclip")
								}
								else
								{
									scxpm_randomammo(i)
								}
							}
							case 11: /* Hornetgun */
							{
								scxpm_randomammo(i)
							}
							case 12: /* Handgrenade */
							{
								scxpm_randomammo(i)
							}
							case 13: /* Tripmine */
							{
								scxpm_randomammo(i)
							}
							case 14: /* Satchels */
							{
								scxpm_randomammo(i)
							}
							case 15: /* Snarks */
							{
								scxpm_randomammo(i)
							}
							case 16: /* Uzi Akimbo */
							{
								get_user_ammo(i,16,clip,ammo)
								if(ammo<250)
								{
									give_item(i,"ammo_9mmAR")
									give_item(i,"ammo_9mmclip")
								}
								else
								{
									scxpm_randomammo(i)
								}
							}
							case 17: /* Uzi */
							{
								get_user_ammo(i,17,clip,ammo)
								if(ammo<100)
								{
									give_item(i,"ammo_9mmAR")
								}
								else
								{
									scxpm_randomammo(i)
								}
							}
							case 18: /* Medkit */
							{
								scxpm_randomammo(i)
								if(get_user_health(i)<health[i]+starthealth+medals[i]+halfspeed)
								{
									set_user_health(i,get_user_health(i)+1)
									rhealthwait[i]=300-rhealth[i]
								}
							}
							case 20: /* Pipewrench */
							{
								scxpm_randomammo(i)
							}
							case 21: /* Minigun */
							{
								get_user_ammo(i,21,clip,ammo)
								if(ammo<999)
								{
									give_item(i,"ammo_556")
								}
								else
								{
									scxpm_randomammo(i)
								}
							}
							case 22: /* Grapple */
							{
								scxpm_randomammo(i)
							}
							case 23: /* Sniper Rifle */
							{
								get_user_ammo(i,23,clip,ammo)
								if(ammo<15)
								{
									give_item(i,"ammo_762")
								}
								else
								{
									scxpm_randomammo(i)
								}
							}
						}
						new speed_dt=floatround(float(speed[i])/18.0)
						ammowait[i]=179-(5*rammo[i])-speed_dt
					}
					else
					{
						ammowait[i]-=1
					}
				}
				new clip,ammo
				switch(get_user_weapon(i,clip,ammo))
				{
					case 18: /* Medkit */
					{
						if(get_user_health(i)<100)
						{
							if(random_num(rhealth[i],800-get_user_health(i)>299))
							{
								set_user_health(i,get_user_health(i)+1)
							}
						}
						else
						{
							if(get_user_health(i)<health[i]+starthealth+medals[i]+halfspeed&&random_num(0,1300+rhealth[i])>1200)
							{
								set_user_health(i,get_user_health(i)+1)
							}
						}
					}
				}
				if(dist[i]>0)
				{
					for(new h=0;h<iNum;h++)
					{
						new id=iPlayers[h]
						for(new j=0;j<iNum;j++)
						{
							new i=iPlayers[j]
							if(id==i)
							{
								// Do nothing
							}
							else
							{
								if(is_user_alive(i)&&is_user_alive(id))
								{
									new Float:origin_i[3]
									pev(i,pev_origin,origin_i)
									new Float:origin_id[3]
									pev(id,pev_origin,origin_id)
									if(get_distance_f(origin_i,origin_id)<=650.0)
									{
										new halfspeed=floatround(float(speed[i])/2.0)
										new iPlayers[32],iNum
										get_players(iPlayers,iNum)
										iNum=iNum*50
										new luck=random_num(1651-iNum,4200+dist[id]+dist[i]+halfspeed)
										if(luck>4200)
										{
											set_user_health(i,get_user_health(i)+1)
											if(get_user_health(i)>health[i]+starthealth+60+dist[id]+medals[i]+halfspeed)
											{
												set_user_health(i,health[i]+starthealth+60+dist[id]+medals[i]+halfspeed)
											}
										}
										luck=random_num(1651-iNum,4200+dist[id]+dist[i]+halfspeed)
										if(luck>4200)
										{
											set_user_armor(i,get_user_armor(i)+1)
											if(get_user_armor(i)>health[i]+starthealth+60+dist[id]+medals[i]+halfspeed)
											{
												set_user_armor(i,health[i]+starthealth+60+dist[id]+medals[i]+halfspeed)
											}
										}
										if(dist[id]>=40)
										{
											luck=random_num(0,1000+dist[id])
											if(luck>1038)
											{
												set_user_health(i,get_user_health(i)+1)
												if(get_user_health(i)>health[i]+starthealth+60+dist[id]+medals[i]+halfspeed)
												{
													set_user_health(i,health[i]+starthealth+60+dist[id]+medals[i]+halfspeed)
												}
												set_user_armor(i,get_user_armor(i)+1)
												if(get_user_armor(i)>health[i]+starthealth+60+dist[id]+medals[i]+halfspeed)
												{
													set_user_armor(i,health[i]+starthealth+60+dist[id]+medals[i]+halfspeed)
												}
											}
										}
									}
								}
							}
						}
					}
				}
				if(!has_godmode[i])
				{
					if(dodge[i]>0)
					{
						new piecespeed=floatround(float(speed[i])/7.0)
						new luck=random_num(0,185+dodge[i]+medals[i]+piecespeed)
						if(luck>185)
						{
							set_user_godmode(i,1)
						}
						else
						{
							set_user_godmode(i)
						}
					}
					else
					{
						set_user_godmode(i)
					}
				}
			}
		}
	}
}

public scxpm_sdac()
{
	switch(onecount)
	{
		case false:
		{
			onecount=true
		}
		case true:
		{
			scxpm_reexp()
			scxpm_showdata()
			onecount=false
		}
	}
	scxpm_regen
}

public scxpm_reexp()
{
	new iPlayers[32],iNum
	get_players(iPlayers,iNum)
	for(new g=0;g<iNum;g++)
	{
		new i=iPlayers[g]
		if(is_user_connected(i))
		{
			if(playerlevel[i]==1800)
			{
				xp[i]=11500000
			}
			else
			{
				new Float:helpvar=float(xp[i])/5.0/get_cvar_float("amx_scxpm_xpgain")+float(get_user_frags(i))-float(lastfrags[i])
				xp[i]=floatround(helpvar*5.0*get_cvar_float("amx_scxpm_xpgain"))
				lastfrags[i]=get_user_frags(i)
				if(neededxp[i]>0)
				{
					if(xp[i]>=neededxp[i])
					{
						new prevxp=neededxp[i]
						playerlevel[i]+=1
						scxpm_calcneedxp(i)
						skillpoints[i]+=1
						new name[32]
						get_user_name(i,name,31)
						if(playerlevel[i]==1800)
						{
							client_print(0,print_chat,"[SCXPM] Everyone say ^"Congratulations!!!^" to %s, who has reached Level 1800!",name)
						}
						else
						{
							client_print(i,print_chat,"[SCXPM] Congratulations, %s, you are now Level %i - Next Level: %i XP - Needed: %i XP",name,playerlevel[i],neededxp[i],neededxp[i]-prevxp)
						}
						scxpm_getrank(i)
						SCXPMSkill(i)
					}
				}
			}
		}
	}
}

public scxpm_showdata()
{
	new iPlayers[32],iNum
	get_players(iPlayers,iNum)
	for(new g=0;g<iNum;g++)
	{
		new i=iPlayers[g]
		if(is_user_connected(i))
		{
			set_hudmessage(50,135,180,0.65,0.04,0,1.0,255.0,0.0,0.0,3)
			switch(playerlevel[i])
			{
				case 1800:
				{
					show_hudmessage(i,"Level:   1800 / 1800^nRank:   Highest Force Leader^nMedals:   %i / 15",medals[i]-1)
				}
				default:
				{
					show_hudmessage(i,"Exp.:   %i / %i  (+%i)^nLevel:   %i / 1800^nRank:   %s^nMedals:   %i / 15",xp[i],neededxp[i],neededxp[i]-xp[i],playerlevel[i],rank[i],medals[i]-1)
				}
			}
		}
	}
}

public SCXPMSkill(id)
{
	new menuBody[1024]
	format(menuBody,1023,"Select Skills - Skillpoints available: %i^n^n^n^n 1.   Strength  [ %i / 450 ]^n^n 2.   Superior Armor  [ %i / 450 ]^n^n 3.   Health Regeneration  [ %i / 300 ]^n^n 4.   Nano Armor  [ %i / 300 ]^n^n 5.   Ammo Reincarnation  [ %i / 30 ]^n^n 6.   Anti Gravity Device  [ %i / 40 ]^n^n 7.   Awareness  [ %i / 80 ]^n^n 8.   Team Power  [ %i / 60 ]^n^n 9.   Block Attack  [ %i / 90 ]^n^n^n 0.   Done"
	,skillpoints[id],health[id],armor[id],rhealth[id],rarmor[id],rammo[id],gravity[id],speed[id],dist[id],dodge[id])
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9),menuBody,13,"Select Skill")
}

public SCXPMSkillChoice(id,key)
{
	switch(key)
	{
		case 0:
		{
			if(skillpoints[id]>0)
			{
				if(health[id]<450)
				{
					skillpoints[id]-=1
					health[id]+=1
					client_print(id,print_chat,"[SCXPM] You spent one Skillpoint to enhance your Strength to Level %i!",health[id])
					if(is_user_alive(id))
					{
						set_user_health(id,get_user_health(id)+1)
					}
				}
				else
				{
					client_print(id,print_chat,"[SCXPM] You have mastered your Strength already.")
				}
				if(skillpoints[id]>0)
				{
					SCXPMSkill(id)
				}
			}
			else
			{
				client_print(id,print_chat,"[SCXPM] You need one Skillpoint for enhancing your Strength.")
			}
		}
		case 1:
		{
			if(skillpoints[id]>0)
			{
				if(armor[id]<450)
				{
					skillpoints[id]-=1
					armor[id]+=1
					client_print(id,print_chat,"[SCXPM] You spent one Skillpoint to enhance your Armor to Level %i!",armor[id])
					if(is_user_alive(id))
					{
						set_user_armor(id,get_user_armor(id)+1)
					}
				}
				else
				{
					client_print(id,print_chat,"[SCXPM] You have mastered your Armor already.")
				}
				if(skillpoints[id]>0)
				{
					SCXPMSkill(id)
				}
			}
			else
			{
				client_print(id,print_chat,"[SCXPM] You need one Skillpoint for enhancing your Armor.")
			}
		}
		case 2:
		{
			if(skillpoints[id]>0)
			{
				if(rhealth[id]<300)
				{
					skillpoints[id]-=1
					rhealth[id]+=1
					client_print(id,print_chat,"[SCXPM] You spent one Skillpoint to enhance your Regeneration to Level %i!",rhealth[id])
				}
				else
				{
					client_print(id,print_chat,"[SCXPM] You have mastered your Regeneration already.")
				}
				if(skillpoints[id]>0)
				{
					SCXPMSkill(id)
				}
			}
			else
			{
				client_print(id,print_chat,"[SCXPM] You need one Skillpoint for enhancing your Regeneration.")
			}
		}
		case 3:
		{
			if(skillpoints[id]>0)
			{
				if(rarmor[id]<300)
				{
					skillpoints[id]-=1
					rarmor[id]+=1
					client_print(id,print_chat,"[SCXPM] You spent one Skillpoint to enhance your Nano Armor to Level %i!",rarmor[id])
				}
				else
				{
					client_print(id,print_chat,"[SCXPM] You have mastered your Nano Armor already.")
				}
				if(skillpoints[id]>0)
				{
					SCXPMSkill(id)
				}
			}
			else
			{
				client_print(id,print_chat,"[SCXPM] You need one Skillpoint for enhancing your Nano Armor.")
			}
		}
		case 4:
		{
			if(skillpoints[id]>0)
			{
				if(rammo[id]<30)
				{
					skillpoints[id]-=1
					rammo[id]+=1
					client_print(id,print_chat,"[SCXPM] You spent one Skillpoint to enhance your Ammo Reincarnation to Level %i!",rammo[id])
				}
				else
				{
					client_print(id,print_chat,"[SCXPM] You have mastered your Ammo Reincarnation already.")
				}
				if(skillpoints[id]>0)
				{
					SCXPMSkill(id)
				}
			}
			else
			{
				client_print(id,print_chat,"[SCXPM] You need one Skillpoint for enhancing your Ammo Reincarnation.")
			}
		}
		case 5:
		{
			if(skillpoints[id]>0)
			{
				if(gravity[id]<40)
				{
					skillpoints[id]-=1
					gravity[id]+=1
					client_print(id,print_chat,"[SCXPM] You spent one Skillpoint to enhance your Anti Gravity Device to Level %i!",gravity[id])
				}
				else
				{
					client_print(id,print_chat,"[SCXPM] You have mastered your Anti Gravity Device already.")
				}
				if(skillpoints[id]>0)
				{
					SCXPMSkill(id)
				}
			}
			else
			{
				client_print(id,print_chat,"[SCXPM] You need one Skillpoint for enhancing your Anti Gravity Device.")
			}
		}
		case 6:
		{
			if(skillpoints[id]>0)
			{
				if(speed[id]<80)
				{
					skillpoints[id]-=1
					speed[id]+=1
					client_print(id,print_chat,"[SCXPM] You spent one Skillpoint to enhance your Awareness to Level %i!",speed[id])
				}
				else
				{
					client_print(id,print_chat,"[SCXPM] You have mastered your Awareness already.")
				}
				if(skillpoints[id]>0)
				{
					SCXPMSkill(id)
				}
			}
			else
			{
				client_print(id,print_chat,"[SCXPM] You need one Skillpoint for enhancing your Awareness.")
			}
		}
		case 7:
		{
			if(skillpoints[id]>0)
			{
				if(dist[id]<60)
				{
					skillpoints[id]-=1
					dist[id]+=1
					client_print(id,print_chat,"[SCXPM] You spent one Skillpoint to enhance your Team Power to Level %i!",dist[id])
				}
				else
				{
					client_print(id,print_chat,"[SCXPM] You have mastered your Team Power already.")
				}
				if(skillpoints[id]>0)
				{
					SCXPMSkill(id)
				}
			}
			else
			{
				client_print(id,print_chat,"[SCXPM] You need one Skillpoint for enhancing your Team Power.")
			}
		}
		case 8:
		{
			if(skillpoints[id]>0)
			{
				if(dodge[id]<90)
				{
					skillpoints[id]-=1
					dodge[id]+=1
					client_print(id,print_chat,"[SCXPM] You spent one Skillpoint to enhance your Dodging and Blocking Skills to Level %i!",dodge[id])
				}
				else
				{
					client_print(id,print_chat,"[SCXPM] You have mastered your Dodging and Blocking Skills already.")
				}
				if(skillpoints[id]>0)
				{
					SCXPMSkill(id)
				}
			}
			else
			{
				client_print(id,print_chat,"[SCXPM] You need one Skillpoint for enhancing your Dodgin and Blocking Skills.")
			}
		}
		case 9:
		{
			
		}
	}
	return PLUGIN_HANDLED
}
