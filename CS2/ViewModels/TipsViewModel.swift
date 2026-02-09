//
//  TipsViewModel.swift
//  CS2
//

import Combine
import Foundation
import SwiftUI

/// ViewModel for API-fetched tips (loading, success, error states)
final class TipsViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case success([APIPost])
        case error(String)
    }

    @Published private(set) var state: State = .idle
    private let api = APIService.shared

    func loadTips() {
        state = .loading
        Task { @MainActor in
            do {
                let posts = try await api.fetchTips()
                state = .success(posts)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
