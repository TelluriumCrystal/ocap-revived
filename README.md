[![GitHub release (latest by date)](https://img.shields.io/github/v/release/TelluriumCrystal/ocap-revived)](https://github.com/TelluriumCrystal/ocap-revived/releases)
[![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/TelluriumCrystal/ocap-revived?include_prereleases&label=pre-release)](https://github.com/TelluriumCrystal/ocap-revived/releases)
[![GitHub issues](https://img.shields.io/github/issues/TelluriumCrystal/ocap-revived)](https://github.com/TelluriumCrystal/ocap-revived/issues)
[![GitHub license](https://img.shields.io/github/license/TelluriumCrystal/ocap-revived?color=g)](https://www.gnu.org/licenses/gpl-3.0.en.html)

![OCAP](https://i.imgur.com/4Z16B8J.png)

**Operation Capture And Playback - REVIVED (BETA)**

![OCAP Screenshot](https://i.imgur.com/67L12wKl.jpg)

## What is it?
OCAP is a tool for Arma 3 that facilitates recording and playback of operations on an interactive web-based map. Reveal where the enemy was located, analyze how each group carried out their assaults, and find out who engaged who, when, and with what. Use it simply for fun or as a training tool to see how well your group performs on ops.

## Overview

* Interactive web-based playback. All you need is a browser.
* Captures positions of all units and vehicles throughout an operation.
* Captures events such as shots fired, kills, and hits.
* Event log displays events as they happened in realtime.
* Clicking on a unit lets you follow them.
* Server based capture - no mods required for clients.

## Running OCAP
Capture automatically begins when server becomes populated (see userconfig for settings).

To end and export capture data, call the following (server-side):

`[] call ocap_fnc_exportData;`

**Tip:** You can use the above function in a trigger.
e.g. Create a trigger that activates once all objectives complete. Then on activiation:
```
if (isServer) then {
    [] call ocap_fnc_exportData;
};

"end1" call BIS_fnc_endMission; // Ends mission for everyone
```

## Revival
When the original development of OCAP was abandoned, the data collection/map data server was shut down. We are currently in the process of re-writing the application to facilitate running on a local server only. The tool is currently functional but is buggy and lacking features. We will continue to work on getting it into a more polished state.
 
## Credits

* [3 Commando Brigade](http://www.3commandobrigade.com/) for testing and moral-boosting.
* [Leaflet](http://leafletjs.com/) - an awesome JS interactive map library.
* Maca134 for his tutorial on [writing Arma extensions in C#](http://maca134.co.uk/tutorial/write-an-arma-extension-in-c-sharp-dot-net/).


Original work copyright (C) 2016 Jamie Goodson (aka MisterGoodson) (goodsonjamie@yahoo.co.uk)

Modified work copyright (C) 2020 OCAP Revived contributors
