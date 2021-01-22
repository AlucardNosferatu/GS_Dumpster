#include "Ecco/Include"

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "My-Dearest-Girl...Ms.Carol!\n");
    InitEcco();
    InitInsurrance();
}

void InitInsurrance()
{
    g_Hooks.RegisterHook(Hooks::Player::ClientSay, @medical_servive);
}

HookReturnCode medical_servive(SayParameters@ pParams)
{
    CBasePlayer@ pPlayer = pParams.GetPlayer();
    const CCommand@ cArgs = pParams.GetArguments();
    if(pPlayer !is null && (cArgs[0].ToLowercase() == "!rescue" || cArgs[0].ToLowercase() == "/rescue"))
    {
        if(pPlayer.IsAlive())
        {
            if(e_PlayerInventory.GetBalance(pPlayer)>100)
            {
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Thank You for donating funds to the LostXmas medical foundation.\n");
                e_PlayerInventory.ChangeBalance(pPlayer, -100);
            }
            else
            {
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "You don't need emergency rescue, don't mess with us.\n");
            }
        }
        else
        {
            if(e_PlayerInventory.GetBalance(pPlayer)>100)
            {
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "You are now as healthy as a new born baby.\n");
                if ( pPlayer.GetObserver().IsObserver() )
			    {
                    // Observing, player has a corpse left behind?
                    if ( pPlayer.GetObserver().HasCorpse() )
                    {
                        // We do, normal revive
                        e_PlayerInventory.ChangeBalance(pPlayer, -100);
                        pPlayer.Revive();
                    }
                    else
                    {
                        if(e_PlayerInventory.GetBalance(pPlayer)>150)
                        {
                            e_PlayerInventory.ChangeBalance(pPlayer, -150);
                            // Nope, respawn the player
                            pPlayer.Revive(); // So Spawn() ain't called
                            g_PlayerFuncs.RespawnPlayer( pPlayer, true, true );
                        }
                        else
                        {
                            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Sorry, but you need more money to recreate your body.\n");
                        }
                    }
			    }
                else
                {
                    // Player has been gibbed?
                    if ( ( pPlayer.pev.effects & EF_NODRAW ) != 0 )
                    {
                        // Yes, respawn the player
                        if(e_PlayerInventory.GetBalance(pPlayer)>150)
                        {
                            e_PlayerInventory.ChangeBalance(pPlayer, -150);
                            pPlayer.pev.takedamage = DAMAGE_NO; // In the event a player died in the middle of a trigger_hurt or just a bad place
                            pPlayer.Revive();
                            g_PlayerFuncs.RespawnPlayer( pPlayer, true, true );
                        }
                        else
                        {
                            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Sorry, but you need more money to put your organs together.\n");
                        }
                    }
                    else
                    {
                        e_PlayerInventory.ChangeBalance(pPlayer, -100);
                        // Nope, normal revive
                        pPlayer.Revive();
                    }
                }
            }
            else
            {
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "You are too poor to call for an emergency rescue!\n");
            }
        }
    }
    return HOOK_CONTINUE;
}
