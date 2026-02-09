//
//  SettingsView.swift
//  CS2
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("cs2_defaultMap") private var defaultMap: String = "Mirage"
    @AppStorage("cs2_sortFavoritesFirst") private var sortFavoritesFirst: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Picker("Default map", selection: $defaultMap) {
                        ForEach(MapItem.allMaps.map(\.name), id: \.self) { name in
                            Text(name).tag(name)
                        }
                    }
                    Toggle("Sort favorites first in Lineups", isOn: $sortFavoritesFirst)
                }
                Section {
                    Text("CS2 Lineups helps you remember smoke and utility positions for competitive play.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
        .onChange(of: defaultMap) { _, newValue in
            PersistenceService.shared.defaultMapName = newValue
        }
        .onChange(of: sortFavoritesFirst) { _, newValue in
            PersistenceService.shared.sortFavoritesFirst = newValue
        }
    }
}
