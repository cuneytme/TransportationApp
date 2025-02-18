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
    
    var didTapMap: (() -> Void)?
    var didTapStops: (() -> Void)?
    var didTapServices: (() -> Void)?
    
    var didTapRegisterCard: (() -> Void)?
    
    init(user: User) {
        self.user = user
    }
    
    var userName: String {
        return user.fullName
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            didLogout?()
        } catch {
            //
        }
    }
    
    func registerCard() {
        didTapRegisterCard?()
    }
}
