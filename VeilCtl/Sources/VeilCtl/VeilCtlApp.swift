//
//  VeilCtlApp.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import AppKit
import SwiftUI

@main
struct VeilCtlApp: App {
    @State private var engine = VeilCtlEngine()

    var body: some Scene {
        Window("VeilCtl", id: "VeilCtl-main") {
            ContentView(engine: engine)
                .frame(minWidth: 600, minHeight: 500)
                .onOpenURL { url in
                    engine.handleIncoming(url: url)
                }
        }
        .windowResizability(.contentMinSize)
        .handlesExternalEvents(matching: ["*"])
    }
}

@Observable
final class VeilCtlEngine {
    var log: [LogEntry] = []
    var callbacks: [CallbackResponse] = []

    struct LogEntry: Identifiable {
        let id = UUID()
        let timestamp: Date
        let direction: Direction
        let message: String

        enum Direction: String { case sent = "→ SENT", received = "← GOT" }
    }

    struct CallbackResponse: Identifiable {
        let id = UUID()
        let timestamp: Date
        let rawData: String
        var parsed: [String: Any]? {
            guard let d = rawData.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: d) as? [String: Any]
            else { return nil }
            return json
        }
    }

    func handleIncoming(url: URL) {
        guard url.scheme?.lowercased() == "veilctl" else { return }
        handleCallback(url: url)
    }

    private func handleCallback(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let dataItem = components.queryItems?.first(where: { $0.name == "data" })?.value
        else { return }

        let entry = CallbackResponse(timestamp: Date(), rawData: dataItem)
        callbacks.insert(entry, at: 0)
        log.insert(LogEntry(timestamp: Date(), direction: .received, message: dataItem), at: 0)
    }

    func send(url: String) {
        log.insert(LogEntry(timestamp: Date(), direction: .sent, message: url), at: 0)
        guard let url = URL(string: url) else { return }
        NSWorkspace.shared.open(url)
    }

    func sendSet(key: String, value: String, display: String = "") {
        var url = "veil://set?key=\(key)&value=\(value)"
        if !display.isEmpty { url += "&display=\(display)" }
        send(url: url)
    }

    func sendToggle(key: String, display: String = "") {
        var url = "veil://toggle?key=\(key)"
        if !display.isEmpty { url += "&display=\(display)" }
        send(url: url)
    }

    func sendGet(key: String, display: String = "") {
        let callback = "veilctl://response"
        var url = "veil://get?key=\(key)&callback=\(callback)"
        if !display.isEmpty { url += "&display=\(display)" }
        send(url: url)
    }

    func sendAuthorize() {
        send(url: "veil://authorize")
    }

    func sendAction(_ action: String) {
        send(url: "veil://\(action)")
    }
}
