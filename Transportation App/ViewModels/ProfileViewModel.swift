//
//  ProfileViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//


import UIKit
import FirebaseAuth

final class ProfileViewModel {
    private let user: User
    var didLogout: (() -> Void)?
    
    init(user: User) {
        self.user = user
    }
    
    var fullName: String {
        return user.fullName
    }
    
    var email: String {
        return user.email
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            didLogout?()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
} 
