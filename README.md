# Barrelhunt
Code for Barrelhunt, a custom ZPS gamemode

Please note that this plugin is rather simple and has been rewritten as to not interfere with other plugins or methods/variables from other plugins. 
This plugin can be run on a server without too much worry as it only triggers with maps that have "barrelhunt", "bhs", or "bhm" in the map name. However, you can remove this restriction and recompile the plugin yourself.

# Cvars
The following cvars are available in the plugin:

- `sm_barrelhunt_version` - [ZPS] Barrelhunt Version.
- `sm_barrel_gamemode` - Sets the gamemode for the plugin. Normal (Zombies are barrels) = "0", Reverse (Survivors are barrels) = "1" Double Barrel (Both teams are barrels) = "2". Default is "0"

NOTE: There is no configuration file for this plugin, place the sm_barrel_gamemode cvar into server.cfg or sourcemod.cfg (which ever you prefer).

# Changelog
2.6.0 Update (12-04-2019)
-----------------
- Updated plugin code to use the new syntax.
- Updated the plugin with three game modes: Normal, Reverse, and Double Barrel. See Cvar description for more details.
- Compiled plugins for SM 1.10

2.5 Update/Release (6-11-2018)
-----------------
- Added "sm_doublebarrel_mode" cvar. This will basically turn all players (zombies and survivors) into barrels! Set this in your server and/or sm config file!
- Updated code and compiled against 1.8 SM. This should work for ZPS 3.0 now!
- Added a few validation checks to make sure we only turn active/living/valid players into barrels.
- Added some handles to clear old timers in the case of round restart/disconnects from the server.
