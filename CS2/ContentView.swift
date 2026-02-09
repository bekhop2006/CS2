//
//  ContentView.swift
//  CS2
//
//  Created by Beknur Tanibergen on 09.02.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var lineupViewModel = LineupViewModel()

    var body: some View {
        MainTabView()
            .environmentObject(lineupViewModel)
    }
}

#Preview {
    ContentView()
}
