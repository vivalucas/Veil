//
//  LayoutBar.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import SwiftUI

struct LayoutBar: View {
    private struct Representable: NSViewRepresentable {
        let appState: AppState
        let section: MenuBarSection.Name

        func makeNSView(context _: Context) -> LayoutBarScrollView {
            LayoutBarScrollView(appState: appState, section: section)
        }

        func updateNSView(_: LayoutBarScrollView, context _: Context) {
            // Intentionally empty: `LayoutBarScrollView` wires itself to shared
            // state during initialization, so subsequent updates arrive through
            // its internal observers rather than SwiftUI's representable hook.
        }
    }

    @EnvironmentObject var appState: AppState

    let section: MenuBarSection.Name

    private var backgroundShape: some InsettableShape {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
    }

    var body: some View {
        mainContent
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .menuBarItemContainer(appState: appState)
            .containerShape(backgroundShape)
            .clipShape(backgroundShape)
            .contentShape([.interaction, .focusEffect], backgroundShape)
            .overlay {
                backgroundShape
                    .strokeBorder(Color(red: 0.65, green: 0.86, blue: 1.0).opacity(0.35), lineWidth: 0.8)
            }
    }

    @ViewBuilder
    private var mainContent: some View {
        Representable(appState: appState, section: section)
    }
}
