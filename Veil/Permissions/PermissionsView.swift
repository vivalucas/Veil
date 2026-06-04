//
//  PermissionsView.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import SwiftUI

struct PermissionsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var manager: AppPermissions

    private var continueButtonText: LocalizedStringKey {
        if case .hasRequired = manager.permissionsState {
            "Continue in Limited Mode"
        } else {
            "Continue"
        }
    }

    private var continueButtonForegroundStyle: some ShapeStyle {
        switch manager.permissionsState {
        case .missing:
            AnyShapeStyle(.secondary)
        case .hasAll:
            AnyShapeStyle(.primary)
        case .hasRequired:
            AnyShapeStyle(Color.accentColor)
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            permissionsStack

            footerView
                .padding(.top, 2)
        }
        .padding(20)
        .frame(width: 520)
        .fixedSize()
        .onAppear {
            // First launch detection handled elsewhere
        }
    }

    private var explanationBox: some View {
        IceSection {
            VStack(alignment: .leading, spacing: 6) {
                Text("Set up access")
                    .font(.headline)

                Text("\(Constants.displayName) needs your permission to manage the menu bar.")
                    .fontWeight(.medium)

                Text("Absolutely no personal information is collected or stored.")
                    .font(.callout.weight(.medium))
                    .foregroundStyle(Color.accentColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
        }
        .font(.body)
    }

    private var permissionsStack: some View {
        VStack(spacing: 12) {
            explanationBox
            ForEach(manager.allPermissions) { permission in
                permissionBox(permission)
            }
        }
    }

    private var footerView: some View {
        HStack {
            quitButton
            continueButton
        }
        .controlSize(.large)
    }

    private var quitButton: some View {
        Button {
            NSApp.terminate(nil)
        } label: {
            Text("Quit")
                .frame(maxWidth: .infinity)
        }
    }

    private var continueButton: some View {
        Button {
            appState.dismissWindow(.permissions)

            guard manager.permissionsState != .missing else {
                appState.performSetup(hasPermissions: false)
                Defaults.set(true, forKey: .hasCompletedFirstLaunch)
                return
            }

            appState.performSetup(hasPermissions: true)
            Defaults.set(true, forKey: .hasCompletedFirstLaunch)

            Task {
                appState.activate(withPolicy: .regular)
                appState.openWindow(.settings)
            }
        } label: {
            Text(continueButtonText)
                .frame(maxWidth: .infinity)
                .foregroundStyle(continueButtonForegroundStyle)
        }
        .disabled(manager.permissionsState == .missing)
    }

    private func permissionBox(_ permission: Permission) -> some View {
        IceSection {
            VStack(alignment: .leading, spacing: 12) {
                Text(permission.title)
                    .font(.headline)

                VStack(alignment: .leading, spacing: 6) {
                    Text("\(Constants.displayName) needs this to:")
                        .font(.callout.weight(.semibold))

                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(permission.details, id: \.self) { detail in
                            HStack(alignment: .firstTextBaseline, spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.accentColor.opacity(0.85))
                                Text(detail).fontWeight(.medium)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                    permission.performRequest()
                    Task {
                        await permission.waitForPermission()
                        appState.activate(withPolicy: .regular)
                        appState.openWindow(.permissions)
                    }
                } label: {
                    if permission.hasPermission {
                        Text("Permission Granted")
                            .foregroundStyle(Color.accentColor)
                    } else {
                        Text("Grant Permission")
                    }
                }
                .allowsHitTesting(!permission.hasPermission)
                .frame(maxWidth: .infinity, alignment: .trailing)

                if !permission.isRequired {
                    CalloutBox("\(Constants.displayName) can work in a limited mode without this permission.") {
                        Image(systemName: "checkmark.shield")
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity)
        }
    }
}
