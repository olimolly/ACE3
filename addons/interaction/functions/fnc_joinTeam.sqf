#include "script_component.hpp"
/*
 * Author: commy2
 * Unit joins a fire team.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Team <STRING>
 * 2: Display hint <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "YELLOW", false] call ace_interaction_fnc_joinTeam
 *
 * Public: No
 */

params ["_unit", "_team", ["_displayHint", false, [false]]];

_unit assignTeam _team;

// display message
if (_unit == ACE_player) then {
    private _message = "";

    if (_team == "MAIN") then {
        _message = localize LSTRING(LeftTeam);
    } else {
        _team = localize format [LSTRING(Team%1), _team];
        _message = format [localize LSTRING(JoinedTeam), _team];
    };
    if (_displayHint) then {
        [_message] call EFUNC(common,displayTextStructured);
    };
};
