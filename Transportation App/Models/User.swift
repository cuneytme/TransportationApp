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
    let title: String
    let cardNumber: String?
    let balance: Double
    
    init(id: String, email: String, fullName: String, title: String = "", cardNumber: String? = nil, balance: Double = 10.0) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.title = title
        self.cardNumber = cardNumber
        self.balance = balance
    }
    
    init(data: [String: Any]) {
        self.id = data["userId"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
        self.title = data["title"] as? String ?? "No title"
        self.cardNumber = data["cardNumber"] as? String
        self.balance = data["balance"] as? Double ?? 0.0
    }
} 
