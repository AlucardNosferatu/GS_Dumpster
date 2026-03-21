// Cain.as
bool g_bSpecialMode = false;
const int g_iCainDamage = 930000;

// 命令注册，风格一致
CClientCommand g_cmdCain("cain", "Toggle special Cain mode", @OnCainCommand);

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor("Scrooge2029");
	g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");

	// 正确注册方式：直接用函数指针 @OnPlayerTakeDamage
	g_Hooks.RegisterHook(Hooks::Player::PlayerTakeDamage, @OnPlayerTakeDamage);

	g_PlayerFuncs.SayTextAll(null, "[Cain] 已加载 - 输入 cain 切换\n");
}

void OnCainCommand(const CCommand @pArgs)
{
	CBasePlayer @pPlayer = g_ConCommandSystem.GetCurrentPlayer();

	if (pPlayer is null)
		return;

	g_bSpecialMode = !g_bSpecialMode;
	string modeMsg = g_bSpecialMode ? "✅ 开启：Cain反伤" : "❌ 关闭：普通模式";
	g_PlayerFuncs.SayText(pPlayer, "[Cain] " + modeMsg + "\n");
}

HookReturnCode OnPlayerTakeDamage(DamageInfo @pDamageInfo)
{
	// pDamageInfo 不能为空
	if (pDamageInfo is null || !g_bSpecialMode)
		return HOOK_CONTINUE;

	// 受害者必须是玩家（hook本身针对玩家，但保险起见检查）
	CBasePlayer @pVictim = cast<CBasePlayer @>(pDamageInfo.pVictim);

	if (pVictim is null)
		return HOOK_CONTINUE;

	g_PlayerFuncs.SayText(pVictim, "Inflictor: " + (pDamageInfo.pInflictor !is null ? pDamageInfo.pInflictor.GetClassname() : "null") + " | Attacker: " + (pDamageInfo.pAttacker !is null ? pDamageInfo.pAttacker.GetClassname() : "null") + "\n");

	// 检查攻击者是否为怪物/NPC（IsMonster() 判断）
	CBaseEntity @pAttacker = pDamageInfo.pAttacker;
	if (pAttacker is null || !pAttacker.IsMonster())
		return HOOK_CONTINUE;

	// 反伤：对攻击者造成巨额伤害
	pAttacker.TakeDamage(pVictim.pev, pVictim.pev, g_iCainDamage, DMG_CLUB);

	// 显示提示，使用字符串拼接
	g_PlayerFuncs.SayText(pVictim, "[Cain] " + pAttacker.GetClassname() + " 已反杀！\n");

	// 可以选择返回 HOOK_HANDLED 来阻止原伤害（如果想完全免疫），但这里保持原伤害继续
	// return HOOK_HANDLED;  // 如果想让玩家不受伤害，取消注释这行

	return HOOK_CONTINUE;
}