#include "script_component.hpp"
#include "..\defines.hpp"
/*
 * Author: Alganthe
 * Hide / show arsenal interface.
 *
 * Arguments:
 * 0: Arsenal display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Public: No
*/

params ["_display"];

private _showToggle = !ctrlShown (_display displayCtrl IDC_menuBar);
private _ctrl = controlNull;

{
    _ctrl = _display displayCtrl _x;
    _ctrl ctrlShow _showToggle;
    _ctrl ctrlCommit FADE_DELAY;
} forEach [
    IDC_blockLeftFrame,
    IDC_blockLeftBackground,
    IDC_blockRightFrame,
    IDC_blockRighttBackground,
    IDC_loadIndicator,
    IDC_totalWeight,
    IDC_menuBar,
    IDC_infoBox,
    IDC_leftTabContent,
    IDC_rightTabContent,
    IDC_rightTabContentListnBox,
    IDC_sortLeftTab,
    IDC_sortRightTab,
    IDC_sortLeftTabDirection,
    IDC_sortRightTabDirection,
    IDC_leftSearchbarButton,
    IDC_rightSearchbarButton,
    IDC_leftSearchbar,
    IDC_rightSearchbar,
    IDC_tabLeft,
    RIGHT_PANEL_ACC_BACKGROUND_IDCS,
    RIGHT_PANEL_ACC_IDCS,
    RIGHT_PANEL_ITEMS_BACKGROUND_IDCS,
    RIGHT_PANEL_ITEMS_IDCS,
    IDC_buttonRemoveAll,
    IDC_buttonCurrentMag,
    IDC_buttonCurrentMag2,
    IDC_iconBackgroundCurrentMag,
    IDC_iconBackgroundCurrentMag2,
    IDC_statsPreviousPage,
    IDC_statsNextPage,
    IDC_statsCurrentPage
];

[QGVAR(statsToggle), [_display, _showToggle]] call CBA_fnc_localEvent;
[QGVAR(actionsToggle), [_display, _showToggle]] call CBA_fnc_localEvent;
