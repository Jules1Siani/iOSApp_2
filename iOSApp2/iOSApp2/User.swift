//
//  User.swift
//  iOSApp2
//
//  Created by Jules Mickael on 2025-02-17.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var username: String
    var email: String
    var password: String
}
