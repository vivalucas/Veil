//
//  SettingsWindow.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import SwiftUI

// MARK: - SettingsWindow

struct SettingsWindow: Scene {
    @ObservedObject var appState: AppState

    var body: some Scene {
        IceWindow(id: .settings) {
            SettingsView(appState: appState, navigationState: appState.navigationState)
                .frame(minWidth: 850, minHeight: 600)
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 950, height: 650)
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        .environmentObject(appState)
    }
}
