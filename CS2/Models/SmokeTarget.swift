//
//  SmokeTarget.swift
//  CS2
//

import Foundation

/// Точка на миникарте — куда летит смок (цель).
/// Координаты normalizedX, normalizedY — от 0 до 1: (0,0) = верхний левый угол фото, (1,1) = нижний правый.
/// Чтобы узнать координаты: в приложении открой карту → нажми «Указать точки» → нажми на нужное место на миникарте — в алерте появятся числа для вставки сюда.
struct SmokeTarget: Identifiable, Hashable {
    let id: UUID
    let mapName: String
    let name: String
    /// Нормализованные координаты на миникарте (0...1), верхний левый = (0,0)
    let normalizedX: Double
    let normalizedY: Double
    /// Ссылка на видео-туториал (при нажатии на иконку смока откроется это видео)
    let videoURL: String?
    /// Или имя видео в бандле (файл в проекте)
    let videoAssetName: String?

    init(id: UUID = UUID(), mapName: String, name: String, normalizedX: Double, normalizedY: Double, videoURL: String? = nil, videoAssetName: String? = nil) {
        self.id = id
        self.mapName = mapName
        self.name = name
        self.normalizedX = normalizedX
        self.normalizedY = normalizedY
        self.videoURL = videoURL
        self.videoAssetName = videoAssetName
    }
}

/// Позиция откуда кидать смок (одна из точек для выбранной цели)
struct ThrowPosition: Identifiable, Hashable {
    let id: UUID
    let smokeTargetId: UUID
    let name: String
    /// URL видео-туториала (позже подставишь свои)
    let videoURL: String?
    /// Или имя ассета видео в бандле
    let videoAssetName: String?

    init(id: UUID = UUID(), smokeTargetId: UUID, name: String, videoURL: String? = nil, videoAssetName: String? = nil) {
        self.id = id
        self.smokeTargetId = smokeTargetId
        self.name = name
        self.videoURL = videoURL
        self.videoAssetName = videoAssetName
    }
}

// MARK: - Данные точек смоков по картам
// Координаты: в приложении нажми «Указать точки» и тапни по миникарте — подставь полученные числа сюда.

enum SmokeData {
    private static let dust2MapName = "Dust II"

    static func smokeTargets(for mapName: String) -> [SmokeTarget] {
        guard mapName == dust2MapName else { return [] }
        return Array(dust2Targets.values).sorted { $0.name < $1.name }
    }

    static func throwPositions(for smokeTargetId: UUID) -> [ThrowPosition] {
        throwPositionsByTarget[smokeTargetId] ?? []
    }

    // MARK: - Dust II — примерные точки (0 = левый/верхний край, 1 = правый/нижний)
    //
    // ЧТО МЕНЯТЬ:
    //   • normalizedX — сдвиг точки по горизонтали (больше = правее)
    //   • normalizedY — сдвиг по вертикали (больше = ниже)
    //   • name — подпись точки на карте (A Site, B Site и т.д.)
    // Чтобы точно подогнать: в приложении «Указать точки» → тап по месту → вставь числа вместо 0.XX ниже.

    private static let dust2Targets: [String: SmokeTarget] = {
        // Видео: подставь videoURL: "https://..." или videoAssetName: "имя_файла" когда будут готовы
        // A Site
        let a = SmokeTarget(
            id: UUID(uuidString: "A1A1A1A1-0001-4000-8000-000000000001")!,
            mapName: dust2MapName,
            name: "A Site",
            normalizedX: 0.80,
            normalizedY: 0.20,
            videoURL: nil,       // ← подставь ссылку на видео
            videoAssetName: nil  // ← или имя файла из проекта
        )
        let b = SmokeTarget(
            id: UUID(uuidString: "A1A1A1A1-0002-4000-8000-000000000002")!,
            mapName: dust2MapName,
            name: "B Site",
            normalizedX: 0.28,
            normalizedY: 0.30,
            videoURL: nil,
            videoAssetName: nil
        )
        let m = SmokeTarget(
            id: UUID(uuidString: "A1A1A1A1-0003-4000-8000-000000000003")!,
            mapName: dust2MapName,
            name: "Mid",
            normalizedX: 0.50,
            normalizedY: 0.52,
            videoURL: nil,
            videoAssetName: nil
        )
        let l = SmokeTarget(
            id: UUID(uuidString: "A1A1A1A1-0004-4000-8000-000000000004")!,
            mapName: dust2MapName,
            name: "Long A",
            normalizedX: 0.80,
            normalizedY: 0.38,
            videoURL: nil,
            videoAssetName: nil
        )
        let c = SmokeTarget(
            id: UUID(uuidString: "A1A1A1A1-0005-4000-8000-000000000005")!,
            mapName: dust2MapName,
            name: "Catwalk",
            normalizedX: 0.62,
            normalizedY: 0.42,
            videoURL: nil,
            videoAssetName: nil
        )
        return ["a": a, "b": b, "m": m, "l": l, "c": c]
    }()

    // Позиции броска для каждой точки смока (названия и видео меняй при необходимости)
    private static var throwPositionsByTarget: [UUID: [ThrowPosition]] {
        let a = dust2Targets["a"]!
        let b = dust2Targets["b"]!
        let m = dust2Targets["m"]!
        let l = dust2Targets["l"]!
        let c = dust2Targets["c"]!
        return [
            a.id: [
                ThrowPosition(smokeTargetId: a.id, name: "С CT спавна", videoURL: nil, videoAssetName: nil),
                ThrowPosition(smokeTargetId: a.id, name: "С Long", videoURL: nil, videoAssetName: nil)
            ],
            b.id: [
                ThrowPosition(smokeTargetId: b.id, name: "С B туннеля", videoURL: nil, videoAssetName: nil),
                ThrowPosition(smokeTargetId: b.id, name: "С CT", videoURL: nil, videoAssetName: nil)
            ],
            m.id: [
                ThrowPosition(smokeTargetId: m.id, name: "С T спавна", videoURL: nil, videoAssetName: nil)
            ],
            l.id: [
                ThrowPosition(smokeTargetId: l.id, name: "С pit", videoURL: nil, videoAssetName: nil)
            ],
            c.id: [
                ThrowPosition(smokeTargetId: c.id, name: "С mid", videoURL: nil, videoAssetName: nil)
            ]
        ]
    }
}
