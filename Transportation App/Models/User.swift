//
//  User.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

struct User {
    let id: String
    let email: String
    let fullName: String
    
    init(id: String, email: String, fullName: String) {
        self.id = id
        self.email = email
        self.fullName = fullName
    }
    
    init(data: [String: Any]) {
        self.id = data["userId"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
    }
} 
