//
//  AuthService.swift
//  CS2
//
//  Сейчас: локальная авторизация (Keychain). Регистрация и вход хранятся только на устройстве.
//  Чтобы перейти на MongoDB Atlas: создай backend API (Node.js/Express и т.д.), который пишет
//  пользователей в Atlas и проверяет пароль; здесь замени register/login на HTTP-запросы к этому API.
//

import Combine
import CryptoKit
import Foundation

enum AuthError: LocalizedError {
    case invalidEmail
    case passwordTooShort
    case passwordsDontMatch
    case emailTaken
    case wrongCredentials
    case keychainError

    var errorDescription: String? {
        switch self {
        case .invalidEmail: return "Введите корректный email"
        case .passwordTooShort: return "Пароль минимум 6 символов"
        case .passwordsDontMatch: return "Пароли не совпадают"
        case .emailTaken: return "Этот email уже зарегистрирован"
        case .wrongCredentials: return "Неверный email или пароль"
        case .keychainError: return "Ошибка сохранения"
        }
    }
}

/// Сервис входа/регистрации. Сейчас — локально (Keychain), потом можно переключить на MongoDB Atlas API.
final class AuthService: ObservableObject {
    static let shared = AuthService()
    private let keychain = KeychainService.shared

    private enum Keys {
        static let users = "cs2_auth_users"
        static let currentUser = "cs2_current_user"
    }

    private static let lastEmailKey = "cs2_last_login_email"

    /// Последний успешный вход (для подстановки email на экране входа).
    static var lastLoggedInEmail: String? {
        get { UserDefaults.standard.string(forKey: lastEmailKey) }
        set { UserDefaults.standard.set(newValue, forKey: lastEmailKey) }
    }

    @Published private(set) var currentUser: AuthUser?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    var isLoggedIn: Bool { currentUser != nil }

    private init() {
        loadCurrentUser()
    }

    private func loadCurrentUser() {
        guard let data = keychain.load(key: Keys.currentUser),
              let user = try? JSONDecoder().decode(AuthUser.self, from: data) else {
            currentUser = nil
            return
        }
        currentUser = user
    }

    // MARK: - Register (локально)

    func register(email: String, password: String, confirmPassword: String) async throws {
        await MainActor.run { isLoading = true; errorMessage = nil }
        defer { Task { @MainActor in isLoading = false } }

        let email = email.trimmingCharacters(in: .whitespaces).lowercased()
        guard isValidEmail(email) else { throw AuthError.invalidEmail }
        guard password.count >= 6 else { throw AuthError.passwordTooShort }
        guard password == confirmPassword else { throw AuthError.passwordsDontMatch }

        var users = loadStoredUsers()
        if users.contains(where: { $0.email == email }) {
            throw AuthError.emailTaken
        }

        let salt = Data((0..<32).map { _ in UInt8.random(in: 0...255) })
        let hash = hashPassword(password: password, salt: salt)
        users.append(StoredUser(email: email, saltBase64: salt.base64EncodedString(), hashBase64: hash))

        guard saveStoredUsers(users) else { throw AuthError.keychainError }

        try await login(email: email, password: password)
    }

    // MARK: - Login (локально)

    func login(email: String, password: String) async throws {
        await MainActor.run { isLoading = true; errorMessage = nil }
        defer { Task { @MainActor in isLoading = false } }

        let email = email.trimmingCharacters(in: .whitespaces).lowercased()
        guard isValidEmail(email) else { throw AuthError.invalidEmail }

        let users = loadStoredUsers()
        guard let stored = users.first(where: { $0.email == email }) else {
            throw AuthError.wrongCredentials
        }

        guard let salt = Data(base64Encoded: stored.saltBase64) else { throw AuthError.wrongCredentials }
        let hash = hashPassword(password: password, salt: salt)
        guard hash == stored.hashBase64 else { throw AuthError.wrongCredentials }

        let user = AuthUser(email: email, id: UUID().uuidString)
        let data = (try? JSONEncoder().encode(user)) ?? Data()
        guard keychain.save(key: Keys.currentUser, value: data) else { throw AuthError.keychainError }

        Self.lastLoggedInEmail = email
        await MainActor.run { currentUser = user }
    }

    func logout() {
        _ = keychain.remove(key: Keys.currentUser)
        currentUser = nil
    }

    /// Удалить текущий аккаунт с устройства (можно снова зарегистрироваться с тем же email).
    func deleteAccount() {
        guard let user = currentUser else { return }
        let users = loadStoredUsers().filter { $0.email != user.email }
        _ = saveStoredUsers(users)
        _ = keychain.remove(key: Keys.currentUser)
        currentUser = nil
    }

    // MARK: - Helpers

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    private func hashPassword(password: String, salt: Data) -> String {
        var data = salt
        data.append(Data(password.utf8))
        let hash = SHA256.hash(data: data)
        return hash.withUnsafeBytes { Data($0) }.base64EncodedString()
    }

    private struct StoredUser: Codable {
        let email: String
        let saltBase64: String
        let hashBase64: String
    }

    private func loadStoredUsers() -> [StoredUser] {
        guard let data = keychain.load(key: Keys.users),
              let users = try? JSONDecoder().decode([StoredUser].self, from: data) else {
            return []
        }
        return users
    }

    private func saveStoredUsers(_ users: [StoredUser]) -> Bool {
        guard let data = try? JSONEncoder().encode(users) else { return false }
        return keychain.save(key: Keys.users, value: data)
    }
}
