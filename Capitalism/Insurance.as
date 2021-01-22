#include "Ecco/Include"
dictionary INS_DMG_BULLET;
dictionary INS_DMG_BLAST;


void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Scrooge2029");
    g_Module.ScriptInfo.SetContactInfo("1641367382@qq.com");
    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "My-Dearest-Girl...Ms.Carol!\n");
    InitEcco();
    InitInsurance();
}

void GetUserList()
{
    File@ fHandle;
    string sLine;
    
    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/ins_dmg_bullet.txt" , OpenFile::READ);
    if( fHandle !is null )
    {
        while(!fHandle.EOFReached())
        {
            fHandle.ReadLine(sLine);
            string user_name=sLine.Split("\t")[0];
            int rest_time=atoi(sLine.Split("\t")[1]);
            INS_DMG_BULLET.set(user_name,rest_time);

        }
        fHandle.Close();
    }

    @fHandle  = g_FileSystem.OpenFile( "scripts/plugins/store/ins_dmg_blast.txt" , OpenFile::READ);
    if( fHandle !is null )
    {
        while(!fHandle.EOFReached())
        {
            fHandle.ReadLine(sLine);
            string user_name=sLine.Split("\t")[0];
            int rest_time=atoi(sLine.Split("\t")[1]);
            INS_DMG_BLAST.set(user_name,rest_time);
        }
        fHandle.Close();
    }
}

void UpdateUserInfo()
{
    File@ fHandle;

    @fHandle = g_FileSystem.OpenFile( "scripts/plugins/store/ins_dmg_bullet.txt" , OpenFile::WRITE);
    if( fHandle !is null )
    {
        array<string> users=INS_DMG_BULLET.getKeys()
        int users_count=int(keys.length());
        for(int i=0;i<users_count;i++)
        {
            fHandle.Write(users[i]+"\t"+string(INS_DMG_BULLET[users[i]])+"\n")
        }
        fHandle.Close();
    }

    @fHandle = g_FileSystem.OpenFile( "scripts/plugins/store/ins_dmg_blast.txt" , OpenFile::WRITE);
    if( fHandle !is null )
    {
        array<string> users=INS_DMG_BLAST.getKeys()
        int users_count=int(keys.length());
        for(int i=0;i<users_count;i++)
        {
            fHandle.Write(users[i]+"\t"+string(INS_DMG_BLAST[users[i]])+"\n")
        }
        fHandle.Close();
    }
}

void InitInsurance()
{
    GetUserList();
    g_Hooks.RegisterHook(Hooks::Player::ClientSay, @medical_servive);
    g_Hooks.RegisterHook(Hooks::Player::PlayerTakeDamage, @insurance_service);
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
    else if(pPlayer !is null && (cArgs[0].ToLowercase() == "!insure" || cArgs[0].ToLowercase() == "/insure"))
    {
        if( cArgs.ArgC() < 2 )
        {
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Plz specify the type of insurance you want to buy.\n");
            return HOOK_CONTINUE;
        }
        else
        {
            if(cArgs[1]=="DMG_BULLET")
            {
                if(e_PlayerInventory.GetBalance(pPlayer)>10000)
                {
                    string PlayerUniqueId = e_PlayerInventory.GetUniquePlayerId(pPlayer);
                    e_PlayerInventory.ChangeBalance(pPlayer, -10000);
                    INS_DMG_BULLET.set(PlayerUniqueId,1000);
                    UpdateUserInfo();
                }
                else
                {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Price for Bullet INS is 10000, You need more funds.\n");
                    return HOOK_CONTINUE;
                }
                return HOOK_CONTINUE;
            }
            else if(cArgs[1]=="DMG_BLAST")
            {
                if(e_PlayerInventory.GetBalance(pPlayer)>20000)
                {
                    string PlayerUniqueId = e_PlayerInventory.GetUniquePlayerId(pPlayer);
                    e_PlayerInventory.ChangeBalance(pPlayer, -20000);
                    INS_DMG_BLAST.set(PlayerUniqueId,1000);
                    UpdateUserInfo();
                }
                else
                {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "Price for Blast INS is 20000, You need more funds.\n");
                    return HOOK_CONTINUE;
                }
                return HOOK_CONTINUE;
            }
            else
            {
                g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "We don't have the type of insurance you specified, sorry.\n");
                return HOOK_CONTINUE;
            }
        }
    }
    return HOOK_CONTINUE;
}

HookReturnCode insurance_service(DamageInfo@ pDamageInfo)
{
    if(pDamageInfo.flDamage<1.0)
    {
        return HOOK_CONTINUE;
    }
    if(pDamageInfo.pVictim.IsPlayer())
    {
        CBasePlayer@ pPlayer=cast<CBasePlayer@>(pDamageInfo.pVictim);
        CBaseEntity@ pAtk=pDamageInfo.pAttacker;
        //TODO 根据pAtk筛选，防止骗保
        string PlayerUniqueId = e_PlayerInventory.GetUniquePlayerId(pPlayer);
        switch(pDamageInfo.bitsDamageType)
        {
            case DMG_BULLET:
                if(INS_DMG_BULLET.exists(PlayerUniqueId) and int(INS_DMG_BULLET[PlayerUniqueId])>0)
                {
                    INS_DMG_BULLET[PlayerUniqueId]-=1;
                    e_PlayerInventory.ChangeBalance(pPlayer, int(pDamageInfo.flDamage));
                    if(INS_DMG_BULLET[PlayerUniqueId]%10==0)
                    {
                        UpdateUserInfo();
                    }
                }
                else
                {
                    return HOOK_CONTINUE;
                }
                break;
            case DMG_BLAST:
                if(INS_DMG_BLAST.exists(PlayerUniqueId) and int(INS_DMG_BLAST[PlayerUniqueId])>0)
                {
                    INS_DMG_BLAST[PlayerUniqueId]-=1;
                    e_PlayerInventory.ChangeBalance(pPlayer, int(pDamageInfo.flDamage));
                    if(INS_DMG_BLAST[PlayerUniqueId]%10==0)
                    {
                        UpdateUserInfo();
                    }
                }
                else
                {
                    return HOOK_CONTINUE;
                }
                break;
            default:
                return HOOK_CONTINUE;
        }
        return HOOK_CONTINUE;
    }
    else
    {
        return HOOK_CONTINUE;
    }
    return HOOK_CONTINUE;
}