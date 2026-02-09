//
//  RegisterView.swift
//  CS2
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var auth = AuthService.shared
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.screenBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
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
                            Text("Пароль (минимум 6 символов)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            SecureField("Минимум 6 символов", text: $password)
                                .textContentType(.newPassword)
                                .padding()
                                .background(Theme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .foregroundColor(.primary)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Повторите пароль")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            SecureField("Повторите пароль", text: $confirmPassword)
                                .textContentType(.newPassword)
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

                        Button(action: register) {
                            HStack {
                                if auth.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Зарегистрироваться")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.tabSelected)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(auth.isLoading || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Регистрация")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена", action: onDismiss)
                }
            }
            .onAppear { auth.errorMessage = nil }
        }
    }

    private func register() {
        auth.errorMessage = nil
        Task {
            do {
                try await auth.register(email: email, password: password, confirmPassword: confirmPassword)
                onDismiss()
            } catch {
                await MainActor.run {
                    auth.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    RegisterView(onDismiss: {})
}
