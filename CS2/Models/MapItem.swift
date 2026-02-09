//
//  MapItem.swift
//  CS2
//

import SwiftUI

struct MapItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    /// Image name in Assets.xcassets
    let imageName: String
    /// Radar minimap asset name (nil if no radar)
    let radarImageName: String?
}

extension MapItem {
    static let activeMaps: [MapItem] = [
        MapItem(name: "Anubis", imageName: "MapAnubis", radarImageName: "RadarAnubis"),
        MapItem(name: "Overpass", imageName: "MapOverpass", radarImageName: nil),
        MapItem(name: "Inferno", imageName: "MapInferno", radarImageName: nil),
        MapItem(name: "Mirage", imageName: "MapMirage", radarImageName: "RadarMirage"),
        MapItem(name: "Dust II", imageName: "MapDust2", radarImageName: "RadarDust2"),
        MapItem(name: "Nuke", imageName: "MapNuke", radarImageName: nil)
    ]

    static let otherMaps: [MapItem] = [
        MapItem(name: "Ancient", imageName: "MapAncient", radarImageName: "RadarAncient")
    ]

    static var allMaps: [MapItem] { activeMaps + otherMaps }
}
