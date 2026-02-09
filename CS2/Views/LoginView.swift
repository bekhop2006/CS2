//
//  LoginView.swift
//  CS2
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var auth = AuthService.shared
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.screenBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Text("CS2 Lineups")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .padding(.top, 40)
                        Text("Локальный вход — данные только на устройстве")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            TextField("example@mail.com", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Theme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .foregroundColor(.primary)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Пароль")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            SecureField("Минимум 6 символов", text: $password)
                                .textContentType(.password)
                                .padding()
                                .background(Theme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .foregroundColor(.primary)
                        }

                        if let msg = auth.errorMessage {
                            Text(msg)
                                .font(.caption)
                                .foregroundColor(.red)
                        }

                        Button(action: login) {
                            HStack {
                                if auth.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Войти")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.tabSelected)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(auth.isLoading || email.isEmpty || password.isEmpty)

                        Button("Нет аккаунта? Регистрация") {
                            showRegister = true
                        }
                        .font(.subheadline)
                        .foregroundColor(Theme.tabSelected)
                        .padding(.top, 8)
                    }
                    .padding(24)
                }
            }
            .sheet(isPresented: $showRegister) {
                RegisterView(onDismiss: { showRegister = false })
            }
        }
        .onAppear {
            auth.errorMessage = nil
            if email.isEmpty, let last = AuthService.lastLoggedInEmail {
                email = last
            }
        }
    }

    private func login() {
        auth.errorMessage = nil
        Task {
            do {
                try await auth.login(email: email, password: password)
            } catch {
                await MainActor.run {
                    auth.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
