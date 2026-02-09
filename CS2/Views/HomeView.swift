//
//  HomeView.swift
//  CS2
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var lineupViewModel: LineupViewModel
    @StateObject private var tipsVM = TipsViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section("Your lineups") {
                    let counts = lineupViewModel.lineupCountByMap()
                    if counts.isEmpty {
                        Text("No lineups yet. Add lineups in the Lineups or Maps tab.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(Array(counts.keys).sorted(), id: \.self) { mapName in
                            HStack {
                                Text(mapName)
                                Spacer()
                                Text("\(counts[mapName] ?? 0)")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                Section("Recent") {
                    let recent = lineupViewModel.lineupsSortedByDate(ascending: false).prefix(3)
                    if recent.isEmpty {
                        Text("No recent lineups.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(Array(recent)) { lineup in
                            NavigationLink(value: lineup) {
                                LineupRowView(lineup: lineup)
                            }
                        }
                    }
                }
                Section("Community tips") {
                    tipsContent
                }
            }
            .navigationTitle("Home")
            .onAppear { tipsVM.loadTips() }
            .refreshable { tipsVM.loadTips() }
            .navigationDestination(for: SmokeLineup.self) { lineup in
                LineupDetailView(lineup: lineup, viewModel: lineupViewModel)
            }
        }
    }

    @ViewBuilder
    private var tipsContent: some View {
        switch tipsVM.state {
        case .idle:
            Text("Pull to load tips")
                .foregroundColor(.secondary)
        case .loading:
            HStack {
                ProgressView()
                Text("Loading…")
                    .foregroundColor(.secondary)
            }
        case .success(let posts):
            ForEach(posts.prefix(5), id: \.id) { post in
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.title)
                        .font(.subheadline.weight(.medium))
                    Text(post.body)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                .padding(.vertical, 4)
            }
        case .error(let message):
            Text("Error: \(message)")
                .foregroundColor(.red)
        }
    }
}
