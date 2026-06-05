//
//  PermissionsSettingsPane.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import SwiftUI

struct PermissionsSettingsPane: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        IceForm(spacing: 16) {
            IceSection("Required") {
                permissionRow(appState.permissions.accessibility)
            }

            IceSection("Optional") {
                permissionRow(appState.permissions.screenRecording)
                Text("Screen Recording is only needed for menu bar item previews in Layout. Folding still works without it.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .onAppear {
            appState.permissions.refreshAll()
        }
    }

    private func permissionRow(_ permission: Permission) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(permission.title)
                        .font(.headline)
                    ForEach(permission.details, id: \.self) { detail in
                        Text(detail)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer(minLength: 16)

                if permission.hasPermission {
                    Label("Granted", systemImage: "checkmark.circle")
                        .foregroundStyle(.green)
                } else {
                    Button("Grant") {
                        permission.performRequest()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}
