// listweapons.as - 完整版：主槽 + 背包所有武器

void ListWeapons(const CCommand @pArgs)
{
	CBasePlayer @pPlayer = g_ConCommandSystem.GetCurrentPlayer();
	if (pPlayer is null)
		return;

	g_PlayerFuncs.SayText(pPlayer, "=== 主槽武器 (m_rgpPlayerItems) ===\n");

	for (uint uiSlot = 0; uiSlot < MAX_ITEM_TYPES; uiSlot++)
	{
		CBasePlayerItem @pItem = pPlayer.m_rgpPlayerItems(uiSlot);
		if (pItem !is null)
		{
			PrintWeaponInfo(pPlayer, pItem, "槽位 " + uiSlot);
		}
	}

	g_PlayerFuncs.SayText(pPlayer, "\n=== 背包武器 (遍历子实体) ===\n");

	// 遍历玩家所有子实体，找武器
	CBaseEntity @pEnt = null;
	while ((@pEnt = g_EntityFuncs.FindEntityByClassname(pEnt, "*")) !is null)
	{
		if (pEnt.pev.owner !is null && pEnt.pev.owner is pPlayer.edict())
		{
			CBasePlayerItem @pItem = cast<CBasePlayerItem @>(pEnt);
			if (pItem !is null && pItem.GetClassname().Find("weapon_") != -1) // 只显示武器
			{
				PrintWeaponInfo(pPlayer, pItem, "背包: " + pItem.GetClassname());
			}
		}
	}

	// 当前手持武器（独立显示，防遗漏）
	g_PlayerFuncs.SayText(pPlayer, "\n=== 当前手持 ===\n");
	if (pPlayer.m_hActiveItem)
	{
		CBaseEntity @pActiveEnt = pPlayer.m_hActiveItem.GetEntity();
		if (pActiveEnt !is null)
		{
			CBasePlayerItem @pActiveItem = cast<CBasePlayerItem @>(pActiveEnt);
			if (pActiveItem !is null)
				PrintWeaponInfo(pPlayer, pActiveItem, "手持");
		}
	}

	g_PlayerFuncs.SayText(pPlayer, "====================\n");
}

void PrintWeaponInfo(CBasePlayer @pPlayer, CBasePlayerItem @pItem, string szLabel = "")
{
	if (pItem is null)
		return;

	CBasePlayerWeapon @pWeapon = cast<CBasePlayerWeapon @>(pItem);
	if (pWeapon is null)
	{
		g_PlayerFuncs.SayText(pPlayer, szLabel + ": " + pItem.GetClassname() + " (非武器物品)\n");
		return;
	}

	string szInfo = szLabel + ": **" + pWeapon.GetClassname() + "**\n";

	// 槽位 & 位置
	szInfo += "  槽位: " + pWeapon.iItemSlot() + "\n";

	// 是否当前手持
	bool isActive = false;
	if (pPlayer.m_hActiveItem)
	{
		CBaseEntity @pActiveEnt = pPlayer.m_hActiveItem.GetEntity();
		if (pActiveEnt !is null && pActiveEnt is pWeapon)
			isActive = true;
	}
	szInfo += "  状态: " + (isActive ? "[当前手持]" : "未手持") + "\n";

	// 武器 ID
	szInfo += "  ID: " + pWeapon.m_iId + "\n";

	// 主弹药信息（最可靠部分）
	int iPrimType = pWeapon.PrimaryAmmoIndex();
	if (iPrimType >= 0)
	{
		int clip = pWeapon.m_iClip;
		int carry = pPlayer.m_rgAmmo(iPrimType); // 玩家当前携带总量（包括弹夹外）
		// 注意：没有标准 iMaxClip() 和 iMaxAmmo1()，所以不显示上限（或你可以用硬编码表）
		szInfo += "  主弹药类型索引: " + iPrimType + " | 弹夹: " + clip + " | 携带总量: " + carry + "\n";
	}
	else
	{
		szInfo += "  无主弹药\n";
	}

	// 副弹药（如果存在）
	int iSecType = pWeapon.SecondaryAmmoIndex();
	if (iSecType >= 0 && iSecType != iPrimType)
	{
		int clip2 = pWeapon.m_iClip2;
		int carry2 = pPlayer.m_rgAmmo(iSecType);
		szInfo += "  副弹药类型索引: " + iSecType + " | 弹夹: " + clip2 + " | 携带总量: " + carry2 + "\n";
	}

	// 冷却时间
	float now = g_Engine.time;
	string cdPrim = (pWeapon.m_flNextPrimaryAttack <= now) ? "可用" : formatFloat(pWeapon.m_flNextPrimaryAttack - now, "", 0, 2) + "s";
	string cdSec = (pWeapon.m_flNextSecondaryAttack <= now) ? "可用" : formatFloat(pWeapon.m_flNextSecondaryAttack - now, "", 0, 2) + "s";
	szInfo += "  主攻冷却: " + cdPrim + " | 副攻冷却: " + cdSec + "\n";

	szInfo += "------------------------\n";
	g_PlayerFuncs.SayText(pPlayer, szInfo);
}

CClientCommand g_cmdListWeapons("listweapons", "列出所有武器（主槽+背包+手持）", @ListWeapons);

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor("Scrooge2029");
	g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
	g_PlayerFuncs.SayTextAll(null, "[listweapons] 已加载 - 完整版！\n");
}