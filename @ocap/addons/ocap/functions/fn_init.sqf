/*
	Function: ocap_fnc_init

	Description:
	Initialises OCAP global variables and mission event handlers.
	Capture loop is automatically started once init completes.

	Paramaters:
	_logic = [OBJECT] Module settings
	_units = [LIST] List of affected units
	_activated = [BOOL] True if the module is activated

	Returns:
	nil

	Author: MisterGoodson, TelluriumCrystal
*/

// Get Module settings
_this params ["_logic", "", "_activated"];

if(_activated and isServer) then {

	// Define global variables
	ocap_version = "0.7.0";														 // OCAP version
	ocap_ace3Present = isClass (configFile >> "CfgPatches" >> "ace_medical");	 // True if ACE3 medical is present
	ocap_enableCapture = true;													 // Enables or disables the data capture
	ocap_moduleEnableCapture = true;											 // Mirrors the pause and resume module commands
	ocap_captureArray = [];														 // Array containing capture strings waiting to be saved to the .data file
	ocap_exportPath = _logic getVariable "ExportPath";                           // Absolute path the mission.data file will be exported to
	ocap_captureDelay = _logic getVariable "CaptureDelay";        				 // Minimum delay between each capture, may be exceeded if number of entities is high or scheduler is overloaded
	ocap_pauseCaptureOnNoPlayers = _logic getVariable "PauseCaptureOnNoPlayers"; // Enables/disables automatic export if all players leave the server
	ocap_endCaptureOnEndMission = _logic getVariable "EndCaptureOnEndMission";   // Enables/disables automatic export when the mission ends
	ocap_debug = _logic getVariable "DebugMode";                                 // Enables/disables verbose debug logging
	ocap_missionEHs = [];														 // List of all OCAP mission event handlers and their types to allow easy removal
	ocap_eh_aceUnconscious = nil;												 // ACE3 unconscious CBA event handler id to allow easy removal
	ocap_mainLoop = nil;														 // Script handle for OCAP main capture loop to allow terminating the loop

	// Use CBA setting export path if module path is empty
	if (ocap_exportPath == "") then {
		ocap_exportPath = ocap_ModuleInit_ExportPath_default;
	};

	// Force end capture on no players to be false in singleplayer
	if (!isMultiplayer) then {
		ocap_pauseCaptureOnNoPlayers = false;
	};

	// Add mission event handlers and save ids to event handler array
	ocap_missionEHs pushBack ["EntityKilled", addMissionEventHandler ["EntityKilled", {_this call ocap_fnc_eh_entityKilled}]];
	ocap_missionEHs pushBack ["EntityRespawned", addMissionEventHandler ["EntityRespawned", {_this call ocap_fnc_eh_entityRespawned}]];
	ocap_missionEHs pushBack ["HandleDisconnect", addMissionEventHandler ["HandleDisconnect", {_this call ocap_fnc_eh_handleDisconnect}]];
	ocap_missionEHs pushBack ["PlayerConnected", addMissionEventHandler ["PlayerConnected", {_this call ocap_fnc_eh_playerConnected}]];
	ocap_missionEHs pushBack ["Ended", addMissionEventHandler ["Ended", {_this call ocap_fnc_eh_ended}]];
	ocap_missionEHs pushBack ["MPEnded", addMissionEventHandler ["MPEnded", {_this call ocap_fnc_eh_ended}]];

	// ACE3 medical unconscious event hander
	if (ocap_ace3Present) then {
		diag_log "OCAP: found ACE3, will include detection of unconsciousness";
		//ocap_fnc_eh_aceUnconscious = call compileFinal preprocessFileLineNumbers "functions\fn_eh_aceUnconscious.sqf";
		ocap_eh_aceUnconscious = ["ace_unconscious", ocap_fnc_eh_aceUnconscious] call CBA_fnc_addEventHandler;
	};

	// Delete mission capture file if it already exists
	0 call ocap_fnc_callExtension;

	// Create metadata and mission head capture strings and append to capture array
	private _armaInfo = productVersion;
	private _armaVersion = _armaInfo select 2;
	private _userPlatform = _armaInfo select 6;
	private _userArch = _armaInfo select 7;
	private _captureString = format ["0;%1;%2;%3;%4", ocap_version, _armaVersion, _userPlatform, _userArch];
	ocap_captureArray pushBack _captureString;
	2 call ocap_fnc_callExtension;
	private _missionAuthor = getMissionConfigValue ["author", ""];
	_captureString = format ["1;%1;%2;%3;%4;", worldName, missionName, _missionAuthor, time];
	ocap_captureArray pushBack _captureString;
	1 call ocap_fnc_callExtension;

	// Log that init has completed
	diag_log "OCAP: init complete";

	// Start position capture and export loop
	ocap_mainLoop = [] spawn ocap_fnc_captureLoop;
};

nil
