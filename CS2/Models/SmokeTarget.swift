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
    private static let mirageMapName = "Mirage"
    private static let ancientMapName = "Ancient"
    private static let anubisMapName = "Anubis"

    static func smokeTargets(for mapName: String) -> [SmokeTarget] {
        switch mapName {
        case dust2MapName: return Array(dust2Targets.values).sorted { $0.name < $1.name }
        case mirageMapName: return Array(mirageTargets.values).sorted { $0.name < $1.name }
        case ancientMapName: return Array(ancientTargets.values).sorted { $0.name < $1.name }
        case anubisMapName: return Array(anubisTargets.values).sorted { $0.name < $1.name }
        default: return []
        }
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
        //
        // Сейчас активна только одна настоящая точка (A Site).
        // Ещё 4 точки оставлены ниже как закомментированные примеры — когда будешь готов,
        // просто сними `//` и подставь свои координаты/названия.

        // Видео из CS2/video-tutor/dust2/: XBOX.mp4, doors B.mp4, mid doors.mp4, mid to B.mp4, window B.mp4
        let a = SmokeTarget(
            id: UUID(uuidString: "A1A1A1A1-0001-4000-8000-000000000001")!,
            mapName: dust2MapName,
            name: "A Site",
            normalizedX: 0.45,
            normalizedY: 0.30,
            videoURL: nil,
            videoAssetName: "XBOX"  // XBOX.mp4
        )
        let b = SmokeTarget(
            id: UUID(uuidString: "A1A1A1A1-0002-4000-8000-000000000002")!,
            mapName: dust2MapName,
            name: "B Site",
            normalizedX: 0.28,
            normalizedY: 0.30,
            videoURL: nil,
            videoAssetName: "doors B"  // doors B.mp4
        )
        let m = SmokeTarget(
            id: UUID(uuidString: "A1A1A1A1-0003-4000-8000-000000000003")!,
            mapName: dust2MapName,
            name: "Mid",
            normalizedX: 0.50,
            normalizedY: 0.52,
            videoURL: nil,
            videoAssetName: "mid to B"  // mid to B.mp4
        )
        let l = SmokeTarget(
            id: UUID(uuidString: "A1A1A1A1-0004-4000-8000-000000000004")!,
            mapName: dust2MapName,
            name: "Long A",
            normalizedX: 0.80,
            normalizedY: 0.38,
            videoURL: nil,
            videoAssetName: "window B"  // window B.mp4
        )
        let c = SmokeTarget(
            id: UUID(uuidString: "A1A1A1A1-0005-4000-8000-000000000005")!,
            mapName: dust2MapName,
            name: "Catwalk",
            normalizedX: 0.62,
            normalizedY: 0.42,
            videoURL: nil,
            videoAssetName: "mid doors"  // mid doors.mp4
        )

        return ["a": a, "b": b, "m": m, "l": l, "c": c]
    }()

    // MARK: - Mirage — точки и видео из CS2/video-tutor/mirage/ (1 spawn.mp4 … 5 spawn.mp4)
    private static let mirageTargets: [String: SmokeTarget] = {
        let s1 = SmokeTarget(id: UUID(uuidString: "B2B2B2B2-0001-4000-8000-000000000001")!, mapName: mirageMapName, name: "Spawn 1", normalizedX: 0.35, normalizedY: 0.75, videoURL: nil, videoAssetName: "1 spawn")
        let s2 = SmokeTarget(id: UUID(uuidString: "B2B2B2B2-0002-4000-8000-000000000002")!, mapName: mirageMapName, name: "Spawn 2", normalizedX: 0.45, normalizedY: 0.70, videoURL: nil, videoAssetName: "2 spawn")
        let s3 = SmokeTarget(id: UUID(uuidString: "B2B2B2B2-0003-4000-8000-000000000003")!, mapName: mirageMapName, name: "Spawn 3", normalizedX: 0.55, normalizedY: 0.65, videoURL: nil, videoAssetName: "3 spawn")
        let s4 = SmokeTarget(id: UUID(uuidString: "B2B2B2B2-0004-4000-8000-000000000004")!, mapName: mirageMapName, name: "Spawn 4", normalizedX: 0.65, normalizedY: 0.60, videoURL: nil, videoAssetName: "4 spawn")
        let s5 = SmokeTarget(id: UUID(uuidString: "B2B2B2B2-0005-4000-8000-000000000005")!, mapName: mirageMapName, name: "Spawn 5", normalizedX: 0.75, normalizedY: 0.55, videoURL: nil, videoAssetName: "5 spawn")
        return ["1": s1, "2": s2, "3": s3, "4": s4, "5": s5]
    }()

    // MARK: - Ancient — точки и видео из CS2/video-tutor/ancient/ (anc spawn2.mp4, anc spawn5.mp4, anc spwn3.mp4)
    private static let ancientTargets: [String: SmokeTarget] = {
        let anc2 = SmokeTarget(id: UUID(uuidString: "C3C3C3C3-0001-4000-8000-000000000001")!, mapName: ancientMapName, name: "Spawn 2", normalizedX: 0.40, normalizedY: 0.65, videoURL: nil, videoAssetName: "anc spawn2")
        let anc5 = SmokeTarget(id: UUID(uuidString: "C3C3C3C3-0002-4000-8000-000000000002")!, mapName: ancientMapName, name: "Spawn 5", normalizedX: 0.60, normalizedY: 0.55, videoURL: nil, videoAssetName: "anc spawn5")
        let anc3 = SmokeTarget(id: UUID(uuidString: "C3C3C3C3-0003-4000-8000-000000000003")!, mapName: ancientMapName, name: "Spawn 3", normalizedX: 0.50, normalizedY: 0.60, videoURL: nil, videoAssetName: "anc spwn3")
        return ["2": anc2, "5": anc5, "3": anc3]
    }()

    // MARK: - Anubis — точки и видео из CS2/video-tutor/anubis/ (9.mp4, camera.mp4, ct anubis.mp4, mid.mp4, temple.mp4, temple2.mp4)
    private static let anubisTargets: [String: SmokeTarget] = {
        let a9 = SmokeTarget(id: UUID(uuidString: "D4D4D4D4-0001-4000-8000-000000000001")!, mapName: anubisMapName, name: "9", normalizedX: 0.45, normalizedY: 0.50, videoURL: nil, videoAssetName: "9")
        let cam = SmokeTarget(id: UUID(uuidString: "D4D4D4D4-0002-4000-8000-000000000002")!, mapName: anubisMapName, name: "Camera", normalizedX: 0.55, normalizedY: 0.45, videoURL: nil, videoAssetName: "camera")
        let ct = SmokeTarget(id: UUID(uuidString: "D4D4D4D4-0003-4000-8000-000000000003")!, mapName: anubisMapName, name: "CT Anubis", normalizedX: 0.50, normalizedY: 0.35, videoURL: nil, videoAssetName: "ct anubis")
        let mid = SmokeTarget(id: UUID(uuidString: "D4D4D4D4-0004-4000-8000-000000000004")!, mapName: anubisMapName, name: "Mid", normalizedX: 0.50, normalizedY: 0.55, videoURL: nil, videoAssetName: "mid")
        let temple = SmokeTarget(id: UUID(uuidString: "D4D4D4D4-0005-4000-8000-000000000005")!, mapName: anubisMapName, name: "Temple", normalizedX: 0.35, normalizedY: 0.55, videoURL: nil, videoAssetName: "temple")
        let temple2 = SmokeTarget(id: UUID(uuidString: "D4D4D4D4-0006-4000-8000-000000000006")!, mapName: anubisMapName, name: "Temple 2", normalizedX: 0.40, normalizedY: 0.50, videoURL: nil, videoAssetName: "temple2")
        return ["9": a9, "camera": cam, "ct": ct, "mid": mid, "temple": temple, "temple2": temple2]
    }()

    // Позиции броска для каждой точки смока
    private static var throwPositionsByTarget: [UUID: [ThrowPosition]] {
        let a = dust2Targets["a"]!
        let b = dust2Targets["b"]!
        let m = dust2Targets["m"]!
        let l = dust2Targets["l"]!
        let c = dust2Targets["c"]!
        let s1 = mirageTargets["1"]!
        let s2 = mirageTargets["2"]!
        let s3 = mirageTargets["3"]!
        let s4 = mirageTargets["4"]!
        let s5 = mirageTargets["5"]!
        let anc2 = ancientTargets["2"]!
        let anc5 = ancientTargets["5"]!
        let anc3 = ancientTargets["3"]!
        let a9 = anubisTargets["9"]!
        let cam = anubisTargets["camera"]!
        let ct = anubisTargets["ct"]!
        let mid = anubisTargets["mid"]!
        let temple = anubisTargets["temple"]!
        let temple2 = anubisTargets["temple2"]!
        var result: [UUID: [ThrowPosition]] = [
            a.id: [ThrowPosition(smokeTargetId: a.id, name: "С CT спавна", videoURL: nil, videoAssetName: nil), ThrowPosition(smokeTargetId: a.id, name: "С Long", videoURL: nil, videoAssetName: nil)],
            b.id: [ThrowPosition(smokeTargetId: b.id, name: "С B туннеля", videoURL: nil, videoAssetName: nil), ThrowPosition(smokeTargetId: b.id, name: "С CT", videoURL: nil, videoAssetName: nil)],
            m.id: [ThrowPosition(smokeTargetId: m.id, name: "С T спавна", videoURL: nil, videoAssetName: nil)],
            l.id: [ThrowPosition(smokeTargetId: l.id, name: "С pit", videoURL: nil, videoAssetName: nil)],
            c.id: [ThrowPosition(smokeTargetId: c.id, name: "С mid", videoURL: nil, videoAssetName: nil)]
        ]
        result[s1.id] = [ThrowPosition(smokeTargetId: s1.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[s2.id] = [ThrowPosition(smokeTargetId: s2.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[s3.id] = [ThrowPosition(smokeTargetId: s3.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[s4.id] = [ThrowPosition(smokeTargetId: s4.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[s5.id] = [ThrowPosition(smokeTargetId: s5.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[anc2.id] = [ThrowPosition(smokeTargetId: anc2.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[anc5.id] = [ThrowPosition(smokeTargetId: anc5.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[anc3.id] = [ThrowPosition(smokeTargetId: anc3.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[a9.id] = [ThrowPosition(smokeTargetId: a9.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[cam.id] = [ThrowPosition(smokeTargetId: cam.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[ct.id] = [ThrowPosition(smokeTargetId: ct.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[mid.id] = [ThrowPosition(smokeTargetId: mid.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[temple.id] = [ThrowPosition(smokeTargetId: temple.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        result[temple2.id] = [ThrowPosition(smokeTargetId: temple2.id, name: "Туториал", videoURL: nil, videoAssetName: nil)]
        return result
    }
}
