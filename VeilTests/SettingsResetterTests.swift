//
//  SettingsResetterTests.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

@testable import Veil
import XCTest

@MainActor
final class SettingsResetterTests: XCTestCase {
    func testResetAdvancedRestoresAllAdvancedDefaults() {
        let settings = AppSettings()

        settings.advanced.enableAlwaysHiddenSection = true
        settings.advanced.showAllSectionsOnUserDrag = false
        settings.advanced.useOptionClickToShowAlwaysHiddenSection = true
        settings.advanced.useDoubleClickToShowAlwaysHiddenSection = true
        settings.advanced.sectionDividerStyle = .chevron
        settings.advanced.hideApplicationMenus = true
        settings.advanced.enableSecondaryContextMenu = true
        settings.advanced.enableSecondaryContextMenuQuit = true
        settings.advanced.showOnHoverDelay = 1.2
        settings.advanced.tooltipDelay = 1.3
        settings.advanced.showMenuBarTooltips = true
        settings.advanced.iconRefreshInterval = 2.4
        settings.advanced.enableDiagnosticLogging = true
        settings.advanced.useLCSSortingOnNotchedDisplays = true
        settings.advanced.enableMenuBarItemOverflow = false

        settings.resetAdvanced()

        XCTAssertEqual(settings.advanced.enableAlwaysHiddenSection, Defaults.DefaultValue.enableAlwaysHiddenSection)
        XCTAssertEqual(settings.advanced.showAllSectionsOnUserDrag, Defaults.DefaultValue.showAllSectionsOnUserDrag)
        XCTAssertEqual(
            settings.advanced.useOptionClickToShowAlwaysHiddenSection,
            Defaults.DefaultValue.useOptionClickToShowAlwaysHiddenSection
        )
        XCTAssertEqual(
            settings.advanced.useDoubleClickToShowAlwaysHiddenSection,
            Defaults.DefaultValue.useDoubleClickToShowAlwaysHiddenSection
        )
        XCTAssertEqual(settings.advanced.sectionDividerStyle, Defaults.DefaultValue.sectionDividerStyle)
        XCTAssertEqual(settings.advanced.hideApplicationMenus, Defaults.DefaultValue.hideApplicationMenus)
        XCTAssertEqual(settings.advanced.enableSecondaryContextMenu, Defaults.DefaultValue.enableSecondaryContextMenu)
        XCTAssertEqual(
            settings.advanced.enableSecondaryContextMenuQuit,
            Defaults.DefaultValue.enableSecondaryContextMenuQuit
        )
        XCTAssertEqual(settings.advanced.showOnHoverDelay, Defaults.DefaultValue.showOnHoverDelay)
        XCTAssertEqual(settings.advanced.tooltipDelay, Defaults.DefaultValue.tooltipDelay)
        XCTAssertEqual(settings.advanced.showMenuBarTooltips, Defaults.DefaultValue.showMenuBarTooltips)
        XCTAssertEqual(settings.advanced.iconRefreshInterval, Defaults.DefaultValue.iconRefreshInterval)
        XCTAssertEqual(settings.advanced.enableDiagnosticLogging, Defaults.DefaultValue.enableDiagnosticLogging)
        XCTAssertEqual(
            settings.advanced.useLCSSortingOnNotchedDisplays,
            Defaults.DefaultValue.useLCSSortingOnNotchedDisplays
        )
        XCTAssertEqual(
            settings.advanced.enableMenuBarItemOverflow,
            Defaults.DefaultValue.enableMenuBarItemOverflow
        )
    }
}
