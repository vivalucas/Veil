//
//  ProfileEntityTests.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

@testable import Veil
import XCTest

final class ProfileEntityTests: XCTestCase {
    // MARK: - Initialization Tests

    func testInitialization() {
        let entity = ProfileEntity(id: "test-id", name: "Test Profile")

        XCTAssertEqual(entity.id, "test-id")
        XCTAssertEqual(entity.name, "Test Profile")
    }

    // MARK: - Type Display Representation

    func testTypeDisplayRepresentation() {
        let representation = ProfileEntity.typeDisplayRepresentation
        XCTAssertNotNil(representation)
    }

    // MARK: - Display Representation

    func testDisplayRepresentationContainsName() {
        let entity = ProfileEntity(id: "123", name: "My Profile")
        let representation = entity.displayRepresentation

        // The display representation title should contain the profile name
        XCTAssertNotNil(representation.title)
    }
}
