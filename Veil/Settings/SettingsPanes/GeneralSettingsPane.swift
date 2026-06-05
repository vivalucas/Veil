//
//  GeneralSettingsPane.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

@preconcurrency import LaunchAtLogin
import SwiftUI

struct GeneralSettingsPane: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var settings: GeneralSettings

    private var rehideIntervalKey: LocalizedStringKey {
        let count = Int(settings.rehideInterval)
        return LocalizedStringKey(String(localized: "\(count) seconds"))
    }

    private var overflowBinding: Binding<Bool> {
        Binding(
            get: { appState.settings.advanced.enableMenuBarItemOverflow },
            set: { appState.settings.advanced.enableMenuBarItemOverflow = $0 }
        )
    }

    private var alwaysHiddenBinding: Binding<Bool> {
        Binding(
            get: { appState.settings.advanced.enableAlwaysHiddenSection },
            set: { appState.settings.advanced.enableAlwaysHiddenSection = $0 }
        )
    }

    var body: some View {
        IceForm(spacing: 16) {
            IceSection("Folding") {
                foldingOptions
            }
            IceSection("Reveal") {
                showOptions
            }
            IceSection("Rehide") {
                rehideOptions
            }
            IceSection("App") {
                appOptions
            }
        }
    }

    // MARK: App Options

    @ViewBuilder
    private var appOptions: some View {
        LaunchAtLogin.Toggle {
            Text("Launch at Login")
        }
    }

    // MARK: Folding Options

    @ViewBuilder
    private var foldingOptions: some View {
        Toggle("Show \(Constants.displayName) icon", isOn: $settings.showIceIcon)
            .annotation("Keep the \(Constants.displayName) control icon in the menu bar so hidden items can be revealed quickly.")

        Toggle("Automatically fold overflowing items", isOn: overflowBinding)
            .annotation("When items do not fit on a notched display, move lower-priority visible items into Hidden instead of letting them sit under the notch.")

        Toggle("Use always-hidden section", isOn: alwaysHiddenBinding)
            .annotation("Adds a second hidden section for items you almost never need.")
    }

    // MARK: Show Options

    @ViewBuilder
    private var showOptions: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle("Show on click", isOn: $settings.showOnClick)
                .annotation("Click an empty area of the menu bar to show hidden menu bar items.")

            if settings.showOnClick, appState.settings.advanced.enableAlwaysHiddenSection {
                Toggle("Double-click for always-hidden", isOn: $settings.showOnDoubleClick)
                    .annotation("Double-click an empty area of the menu bar to show always-hidden menu bar items.")
            }
        }
        Toggle("Show on hover", isOn: $settings.showOnHover)
            .annotation("Hover over an empty area of the menu bar to show hidden menu bar items.")
        Toggle("Show on scroll", isOn: $settings.showOnScroll)
            .annotation("Scroll or swipe in the menu bar to show hidden menu bar items.")
    }

    // MARK: Rehide Options

    @ViewBuilder
    private var rehideOptions: some View {
        autoRehide
        if settings.autoRehide {
            rehideStrategyPicker
        }
    }

    private var autoRehide: some View {
        Toggle("Automatically rehide", isOn: $settings.autoRehide)
    }

    private var rehideStrategyPicker: some View {
        VStack {
            IcePicker("Strategy", selection: $settings.rehideStrategy) {
                ForEach(RehideStrategy.allCases) { strategy in
                    Text(strategy.localized).tag(strategy)
                }
            }
            .annotation {
                switch settings.rehideStrategy {
                case .smart:
                    Text("Menu bar items are rehidden using a smart algorithm.")
                case .timed:
                    Text("Menu bar items are rehidden after a fixed amount of time.")
                case .focusedApp:
                    Text("Menu bar items are rehidden when the focused app changes.")
                }
            }

            if case .timed = settings.rehideStrategy {
                IceSlider(
                    rehideIntervalKey,
                    value: $settings.rehideInterval,
                    in: 0 ... 30,
                    step: 1
                )
            }
        }
    }
}
