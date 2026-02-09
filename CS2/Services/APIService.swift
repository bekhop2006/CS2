//
//  APIService.swift
//  CS2
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
}

/// Fetches data from REST API (JSONPlaceholder - community tips style)
final class APIService {
    static let shared = APIService()
    private let session: URLSession
    private let baseURL = "https://jsonplaceholder.typicode.com"

    private init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }

    func fetchTips() async throws -> [APIPost] {
        guard let url = URL(string: "\(baseURL)/posts?_limit=5") else {
            throw APIError.invalidURL
        }
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw APIError.noData
        }
        do {
            let decoded = try JSONDecoder().decode([APIPost].self, from: data)
            return decoded
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
