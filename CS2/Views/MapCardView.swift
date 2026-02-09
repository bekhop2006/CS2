//
//  MapCardView.swift
//  CS2
//

import SwiftUI

struct MapCardView: View {
    let map: MapItem

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(map.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 160)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 24))

            Text(map.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 1)
                .padding(.leading, 20)
                .padding(.bottom, 16)
        }
        .frame(height: 160)
        .contentShape(Rectangle())
        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    MapCardView(map: MapItem.activeMaps[0])
        .padding()
        .background(Theme.screenBackground)
}
