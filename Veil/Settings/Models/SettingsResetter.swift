//
//  SettingsResetter.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import Foundation

extension AppSettings {
    /// Resets all settings to their default values.
    func resetAllSettingsToDefaults() {
        resetGeneral()
        resetAdvanced()
        resetHotkeys()
        resetDisplay()
        resetAppearance()
    }

    /// Resets Appearance settings to their default values.
    func resetAppearance() {
        appState?.appearanceManager.configuration = .defaultConfiguration
    }

    /// Resets General settings to their default values.
    func resetGeneral() {
        general.showIceIcon = Defaults.DefaultValue.showIceIcon
        general.iceIcon = Defaults.DefaultValue.iceIcon
        general.lastCustomIceIcon = nil
        general.customIceIconIsTemplate = Defaults.DefaultValue.customIceIconIsTemplate
        general.useIceBar = Defaults.DefaultValue.useIceBar
        general.useIceBarOnlyOnNotchedDisplay = Defaults.DefaultValue.useIceBarOnlyOnNotchedDisplay
        general.iceBarLocation = Defaults.DefaultValue.iceBarLocation
        general.iceBarLocationOnHotkey = Defaults.DefaultValue.iceBarLocationOnHotkey
        general.showOnClick = Defaults.DefaultValue.showOnClick
        general.showOnDoubleClick = Defaults.DefaultValue.showOnDoubleClick
        general.showOnHover = Defaults.DefaultValue.showOnHover
        general.showOnScroll = Defaults.DefaultValue.showOnScroll
        general.autoRehide = Defaults.DefaultValue.autoRehide
        general.rehideStrategy = Defaults.DefaultValue.rehideStrategy
        general.rehideInterval = Defaults.DefaultValue.rehideInterval
    }

    /// Resets Advanced settings to their default values.
    func resetAdvanced() {
        advanced.enableAlwaysHiddenSection = Defaults.DefaultValue.enableAlwaysHiddenSection
        advanced.showAllSectionsOnUserDrag = Defaults.DefaultValue.showAllSectionsOnUserDrag
        advanced.useOptionClickToShowAlwaysHiddenSection = Defaults.DefaultValue.useOptionClickToShowAlwaysHiddenSection
        advanced.useDoubleClickToShowAlwaysHiddenSection = Defaults.DefaultValue.useDoubleClickToShowAlwaysHiddenSection
        appState?.itemManager.updateNewItemsPlacement(section: .hidden, arrangedViews: [])
        advanced.sectionDividerStyle = Defaults.DefaultValue.sectionDividerStyle
        advanced.hideApplicationMenus = Defaults.DefaultValue.hideApplicationMenus
        advanced.enableSecondaryContextMenu = Defaults.DefaultValue.enableSecondaryContextMenu
        advanced.enableSecondaryContextMenuQuit = Defaults.DefaultValue.enableSecondaryContextMenuQuit
        advanced.showOnHoverDelay = Defaults.DefaultValue.showOnHoverDelay
        advanced.tooltipDelay = Defaults.DefaultValue.tooltipDelay
        advanced.showMenuBarTooltips = Defaults.DefaultValue.showMenuBarTooltips
        advanced.iconRefreshInterval = Defaults.DefaultValue.iconRefreshInterval
        advanced.enableDiagnosticLogging = Defaults.DefaultValue.enableDiagnosticLogging
        advanced.useLCSSortingOnNotchedDisplays = Defaults.DefaultValue.useLCSSortingOnNotchedDisplays
        advanced.enableMenuBarItemOverflow = Defaults.DefaultValue.enableMenuBarItemOverflow
    }

    /// Resets Hotkeys settings to their default values.
    func resetHotkeys() {
        Defaults.set(Defaults.DefaultValue.hotkeys, forKey: .hotkeys)
        for hotkey in hotkeys.hotkeys {
            hotkey.keyCombination = nil
        }
    }

    /// Resets Display settings to their default values.
    func resetDisplay() {
        displaySettings.configurations = Defaults.DefaultValue.displayIceBarConfigurations
    }
}
