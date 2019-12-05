/************************************************************************
*************************************************************************
[ZPS] Barrelhunt
Description:
	Initiates the Barrelhunt gamemode on select maps in ZPS with 'barrelhunt',
    'bhs', or 'bhm' naming conventions in the map. The classic gamemode basically 
    transforms all zombies into barrels! Hide amongst the other barrels in 
    the map and go munching on unsuspecting survivors!
*************************************************************************
*************************************************************************
This plugin is free software: you can redistribute 
it and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the License, or
later version. 

This plugin is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this plugin.  If not, see <http://www.gnu.org/licenses/>.
*************************************************************************
*************************************************************************/
#pragma semicolon 1

#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

#pragma newdecls required

#define TEAM_SURVIVORS  2
#define TEAM_UNDEAD     3
#define PLUGIN_VERSION "2.6.0"

char g_sBHMap[PLATFORM_MAX_PATH];
bool g_bBarrelHunt = false;
Handle g_BHTimerHandle[MAXPLAYERS+1];
ConVar g_hBarrelGameMode = null;

// Barrel model and associated assets
// NOTE: The files from props_c17 all belong to HL2 and are not native to ZPS,
// despite being an HL2 mod. This means we have to have users download the files 
// into models directory client side as well as have them server side.
char g_aBarrelAssets[7][PLATFORM_MAX_PATH] =
{
    "models/props_c17/oildrum001.mdl",
    "models/props_c17/oildrum001.jpg",
    "models/props_c17/oildrum001.dx80.vtx",
    "models/props_c17/oildrum001.dx90.vtx",
    "models/props_c17/oildrum001.phy",
    "models/props_c17/oildrum001.sw.vtx",
    "models/props_c17/oildrum001.vvd"
};


public Plugin myinfo = {
    name = "[ZPS] Barrelhunt",
    author = "noob cannon lol (original author), Mr.Silence (update)",
    description = "Zombies become barrels!",
    version = PLUGIN_VERSION,
    url = "https://github.com/Silenci0/Barrelhunt"
};

public void OnPluginStart()
{
    CreateConVar("sm_barrelhunt_version", PLUGIN_VERSION, "[ZPS] Barrelhunt Version", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
    g_hBarrelGameMode = CreateConVar("sm_barrel_gamemode", "0", "Sets the gamemode for the plugin. \nNormal = 0 (default) \nReverse = 1 \nDouble Barrel = 2", FCVAR_NOTIFY|FCVAR_REPLICATED);
}

public void OnClientDisconnect(int client)
{
    g_BHTimerHandle[client] = INVALID_HANDLE;
}

public void OnMapStart()
{
    // Is the map we are on actually barrelhunt?
    GetCurrentMap(g_sBHMap, sizeof(g_sBHMap));
    if(StrContains(g_sBHMap, "barrelhunt", false) > -1 || StrContains(g_sBHMap, "bhm", false) > -1 || StrContains(g_sBHMap, "bhs", false) > -1)
    {
        g_bBarrelHunt  = true;
    }

    // Make sure our timer handles are invalid. Wouldn't want garbage in them.
    for(int i = 1; i <= MaxClients; i++)
    {
        g_BHTimerHandle[i] = INVALID_HANDLE;
    }
    
    // If the map is a barrelhunt map...
    if (g_bBarrelHunt  == true)
    {    
        // Grab our events
        HookEvent("player_spawn", BH_SpawnHandler, EventHookMode_Post);
        HookEvent("player_team", BH_SpawnHandler, EventHookMode_Post);

        // Precache our model
        PrecacheModel(g_aBarrelAssets[0]);
        
        // Add the barrel files to be downloaded by the client
        for (int i = 0; i < sizeof(g_aBarrelAssets); i++)
        {
            AddFileToDownloadsTable(g_aBarrelAssets[i]);
        }
    }
}

public void OnMapEnd()
{
    // Unhook and resest everything
    g_bBarrelHunt  = false;
    UnhookEvent("player_spawn", BH_SpawnHandler, EventHookMode_Post);
    UnhookEvent("player_team", BH_SpawnHandler, EventHookMode_Post);
}

public void BH_SpawnHandler(Handle event, const char[] name, bool dontBroadcast)
{
    // Grab our player's userid, find out if they are a zombie, and 
    // create a timer that sets the player's entity model to a barrel
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    
    // Check if our player isn't client 0
    if (client > 0)
    {
        int bh_gamemode = GetConVarInt(g_hBarrelGameMode);
        
        // If we are using default barrel hunt game mode, turn zombies into barrels
        if (GetClientTeam(client) == TEAM_UNDEAD && bh_gamemode == 0)
        {
            g_BHTimerHandle[client] = CreateTimer(1.0, BH_SetModel, client);
        }
        // If Reverse is the game mode, turn all survivors into barrels
        else if (GetClientTeam(client) == TEAM_SURVIVORS && bh_gamemode == 1)
        {
            g_BHTimerHandle[client] = CreateTimer(1.0, BH_SetModel, client);
        }
        // If Double Barrel Mode is active, both should become barrels! 
        else if (bh_gamemode == 2)
        {
            g_BHTimerHandle[client] = CreateTimer(1.0, BH_SetModel, client);
        }
        else
        {
            // The gamemode is incorrect, output the info to the log.
            LogMessage("ERROR: Gamemode option %i is not a valid gamemode!", bh_gamemode);
            return;
        }
    }
}

public Action BH_SetModel(Handle timer, int client)
{
    // Sets the player's model to a barrel
    // NOTE: You must precache this model or it will not set!
    if (!IsPlayerValid(client))
    {
        return Plugin_Continue;
    }
    
    SetEntityModel(client,g_aBarrelAssets[0]);
    return Plugin_Continue;
}

stock bool IsPlayerValid(int client)
{
    // Are they connected, in game, and alive?
    if (IsClientInGame(client) && IsClientConnected(client) && IsPlayerAlive(client))
    {
        return true;
    }
    
    return false;
}