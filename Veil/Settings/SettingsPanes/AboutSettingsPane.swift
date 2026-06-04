//
//  AboutSettingsPane.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import SwiftUI

struct AboutSettingsPane: View {
    var body: some View {
        IceForm {
            IceSection {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Constants.displayName)
                            .font(.headline)

                        Text("Version \(Constants.versionString) (\(Constants.buildString))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .textSelection(.enabled)

                        Text(Constants.copyrightString)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    checkForUpdatesButton
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
            }
        }
    }

    private var checkForUpdatesButton: some View {
        HStack(spacing: 12) {
            Button("Check for Updates") {
                AppDelegate.shared?.checkForUpdates(nil)
            }

            Button("Quit \(Constants.displayName)") {
                NSApp.terminate(nil)
            }
            .foregroundStyle(.red)
        }
    }
}
