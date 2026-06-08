//
//  HookRunnerTests.swift
//  Project: Veil
//
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import XCTest
@testable import Veil

final class HookRunnerTests: XCTestCase {
    func testLargeStdoutDoesNotBlockHookProcess() async throws {
        let scriptURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("VeilHookRunnerLargeStdout-\(UUID().uuidString).sh")
        defer { try? FileManager.default.removeItem(at: scriptURL) }

        let script = """
        #!/bin/sh
        i=0
        while [ "$i" -lt 5000 ]; do
          printf '0123456789abcdef0123456789abcdef\\n'
          i=$((i + 1))
        done
        """

        try script.write(to: scriptURL, atomically: true, encoding: .utf8)
        try FileManager.default.setAttributes(
            [.posixPermissions: 0o755],
            ofItemAtPath: scriptURL.path
        )

        let hook = HookScript(path: scriptURL.path, timeoutSeconds: 5, isEnabled: true)
        let outcome = try await HookRunner.run(
            hook,
            context: HookRunner.Context(
                phase: .pre,
                scope: .profile,
                profileID: UUID(),
                profileName: "Large Output",
                previousProfileID: nil,
                previousProfileName: nil
            )
        )

        XCTAssertEqual(outcome.exitStatus, 0)
        XCTAssertTrue(outcome.stdout.contains("[output truncated]"))
    }
}
