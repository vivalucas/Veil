//
//  MenuBarAppearanceSettingsPane.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import SwiftUI

struct MenuBarAppearanceSettingsPane: View {
    @ObservedObject var appearanceManager: MenuBarAppearanceManager

    var body: some View {
        MenuBarAppearanceEditor(
            appearanceManager: appearanceManager,
            location: .settings,
            onDone: nil
        )
    }
}
