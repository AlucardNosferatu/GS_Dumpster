class Weapon
{
    string name;
    int primary_ammo;
    int secondary_ammo
}

class Status
{
    bool alive;
    int health;
    int armor;
}

class Action
{
    bool jump;
    bool crouch;
    bool firing;
    float pitch;
    float yaw;
}

class Context
{
    array<float> coordinate;
    string buff;
    int die_count;
    int kill_count;
    int sparied_logo;
}

class Behavior
{
    string player_name;
    string map_name;
    string game_id;
    string log_dir;
    string log_file_full_path;
    DateTime time_stamp;
    File fHandle;
}

class Monitor
{
    string current_map;
    void PluginInit()
    {
        g_Module.ScriptInfo.SetAuthor( "Scrooge2029" );
	    g_Module.ScriptInfo.SetContactInfo( "1641367382@qq.com" );
        g_PlayerFuncs.ClientPrintAll( HUD_PRINTCONSOLE, "Hello World!" );
        current_map="";
    }
}
