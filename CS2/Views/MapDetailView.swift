//
//  MapDetailView.swift
//  CS2
//

import SwiftUI

struct MapDetailView: View {
    let map: MapItem
    @EnvironmentObject var lineupViewModel: LineupViewModel
    @State private var showAddLineup = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Интерактивная миникарта: точки смоков → позиции броска → видео
                if let radarName = map.radarImageName {
                    let targets = SmokeData.smokeTargets(for: map.name)
                    if !targets.isEmpty {
                        MinimapInteractiveView(mapName: map.name, radarImageName: radarName, smokeTargets: targets)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Миникарта")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Image(radarName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                    }
                } else {
                    Text("Миникарта для этой карты пока недоступна.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Лайнапы по карте
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Lineups для \(map.name)")
                            .font(.headline)
                        Spacer()
                        Button(action: { showAddLineup = true }) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .foregroundColor(.primary)

                    let forMap = lineupViewModel.lineups(for: map.name)
                    if forMap.isEmpty {
                        Text("Пока нет лайнапов. Добавьте смоки и утилити.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 8)
                    } else {
                        ForEach(forMap) { lineup in
                            NavigationLink(value: lineup) {
                                LineupRowView(lineup: lineup)
                            }
                            .padding(.vertical, 4)
                            .contextMenu {
                                Button("Удалить", role: .destructive) {
                                    lineupViewModel.delete(lineup)
                                }
                            }
                        }
                    }
                }
            }
            .padding(20)
            .padding(.bottom, 24)
        }
        .background(Theme.screenBackground)
        .navigationTitle(map.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddLineup) {
            LineupFormView(viewModel: lineupViewModel, editingLineup: nil, initialMapName: map.name)
        }
        .navigationDestination(for: SmokeLineup.self) { lineup in
            LineupDetailView(lineup: lineup, viewModel: lineupViewModel)
        }
    }
}
