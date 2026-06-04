//
//  DisplaySettingsPane.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import SwiftUI

struct DisplaySettingsPane: View {
    @ObservedObject var displaySettings: DisplaySettingsManager

    private var hasDisconnectedDisplays: Bool {
        displaySettings.allDisplays().contains { !$0.isConnected }
    }

    var body: some View {
        IceForm {
            if hasDisconnectedDisplays {
                IceSection {
                    HStack {
                        Text("Disconnected display settings")
                        Spacer()
                        Button("Clear All") {
                            displaySettings.removeAllDisconnectedDisplays()
                        }
                    }
                    .annotation("Remove saved settings for displays that are no longer connected.")
                }
            }

            ForEach(displaySettings.allDisplays()) { display in
                IceSection {
                    displayRow(for: display)
                }
            }
        }
    }

    @ViewBuilder
    private func displayRow(for display: DisplaySettingsManager.DisplayInfo) -> some View {
        let useIceBar = Binding<Bool>(
            get: { displaySettings.configuration(forUUID: display.id).useIceBar },
            set: { newValue in
                displaySettings.updateConfiguration(forDisplayUUID: display.id) { config in
                    config.withUseIceBar(newValue)
                }
            }
        )

        let location = Binding<IceBarLocation>(
            get: { displaySettings.configuration(forUUID: display.id).iceBarLocation },
            set: { newValue in
                displaySettings.updateConfiguration(forDisplayUUID: display.id) { config in
                    config.withIceBarLocation(newValue)
                }
            }
        )

        let alwaysShowHiddenItems = Binding<Bool>(
            get: { displaySettings.configuration(forUUID: display.id).alwaysShowHiddenItems },
            set: { newValue in
                displaySettings.updateConfiguration(forDisplayUUID: display.id) { config in
                    config.withAlwaysShowHiddenItems(newValue)
                }
            }
        )

        let layout = Binding<IceBarLayout>(
            get: { displaySettings.configuration(forUUID: display.id).iceBarLayout },
            set: { newValue in
                displaySettings.updateConfiguration(forDisplayUUID: display.id) { config in
                    config.withIceBarLayout(newValue)
                }
            }
        )

        let gridColumns = Binding<Int>(
            get: { displaySettings.configuration(forUUID: display.id).gridColumns },
            set: { newValue in
                displaySettings.updateConfiguration(forDisplayUUID: display.id) { config in
                    config.withGridColumns(newValue)
                }
            }
        )

        HStack {
            Spacer()
            Text(display.name)
                .font(.headline)
            if display.hasNotch {
                Text("Notch")
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.quaternary)
                    .clipShape(Capsule())
            }
            if !display.isConnected {
                Text("Disconnected")
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.quaternary)
                    .clipShape(Capsule())
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if !display.isConnected {
                Button("Remove") {
                    displaySettings.removeDisconnectedDisplay(uuid: display.id)
                }
            }
        }

        Toggle("Always show hidden items", isOn: alwaysShowHiddenItems)
            .disabled(useIceBar.wrappedValue)
            .annotation {
                if useIceBar.wrappedValue {
                    Text("Not available because the \(Constants.displayName) Bar is enabled for this display.")
                } else {
                    Text("Always show hidden menu bar items in the menu bar on this display.")
                }
            }

        Toggle("Use \(Constants.displayName) Bar", isOn: useIceBar)
            .annotation("Show hidden menu bar items in a separate bar below the menu bar on this display.")

        if useIceBar.wrappedValue {
            IcePicker("Location", selection: location) {
                ForEach(IceBarLocation.allCases) { loc in
                    Text(loc.localized).tag(loc)
                }
            }
            .annotation {
                switch location.wrappedValue {
                case .dynamic:
                    Text("The \(Constants.displayName) Bar's location changes based on context.")
                case .mousePointer:
                    Text("The \(Constants.displayName) Bar is centered below the mouse pointer.")
                case .iceIcon:
                    Text("The \(Constants.displayName) Bar is centered below the \(Constants.displayName) icon.")
                case .leftAligned:
                    Text("The \(Constants.displayName) Bar is aligned to the left edge of the display.")
                case .rightAligned:
                    Text("The \(Constants.displayName) Bar is aligned to the right edge of the display.")
                }
            }

            IcePicker("Layout", selection: layout) {
                ForEach(IceBarLayout.allCases) { lay in
                    Text(lay.localized).tag(lay)
                }
            }
            .annotation {
                switch layout.wrappedValue {
                case .horizontal:
                    Text("Items are arranged in a single horizontal row.")
                case .vertical:
                    Text("Items are stacked vertically in a single column.")
                case .grid:
                    Text("Items are arranged in a grid with multiple columns.")
                }
            }

            if layout.wrappedValue == .grid {
                let gridColumnsDouble = Binding<Double>(
                    get: { Double(gridColumns.wrappedValue) },
                    set: { gridColumns.wrappedValue = Int($0) }
                )
                LabeledContent {
                    IceSlider(
                        value: gridColumnsDouble,
                        in: 2 ... 10,
                        step: 1
                    ) {
                        Text(verbatim: "\(gridColumns.wrappedValue)")
                    }
                } label: {
                    Text("Columns")
                }
                .annotation("Maximum number of items per row in the grid layout.")
            }
        }

        // The menu bar item spacing control has been removed; the app now
        // uses the system default spacing on every display.
    }
}
