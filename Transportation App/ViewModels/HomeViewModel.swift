//
//  HomeViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import Foundation
import Firebase
import FirebaseAuth

final class HomeViewModel {
    private let user: User
    var didLogout: (() -> Void)?
    
    init(user: User) {
        self.user = user
        
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
