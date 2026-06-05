//
//  SettingsNavigationIdentifier.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import SwiftUI

/// The navigation identifier type for the "Settings" interface.
enum SettingsNavigationIdentifier: String, NavigationIdentifier {
    case general = "Folding"
    case menuBarLayout = "Menu Bar Layout"
    case permissions = "Permissions"
    case about = "About"

    var localized: LocalizedStringKey {
        switch self {
        case .general: "Folding"
        case .menuBarLayout: "Layout"
        case .permissions: "Permissions"
        case .about: "About"
        }
    }

    var iconResource: IconResource {
        switch self {
        case .general: .systemSymbol("rectangle.compress.vertical")
        case .menuBarLayout: .systemSymbol("rectangle.topthird.inset.filled")
        case .permissions: .systemSymbol("checkmark.shield")
        case .about: .systemSymbol("cube")
        }
    }
}
