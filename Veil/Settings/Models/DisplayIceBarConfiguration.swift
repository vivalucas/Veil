//
//  DisplayIceBarConfiguration.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import AppKit

/// Per-display configuration for the Veil Bar.
struct DisplayIceBarConfiguration: Codable, Equatable {
    /// Whether the Veil Bar is enabled on this display.
    let useIceBar: Bool

    /// The location where the Veil Bar appears on this display.
    let iceBarLocation: IceBarLocation

    /// Whether to always show hidden menu bar items on this display.
    ///
    /// This setting is only applicable when ``useIceBar`` is `false`.
    let alwaysShowHiddenItems: Bool

    /// The layout mode for the Veil Bar on this display.
    let iceBarLayout: IceBarLayout

    /// The maximum number of items per row when the Veil Bar is in grid layout.
    ///
    /// Valid range is 2 through 10.
    let gridColumns: Int

    /// Preserved for backward-compatible decoding of older profiles and
    /// defaults. New versions keep menu bar spacing at the system default.
    let itemSpacingOffset: Double

    /// Default configuration (disabled, dynamic location, horizontal layout).
    static let defaultConfiguration = DisplayIceBarConfiguration(
        useIceBar: false,
        iceBarLocation: .dynamic,
        alwaysShowHiddenItems: false,
        iceBarLayout: .horizontal,
        gridColumns: 4,
        itemSpacingOffset: 0
    )

    /// Returns a new configuration with the `useIceBar` flag replaced.
    func withUseIceBar(_ value: Bool) -> DisplayIceBarConfiguration {
        DisplayIceBarConfiguration(
            useIceBar: value,
            iceBarLocation: iceBarLocation,
            alwaysShowHiddenItems: alwaysShowHiddenItems,
            iceBarLayout: iceBarLayout,
            gridColumns: gridColumns,
            itemSpacingOffset: itemSpacingOffset
        )
    }

    /// Returns a new configuration with the `iceBarLocation` replaced.
    func withIceBarLocation(_ value: IceBarLocation) -> DisplayIceBarConfiguration {
        DisplayIceBarConfiguration(
            useIceBar: useIceBar,
            iceBarLocation: value,
            alwaysShowHiddenItems: alwaysShowHiddenItems,
            iceBarLayout: iceBarLayout,
            gridColumns: gridColumns,
            itemSpacingOffset: itemSpacingOffset
        )
    }

    /// Returns a new configuration with the `alwaysShowHiddenItems` flag replaced.
    func withAlwaysShowHiddenItems(_ value: Bool) -> DisplayIceBarConfiguration {
        DisplayIceBarConfiguration(
            useIceBar: useIceBar,
            iceBarLocation: iceBarLocation,
            alwaysShowHiddenItems: value,
            iceBarLayout: iceBarLayout,
            gridColumns: gridColumns,
            itemSpacingOffset: itemSpacingOffset
        )
    }

    /// Returns a new configuration with the `iceBarLayout` replaced.
    func withIceBarLayout(_ value: IceBarLayout) -> DisplayIceBarConfiguration {
        DisplayIceBarConfiguration(
            useIceBar: useIceBar,
            iceBarLocation: iceBarLocation,
            alwaysShowHiddenItems: alwaysShowHiddenItems,
            iceBarLayout: value,
            gridColumns: gridColumns,
            itemSpacingOffset: itemSpacingOffset
        )
    }

    /// Returns a new configuration with the `gridColumns` replaced.
    ///
    /// Values are clamped to the range 2 through 10.
    func withGridColumns(_ value: Int) -> DisplayIceBarConfiguration {
        DisplayIceBarConfiguration(
            useIceBar: useIceBar,
            iceBarLocation: iceBarLocation,
            alwaysShowHiddenItems: alwaysShowHiddenItems,
            iceBarLayout: iceBarLayout,
            gridColumns: Swift.max(2, Swift.min(value, 10)),
            itemSpacingOffset: itemSpacingOffset
        )
    }

    /// Preserves source compatibility for the removed menu bar spacing
    /// workflow while keeping the runtime spacing at the system default.
    func withItemSpacingOffset(_ value: Double) -> DisplayIceBarConfiguration {
        DisplayIceBarConfiguration(
            useIceBar: useIceBar,
            iceBarLocation: iceBarLocation,
            alwaysShowHiddenItems: alwaysShowHiddenItems,
            iceBarLayout: iceBarLayout,
            gridColumns: gridColumns,
            itemSpacingOffset: 0
        )
    }

    /// Builds per-display configurations for all connected screens.
    @MainActor
    static func buildConfigurations(
        onlyOnNotched: Bool,
        location: IceBarLocation
    ) -> [String: DisplayIceBarConfiguration] {
        var configs = [String: DisplayIceBarConfiguration]()
        for screen in NSScreen.screens {
            guard let uuid = Bridging.getDisplayUUIDString(for: screen.displayID) else {
                continue
            }
            let enabled = onlyOnNotched ? screen.hasNotch : true
            configs[uuid] = DisplayIceBarConfiguration(
                useIceBar: enabled,
                iceBarLocation: location,
                alwaysShowHiddenItems: false,
                iceBarLayout: .horizontal,
                gridColumns: 4,
                itemSpacingOffset: 0
            )
        }
        return configs
    }
}

// MARK: - Backward-compatible decoding

extension DisplayIceBarConfiguration {
    enum CodingKeys: String, CodingKey {
        case useIceBar
        case iceBarLocation
        case alwaysShowHiddenItems
        case iceBarLayout
        case gridColumns
        case itemSpacingOffset
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.useIceBar = try container.decode(Bool.self, forKey: .useIceBar)
        self.iceBarLocation = try container.decode(IceBarLocation.self, forKey: .iceBarLocation)
        self.alwaysShowHiddenItems = try container.decode(Bool.self, forKey: .alwaysShowHiddenItems)
        self.iceBarLayout = try container.decodeIfPresent(IceBarLayout.self, forKey: .iceBarLayout) ?? .horizontal
        let decodedGridColumns = try container.decodeIfPresent(Int.self, forKey: .gridColumns) ?? 4
        self.gridColumns = Swift.max(2, Swift.min(decodedGridColumns, 10))
        _ = try container.decodeIfPresent(Double.self, forKey: .itemSpacingOffset)
        self.itemSpacingOffset = 0
    }
}
