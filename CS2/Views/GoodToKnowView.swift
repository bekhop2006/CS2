//
//  GoodToKnowView.swift
//  CS2
//

import SwiftUI

struct GoodToKnowView: View {
    var body: some View {
        ZStack {
            Theme.screenBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.yellow)

                Text("Good to Know")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Полезная информация о картах и режимах игры.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    GoodToKnowView()
}
