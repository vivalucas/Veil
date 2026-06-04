//
//  SharedConstants.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import Foundation

/// Constants shared across all targets (main app and XPC services).
/// Only values that are needed in every target belong here; app-only
/// constants live in `Constants` (main app target).
enum SharedConstants {
    // MARK: - System Framework Paths

    /// Info.plist key used to configure the SkyLight private framework path.
    static let skyLightFrameworkPathInfoPlistKey = "VeilSkyLightFrameworkPath"

    /// Path to the SkyLight private framework for window capture APIs.
    static let skyLightFrameworkPath: String = requiredInfoPlistString(skyLightFrameworkPathInfoPlistKey)

    // MARK: - Helpers

    /// Returns a required string from the bundle's Info.plist.
    private static func requiredInfoPlistString(_ key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            fatalError("Missing or invalid Info.plist string for key: \(key)")
        }
        return value
    }
}
