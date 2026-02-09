//
//  SettingsView.swift
//  CS2
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var auth = AuthService.shared
    @AppStorage("cs2_defaultMap") private var defaultMap: String = "Mirage"
    @AppStorage("cs2_sortFavoritesFirst") private var sortFavoritesFirst: Bool = false
    @State private var showDeleteAccountAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if let user = auth.currentUser {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.email)
                                .font(.body)
                            Text("Локальный аккаунт — данные только на этом устройстве")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        Button("Выйти", role: .destructive) {
                            auth.logout()
                        }
                        Button("Удалить аккаунт", role: .destructive) {
                            showDeleteAccountAlert = true
                        }
                    }
                } header: {
                    Text("Аккаунт")
                } footer: {
                    Text("Регистрация и вход хранятся только на этом устройстве. Удаление аккаунта стирает его с устройства; с тем же email можно зарегистрироваться снова.")
                }
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
        .alert("Удалить аккаунт?", isPresented: $showDeleteAccountAlert) {
            Button("Отмена", role: .cancel) {}
            Button("Удалить", role: .destructive) {
                auth.deleteAccount()
            }
        } message: {
            Text("Аккаунт будет удалён с этого устройства. С тем же email можно зарегистрироваться заново.")
        }
    }
}
