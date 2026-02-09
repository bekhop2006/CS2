//
//  LineupViewModel.swift
//  CS2
//

import Combine
import Foundation
import SwiftUI

/// MVVM ViewModel for smoke lineups (CRUD, persistence, sorting/filtering)
final class LineupViewModel: ObservableObject {
    @Published private(set) var lineups: [SmokeLineup] = []
    private let persistence = PersistenceService.shared

    init() {
        loadLineups()
    }

    // MARK: - Custom functions (requirement: at least 2 in ViewModels)

    func loadLineups() {
        lineups = persistence.loadLineups()
    }

    func saveLineups() {
        persistence.saveLineups(lineups)
    }

    // MARK: - CRUD

    func add(_ lineup: SmokeLineup) {
        guard lineup.isValid else { return }
        lineups.append(lineup)
        saveLineups()
    }

    func update(_ lineup: SmokeLineup) {
        guard let i = lineups.firstIndex(where: { $0.id == lineup.id }), lineup.isValid else { return }
        lineups[i] = lineup
        saveLineups()
    }

    func delete(_ lineup: SmokeLineup) {
        lineups.removeAll { $0.id == lineup.id }
        saveLineups()
    }

    func delete(at offsets: IndexSet) {
        lineups.remove(atOffsets: offsets)
        saveLineups()
    }

    // MARK: - Closure-based operations (filter, map, sorted)

    func lineups(for mapName: String) -> [SmokeLineup] {
        lineups.filter { $0.mapName == mapName }
    }

    func lineupsSortedByDate(ascending: Bool = false) -> [SmokeLineup] {
        lineups.sorted { ascending ? $0.dateCreated < $1.dateCreated : $0.dateCreated > $1.dateCreated }
    }

    func favoriteLineups() -> [SmokeLineup] {
        lineups.filter { $0.isFavorite }
    }

    /// Lineups grouped by map for List sections; sorted by map name
    func lineupsGroupedByMap() -> [(key: String, value: [SmokeLineup])] {
        let grouped = Dictionary(grouping: lineups) { $0.mapName }
        return grouped.map { (key: $0.key, value: $0.value) }
            .sorted { $0.key < $1.key }
    }

    /// Summary counts per map (for Home)
    func lineupCountByMap() -> [String: Int] {
        lineups.reduce(into: [String: Int]()) { result, lineup in
            result[lineup.mapName, default: 0] += 1
        }
    }
}
