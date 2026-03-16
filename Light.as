// Light.as
// 放置路径：svencoop/scripts/plugins/Light.as (小寫)

// ===================== 全局變量 =====================
bool g_bLightMode = false;
dictionary g_pPlayerTimers; // SteamID → CScheduledFunction@ (scheduler handle)

// 燈光參數（可調）
const float g_fLightOffsetZ = 48.0f;
const float g_fLightRadius = 280.0f; // 調大才明顯！測試用 280~400
const int g_iLightR = 255;
const int g_iLightG = 220;
const int g_iLightB = 180;

// 指令
CClientCommand g_cmdFollowLight("light", "Toggle follow player light", @OnFollowLightCommand);

// ===================== 初始化 =====================
void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor("Scrooge2029");
	g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");

	g_Hooks.RegisterHook(Hooks::Player::PlayerKilled, @OnPlayerKilled);
	g_Hooks.RegisterHook(Hooks::Player::ClientDisconnect, @OnClientDisconnect);

	g_PlayerFuncs.SayTextAll(null, "[FollowLight] 已載入 - 輸入 light 切換\n");
}

// ===================== 定時更新 DLIGHT =====================
void UpdatePlayerLight(string szSteamId)
{
	CBasePlayer @pPlayer = null;

	for (int i = 1; i <= g_Engine.maxClients; ++i)
	{
		CBasePlayer @p = g_PlayerFuncs.FindPlayerByIndex(i);
		if (p !is null && g_EngineFuncs.GetPlayerAuthId(p.edict()) == szSteamId)
		{
			@pPlayer = p;
			break;
		}
	}

	if (pPlayer is null || !pPlayer.IsAlive())
	{
		StopLightTimer(szSteamId);
		return;
	}

	Vector vecPos = pPlayer.GetOrigin() + Vector(0, 0, g_fLightOffsetZ);

	// 先只發給自己測試（確認亮了再改成 MSG_BROADCAST）
	NetworkMessage nMsg(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
	nMsg.WriteByte(TE_DLIGHT);
	nMsg.WriteCoord(vecPos.x);
	nMsg.WriteCoord(vecPos.y);
	nMsg.WriteCoord(vecPos.z);
	nMsg.WriteByte(g_iLightR);
	nMsg.WriteByte(g_iLightG);
	nMsg.WriteByte(g_iLightB);
	nMsg.WriteByte(int(g_fLightRadius));
	nMsg.WriteFloat(0.1f);
	nMsg.End();
}

// 停止 timer（關鍵修正：用 CScheduledFunction@）
void StopLightTimer(string szSteamId)
{
	if (g_pPlayerTimers.exists(szSteamId))
	{
		CScheduledFunction @pTimer = cast<CScheduledFunction @>(g_pPlayerTimers[szSteamId]);
		if (pTimer !is null)
		{
			g_Scheduler.RemoveTimer(pTimer); // 正確傳 handle
		}
		g_pPlayerTimers.delete(szSteamId);
	}
}

// ===================== 指令回調 =====================
void OnFollowLightCommand(const CCommand @pArgs)
{
	CBasePlayer @pPlayer = g_ConCommandSystem.GetCurrentPlayer();
	if (pPlayer is null)
		return;

	string szSteamId = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict());
	g_bLightMode = !g_bLightMode;

	if (g_pPlayerTimers.exists(szSteamId))
	{
		StopLightTimer(szSteamId);
		g_PlayerFuncs.SayText(pPlayer, "[跟随光] ❌ 已關閉頭頂光源\n");
	}
	else
	{
		// 開啟：返回 CScheduledFunction@，無限循環
		CScheduledFunction @pTimer = g_Scheduler.SetInterval(
			"UpdatePlayerLight",			   // 函數名
			0.05f,							   // 間隔
			g_Scheduler.REPEAT_INFINITE_TIMES, // 無限次
			szSteamId						   // 參數
		);

		if (pTimer is null)
		{
			g_PlayerFuncs.SayText(pPlayer, "[跟随光] ❌ 無法創建定時器！\n");
			return;
		}

		// 存 handle（加 @ 明確傳遞）
		g_pPlayerTimers.set(szSteamId, @pTimer);

		// 立即執行一次
		UpdatePlayerLight(szSteamId);

		g_PlayerFuncs.SayText(pPlayer, "[跟随光] ✅ 已開啟頭頂暖黃光 (半徑 " + g_fLightRadius + ")\n");
	}

	// HUD 提示
	HUDTextParams params;
	params.x = -1;
	params.y = 0.88f;
	params.effect = 0;
	params.r1 = 255;
	params.g1 = 200;
	params.b1 = 50;
	params.a1 = 200;
	params.fadeinTime = 0.5f;
	params.fadeoutTime = 0.5f;
	params.holdTime = 3.0f;

	g_PlayerFuncs.HudMessage(pPlayer, params, "跟随光模式：" + (g_bLightMode ? "ON" : "OFF"));
}

// ===================== 死亡 & 斷線清理 =====================
HookReturnCode OnPlayerKilled(CBasePlayer @pPlayer, CBaseEntity @pAttacker, CBaseEntity @pInflictor)
{
	if (pPlayer is null)
		return HOOK_CONTINUE;

	string szSteamId = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict());
	StopLightTimer(szSteamId);
	return HOOK_CONTINUE;
}

void OnClientDisconnect(CBasePlayer @pPlayer)
{
	if (pPlayer is null)
		return;

	string szSteamId = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict());
	StopLightTimer(szSteamId);
}