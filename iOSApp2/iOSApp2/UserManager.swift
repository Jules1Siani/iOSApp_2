//
//  UserManager.swift
//  iOSApp2
//
//  Created by Jules Mickael on 2025-02-17.
//

import Foundation

class UserManager: ObservableObject {
    @Published var users: [User] = []
    @Published var currentUser: User?

    private let userDefaultsKey = "users"

    init() {
        loadUsers()
    }

    // Load users from UserDefaults
    func loadUsers() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([User].self, from: data) {
            users = decoded
        } else {
            // If no users are loaded, initialize with default users (optional)
            loadInitialUsers()
        }
    }

    // Save users to UserDefaults
    func saveUsers() {
        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    // Load default users if no users are found
    private func loadInitialUsers() {
        if let url = Bundle.main.url(forResource: "users", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([User].self, from: data) {
            users = decoded
            saveUsers() // Save users to UserDefaults
        }
    }

    // User login
    func login(email: String, password: String) -> Bool {
        if let user = users.first(where: { $0.email == email && $0.password == password }) {
            currentUser = user
            return true
        }
        return false
    }

    // Register a new user
    func register(username: String, email: String, password: String) -> Bool {
        if users.contains(where: { $0.email == email }) {
            return false // Email already exists
        }

        let newUser = User(id: UUID().uuidString, username: username, email: email, password: password)
        users.append(newUser)
        saveUsers()
        currentUser = newUser
        return true
    }
}
