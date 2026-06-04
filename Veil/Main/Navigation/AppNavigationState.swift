//
//  AppNavigationState.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import Combine

/// The model for app-wide navigation.
@MainActor
final class AppNavigationState: ObservableObject {
    @Published var isAppFrontmost = false
    @Published var isSettingsPresented = false
    @Published var isIceBarPresented = false
    @Published var isSearchPresented = false
    @Published var settingsNavigationIdentifier: SettingsNavigationIdentifier = .general
}
