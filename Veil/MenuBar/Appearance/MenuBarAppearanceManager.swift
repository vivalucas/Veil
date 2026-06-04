//
//  MenuBarAppearanceManager.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import Cocoa
import Combine

/// A manager for the appearance of the menu bar.
@MainActor
final class MenuBarAppearanceManager: ObservableObject {
    private let diagLog = DiagLog(category: "MenuBarAppearanceManager")
    /// The current menu bar appearance configuration.
    @Published var configuration = Defaults.DefaultValue.menuBarAppearanceConfigurationV2

    /// The currently previewed partial configuration.
    @Published var previewConfiguration: MenuBarAppearancePartialConfiguration?

    /// The shared app state.
    private weak var appState: AppState?

    /// Encoder for UserDefaults values.
    private let encoder = JSONEncoder()

    /// Decoder for UserDefaults values.
    private let decoder = JSONDecoder()

    /// Storage for internal observers.
    private var cancellables = Set<AnyCancellable>()

    /// The currently managed menu bar overlay panels.
    private(set) var overlayPanels = Set<MenuBarOverlayPanel>()

    /// The amount to inset the menu bar if called for by the configuration.
    let menuBarInsetAmount: CGFloat = 3.5

    /// Performs initial setup of the manager.
    func performSetup(with appState: AppState) {
        self.appState = appState
        loadInitialState()
        configureCancellables()
    }

    /// Loads the initial values for the configuration.
    private func loadInitialState() {
        if let data = Defaults.data(forKey: .menuBarAppearanceConfigurationV2),
           let decoded = try? decoder.decode(MenuBarAppearanceConfigurationV2.self, from: data) {
            configuration = decoded
        } else {
            configuration = .defaultConfiguration
        }
    }

    /// Configures the internal observers for the manager.
    private func configureCancellables() {
        cancellables.removeAll()
    }
}
