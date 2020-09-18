/*
	Function: ocap_fnc_exportData

	Description:
	Exports all current capture strings to the temp file, then builds and exports
	the footer capture strings. Next it tells the extension to export the temp file to
	its final location and deletes the local copy. Finally, all event handlers are removed,
	the main capture loop is terminated, and all missionNamespace variables are deinstantiated.

	Note that this is a terminal function. OCAP must be reinitalized to resume capturing
	data. Because it has to wait for the main loop to stop this function should be spawned.

	Parameters:
	None

	Returns:
	nil

	Author: TelluriumCrystal
*/

// Check if OCAP is running
if (isNil {ocap_captureArray}) then {
	diag_log "OCAP: Error: exportData called but OCAP is not running!";
} else {

	// Log that export is starting
	diag_log "OCAP: exporting all data to remote folder";
	
	// Terminate main capture loop
	terminate ocap_mainLoop;
	
	// Wait for main loop to completely terminate
	waitUntil { scriptDone ocap_mainLoop };
	
	// Create mission footer capture string and append to capture array
	private _captureString = format ["2;%1",  time];
	ocap_captureArray pushBack _captureString;

	// Export all data to remote folder
	2 call ocap_fnc_callExtension;
	3 call ocap_fnc_callExtension;
	0 call ocap_fnc_callExtension;

	// Remove all event handlers
	{
		removeMissionEventHandler _x;
	} forEach ocap_missionEHs;
	{
		private _unit = _x;
		if (_unit getVariable ["ocap_isInitialised", false]) then {
			{
				_unit removeEventHandler _x;
			} forEach (_unit getVariable "ocap_eventHandlers");
			{
				_unit removeMPEventHandler _x;
			} forEach (_unit getVariable "ocap_MPeventHandlers");
			_unit setVariable ["ocap_isInitialised", nil];
			_unit setVariable ["ocap_exclude", nil];
			_unit setVariable ["ocap_id", nil];
			_unit setVariable ["ocap_eventHandlers", nil];
			_unit setVariable ["ocap_MPeventHandlers", nil];
		};
	} forEach (allUnits + (entities "LandVehicle") + (entities "Ship") + (entities "Air"));
	if (ocap_ace3Present) then {
		["ace_unconscious", ocap_eh_aceUnconscious] call CBA_fnc_removeEventHandler;
	};

	// Deallocate all global variables
	ocap_version = nil;
	ocap_ace3Present = nil;
	ocap_enableCapture = nil;
	ocap_moduleEnableCapture = nil;
	ocap_captureArray = nil;
	ocap_exportPath = nil;
	ocap_captureDelay = nil;
	ocap_endCaptureOnNoPlayers = nil;
	ocap_endCaptureOnEndMission = nil;
	ocap_debug = nil;
	ocap_missionEHs = nil;
	ocap_eh_aceUnconscious = nil;
	ocap_mainLoop = nil;

	// Log that OCAP is now shut down
	diag_log "OCAP: exporting complete and OCAP has shut down";
};

nil
