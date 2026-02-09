//
//  MapsView.swift
//  CS2
//

import SwiftUI

enum MapsTab: String, CaseIterable {
    case active = "ACTIVE MAPS"
    case other = "OTHER MAPS"
}

struct MapsView: View {
    @EnvironmentObject var lineupViewModel: LineupViewModel
    @State private var selectedTab: MapsTab = .active

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                tabs
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

    private var tabs: some View {
        HStack(spacing: 0) {
            ForEach(MapsTab.allCases, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    Text(tab.rawValue)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.9))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Group {
                                if selectedTab == tab {
                                    Theme.tabSelected
                                } else {
                                    Color.clear
                                }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Theme.headerBackground)
    }

    private var mapList: some View {
        let items = selectedTab == .active ? MapItem.activeMaps : MapItem.otherMaps

        return List(items) { map in
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
