/************************************************************************
*************************************************************************
[ZPS] Barrelhunt
Description:
	Initiates the Barrelhunt gamemode on select maps in ZPS with 'barrelhunt'
    or 'bhm' naming conventions in the map. The classic gamemode basically 
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

#define TEAM_SURVIVORS  2
#define TEAM_UNDEAD     3
#define PLUGIN_VERSION "2.0"
#define BARREL_MODEL "models/props_c17/oildrum001.mdl"

new String:g_sBHMap[PLATFORM_MAX_PATH];
new bool:g_bBarrelHunt = false;

public Plugin:myinfo = {
    name = "[ZPS] Barrelhunt",
    author = "noob cannon lol (original author), Mr.Silence (update)",
    description = "Zombies become barrels!",
    version = PLUGIN_VERSION,
    url = "http://forums.alliedmods.net"
};

public OnMapStart()
{
    // Is the map we are on actually barrelhunt?
    GetCurrentMap(g_sBHMap, sizeof(g_sBHMap));
    if(StrContains(g_sBHMap, "barrelhunt", false) > -1 || StrContains(g_sBHMap, "bhm", false) > -1)
    {
        g_bBarrelHunt  = true;
    }

    // If the map is a barrelhunt map...
    if (g_bBarrelHunt  == true)
    {    
        // Grab our events
        HookEvent("player_spawn", BH_SpawnHandler, EventHookMode_Post);
        HookEvent("player_team", BH_SpawnHandler, EventHookMode_Post);

        // Precache our model
        PrecacheModel(BARREL_MODEL);
        
        // Add the barrel files to be downloaded by the client
        // NOTE: The files from props_c17 all belong to HL2 and are not native to ZPS,
        // despite being an HL2 mod. This means we have to have users download the files 
        // into models directory client side as well as have them server side.
        AddFileToDownloadsTable(BARREL_MODEL);
        AddFileToDownloadsTable("models/props_c17/oildrum001.jpg");
        AddFileToDownloadsTable("models/props_c17/oildrum001.dx80.vtx");
        AddFileToDownloadsTable("models/props_c17/oildrum001.dx90.vtx");
        AddFileToDownloadsTable("models/props_c17/oildrum001.phy");
        AddFileToDownloadsTable("models/props_c17/oildrum001.sw.vtx"); 
        AddFileToDownloadsTable("models/props_c17/oildrum001.vvd");
    }
}

public OnMapEnd()
{
    // Unhook and resest everything
    g_bBarrelHunt  = false;
    UnhookEvent("player_spawn", BH_SpawnHandler, EventHookMode_Post);
    UnhookEvent("player_team", BH_SpawnHandler, EventHookMode_Post);
}

public BH_SpawnHandler(Handle:event, const String:name[], bool:dontBroadcast)
{
    // Grab our player, find out if they are a zombie, and 
    // create a timer that sets the player's entity model to a barrel
    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    if (GetClientTeam(client) == TEAM_UNDEAD)
    {
        CreateTimer(1.0, BH_SetModel, client);
    }
}

public Action:BH_SetModel(Handle:timer, any:client)
{
    // Sets the player's model to a barrel
    // NOTE: You must precache this model or it will not set!
    SetEntityModel(client,BARREL_MODEL);
}