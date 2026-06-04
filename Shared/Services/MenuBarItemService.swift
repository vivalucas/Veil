//
//  MenuBarItemService.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import Foundation

enum MenuBarItemService {
    static let name = "io.github.vivalucas.Veil.MenuBarItemService"
}

extension MenuBarItemService {
    enum Request: Codable {
        case start
        case sourcePID(WindowInfo)
        case sourcePIDs([WindowInfo])
    }

    enum Response: Codable {
        case start
        case sourcePID(pid_t?)
        case sourcePIDs([pid_t?])
    }
}
