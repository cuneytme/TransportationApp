//
//  User.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

struct User {
    let uid: String
    let email: String
    let fullName: String
   
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
    }
} 
