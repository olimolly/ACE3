#include "script_component.hpp"

[QGVAR(updateDamageEffects), LINKFUNC(updateDamageEffects)] call CBA_fnc_addEventHandler;
["unit", {
    params ["_new"];
    [_new] call FUNC(updateDamageEffects); // Run on new controlled unit to update QGVAR(aimFracture)
}, true] call CBA_fnc_addPlayerEventHandler;


["CAManBase", "init", {
    params ["_unit"];

    // Check if last hit point is our dummy.
    private _allHitPoints = getAllHitPointsDamage _unit param [0, []];
    reverse _allHitPoints;
    while {(_allHitPoints param [0, ""]) select [0,1] == "#"} do { WARNING_1("Ignoring Reflector hitpoint %1", _allHitPoints deleteAt 0); };

    if (_allHitPoints param [0, ""] != "ACE_HDBracket") then {
        private _config = configOf _unit;
        if (getText (_config >> "simulation") == "UAVPilot") exitWith {TRACE_1("ignore UAV AI",typeOf _unit);};
        if (getNumber (_config >> "isPlayableLogic") == 1) exitWith {TRACE_1("ignore logic unit",typeOf _unit)};
        ERROR_1("Bad hitpoints for unit type ""%1""",typeOf _unit);
    } else {
        // Calling this function inside curly brackets allows the usage of
        // "exitWith", which would be broken with "HandleDamage" otherwise.
        _unit setVariable [
            QEGVAR(medical,HandleDamageEHID),
            _unit addEventHandler ["HandleDamage", {_this call FUNC(handleDamage)}]
        ];
    };
}, nil, [IGNORE_BASE_UAVPILOTS], true] call CBA_fnc_addClassEventHandler;

#ifdef DEBUG_MODE_FULL
[QEGVAR(medical,woundReceived), {
    params ["_unit", "_damages", "_shooter", "_ammo"];
    TRACE_4("wound",_unit,_damages, _shooter, _ammo);
    //systemChat str _this;
}] call CBA_fnc_addEventHandler;
#endif


// this handles moving units into vehicles via load functions or zeus
// needed, because the vanilla INCAPACITATED state does not handle vehicles
["CAManBase", "GetInMan", {
    params ["_unit", "", "_vehicle"];

    if (local _unit && {lifeState _unit == "INCAPACITATED"}) then {
        [_unit, true] call FUNC(setUnconsciousAnim);
    };

    if (local _vehicle) then {
        [_unit] call FUNC(lockUnconsciousSeat);
    };
}] call CBA_fnc_addClassEventHandler;

["CAManBase", "GetOutMan", {
    params ["_unit", "", "_vehicle"];

    if (local _vehicle) then {
        [_unit] call FUNC(unlockUnconsciousSeat);
    };
}] call CBA_fnc_addClassEventHandler;

// Guarantee aircraft crashes are more lethal
["Air", "Killed", {
    params ["_vehicle", "_killer"];
    TRACE_3("air killed",_vehicle,typeOf _vehicle,velocity _vehicle);
    if ((getText (configOf _vehicle >> "destrType")) == "") exitWith {};
    if (unitIsUAV _vehicle) exitWith {};

    private _lethality = linearConversion [0, 25, (vectorMagnitude velocity _vehicle), 0.5, 1];
    TRACE_2("air crash",_lethality,crew _vehicle);
    {
        [QEGVAR(medical,woundReceived), [_x, [[_lethality, "Head", _lethality]], _killer, "#vehiclecrash"], _x] call CBA_fnc_targetEvent;
    } forEach (crew _vehicle);
}, true, ["ParachuteBase"]] call CBA_fnc_addClassEventHandler;

// Fixes units being stuck in unconscious animation when being knocked over by a PhysX object
["CAManBase", "AnimDone", {
    params ["_unit", "_anim"];
    if (local _unit && {_anim find QUNCON_ANIM(face) != -1 && {lifeState _unit != "INCAPACITATED"}}) then {
        [_unit, false] call FUNC(setUnconsciousAnim);
    };
}] call CBA_fnc_addClassEventHandler;

["ace_unconscious", {
    params ["_unit", "_unconscious"];
    TRACE_3("unit uncon",_unit,objectParent _unit,local _unit);
    if (!isNull objectParent _unit && {local objectParent _unit}) then {
        if (_unconscious) then {
            [_unit] call FUNC(lockUnconsciousSeat);
        } else {
            [_unit] call FUNC(unlockUnconsciousSeat);
        };
    };
}] call CBA_fnc_addEventHandler;

["ace_killed", { // global event
    params ["_unit"];
    TRACE_3("unit Killed",_unit,objectParent _unit,local _unit);
    if (!isNull objectParent _unit && {local objectParent _unit}) exitWith {
        [_unit] call FUNC(lockUnconsciousSeat);
    };
}] call CBA_fnc_addEventHandler;

["CAManBase", "deleted", {
    params ["_unit"];
    TRACE_3("unit deleted",_unit,objectParent _unit,local _unit);
    if ((!isNull objectParent _unit) && {local objectParent _unit}) then {
        [_unit] call FUNC(unlockUnconsciousSeat);
    };
}, true, []] call CBA_fnc_addClassEventHandler;
