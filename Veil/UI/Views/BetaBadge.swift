//
//  BetaBadge.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import SwiftUI

/// A view that displays a badge indicating a beta feature.
struct BetaBadge: View {
    private var backgroundShape: some Shape {
        Capsule()
    }

    var body: some View {
        Text("BETA")
            .font(.system(size: 10, weight: .medium))
            .padding(.horizontal, 6)
            .padding(.vertical, 1)
            .background {
                backgroundShape
                    .fill(Color.accentColor.opacity(0.14))
            }
            .foregroundStyle(Color.accentColor)
    }
}
