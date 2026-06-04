//
//  IceMenu.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import SwiftUI

struct IceMenu<Title: View, Label: View, Content: View>: View {
    private let title: Title
    private let label: Label
    private let content: Content

    /// Creates a menu with the given content, title, and label.
    ///
    /// - Parameters:
    ///   - content: A group of menu items.
    ///   - title: A view to display inside the menu.
    ///   - label: A view to display as an external label for the menu.
    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder title: () -> Title,
        @ViewBuilder label: () -> Label
    ) {
        self.title = title()
        self.label = label()
        self.content = content()
    }

    /// Creates a menu with the given content, title, and label key.
    ///
    /// - Parameters:
    ///   - labelKey: A string key for the menu's external label.
    ///   - content: A group of menu items.
    ///   - title: A view to display inside the menu.
    init(
        _ labelKey: LocalizedStringKey,
        @ViewBuilder content: () -> Content,
        @ViewBuilder title: () -> Title
    ) where Label == Text {
        self.init {
            content()
        } title: {
            title()
        } label: {
            Text(labelKey)
        }
    }

    var body: some View {
        LabeledContent {
            Menu {
                content
                    .labelStyle(.titleAndIcon)
                    .toggleStyle(.automatic)
            } label: {
                title
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color(red: 0.9, green: 0.97, blue: 1.0).opacity(0.14))
                    )
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .strokeBorder(Color(red: 0.65, green: 0.86, blue: 1.0).opacity(0.28), lineWidth: 0.8)
                    )
            }
            .menuStyle(.button)
            .buttonStyle(.bordered)
            .labelsHidden()
            .fixedSize()
        } label: {
            label
        }
    }
}
