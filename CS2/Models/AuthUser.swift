//
//  AuthUser.swift
//  CS2
//

import Foundation

/// Данные залогиненного пользователя (локально).
struct AuthUser: Codable {
    let email: String
    let id: String
}
