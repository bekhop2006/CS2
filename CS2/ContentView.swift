//
//  ContentView.swift
//  CS2
//
//  Created by Beknur Tanibergen on 09.02.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var lineupViewModel = LineupViewModel()
    @ObservedObject private var auth = AuthService.shared

    var body: some View {
        Group {
            if auth.isLoggedIn {
                MainTabView()
                    .environmentObject(lineupViewModel)
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
