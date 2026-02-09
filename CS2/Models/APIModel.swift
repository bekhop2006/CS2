//
//  APIModel.swift
//  CS2
//

import Foundation

/// DTO for REST API response (JSONPlaceholder posts as "community tips")
struct APIPost: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
