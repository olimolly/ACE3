#include "script_component.hpp"
#include "..\defines.hpp"
/*
 * Author: Alganthe, johnb43
 * Handles keyboard inputs inside the searchbars text boxes.
 *
 * Arguments:
 * 0: Arsenal display <DISPLAY>
 * 1: Searchbar control <CONTROL>
 *
 * Return Value:
 * None
 *
 * Public: No
*/

params ["_display", "_control"];

private _searchString = ctrlText _control;

// Right panel search bar
if ((ctrlIDC _control) == IDC_rightSearchbar) then {
    // Don't refill if there is no need
    if (GVAR(lastSearchTextRight) != "" && {(_searchString find GVAR(lastSearchTextRight)) != 0}) then {
        [_display, _display displayCtrl GVAR(currentRightPanel)] call FUNC(fillRightPanel);
    };

    GVAR(lastSearchTextRight) = _searchString;

    // If nothing searched, quit here
    if (_searchString == "") exitWith {};

    private _rightPanelState = GVAR(currentLeftPanel) in [IDC_buttonPrimaryWeapon, IDC_buttonHandgun, IDC_buttonSecondaryWeapon, IDC_buttonBinoculars];
    private _rightPanelCtrl = [_display displayCtrl IDC_rightTabContentListnBox, _display displayCtrl IDC_rightTabContent] select _rightPanelState;

    _searchString = toLower _searchString;

    // If right panel selection is weapons or binoculars
    if (_rightPanelState) then {
        // Get the currently selected item in panel
        private _selectedItemIndex = lbCurSel _rightPanelCtrl;
        private _selectedItem = "";

        // If something is selected, save it
        if (_selectedItemIndex != -1) then {
            _selectedItem = _rightPanelCtrl lbText _selectedItemIndex;
        };

        private _currentDisplayName = "";
        private _currentClassname = "";

        // Go through all items in panel and see if they need to be deleted or not
        for "_lbIndex" from (lbSize _rightPanelCtrl) - 1 to 0 step -1 do {
            _currentDisplayName = toLower (_rightPanelCtrl lbText _lbIndex);
            _currentClassname = toLower (_rightPanelCtrl lbData _lbIndex);

            // Remove item in panel if it doesn't match search, skip otherwise
            if ((_currentDisplayName == "") || {!(_searchString in _currentDisplayName) && {!(_searchString in _currentClassname)}}) then {
                _rightPanelCtrl lbDelete _lbIndex;
            };
        };

        // Try to select previously selected item again, otherwise select nothing
        if (_selectedItemIndex != -1) then {
            private _index = -1;

            // Try to find previously selected item in panel
            for "_lbIndex" from 0 to (lbSize _rightPanelCtrl) - 1 do {
                if ((_rightPanelCtrl lbText _lbIndex) == _selectedItem) exitWith {
                    _index = _lbIndex;
                };
            };

            // Select old item if found, otherwise don't select anything
            _rightPanelCtrl lbSetCurSel _index;
        } else {
            _rightPanelCtrl lbSetCurSel -1;
        };
    } else {
        // Get the currently selected item in panel
        private _selectedItemIndex = lnbCurSelRow _rightPanelCtrl;
        private _selectedItem = "";

        // If something is selected, save it
        if (_selectedItemIndex != -1) then {
            _selectedItem = _rightPanelCtrl lnbText [_selectedItemIndex, 1];
        };

        private _currentDisplayName = "";
        private _currentClassname = "";

        // Go through all items in panel and see if they need to be deleted or not
        for "_lbIndex" from (lnbSize _rightPanelCtrl select 0) - 1 to 0 step -1 do {
            _currentDisplayName = toLower (_rightPanelCtrl lnbText [_lbIndex, 1]);
            _currentClassname = toLower (_rightPanelCtrl lnbData [_lbIndex, 0]);

            // Remove item in panel if it doesn't match search, skip otherwise
            if ((_currentDisplayName == "") || {!(_searchString in _currentDisplayName) && {!(_searchString in _currentClassname)}}) then {
                _rightPanelCtrl lnbDeleteRow _lbIndex;
            };
        };

        // Try to select previously selected item again, otherwise select nothing
        if (_selectedItemIndex != -1) then {
            private _index = -1;

            // Try to find previously selected item in panel
            for "_lbIndex" from 0 to (lnbSize _rightPanelCtrl select 0) - 1 do {
                if ((_rightPanelCtrl lnbText [_lbIndex, 1]) == _selectedItem) exitWith {
                    _index = _lbIndex;
                };
            };

            // Select old item if found, otherwise don't select anything
            _rightPanelCtrl lnbSetCurSelRow _index;
        } else {
            _rightPanelCtrl lnbSetCurSelRow -1;
        };
    };

    [_display, nil, nil, configNull] call FUNC(itemInfo);
} else {
    // Left panel search bar
    // Don't refill if there is no need
    if (GVAR(lastSearchTextLeft) != "" && {(_searchString find GVAR(lastSearchTextLeft)) != 0}) then {
        [_display, _display displayCtrl GVAR(currentLeftPanel)] call FUNC(fillLeftPanel);
    };

    GVAR(lastSearchTextLeft) = _searchString;

    // If nothing searched, quit here
    if (_searchString == "") exitWith {};

    private _leftPanelCtrl = _display displayCtrl IDC_leftTabContent;

    _searchString = toLower _searchString;

    // Get the currently selected item in panel
    private _selectedItemIndex = lbCurSel _leftPanelCtrl;
    private _selectedItem = "";

    // If something is selected, save it
    if (_selectedItemIndex != -1) then {
        _selectedItem = _leftPanelCtrl lbText _selectedItemIndex;
    };

    private _currentDisplayName = "";
    private _currentClassname = "";

    // Go through all items in panel and see if they need to be deleted or not
    for "_lbIndex" from (lbSize _leftPanelCtrl) - 1 to 0 step -1 do {
        _currentDisplayName = toLower (_leftPanelCtrl lbText _lbIndex);
        _currentClassname = toLower (_leftPanelCtrl lbData _lbIndex);

        // Remove item in panel if it doesn't match search, skip otherwise
        if ((_currentDisplayName == "") || {!(_searchString in _currentDisplayName) && {!(_searchString in _currentClassname)}}) then {
            _leftPanelCtrl lbDelete _lbIndex;
        };
    };

    // Try to select previously selected item again, otherwise select nothing
    if (_selectedItemIndex != -1) then {
        private _index = -1;

        for "_lbIndex" from 0 to (lbSize _leftPanelCtrl) - 1 do {
            if ((_leftPanelCtrl lbText _lbIndex) == _selectedItem) exitWith {
                _index = _lbIndex;
            };
        };

        _leftPanelCtrl lbSetCurSel _index;
    } else {
        _leftPanelCtrl lbSetCurSel -1;
    };

    [_display, nil, nil, configNull] call FUNC(itemInfo);
};
