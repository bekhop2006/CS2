//
//  LineupListView.swift
//  CS2
//

import SwiftUI

struct LineupListView: View {
    @EnvironmentObject var viewModel: LineupViewModel
    @State private var showForm = false
    @State private var editingLineup: SmokeLineup?
    @AppStorage("cs2_sortFavoritesFirst") private var sortFavoritesFirst: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(lineupsWithSections(), id: \.key) { section in
                    Section(section.key) {
                        ForEach(section.value) { lineup in
                            NavigationLink(value: lineup) {
                                LineupRowView(lineup: lineup)
                            }
                            .contextMenu {
                                Button("Edit") { editingLineup = lineup }
                                Button("Delete", role: .destructive) {
                                    withAnimation { viewModel.delete(lineup) }
                                }
                            }
                        }
                        .onDelete { offsets in
                            let list = section.value
                            for i in offsets {
                                viewModel.delete(list[i])
                            }
                        }
                    }
                }
            }
            .navigationTitle("Lineups")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showForm = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showForm) {
                LineupFormView(viewModel: viewModel)
            }
            .sheet(item: $editingLineup) { lineup in
                LineupFormView(viewModel: viewModel, editingLineup: lineup)
            }
            .navigationDestination(for: SmokeLineup.self) { lineup in
                LineupDetailView(lineup: lineup, viewModel: viewModel)
            }
        }
    }

    private func lineupsWithSections() -> [(key: String, value: [SmokeLineup])] {
        var grouped = viewModel.lineupsGroupedByMap()
        if sortFavoritesFirst {
            grouped = grouped.map { (key: $0.key, value: $0.value.sorted { $0.isFavorite && !$1.isFavorite }) }
        }
        return grouped
    }
}

struct LineupRowView: View {
    let lineup: SmokeLineup

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(lineup.positionName)
                    .font(.headline)
                if lineup.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }
            Text(lineup.mapName)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(lineup.category.rawValue)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
