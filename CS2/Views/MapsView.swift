//
//  MapsView.swift
//  CS2
//

import SwiftUI

struct MapsView: View {
    @EnvironmentObject var lineupViewModel: LineupViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                mapList
            }
            .background(Theme.screenBackground)
            .ignoresSafeArea(edges: .bottom)
            .navigationDestination(for: MapItem.self) { map in
                MapDetailView(map: map)
                    .environmentObject(lineupViewModel)
            }
        }
    }

    private var header: some View {
        ZStack {
            Theme.headerBackground
                .ignoresSafeArea()

            HStack {
                Button(action: {}) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(.white)
                }

                Spacer()

                Text("MAPS")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "person.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .frame(height: 56)
    }

    private var mapList: some View {
        List(MapItem.activeMaps) { map in
            NavigationLink(value: map) {
                MapCardView(map: map)
                    .contentShape(Rectangle())
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    MapsView()
        .environmentObject(LineupViewModel())
}
