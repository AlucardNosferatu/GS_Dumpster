namespace Capitalism
{
    void Activate()
    {
        e_ScriptParser.Register("samplecmd", CustomMacro(Macro_samplecmd));
    }

    bool Macro_samplecmd(CBasePlayer@ pPlayer, array<string>@ args)
    {
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, "My-Dearest-Girl...Ms.Carol!\n");
        return true;
    }
}