//
//  DisplaySettingsManagerSpacingGateTests.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

@testable import Veil
import XCTest

@MainActor
final class DisplaySettingsManagerSpacingGateTests: XCTestCase {
    // MARK: - Predicate

    func testPredicateSkipsWhenUUIDsMatch() {
        XCTAssertTrue(DisplaySettingsManager.shouldSkipSpacingApply(
            currentActiveDisplayUUID: "UUID-A",
            lastAppliedActiveDisplayUUID: "UUID-A"
        ))
    }

    func testPredicateDoesNotSkipWhenUUIDsDiffer() {
        XCTAssertFalse(DisplaySettingsManager.shouldSkipSpacingApply(
            currentActiveDisplayUUID: "UUID-B",
            lastAppliedActiveDisplayUUID: "UUID-A"
        ))
    }

    func testPredicateDoesNotSkipOnFirstApply() {
        XCTAssertFalse(DisplaySettingsManager.shouldSkipSpacingApply(
            currentActiveDisplayUUID: "UUID-A",
            lastAppliedActiveDisplayUUID: nil
        ))
    }

    func testPredicateDoesNotSkipWhenCurrentBecomesNil() {
        XCTAssertFalse(DisplaySettingsManager.shouldSkipSpacingApply(
            currentActiveDisplayUUID: nil,
            lastAppliedActiveDisplayUUID: "UUID-A"
        ))
    }

    func testPredicateSkipsWhenBothNil() {
        XCTAssertTrue(DisplaySettingsManager.shouldSkipSpacingApply(
            currentActiveDisplayUUID: nil,
            lastAppliedActiveDisplayUUID: nil
        ))
    }

    func testPredicateIsStableAcrossRepeatedCalls() {
        for _ in 0 ..< 10 {
            XCTAssertTrue(DisplaySettingsManager.shouldSkipSpacingApply(
                currentActiveDisplayUUID: "UUID-A",
                lastAppliedActiveDisplayUUID: "UUID-A"
            ))
        }
    }

    // MARK: - Field semantics

    func testFreshManagerHasNilLastAppliedUUID() {
        let manager = DisplaySettingsManager()
        XCTAssertNil(manager.lastAppliedActiveDisplayUUID)
    }

    func testSeededFieldDrivesPredicate() {
        let manager = DisplaySettingsManager()
        manager.lastAppliedActiveDisplayUUID = "UUID-A"

        XCTAssertTrue(DisplaySettingsManager.shouldSkipSpacingApply(
            currentActiveDisplayUUID: "UUID-A",
            lastAppliedActiveDisplayUUID: manager.lastAppliedActiveDisplayUUID
        ))
        XCTAssertFalse(DisplaySettingsManager.shouldSkipSpacingApply(
            currentActiveDisplayUUID: "UUID-B",
            lastAppliedActiveDisplayUUID: manager.lastAppliedActiveDisplayUUID
        ))
    }

    // MARK: - Disconnected Display Cleanup

    func testRemoveDisconnectedDisplayRemovesCachedMetadataAndConfiguration() {
        let manager = DisplaySettingsManager()
        let uuid = UUID().uuidString
        manager.knownDisplays[uuid] = KnownDisplay(name: "Old Display", hasNotch: false)
        manager.configurations[uuid] = DisplayIceBarConfiguration.defaultConfiguration.withUseIceBar(true)

        manager.removeDisconnectedDisplay(uuid: uuid)

        XCTAssertNil(manager.knownDisplays[uuid])
        XCTAssertNil(manager.configurations[uuid])
    }

    func testRemoveAllDisconnectedDisplaysClearsCachedDisconnectedDisplays() {
        let manager = DisplaySettingsManager()
        let firstUUID = UUID().uuidString
        let secondUUID = UUID().uuidString
        manager.knownDisplays[firstUUID] = KnownDisplay(name: "Old Display A", hasNotch: false)
        manager.knownDisplays[secondUUID] = KnownDisplay(name: "Old Display B", hasNotch: true)
        manager.configurations[firstUUID] = DisplayIceBarConfiguration.defaultConfiguration.withUseIceBar(true)
        manager.configurations[secondUUID] = DisplayIceBarConfiguration.defaultConfiguration.withGridColumns(5)

        manager.removeAllDisconnectedDisplays()

        XCTAssertTrue(manager.knownDisplays.isEmpty)
        XCTAssertTrue(manager.configurations.isEmpty)
    }
}
