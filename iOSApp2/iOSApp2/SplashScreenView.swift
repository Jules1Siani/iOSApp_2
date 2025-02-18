//
//  SplashScreenView.swift
//  iOSApp2
//
//  Created by Jules Mickael on 2025-02-17.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isRegistering: Bool = false
    @State private var isAuthenticated: Bool = false  // For redirection

    var body: some View {
        Group {
            if isAuthenticated || userManager.currentUser != nil {
                ContentView() // Redirect after login
            } else {
                loginRegisterView
            }
        }
        .onAppear {
            if userManager.currentUser != nil {
                isAuthenticated = true // Auto-login if already logged in
            }
        }
    }

    var loginRegisterView: some View {
        ZStack {
            // 🔹 Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // 🔹 Logo Placeholder (Replace with your app logo)
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                Text(isRegistering ? "Create an Account" : "Welcome Back!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                if isRegistering {
                    customTextField(placeholder: "Username", text: $username)
                }

                customTextField(placeholder: "Email", text: $email, isEmail: true)
                customSecureField(placeholder: "Password", text: $password)

                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.bottom, 5)
                }

                // 🔹 Login / Sign Up Button with Animation
                Button(action: {
                    withAnimation {
                        isRegistering ? handleRegistration() : handleLogin()
                    }
                }) {
                    Text(isRegistering ? "Sign Up" : "Log In")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .scaleEffect(0.95)
                        .animation(.spring(), value: isRegistering)
                }
                .padding(.horizontal)

                // 🔹 Toggle between Login & Register
                Button(action: {
                    withAnimation {
                        isRegistering.toggle()
                        showError = false
                        errorMessage = ""
                    }
                }) {
                    Text(isRegistering ? "Already have an account? Log in" : "Don't have an account? Sign up")
                        .foregroundColor(.white)
                        .font(.footnote)
                        .underline()
                }
            }
            .padding()
        }
    }

    // 🔹 Custom Styled TextField
    private func customTextField(placeholder: String, text: Binding<String>, isEmail: Bool = false) -> some View {
        TextField(placeholder, text: text)
            .keyboardType(isEmail ? .emailAddress : .default)
            .autocapitalization(isEmail ? .none : .words)
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(10)
            .shadow(radius: 5)
            .foregroundColor(.white)
            .padding(.horizontal)
    }

    // 🔹 Custom Styled SecureField
    private func customSecureField(placeholder: String, text: Binding<String>) -> some View {
        SecureField(placeholder, text: text)
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(10)
            .shadow(radius: 5)
            .foregroundColor(.white)
            .padding(.horizontal)
    }

    // 🔹 Login Function
    private func handleLogin() {
        if email.isEmpty || password.isEmpty {
            showError = true
            errorMessage = "All fields are required."
            return
        }
        
        if userManager.login(email: email, password: password) {
            showError = false
            isAuthenticated = true
        } else {
            showError = true
            errorMessage = "Incorrect email or password."
        }
    }

    // 🔹 Registration Function
    private func handleRegistration() {
        if username.isEmpty || email.isEmpty || password.isEmpty {
            showError = true
            errorMessage = "All fields are required."
            return
        }

        if userManager.register(username: username, email: email, password: password) {
            showError = false
            isAuthenticated = true
        } else {
            showError = true
            errorMessage = "This email is already in use."
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView().environmentObject(UserManager())
    }
}
