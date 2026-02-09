//
//  MinimapInteractiveView.swift
//  CS2
//

import AVKit
import SwiftUI

/// Миникарта с точками смоков; нажатие на иконку смока → сразу открывается видео-туториал.
struct MinimapInteractiveView: View {
    let mapName: String
    let radarImageName: String
    let smokeTargets: [SmokeTarget]

    @State private var selectedSmokeTarget: SmokeTarget?
    @State private var showVideo = false
    /// Режим подбора координат: нажатие на миникарту показывает normalizedX, normalizedY для вставки в код
    @State private var pickingCoordinates = false
    @State private var pickedCoords: (x: Double, y: Double)?
    @State private var showPickedAlert = false

    private let pointSize: CGFloat = 28
    private let hitSlop: CGFloat = 44

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(pickingCoordinates ? "Нажми на место, куда поставить точку — появятся координаты" : "Нажми на точку смока — откроется видео-туториал")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button(pickingCoordinates ? "Готово" : "Указать точки") {
                    pickingCoordinates.toggle()
                    if !pickingCoordinates { pickedCoords = nil }
                }
                .font(.caption)
                .foregroundColor(Theme.tabSelected)
            }

            ZStack(alignment: .topLeading) {
                Image(radarImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        GeometryReader { geo in
                            let w = geo.size.width
                            let h = geo.size.height
                            Color.clear
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onEnded { value in
                                            guard pickingCoordinates, w > 0, h > 0 else { return }
                                            let nx = Double(value.location.x / w)
                                            let ny = Double(value.location.y / h)
                                            let clampedX = min(1, max(0, nx))
                                            let clampedY = min(1, max(0, ny))
                                            pickedCoords = (clampedX, clampedY)
                                            showPickedAlert = true
                                        }
                                )
                                .overlay(
                                    Group {
                                        if pickingCoordinates {
                                            if let c = pickedCoords {
                                                Circle()
                                                    .fill(Color.green.opacity(0.8))
                                                    .frame(width: pointSize, height: pointSize)
                                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                                    .position(x: w * c.x, y: h * c.y)
                                            }
                                        } else {
                                            ForEach(smokeTargets) { target in
                                                let x = w * target.normalizedX
                                                let y = h * target.normalizedY
                                                Button(action: {
                                                    selectedSmokeTarget = target
                                                    showVideo = true
                                                }) {
                                                    Circle()
                                                        .fill(Color.orange.opacity(0.9))
                                                        .frame(width: pointSize, height: pointSize)
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color.white, lineWidth: 2)
                                                        )
                                                }
                                                .buttonStyle(.plain)
                                                .frame(width: hitSlop, height: hitSlop)
                                                .position(x: x, y: y)
                                            }
                                        }
                                    }
                                )
                        }
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
        }
        .alert("Координаты для кода", isPresented: $showPickedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            if let c = pickedCoords {
                Text("Вставь в SmokeTarget.swift:\nnormalizedX: \(c.x, specifier: "%.3f"), normalizedY: \(c.y, specifier: "%.3f")")
            }
        }
        .sheet(isPresented: $showVideo) {
            if let target = selectedSmokeTarget {
                SmokeTutorialVideoSheet(smokeTarget: target, onDismiss: { showVideo = false })
            }
        }
    }
}

// MARK: - Видео-туториал по нажатию на иконку смока (одно видео на точку)
struct SmokeTutorialVideoSheet: View {
    let smokeTarget: SmokeTarget
    let onDismiss: () -> Void

    /// Ищем видео по карте: Dust II → video-tutor/dust2/, Mirage → video-tutor/mirage/.
    private var videoURL: URL? {
        if let s = smokeTarget.videoURL, let url = URL(string: s) { return url }
        guard let name = smokeTarget.videoAssetName else { return nil }
        let subdir: String
        switch smokeTarget.mapName {
        case "Dust II": subdir = "video-tutor/dust2"
        case "Mirage": subdir = "video-tutor/mirage"
        case "Ancient": subdir = "video-tutor/ancient"
        case "Anubis": subdir = "video-tutor/anubis"
        default: subdir = "video-tutor"
        }
        if let url = Bundle.main.url(forResource: name, withExtension: "mp4", subdirectory: subdir) { return url }
        if let url = Bundle.main.url(forResource: name, withExtension: nil, subdirectory: subdir) { return url }
        if let url = Bundle.main.url(forResource: name, withExtension: "mp4") { return url }
        return nil
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let url = videoURL {
                    VideoPlayerView(url: url)
                        .frame(height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Theme.cardBackground)
                            .frame(height: 240)
                        VStack(spacing: 12) {
                            Image(systemName: "play.rectangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)
                            Text("Видео-туториал")
                                .font(.headline)
                            Text("Смок: \(smokeTarget.name)")
                                .font(.subheadline)
                            Text("Видео не найдено. Проверь: 1) videoAssetName в SmokeTarget.swift; 2) папка CS2/video-tutor/dust2 с .mp4 в Copy Bundle Resources.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.screenBackground)
            .navigationTitle(smokeTarget.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово", action: onDismiss)
                }
            }
        }
    }
}

// MARK: - Список позиций откуда кидать выбранный смок (оставлен на случай нескольких позиций)
struct ThrowPositionsSheet: View {
    let smokeTarget: SmokeTarget
    let onSelectPosition: (ThrowPosition) -> Void
    let onDismiss: () -> Void

    private var positions: [ThrowPosition] {
        SmokeData.throwPositions(for: smokeTarget.id)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Откуда кидать смок «\(smokeTarget.name)»")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Section("Позиции броска") {
                    if positions.isEmpty {
                        Text("Позиции пока не добавлены.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(positions) { position in
                            Button(action: { onSelectPosition(position) }) {
                                HStack {
                                    Image(systemName: "scope")
                                        .foregroundColor(Theme.tabSelected)
                                    Text(position.name)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(smokeTarget.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть", action: onDismiss)
                }
            }
        }
    }
}

// MARK: - Экран туториала (видео); позже подставишь своё видео
struct TutorialVideoSheet: View {
    let throwPosition: ThrowPosition
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let urlString = throwPosition.videoURL, let url = URL(string: urlString) {
                    VideoPlayerView(url: url)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Theme.cardBackground)
                            .frame(height: 220)
                        VStack(spacing: 12) {
                            Image(systemName: "play.rectangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)
                            Text("Видео туториала")
                                .font(.headline)
                            Text("Сюда подставишь своё видео для:\n«\(throwPosition.name)»")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.screenBackground)
            .navigationTitle(throwPosition.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово", action: onDismiss)
                }
            }
        }
    }
}

/// Плеер по URL (когда добавишь ссылки на видео)
struct VideoPlayerView: View {
    let url: URL

    var body: some View {
        _AVPlayerView(url: url)
    }
}

private struct _AVPlayerView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        let player = AVPlayer(url: url)
        vc.player = player
        player.play()
        return vc
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
