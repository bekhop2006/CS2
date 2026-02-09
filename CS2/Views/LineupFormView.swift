//
//  LineupFormView.swift
//  CS2
//

import SwiftUI

struct LineupFormView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: LineupViewModel

    @State private var positionName: String = ""
    @State private var descriptionText: String = ""
    @State private var mapName: String = "Mirage"
    @State private var category: LineupCategory = .smoke
    @State private var dateCreated: Date = Date()
    @State private var isFavorite: Bool = false

    var editingLineup: SmokeLineup?
    var initialMapName: String?
    private var isEditing: Bool { editingLineup != nil }

    init(viewModel: LineupViewModel, editingLineup: SmokeLineup? = nil, initialMapName: String? = nil) {
        self.viewModel = viewModel
        self.editingLineup = editingLineup
        self.initialMapName = initialMapName
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Position") {
                    TextField("Position name", text: $positionName)
                    Picker("Map", selection: $mapName) {
                        ForEach(MapItem.allMaps.map(\.name), id: \.self) { name in
                            Text(name).tag(name)
                        }
                    }
                    Picker("Type", selection: $category) {
                        ForEach(LineupCategory.allCases, id: \.self) { c in
                            Text(c.rawValue).tag(c)
                        }
                    }
                }
                Section("Description") {
                    TextEditor(text: $descriptionText)
                        .frame(minHeight: 100)
                }
                Section("Date") {
                    DatePicker("Created", selection: $dateCreated, displayedComponents: .date)
                }
                Section("Favorite") {
                    Toggle("Favorite", isOn: $isFavorite)
                }
                Section {
                    Button(isEditing ? "Save changes" : "Add lineup") {
                        save()
                    }
                    .disabled(positionName.trimmingCharacters(in: .whitespaces).isEmpty || mapName.isEmpty)
                }
            }
            .navigationTitle(isEditing ? "Edit lineup" : "New lineup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                bindEditing()
                if let map = initialMapName, !isEditing { mapName = map }
            }
        }
    }

    private func bindEditing() {
        if let e = editingLineup {
            positionName = e.positionName
            descriptionText = e.description
            mapName = e.mapName
            category = e.category
            dateCreated = e.dateCreated
            isFavorite = e.isFavorite
        }
    }

    private func save() {
        let lineup = SmokeLineup(
            id: editingLineup?.id ?? UUID(),
            positionName: positionName.trimmingCharacters(in: .whitespaces),
            description: descriptionText,
            mapName: mapName,
            category: category,
            dateCreated: dateCreated,
            isFavorite: isFavorite
        )
        withAnimation(.easeInOut(duration: 0.25)) {
            if isEditing {
                viewModel.update(lineup)
            } else {
                viewModel.add(lineup)
            }
        }
        dismiss()
    }
}
