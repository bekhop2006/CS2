//
//  PersistenceService.swift
//  CS2
//

import Foundation

final class PersistenceService {
    static let shared = PersistenceService()
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let lineups = "cs2_lineups"
        static let defaultMap = "cs2_defaultMap"
        static let sortFavoritesFirst = "cs2_sortFavoritesFirst"
    }

    private init() {}

    // MARK: - Lineups (CRUD)

    func loadLineups() -> [SmokeLineup] {
        guard let data = defaults.data(forKey: Keys.lineups) else { return [] }
        let decoded = (try? JSONDecoder().decode([SmokeLineup].self, from: data)) ?? []
        return decoded
    }

    func saveLineups(_ lineups: [SmokeLineup]) {
        guard let data = try? JSONEncoder().encode(lineups) else { return }
        defaults.set(data, forKey: Keys.lineups)
    }

    // MARK: - Settings

    var defaultMapName: String {
        get { defaults.string(forKey: Keys.defaultMap) ?? "Mirage" }
        set { defaults.set(newValue, forKey: Keys.defaultMap) }
    }

    var sortFavoritesFirst: Bool {
        get { defaults.bool(forKey: Keys.sortFavoritesFirst) }
        set { defaults.set(newValue, forKey: Keys.sortFavoritesFirst) }
    }
}
