// SharkCrowbar.as
bool g_bSpecialMode = false;
const string g_szCrowbar = "weapon_crowbar";
const int g_iCrowbarDamage = 930000;

// 完全复制你的命令注册风格
CClientCommand g_cmdShark("shark", "Toggle special Crowbar mode", @OnSharkCommand);

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor("Scrooge2029");
	g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");

	g_Hooks.RegisterHook(Hooks::Weapon::WeaponPrimaryAttack, @OnWeaponPrimaryAttack);

	g_PlayerFuncs.SayTextAll(null, "[SharkCrowbar] 已加载 - 输入 shark 切换\n");
}

void OnSharkCommand(const CCommand @pArgs)
{
	CBasePlayer @pPlayer = g_ConCommandSystem.GetCurrentPlayer();

	if (pPlayer is null)
		return;

	if (pPlayer.HasNamedPlayerItem(g_szCrowbar) is null)
	{
		pPlayer.GiveNamedItem(g_szCrowbar);
		g_PlayerFuncs.SayText(pPlayer, "[系统] 已发放撬棍！\n");
	}

	g_bSpecialMode = !g_bSpecialMode;
	string modeMsg = g_bSpecialMode ? "✅ 开启：鲨鱼撬棍" : "❌ 关闭：普通撬棍";
	g_PlayerFuncs.SayText(pPlayer, "[SharkCrowbar] " + modeMsg + "\n");
}

HookReturnCode OnWeaponPrimaryAttack(CBasePlayer @pPlayer, CBasePlayerWeapon @pWeapon)
{
	if (pPlayer is null || pWeapon is null || !g_bSpecialMode || pWeapon.GetClassname() != g_szCrowbar)
	{
		pPlayer.SetMaxSpeed(270.0f);
		return HOOK_CONTINUE;
	}

	Vector vecSrc = pPlayer.GetGunPosition();
	Vector vecEnd = pPlayer.GetAutoaimVector(0.0f);
	Math.MakeVectors(pPlayer.pev.v_angle);
	TraceResult tr;
	g_Utility.TraceLine(vecSrc, vecEnd * 65536.0f, dont_ignore_monsters, dont_ignore_glass, pPlayer.edict(), tr);
	pWeapon.m_flNextPrimaryAttack -= 1000.0;
	pPlayer.SetMaxSpeed(400.0f);
	if (tr.pHit !is null)
	{
		CBaseEntity @pHit = g_EntityFuncs.Instance(tr.pHit);

		if (pHit !is null && pHit.IsMonster())
		{
			pHit.TakeDamage(pPlayer.pev, pPlayer.pev, g_iCrowbarDamage, DMG_CLUB);

			// 修复在这里：字符串拼接代替格式化
			g_PlayerFuncs.SayText(pPlayer, "[鲨鱼撬棍] " + pHit.GetClassname() + " 已蒸发！\n");
		}
	}
	return HOOK_CONTINUE;
}