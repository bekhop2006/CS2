//
//  LineupDetailView.swift
//  CS2
//

import SwiftUI

struct LineupDetailView: View {
    let lineup: SmokeLineup
    @ObservedObject var viewModel: LineupViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showEdit = false

    var body: some View {
        List {
            Section("Position") {
                LabeledContent("Position", value: lineup.positionName)
                LabeledContent("Map", value: lineup.mapName)
                LabeledContent("Type", value: lineup.category.rawValue)
                LabeledContent("Date", value: lineup.dateCreated.formatted(date: .abbreviated, time: .omitted))
                LabeledContent("Favorite", value: lineup.isFavorite ? "Yes" : "No")
            }
            Section("Description") {
                Text(lineup.description.isEmpty ? "—" : lineup.description)
            }
        }
        .navigationTitle(lineup.positionName)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { showEdit = true }
            }
            ToolbarItem(placement: .secondaryAction) {
                Button("Delete", role: .destructive) {
                    withAnimation { viewModel.delete(lineup); dismiss() }
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            LineupFormView(viewModel: viewModel, editingLineup: lineup)
        }
    }
}
