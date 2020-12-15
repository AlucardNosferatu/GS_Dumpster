#include <amxmodx>
#include <fakemeta>

#define PLUGIN	"TacticalRobot"
#define VERSION	"1.0"
#define AUTHOR	"Lain"

#define BOT_MAXNUM	32
enum TargetType
{
	TT_None = 0,
	TT_LookAt,
	TT_Move,
	TT_Follow,
	TT_Use,
	TT_Attack,
	TT_Attack2,
	TT_Reload,
	TT_Svencoop_Revive
}


new g_BotId[BOT_MAXNUM]
new Float:g_BotTarget[BOT_MAXNUM][3]
new TargetType:g_BotTargetType[BOT_MAXNUM]
new g_BotTargetEnt[BOT_MAXNUM]
new g_BotTargetWeapon[BOT_MAXNUM][32]
new g_BotOldButton[BOT_MAXNUM]
new g_BotCount

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_forward(FM_StartFrame, "fwd_StartFrame")
}

public plugin_natives()
{
	register_native("bot_create", "native_createbot")
	register_native("bot_settarget", "native_settarget")
	register_native("bot_isfree", "native_isfree")
}

stock get_bot_index(id)
{
	for(new i=0;i<g_BotCount;i++)
		if(g_BotId[i] == id)
			return i
	return -1
}

public client_disconnect(id)
{
	new i = get_bot_index(id)
	if(i != -1)
	{
		g_BotId[i] = 0
		g_BotTarget[i] = Float:{0.0, 0.0, 0.0}
		g_BotTargetType[i] = TT_None
		g_BotTargetEnt[i] = 0
		g_BotTargetWeapon[i] = ""
		g_BotOldButton[i] = 0
		g_BotCount -= 1
	}
}

public native_settarget(id, num)
{
	if(num != 5)
		return
	new bot = get_param(1)
	new i = get_bot_index(bot)
	if(i == -1)
		return
	get_array_f(2, g_BotTarget[i], 3)
	g_BotTargetType[i] = TargetType:get_param(3)
	g_BotTargetEnt[i] = get_param(4)
	get_string(5, g_BotTargetWeapon[i], 31)
}

public bool:native_isfree(id, num)
{
	if(num != 1)
		return false
	new bot = get_param(1)
	new i = get_bot_index(bot)
	if(i == -1)
		return false
	if(g_BotTargetType[i] == TT_None)
		return true
	return false
}

public native_createbot(id, num)
{
	if(num != 1)
		return 0
	if(g_BotCount >= BOT_MAXNUM)
		return 0
	new name[128]
	get_string(1, name, 127)
	new bot = engfunc(EngFunc_CreateFakeClient, name)
	if(!bot)
		return 0

	engfunc(EngFunc_FreeEntPrivateData, bot)
	bot_settings(bot)

	static szRejectReason[128]
	dllfunc(DLLFunc_ClientConnect, bot, name, "127.0.0.1", szRejectReason)
	if(!is_user_connected(bot))
		return 0

	dllfunc(DLLFunc_ClientPutInServer, bot)
	set_pev(bot,pev_spawnflags, pev(bot,pev_spawnflags) | FL_FAKECLIENT)
	set_pev(bot,pev_flags, pev(bot,pev_flags) | FL_FAKECLIENT)
	
	g_BotId[g_BotCount] = bot
	g_BotCount += 1
	
	return bot
}

bot_settings(id)
{
	set_user_info(id, "model",		"aswat")
	set_user_info(id, "rate",		"3500")
	set_user_info(id, "cl_updaterate",	"30")
	set_user_info(id, "cl_lw",		"0")
	set_user_info(id, "cl_lc",		"0")
	set_user_info(id, "tracker",		"0")
	set_user_info(id, "cl_dlmax",		"128")
	set_user_info(id, "lefthand",		"1")
	set_user_info(id, "friends",		"0")
	set_user_info(id, "dm",			"0")
	set_user_info(id, "ah",			"1")
	set_user_info(id, "topcolor",		"145")
	set_user_info(id, "bottomcolor",	"150")

	set_user_info(id, "*bot",		"1")
	set_user_info(id, "_cl_autowepswitch",	"1")
	set_user_info(id, "_vgui_menu",		"0")
	set_user_info(id, "_vgui_menus",	"0")
}

public fwd_StartFrame()
{
	for(new i=0;i<g_BotCount;i++)
		BotThink(i)
}

BotThink(index)
{
	static id, Float:target[3], TargetType:tt, te, tw[32], oldbutton
	id = g_BotId[index]
	target = g_BotTarget[index]
	tt = g_BotTargetType[index]
	te = g_BotTargetEnt[index]
	tw = g_BotTargetWeapon[index]
	oldbutton = g_BotOldButton[index]
	static Float:origin[3], Float:eye_origin[3], Float:speedforward, button
	pev(id, pev_origin, origin)
	pev(id, pev_view_ofs, eye_origin)
	eye_origin[0] += origin[0]
	eye_origin[1] += origin[1]
	eye_origin[2] += origin[2]
	speedforward = 0.0
	button = 0
	static bool:forwardBlocked, bool:thisAlive, bool:inWater, bool:onLadder
	forwardBlocked = fForwardBlocked(id)
	thisAlive = IsAlive(id)
	inWater = (pev(id, pev_waterlevel) == 3)?true:false
	onLadder = (pev(id, pev_movetype) == MOVETYPE_FLY)?true:false
	static bool:resetTarget
	resetTarget = false
	if(!thisAlive)
	{
		button |= IN_ATTACK
		resetTarget = true
	}
	else
	{
		if(te && !pev_valid(te))
			te = 0
		if(te)
		{
			if(!IsAlive(te) && tt != TT_Svencoop_Revive)
				te = 0
			else if(IsAlive(te) && tt == TT_Svencoop_Revive)
				te = 0
		}
		if(te && !FVisible(eye_origin, te, id))
		{
			te = 0
			get_user_aim(id, target)
		}
		if(te)
			BodyTarget(te, target)
			
		static Float:dist, Float:dist2D
		dist = distToEnt(target, id)
		dist2D = distToEnt(target, id, true)
		
		if(tt == TT_Reload)
			goto doAct
		
		if(tt != TT_None && (tt == TT_LookAt || FVisible2(eye_origin, target, id)))
			entity_set_aim(id, target)
		else
		{
			resetTarget = true
			goto end
		}
		
		doAct:
		if(strlen(tw) > 0)
			engclient_cmd(id, tw)
			
		switch(tt)
		{
			case TT_None:
			{
			}
			case TT_LookAt:
			{
				resetTarget = true
			}
			case TT_Move:
			{
				if(inWater || onLadder)
				{
					if(dist > 30.0)
						speedforward = 400.0
					else if(dist < 5.0)
						speedforward = -50.0
					else
						resetTarget = true
				}
				else
				{
					if(dist2D > 30.0)
						speedforward = 400.0
					else if(dist2D < 5.0)
						speedforward = -50.0
					else
						resetTarget = true
				}
				if(speedforward > 0.0)
					button |= IN_FORWARD
				else if(speedforward < 0.0)
					button |= IN_BACK
				if(speedforward > 0.0 && forwardBlocked && !(oldbutton & IN_JUMP))
					button |= IN_DUCK | IN_JUMP
			}
			case TT_Follow:
			{
				if(te)
				{
					if(inWater || onLadder)
					{
						if(dist > 200.0)
							speedforward = 400.0
						else if(dist < 80.0)
							speedforward = -50.0
					}
					else
					{
						if(dist2D > 200.0)
							speedforward = 400.0
						else if(dist2D < 80.0)
							speedforward = -50.0
					}
					if(speedforward > 0.0)
						button |= IN_FORWARD
					else if(speedforward < 0.0)
						button |= IN_BACK
					if(speedforward > 0.0 && forwardBlocked && !(oldbutton & IN_JUMP))
						button |= IN_DUCK | IN_JUMP
				}
				else
					resetTarget = true
			}
			case TT_Use:
			{
				if(te)
				{
					if(inWater || onLadder)
					{
						if(dist > 30.0)
							speedforward = 400.0
						else if(dist < 5.0)
							speedforward = -50.0
						else
						{
							button |= IN_USE
							resetTarget = true
						}
					}
					else
					{
						if(dist2D > 30.0)
							speedforward = 400.0
						else if(dist2D < 5.0)
							speedforward = -50.0
						else
						{
							button |= IN_USE
							resetTarget = true
						}
					}
					if(speedforward > 0.0)
						button |= IN_FORWARD
					else if(speedforward < 0.0)
						button |= IN_BACK
					if(speedforward > 0.0 && forwardBlocked && !(oldbutton & IN_JUMP))
						button |= IN_DUCK | IN_JUMP
				}
				else
					resetTarget = true
			}
			case TT_Attack:
			{
				if(te)
				{
					static clip, ammo
					get_user_weapon(id, clip, ammo)
					if(clip != 0)
						button |= IN_ATTACK
					else
						button |= IN_RELOAD
				}
				else
					resetTarget = true
			}
			case TT_Attack2:
			{
				button |= IN_ATTACK2
				resetTarget = true
			}
			case TT_Reload:
			{
				button |= IN_RELOAD
				resetTarget = true
			}
			case TT_Svencoop_Revive:
			{
				if(te)
				{
					if(inWater || onLadder)
					{
						if(dist > 50.0)
							speedforward = 400.0
						else if(dist < 5.0)
							speedforward = -50.0
						else
							button |= IN_ATTACK2
					}
					else
					{
						if(dist2D > 50.0)
							speedforward = 400.0
						else if(dist2D < 5.0)
							speedforward = -50.0
						else
							button |= IN_ATTACK2
					}
					if(speedforward > 0.0)
						button |= IN_FORWARD
					else if(speedforward < 0.0)
						button |= IN_BACK
					if(speedforward > 0.0 && forwardBlocked && !(oldbutton & IN_JUMP))
						button |= IN_DUCK | IN_JUMP
				}
				else
					resetTarget = true
			}
		}
	}
		
	end:
	static Float:msecval
	global_get(glb_frametime, msecval)
	new msec = floatround(msecval * 1000.0)
	static Float:viewangles[3]
	pev(id, pev_v_angle, viewangles)
	engfunc(EngFunc_RunPlayerMove, id, viewangles, speedforward, 0.0, 0.0, button, 0, msec)
	if(resetTarget)
	{
		get_user_aim(id, g_BotTarget[index])
		g_BotTargetType[index] = TT_None
		g_BotTargetEnt[index] = 0
		g_BotTargetWeapon[index] = ""
		g_BotOldButton[index] = button
	}
	else
	{
		g_BotTarget[index] = target
		g_BotOldButton[index] = button
	}
}

bool:fForwardBlocked(ent)
{
	static Float:origin[3], Float:end[3]
	pev(ent, pev_origin, origin)
	velocity_by_aim(ent, 48, end)
	end[0] += origin[0]
	end[1] += origin[1]
	end[2] = origin[2] + 6.0
	static tr, Float:flFraction
	tr = create_tr2()
	engfunc(EngFunc_TraceHull, origin, end, 0, HULL_HEAD, ent, tr)
	get_tr2(tr, TR_flFraction, flFraction)
	if(flFraction != 1.0)
	{
		free_tr2(tr)
		return true
	}
	end[2] += 18.0
	engfunc(EngFunc_TraceHull, origin, end, 0, HULL_HEAD, ent, tr)
	get_tr2(tr, TR_flFraction, flFraction)
	free_tr2(tr)
	return flFraction!=1.0?true:false
}

stock BodyTarget(ent, Float:vecTarget[3])
{
	static Float:absmin[3], Float:absmax[3]
	pev(ent, pev_absmin, absmin)
	pev(ent, pev_absmax, absmax)
	vecTarget[0] = (absmin[0] + absmax[0]) * 0.5
	vecTarget[1] = (absmin[1] + absmax[1]) * 0.5
	vecTarget[2] = (absmin[2] + absmax[2]) * 0.5
}

stock bool:FVisible(Float:vecSrc[3], pTarget, pSkip)
{
	static tr, Float:vecTarget[3], Float:flFraction
	tr = create_tr2()
	BodyTarget(pTarget, vecTarget)
	engfunc(EngFunc_TraceLine, vecSrc, vecTarget, (1 | 0x100), pSkip, tr)
	get_tr2(tr, TR_flFraction, flFraction)
	free_tr2(tr)
	return (flFraction == 1.0)
}

stock bool:FVisible2(Float:vecSrc[3], Float:vecTarget[3], pSkip)
{
	static tr, Float:flFraction
	tr = create_tr2()
	engfunc(EngFunc_TraceLine, vecSrc, vecTarget, (1 | 0x100), pSkip, tr)
	get_tr2(tr, TR_flFraction, flFraction)
	free_tr2(tr)
	return (flFraction == 1.0)
}

stock Float:fpev(_index, _value) { static Float:v; pev(_index, _value, v); return v; }
stock bool:IsAlive(pEnt) { return (pev(pEnt, pev_deadflag)==0 && fpev(pEnt, pev_health)>0.0); }

stock entity_set_aim(ent,const Float:origin2[3])
{
	if(!pev_valid(ent))
		return 0;

	static Float:origin[3]
	origin[0] = origin2[0]
	origin[1] = origin2[1]
	origin[2] = origin2[2]

	static Float:ent_origin[3], Float:view_ofs[3]

	pev(ent,pev_origin,ent_origin)
	pev(ent,pev_view_ofs,view_ofs)
	ent_origin[0] += view_ofs[0]
	ent_origin[1] += view_ofs[1]
	ent_origin[2] += view_ofs[2]

	origin[0] -= ent_origin[0]
	origin[1] -= ent_origin[1]
	origin[2] -= ent_origin[2]

	static Float:v_length
	v_length = vector_length(origin)

	static Float:aim_vector[3]
	aim_vector[0] = origin[0] / v_length
	aim_vector[1] = origin[1] / v_length
	aim_vector[2] = origin[2] / v_length

	static Float:new_angles[3]
	vector_to_angle(aim_vector,new_angles)

	if(new_angles[1]>180.0) new_angles[1] -= 360
	if(new_angles[1]<-180.0) new_angles[1] += 360
	if(new_angles[1]==180.0 || new_angles[1]==-180.0) new_angles[1]=-179.999999
	
	new_angles[0] *= -1.0

	set_pev(ent,pev_v_angle,new_angles)
	
	new_angles[0] /= -3.0
	if(new_angles[0] > 90.0) new_angles[0] -= 120.0
	
	set_pev(ent,pev_angles,new_angles)

	return 1;
}

stock get_user_aim(id, Float:aimorig[3])
{
	static Float:origin[3], Float:view_ofs[3]
	pev(id,pev_origin, origin)
	pev(id,pev_view_ofs, view_ofs)
	origin[0] += view_ofs[0]
	origin[1] += view_ofs[1]
	origin[2] += view_ofs[2]

	static Float:vec[3]
	pev(id, pev_v_angle, vec)
	engfunc(EngFunc_MakeVectors, vec)
	global_get(glb_v_forward, vec)
	vec[0] = origin[0] + vec[0] * 9999.0
	vec[1] = origin[1] + vec[1] * 9999.0
	vec[2] = origin[2] + vec[2] * 9999.0

	static line, hit
	line = create_tr2()
	engfunc(EngFunc_TraceLine, origin, vec, 0, id, line)
	get_tr2(line,TR_vecEndPos, aimorig)
	hit = get_tr2(line, TR_pHit)
	free_tr2(line)
	return hit
}

stock Float:Distance2D(Float:vec1[3],Float:vec2[3]) return floatsqroot((vec1[0]-vec2[0])*(vec1[0]-vec2[0])+(vec1[1]-vec2[1])*(vec1[1]-vec2[1]))

stock Float:distToEnt(Float:src[3], ent, bool:_2D=false)
{
	static Float:origin[3]
	pev(ent, pev_origin, origin)
	return _2D?Distance2D(origin, src):vector_distance(origin, src)
}

stock kick(id)
{
	server_cmd("kick #%d", get_user_userid(id))
	server_exec()
}