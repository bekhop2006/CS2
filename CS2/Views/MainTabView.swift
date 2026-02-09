//
//  MainTabView.swift
//  CS2
//

import SwiftUI

enum AppTab: Int, CaseIterable {
    case home = 0
    case maps = 1
    case lineups = 2
    case settings = 3

    var title: String {
        switch self {
        case .home: return "Home"
        case .maps: return "Maps"
        case .lineups: return "Lineups"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .maps: return "map.fill"
        case .lineups: return "list.bullet"
        case .settings: return "gearshape.fill"
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case .home: HomeView()
                case .maps: MapsView()
                case .lineups: LineupListView()
                case .settings: SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            bottomTabBar
        }
        .ignoresSafeArea(.keyboard)
    }

    private var bottomTabBar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.rawValue) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.title3)
                            .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.7))
                        Text(tab.title)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 8)
        .safeAreaPadding(.bottom, 16)
        .background(Theme.headerBackground)
    }
}

#Preview {
    MainTabView()
        .environmentObject(LineupViewModel())
}
