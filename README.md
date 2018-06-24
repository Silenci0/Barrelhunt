# Barrelhunt
Code for Barrelhunt, a custom ZPS gamemode

Please note that this plugin is rather simple and has been rewritten as to not interfere with other plugins or methods/variables from other plugins. 
This plugin can be run on a server without too much worry as it only triggers with maps that have "barrelhunt", "bhs", or "bhm" in the map name. However, you can remove this restriction and recompile the plugin yourself.

==== Version 2.5 (6-11-2018) ====
- Added "sm_doublebarrel_mode" cvar. This will basically turn all players (zombies and survivors) into barrels! Set this in your server and/or sm config file!
- Updated code and compiled against 1.8 SM. This should work for ZPS 3.0 now!
- Added a few validation checks to make sure we only turn active/living/valid players into barrels.
- Added some handles to clear old timers in the case of round restart/disconnects from the server.
