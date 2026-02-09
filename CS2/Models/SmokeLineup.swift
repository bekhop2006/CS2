//
//  SmokeLineup.swift
//  CS2
//

import Foundation

// MARK: - Lineup category (enum for OOP requirement)
enum LineupCategory: String, CaseIterable, Codable, Hashable {
    case smoke = "Smoke"
    case flash = "Flash"
    case molotov = "Molotov"
    case other = "Other"
}

// MARK: - Main entity (struct, Identifiable, Codable)
struct SmokeLineup: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var positionName: String
    var description: String
    var mapName: String
    var category: LineupCategory
    var dateCreated: Date
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        positionName: String = "",
        description: String = "",
        mapName: String = "",
        category: LineupCategory = .smoke,
        dateCreated: Date = Date(),
        isFavorite: Bool = false
    ) {
        self.id = id
        self.positionName = positionName
        self.description = description
        self.mapName = mapName
        self.category = category
        self.dateCreated = dateCreated
        self.isFavorite = isFavorite
    }
}

// MARK: - Custom protocol (Validatable requirement)
protocol Validatable {
    var isValid: Bool { get }
}

extension SmokeLineup: Validatable {
    var isValid: Bool {
        !positionName.trimmingCharacters(in: .whitespaces).isEmpty
            && !mapName.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
