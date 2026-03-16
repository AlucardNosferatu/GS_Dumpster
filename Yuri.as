// Own.as
// 放置路径：svencoop/scripts/plugins/Own.as (必须小写)

bool g_bSpecialMode = false;
const string g_szGlock17 = "weapon_9mmhandgun";
const string g_sz9mmAmmo = "9mm";
const int g_iMaxAmmo = 999;

// 全局 CClientCommand 对象，自动注册客户端命令 "own"
CClientCommand g_cmdOwn("yuri", "Toggle special Glock17 mode: infinite ammo + convert hit targets to ally", @OnOwnCommand);

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor("Scrooge2029");
	g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");

	g_Hooks.RegisterHook(Hooks::Weapon::WeaponPrimaryAttack, @OnWeaponPrimaryAttack);

	g_PlayerFuncs.SayTextAll(null, "[YuriIsMaster] 已加载 - 输入 own 切换模式\n");
}

void OnOwnCommand(const CCommand @pArgs)
{
	CBasePlayer @pPlayer = g_ConCommandSystem.GetCurrentPlayer();

	if (pPlayer is null)
		return;

	// 发放 Glock17 如果没有
	if (pPlayer.HasNamedPlayerItem(g_szGlock17) is null)
	{
		pPlayer.GiveNamedItem(g_szGlock17);
		pPlayer.GiveAmmo(200, g_sz9mmAmmo, g_iMaxAmmo);
		g_PlayerFuncs.SayText(pPlayer, "[系统] 已发放Glock17！\n");
	}

	g_bSpecialMode = !g_bSpecialMode;

	string modeMsg = g_bSpecialMode ? "开启：无限弹药+击中转友军" : "关闭：恢复正常";
	g_PlayerFuncs.SayText(pPlayer, "[Glock17] " + modeMsg + "\n");

	// 屏幕中央提示（类似你的风格）
	HUDTextParams params;
	params.effect = 0;
	params.fadeinTime = 0.5f;
	params.fadeoutTime = 0.5f;
	params.holdTime = 3.0f;
	params.x = -1;
	params.y = 0.88f;
	params.r1 = 255;
	params.g1 = 200;
	params.b1 = 0;
	params.a1 = 200;

	g_PlayerFuncs.HudMessage(pPlayer, params, "Glock17模式：" + (g_bSpecialMode ? "ON" : "OFF"));
}

HookReturnCode OnWeaponPrimaryAttack(CBasePlayer @pShooter, CBasePlayerWeapon @pWeapon)
{
	if (pShooter is null || pWeapon is null || !g_bSpecialMode || pWeapon.GetClassname() != g_szGlock17)
		return HOOK_CONTINUE;

	pShooter.GiveAmmo(1, g_sz9mmAmmo, g_iMaxAmmo);

	Vector vecSrc = pShooter.GetGunPosition();
	Vector vecEnd = pShooter.GetAutoaimVector(0.0f); // 用 autoaim，更准
	// Vector vecEnd = vecSrc + pShooter.GetViewVector() * 8192.0f;

	Math.MakeVectors(pShooter.pev.v_angle); // 确保 v_forward 等正确
	TraceResult tr;
	g_Utility.TraceLine(vecSrc, vecEnd * 65536.0f, dont_ignore_monsters, dont_ignore_glass, pShooter.edict(), tr);

	if (tr.pHit is null)
		return HOOK_CONTINUE;

	CBaseEntity @pHit = g_EntityFuncs.Instance(tr.pHit);

	if (pHit is null || !pHit.IsMonster()) // 只针对怪物（NPC）
		return HOOK_CONTINUE;

	// 核心：直接复制你的洗脑逻辑
	int rel = pHit.IRelationshipByClass(CLASS_PLAYER); // 检查与玩家的关系
	if (rel > 0)									   // 原本敌对
	{
		pHit.SetClassification(11);					   // 设为 CLASS_PLAYER_ALLY（玩家友军）
	}
	else											   // 原本中立或友军（罕见，但保持你的逻辑）
	{
		pHit.SetClassification(16);					   // 设为 CLASS_PLAYER（玩家类）
	}

	// 提示（保持你的风格）
	g_PlayerFuncs.SayText(pShooter, "[特殊模式] 击中 " + pHit.GetClassname() + " 转为友军！\n");

	// 可选：调试控制台输出（像你的 MC Activated）
	// g_PlayerFuncs.ClientPrintAll( HUD_PRINTCONSOLE, "Glock MC Activated on " + pHit.GetClassname() + "\n" );

	return HOOK_CONTINUE;
}